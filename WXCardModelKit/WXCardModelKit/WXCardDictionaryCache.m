//
//  WXCardDictionaryCache.m
//  WXCardModelKit
//
//  Created by  liuyunxuan on 16/4/3.
//  Copyright © 2016年  liuyunxuan. All rights reserved.
//

#import "WXCardDictionaryCache.h"
#import <objc/runtime.h>

@implementation WXCardDictionaryCache

+ (void)setObject:(id)object forKey:(id<NSCopying>)key forDictId:(const void *)dicId
{
    NSMutableDictionary *dict = [self dicWithDicId:dicId];
    if (!dict) {
        dict = [NSMutableDictionary dictionary];
        objc_setAssociatedObject(self, dicId, dict, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    [dict setObject:object forKey:key];
}

+ (id)objectForKey:(id<NSCopying>)key forDictId:(const void *)dicId
{
    return [[self dicWithDicId:dicId] objectForKey:key];
}

+ (NSMutableDictionary *)dicWithDicId:(const void *)dicId
{
    return objc_getAssociatedObject(self, dicId);
}
@end
