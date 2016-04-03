//
//  NSObject+WXCardKeyValue.m
//  WXCardModelKit
//
//  Created by  liuyunxuan on 16/4/3.
//  Copyright © 2016年  liuyunxuan. All rights reserved.
//

#import "NSObject+WXCardKeyValue.h"

@implementation NSObject (WXCardKeyValue)

+ (instancetype)wx_objectWithKeyValues:(NSDictionary *)keyValues
{
    NSAssert([keyValues isKindOfClass:[NSDictionary class]], @"传入的数据不是dictionary");
    return [[[self alloc] init]wx_setKeyValues:keyValues];
}

- (instancetype)wx_setKeyValues:(NSDictionary *)keyValues
{
    Class class = [self class];
    
    
    return self;
}
@end
