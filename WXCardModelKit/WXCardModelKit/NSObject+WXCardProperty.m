//
//  NSObject+WXCardProperty.m
//  WXCardModelKit
//
//  Created by  liuyunxuan on 16/4/3.
//  Copyright © 2016年  liuyunxuan. All rights reserved.
//

#import "NSObject+WXCardProperty.h"
#import "WXCardDictionaryCache.h"
#import "NSObject+WXCardClass.h"
#import <objc/runtime.h>

static const char WXCardCachedPropertiesKey = '\0';
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
                [property setObjectClassInArray:[self propertyObjectClassInArray:property.name] forClass:self];
                [cachedProperties addObject:property];
            }

        }];
    }
    
    return cachedProperties;
}

@end
