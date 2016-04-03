//
//  WXCardPropertyKey.h
//  WXCardModelKit
//
//  Created by  liuyunxuan on 16/4/3.
//  Copyright © 2016年  liuyunxuan. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef enum {
    WXCardPropertyKeyTypeDictionary = 0, // 字典的key
    WXCardPropertyKeyTypeArray // 数组的key
} WXCardPropertyKeyType;


@interface WXCardPropertyKey : NSObject
///key 的名字
@property (nonatomic, copy) NSString *name;
///key的种类
@property (nonatomic, assign) WXCardPropertyKeyType type;

- (id)valueInObject:(id)object;

@end
