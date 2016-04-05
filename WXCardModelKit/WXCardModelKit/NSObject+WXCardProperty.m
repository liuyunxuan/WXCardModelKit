//
//  NSObject+WXCardProperty.m
//  WXCardModelKit
//
//  Created by  liuyunxuan on 16/4/3.
//  Copyright © 2016年  liuyunxuan. All rights reserved.
//

#import "NSObject+WXCardProperty.h"
#import "NSObject+WXCardKeyValue.h"
#import "WXCardDictionaryCache.h"
#import "NSObject+WXCardClass.h"
#import <objc/runtime.h>

@interface NSObject()

@property (nonatomic, strong) NSMutableDictionary *cachedPropertiesDict;

@end

static const char WXCardCachedPropertiesKey = '\0';
static const char MJObjectClassInArrayKey = '\0';
static const char MJCachedPropertiesKey = '\0';
@implementation NSObject (WXCardProperty)


+ (void)wx_enumerateProperties:(WXCardPropertiesEnumeration)enumeration
{
    // 获得成员变量
    NSArray *cachedProperties = [self properties];
    
    // 遍历成员变量
    BOOL stop = NO;
    for (WXCardProperty *property in cachedProperties) {
        enumeration(property, &stop);
        if (stop) break;
    }
}
//获取property的属性数组
+ (NSMutableArray *)properties
{
    NSMutableArray *cachedProperties = [WXCardDictionaryCache objectForKey:NSStringFromClass(self) forDictId:&WXCardCachedPropertiesKey];
    if (!cachedProperties) {
        cachedProperties = [NSMutableArray array];
        
        [self wx_enumerateAllClasses:^(__unsafe_unretained Class c, BOOL *stop) {
            // 1.获得所有的成员变量
            unsigned int outCount = 0;
            objc_property_t *properties = class_copyPropertyList(c, &outCount);
            // 2.遍历每一个成员变量
            for (unsigned int i = 0; i<outCount; i++) {
                WXCardProperty *property = [WXCardProperty cachedPropertyWithProperty:properties[i]];
                // 过滤掉系统自动添加的元素
                if ([property.name isEqualToString:@"hash"]
                    || [property.name isEqualToString:@"superclass"]
                    || [property.name isEqualToString:@"description"]
                    || [property.name isEqualToString:@"debugDescription"]) {
                    continue;
                }
                property.srcClass = c;
                [property setOriginKey:[self propertyKey:property.name] forClass:self];
                // 设置key对应的数组，因为key对应的是数组类型，那么就可以通过这样去取到数组里面类的类型，然后存储起来
                [property setObjectClassInArray:[self propertyObjectClassInArray:property.name] forClass:self];
                [cachedProperties addObject:property];
            }
            free(properties);
        }];
        // 缓存property至全局区处
        [WXCardDictionaryCache setObject:cachedProperties forKey:NSStringFromClass(self) forDictId:&WXCardCachedPropertiesKey];
    }
    return cachedProperties;
}

// 写在属性的上名字，然后将之换成是否需要手动转换,这个是真实从字典里面取数据的key
- (NSString *)propertyKey:(NSString *)propertyName
{
    if (propertyName == nil) return nil;
    
    if ([self respondsToSelector:@selector(wx_replacedKeyFromPropertyName)])
    {
        NSDictionary *dic = [self performSelector:@selector(wx_replacedKeyFromPropertyName)];
        if (dic)
        {
            return [dic objectForKey:propertyName];
        }else{
            return nil;
        }
    }else{
        return propertyName;
    }
}

+ (Class)propertyObjectClassInArray:(NSString *)propertyName
{
    __block id clazz = nil;
    if ([self respondsToSelector:@selector(wx_objectClassInArray)]) {
        clazz = [self wx_objectClassInArray][propertyName];
    }
    
    if (!clazz) {
        [self wx_enumerateAllClasses:^(__unsafe_unretained Class c, BOOL *stop) {
            NSDictionary *dict = objc_getAssociatedObject(c, &MJObjectClassInArrayKey);
            if (dict) {
                clazz = dict[propertyName];
            }
            if (clazz) *stop = YES;
        }];
    }
    
    // 如果是NSString类型
    if ([clazz isKindOfClass:[NSString class]]) {
        clazz = NSClassFromString(clazz);
    }
    return clazz;
}

@end
