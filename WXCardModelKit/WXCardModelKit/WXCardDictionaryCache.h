//
//  WXCardDictionaryCache.h  用来缓存的一个类只是，全部在内存里的
//  WXCardModelKit
//
//  Created by  liuyunxuan on 16/4/3.
//  Copyright © 2016年  liuyunxuan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WXCardDictionaryCache : NSObject

/**
 *  缓存数据
 *
 *  @param object
 *  @param key
 *  @param dicId
 */
+ (void)setObject:(id)object forKey:(id<NSCopying>)key forDictId:(const void *)dicId;

/**
 *  获得缓存的数据
 *
 *  @param key
 *  @param dicId
 *
 *  @return
 */
+ (id)objectForKey:(id<NSCopying>)key forDictId:(const void *)dicId;

/**
 *  获得缓存的字典
 *
 *  @param dicId
 *
 *  @return
 */
+ (NSMutableDictionary *)dicWithDicId:(const void *)dicId;

@end
