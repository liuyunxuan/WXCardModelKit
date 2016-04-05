//
//  WXCardProperty.h
//  WXCardModelKit
//
//  Created by  liuyunxuan on 16/4/3.
//  Copyright © 2016年  liuyunxuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WXCardPropertyType.h"
#import <objc/runtime.h>

@interface WXCardProperty : NSObject

/** 成员属性 */
@property (nonatomic, assign) objc_property_t property;
/** 成员属性的名字 */
@property (nonatomic, readonly) NSString *name;

/** 成员属性的类型 */
@property (nonatomic, readonly)  WXCardPropertyType *type;
/** 成员属性来源于哪个类（可能是父类） */
@property (nonatomic, assign) Class srcClass;

/** 对应着字典中的多级key（里面存放的数组，数组里面都是WXCardPropertyKey对象） */
- (NSArray *)propertyKeysForClass:(Class)c;

/**
 *  初始化
 */
+ (instancetype)cachedPropertyWithProperty:(objc_property_t)property;

- (void)setOriginKey:(NSString *)originKey forClass:(Class)c;

/** 模型数组中的模型类型 */
- (void)setObjectClassInArray:(Class)objectClass forClass:(Class)c;
- (Class)objectClassInArrayForClass:(Class)c;

/**
 * 设置object的成员变量值
 */
- (void)setValue:(id)value forObject:(id)object;

@end
