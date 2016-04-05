//
//  NSObject+WXCardKeyValue.m
//  WXCardModelKit
//
//  Created by  liuyunxuan on 16/4/3.
//  Copyright © 2016年  liuyunxuan. All rights reserved.
//

#import "NSObject+WXCardKeyValue.h"
#import "NSObject+WXCardProperty.h"
#import "WXCardDictionaryCache.h"
#import "WXCardPropertyKey.h"
#import "WXCardPropertyType.h"
#import "WXCardFoundation.h"
@implementation NSObject (WXCardKeyValue)

+ (instancetype)wx_objectWithKeyValues:(NSDictionary *)keyValues
{
    NSAssert([keyValues isKindOfClass:[NSDictionary class]], @"传入的数据不是dictionary");
//    return [[[self alloc] init]wx_setKeyValues:keyValues];
    NSObject *object = [[self alloc] init];
    [object wx_setKeyValues:keyValues];
    return object;
}

/// 进行赋值
- (instancetype)wx_setKeyValues:(NSDictionary *)keyValues
{
    Class class = [self class];
    [class wx_enumerateProperties:^(WXCardProperty *property, BOOL *stop) {
        //取出属性值,因为有可能是多级key，
        id value;
        NSObject *object = self;
        NSArray *propertyKeys = [property propertyKeysForClass:class];
        value = keyValues;
        for (WXCardPropertyKey *propertyKey in propertyKeys)
        {
            value = [propertyKey valueInObject:value];
        }
        if (!value || value == [NSNull null]) return ;
        
        WXCardPropertyType *type = property.type;
        Class propertyClass = type.typeClass;
        Class objectClass = [property objectClassInArrayForClass:[self class]];
        
        // 不可变 -> 可变处理
        if (propertyClass == [NSMutableArray class] && [value isKindOfClass:[NSArray class]]) {
            value = [NSMutableArray arrayWithArray:value];
        } else if (propertyClass == [NSMutableDictionary class] && [value isKindOfClass:[NSDictionary class]]) {
            value = [NSMutableDictionary dictionaryWithDictionary:value];
        } else if (propertyClass == [NSMutableString class] && [value isKindOfClass:[NSString class]]) {
            value = [NSMutableString stringWithString:value];
        } else if (propertyClass == [NSMutableData class] && [value isKindOfClass:[NSData class]]) {
            value = [NSMutableData dataWithData:value];
        }
        
        // 如果不是来自系统原生的则咨询遍历下去
        if (!type.isFromFoundation && propertyClass) {
            value = [propertyClass wx_objectWithKeyValues:value];
        }else if(objectClass){
            if (objectClass == [NSURL class] && [value isKindOfClass:[NSArray class]])
            {
                NSMutableArray *urlArray = [NSMutableArray array];
                for (NSString *string in value)
                {
                    if (![string isKindOfClass:[NSString class]]) continue;
                    [urlArray addObject:[NSURL URLWithString:string]];
                }
            }else
            {// 字典数组转模型数组
                value = [objectClass wx_objectArrayWithKeyValuesArray:value];
            }
        }else{
            if (propertyClass == [NSString class])
            {
                if ([value isKindOfClass:[NSNumber class]])
                {
                    // NSNumber -> NSString
                    value = [value description];
                }else if ([value isKindOfClass:[NSURL class]])
                {
                    value = [value absoluteString];
                }
            }else if ([value isKindOfClass:[NSString class]]){
                if (propertyClass == [NSURL class])
                {
                    value = [NSURL URLWithString:value];
                }else if(type.isNumberType)
                {
                    NSString *oldValue = value;
                    
                    // NSString -> NSNumber
                    value = [NSDecimalNumber decimalNumberWithString:oldValue];
                    if (type.isBoolType)
                    {
                        NSString *lower = [oldValue lowercaseString];
                        if ([lower isEqualToString:@"yes"] || [lower isEqualToString:@"true"])
                        {
                            value = @YES;
                        }
                        else if ([lower isEqualToString:@"no"] || [lower isEqualToString:@"false"])
                        {
                            value = @NO;
                        }
                    }
                }
            }
            if (propertyClass && ! [value isKindOfClass:propertyClass])
            {
                value = nil;
            }
        }
        // 利用KVC键值对coding 进行赋值
        [property setValue:value forObject:object];

    }];
    
    return self;
}

+ (NSMutableArray *)wx_objectArrayWithKeyValuesArray:(NSArray *)keyValuesArray
{
    NSAssert([keyValuesArray isKindOfClass:[NSArray class]], @"传入的不是数组");
    // 如果数组里面是NSString、NSNumber 等数据
    if ([WXCardFoundation isClassFromFoundation:self]) return [NSMutableArray arrayWithArray:keyValuesArray];
    
    // 创建数组
    NSMutableArray *modelArray = [NSMutableArray array];
    
    // 遍历
    for (NSDictionary *keyValues in keyValuesArray) {
        NSAssert([keyValues isKindOfClass:[NSDictionary class]], @"数组里面包的不是字典，数据有误");
        if (![keyValues isKindOfClass:[NSDictionary class]]) continue;
        
        id model = [self wx_objectWithKeyValues:keyValues];
        if (model) [modelArray addObject:model];
    }
    return modelArray;
}

@end
