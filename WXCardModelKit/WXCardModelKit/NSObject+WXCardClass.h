//
//  NSObject+WXCardClass.h
//  WXCardModelKit
//
//  Created by  liuyunxuan on 16/4/4.
//  Copyright © 2016年  liuyunxuan. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 *  遍历所有类的block（父类）
 */
typedef void (^WXCardClassesEnumeration)(Class c, BOOL *stop);

@interface NSObject (WXCardClass)

///便利所有的类但不包含来自于foundation中的类
+ (void)wx_enumerateAllClasses:(WXCardClassesEnumeration)enumeration;
@end
