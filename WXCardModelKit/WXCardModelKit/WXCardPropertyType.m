//
//  WXCardPropertyType.m
//  WXCardModelKit
//
//  Created by  liuyunxuan on 16/4/4.
//  Copyright © 2016年  liuyunxuan. All rights reserved.
//

#import "WXCardPropertyType.h"
#import "WXCardDictionaryCache.h"
#import "WXCardModelConst.h"
#import "WXCardFoundation.h"

@implementation WXCardPropertyType
+ (instancetype)cachedTypeWithCode:(NSString *)code
{
//    MJExtensionAssertParamNotNil2(code, nil);
    
    static const char MJCachedTypesKey = '\0';
    
    WXCardPropertyType *type = [WXCardDictionaryCache objectForKey:code forDictId:&MJCachedTypesKey];
    if (type == nil) {
        type = [[self alloc] init];
        type.code = code;
        [WXCardDictionaryCache setObject:type forKey:code forDictId:&MJCachedTypesKey];
    }
    return type;
}

#pragma mark - 公共方法
- (void)setCode:(NSString *)code
{
    _code = code;
    
//    MJExtensionAssertParamNotNil(code);
    
    if ([code isEqualToString:WXCardPropertyTypeId]) {
        _idType = YES;
    } else if (code.length == 0) {
        _KVCDisabled = YES;
    } else if (code.length > 3 && [code hasPrefix:@"@\""]) {
        // 去掉@"和"，截取中间的类型名称
        _code = [code substringWithRange:NSMakeRange(2, code.length - 3)];
        _typeClass = NSClassFromString(_code);
        _fromFoundation = [WXCardFoundation isClassFromFoundation:_typeClass];
        _numberType = [_typeClass isSubclassOfClass:[NSNumber class]];
        
    } else if ([code isEqualToString:WXCardPropertyTypeSEL] ||
               [code isEqualToString:WXCardPropertyTypeIvar] ||
               [code isEqualToString:WXCardPropertyTypeMethod]) {
        _KVCDisabled = YES;
    }
    
    // 是否为数字类型
    NSString *lowerCode = _code.lowercaseString;
    NSArray *numberTypes = @[WXCardPropertyTypeInt, WXCardPropertyTypeShort, WXCardPropertyTypeBOOL1, WXCardPropertyTypeBOOL2, WXCardPropertyTypeFloat, WXCardPropertyTypeDouble, WXCardPropertyTypeLong, WXCardPropertyTypeLongLong, WXCardPropertyTypeChar];
    if ([numberTypes containsObject:lowerCode]) {
        _numberType = YES;
        
        if ([lowerCode isEqualToString:WXCardPropertyTypeBOOL1]
            || [lowerCode isEqualToString:WXCardPropertyTypeBOOL2]) {
            _boolType = YES;
        }
    }
}

@end
