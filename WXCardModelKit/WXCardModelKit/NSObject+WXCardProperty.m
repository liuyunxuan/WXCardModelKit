//
//  NSObject+WXCardProperty.m
//  WXCardModelKit
//
//  Created by  liuyunxuan on 16/4/3.
//  Copyright © 2016年  liuyunxuan. All rights reserved.
//

#import "NSObject+WXCardProperty.h"
#import "WXCardDictionaryCache.h"
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
+ (NSMutableArray *)properties
{
    NSMutableArray *cachedProperties = [WXCardDictionaryCache objectForKey:NSStringFromClass(self) forDictId:&WXCardCachedPropertiesKey];
    
    return cachedProperties;
}

@end
