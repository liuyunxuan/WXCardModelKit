//
//  NSObject+WXCardKeyValue.h
//  WXCardModelKit
//
//  Created by  liuyunxuan on 16/4/3.
//  Copyright © 2016年  liuyunxuan. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol WXCardKeyValue<NSObject>

@optional
/**
 *  将属性名换为其他key去字典中取值
 *
 *  @return 字典中的key是属性名，value是从字典中取值用的key
 */
+ (NSDictionary *)wx_replacedKeyFromPropertyName;

@end

@interface NSObject (WXCardKeyValue)<WXCardKeyValue>
/**
 *  通过字典来创建一个模型
 *  @param keyValues 字典(可以是NSDictionary、NSData、NSString)
 *  @return 新建的对象
 */
+ (instancetype)wx_objectWithKeyValues:(NSDictionary *)keyValues;

@end
