//
//  NSObject+WXCardProperty.h
//  WXCardModelKit
//
//  Created by  liuyunxuan on 16/4/3.
//  Copyright © 2016年  liuyunxuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WXCardProperty.h"
#import "WXCardPropertyKey.h"

typedef void(^WXCardPropertiesEnumeration)(WXCardProperty *property, BOOL *stop);

@interface NSObject (WXCardProperty)

+ (void)wx_enumerateProperties:(WXCardPropertiesEnumeration)enumeration;

@end
