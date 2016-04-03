//
//  WXCardProperty.h
//  WXCardModelKit
//
//  Created by  liuyunxuan on 16/4/3.
//  Copyright © 2016年  liuyunxuan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WXCardProperty : NSObject

/** 对应着字典中的多级key（里面存放的数组，数组里面都是MJPropertyKey对象） */
- (NSArray *)propertyKeysForClass:(Class)c;
@end
