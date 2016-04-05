//
//  NSObject+WXCardClass.m
//  WXCardModelKit
//
//  Created by  liuyunxuan on 16/4/4.
//  Copyright © 2016年  liuyunxuan. All rights reserved.
//

#import "NSObject+WXCardClass.h"
#import "WXCardFoundation.h"
#import <objc/runtime.h>

@implementation NSObject (WXCardClass)

+ (void)wx_enumerateAllClasses:(WXCardClassesEnumeration)enumeration
{
    // 1.没有block就直接返回
    if (enumeration == nil) return;
    
    // 2.停止遍历的标记
    BOOL stop = NO;
    
    // 3.当前正在遍历的类
    Class c = self;
    
    // 4.开始遍历每一个类
    while (c && !stop) {
        // 4.1.执行操作
        enumeration(c, &stop);
        
        // 4.2.获得父类
        c = class_getSuperclass(c);
        
        if([WXCardFoundation isClassFromFoundation:c]) break;
    }
}

@end
