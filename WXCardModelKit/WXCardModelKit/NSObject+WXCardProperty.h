//
//  NSObject+WXCardProperty.h
//  WXCardModelKit
//
//  Created by  liuyunxuan on 16/4/3.
//  Copyright © 2016年  liuyunxuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WXCardProperty.h"

typedef void(^WXCardPropertiesEnumeration)(WXCardProperty *property, BOOL *stop);

@interface NSObject (WXCardProperty)

+ (void)wx_enumerateProperties:(WXCardPropertiesEnumeration)enumeration;

/** 对应着字典中的多级key（里面存放的数组，数组里面都是MJPropertyKey对象） */
- (NSArray<WXCardProperty *> *)propertyKeysForClass:(Class)c;
@end
