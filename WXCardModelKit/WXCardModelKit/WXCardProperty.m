//
//  WXCardProperty.m
//  WXCardModelKit
//
//  Created by  liuyunxuan on 16/4/3.
//  Copyright © 2016年  liuyunxuan. All rights reserved.
//

#import "WXCardProperty.h"
#import "WXCardPropertyKey.h"
@interface WXCardProperty()
@property (strong, nonatomic) NSMutableDictionary *propertyKeysDict;
@property (strong, nonatomic) NSMutableDictionary *objectClassInArrayDict;
@end

@implementation WXCardProperty

- (NSArray *)propertyKeysForClass:(Class)c
{
    return self.propertyKeysDict[NSStringFromClass(c)];
}

+ (instancetype)cachedPropertyWithProperty:(objc_property_t)property
{
    WXCardProperty *propertyObj = objc_getAssociatedObject(self, property);
    if (propertyObj == nil)
    {
        propertyObj = [[self alloc] init];
        propertyObj.property = property;
        objc_setAssociatedObject(self, property, propertyObj, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return propertyObj;
}

- (void)setProperty:(objc_property_t)property
{
    _property = property;
    //属性名
    _name = @(property_getName(property));
    //成员类型
    NSString *attrs = @(property_getAttributes(property));
    NSUInteger dotLoc = [attrs rangeOfString:@","].location;
    NSString *code = nil;
    NSUInteger loc = 1;
    if (dotLoc == NSNotFound) { // 没有,
        code = [attrs substringFromIndex:loc];
    } else {
        code = [attrs substringWithRange:NSMakeRange(loc, dotLoc - loc)];
    }
    _type = [WXCardPropertyType cachedTypeWithCode:code];
}

/** 对应着字典中的key */
- (void)setOriginKey:(NSString *)originKey forClass:(Class)c
{
    NSArray *propertyKeys = [self propertyKeysWithStringKey:originKey];
    if (propertyKeys.count)
    {
        [self setPorpertyKeys:propertyKeys forClass:c];
    }
}


/** 对应着字典中的多级key */
- (void)setPorpertyKeys:(NSArray *)propertyKeys forClass:(Class)c
{
    if (propertyKeys.count == 0) return;
    self.propertyKeysDict[NSStringFromClass(c)] = propertyKeys;
}

/**
 *  通过字符串key创建对应的keys
 */
- (NSArray *)propertyKeysWithStringKey:(NSString *)stringKey
{
    if (stringKey.length == 0) return nil;
    
    NSMutableArray *propertyKeys = [NSMutableArray array];
    // 如果有多级映射
    NSArray *oldKeys = [stringKey componentsSeparatedByString:@"."];
    
    for (NSString *oldKey in oldKeys) {
        NSUInteger start = [oldKey rangeOfString:@"["].location;
        if (start != NSNotFound) { // 有索引的key
            NSString *prefixKey = [oldKey substringToIndex:start];
            NSString *indexKey = prefixKey;
            if (prefixKey.length) {
                WXCardPropertyKey *propertyKey = [[WXCardPropertyKey alloc] init];
                propertyKey.name = prefixKey;
                [propertyKeys addObject:propertyKey];
                
                indexKey = [oldKey stringByReplacingOccurrencesOfString:prefixKey withString:@""];
            }
            
            /** 解析索引 **/
            // 元素
            NSArray *cmps = [[indexKey stringByReplacingOccurrencesOfString:@"[" withString:@""] componentsSeparatedByString:@"]"];
            for (NSInteger i = 0; i<cmps.count - 1; i++) {
                WXCardPropertyKey *subPropertyKey = [[WXCardPropertyKey alloc] init];
                subPropertyKey.type = WXCardPropertyKeyTypeArray;
                subPropertyKey.name = cmps[i];
                [propertyKeys addObject:subPropertyKey];
            }
        } else { // 没有索引的key
            WXCardPropertyKey *propertyKey = [[WXCardPropertyKey alloc] init];
            propertyKey.name = oldKey;
            [propertyKeys addObject:propertyKey];
        }
    }
    
    return propertyKeys;
}


/** 模型数组中的模型类型 */
- (void)setObjectClassInArray:(Class)objectClass forClass:(Class)c
{
    if (!objectClass) return;
    self.objectClassInArrayDict[NSStringFromClass(c)] = objectClass;
}

- (Class)objectClassInArrayForClass:(Class)c
{
    return self.objectClassInArrayDict[NSStringFromClass(c)];
}

- (void)setValue:(id)value forObject:(id)object
{
    if (self.type.KVCDisabled || value == nil) return;
    [object setValue:value forKey:self.name];
}

- (NSMutableDictionary *)propertyKeysDict
{
    if (!_propertyKeysDict) {
        _propertyKeysDict = [NSMutableDictionary dictionary];
    }
    return _propertyKeysDict;
}

- (NSMutableDictionary *)objectClassInArrayDict
{
    if (!_objectClassInArrayDict)
    {
        _objectClassInArrayDict = [NSMutableDictionary dictionary];
    }
    return _objectClassInArrayDict;
}
@end
