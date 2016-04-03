//
//  WXCardPropertyKey.m
//  WXCardModelKit
//
//  Created by  liuyunxuan on 16/4/3.
//  Copyright © 2016年  liuyunxuan. All rights reserved.
//

#import "WXCardPropertyKey.h"

@implementation WXCardPropertyKey

- (id)valueInObject:(id)object
{
    if ([object isKindOfClass:[NSDictionary class]] && self.type == WXCardPropertyKeyTypeDictionary) {
        return object[self.name];
    } else if ([object isKindOfClass:[NSArray class]] && self.type == WXCardPropertyKeyTypeArray) {
        NSArray *array = object;
        NSUInteger index = self.name.intValue;
        if (index < array.count) return array[index];
        return nil;
    }
    return nil;
}

@end
