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
@implementation NSObject (WXCardKeyValue)

+ (instancetype)wx_objectWithKeyValues:(NSDictionary *)keyValues
{
    NSAssert([keyValues isKindOfClass:[NSDictionary class]], @"传入的数据不是dictionary");
    return [[[self alloc] init]wx_setKeyValues:keyValues];
}

- (instancetype)wx_setKeyValues:(NSDictionary *)keyValues
{
    Class class = [self class];
    
    [class wx_enumerateProperties:^(WXCardProperty *property, BOOL *stop) {
        id value;
        NSArray *propertyKeyses = [property propertyKeysForClass:class];
        for (NSArray *propertyKeys in propertyKeyses)
        {
            value = keyValues;
            for (WXCardPropertyKey *propertyKey in propertyKeys)
            {
                value = [propertyKey valueInObject:value];
            }
            if (value) break;
        }
    }];
    
    return self;
}

@end
