//
//  NSObject+SGExtention.h
//  runtime
//
//  Created by Shangen Zhang on 16/12/20.
//  Copyright © 2016年 HNB. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol SGModelKeyValuesProtocol <NSObject>
@optional
/**
 * 属性对象class与字典映射字典
 *
 * classMap : 属性名称对应的clas 如: 模型中属性为 SubClass *sub  classMap = @{@"sub" : [SubClass class]} 或者 @{@"sub" : @"SubClass"}
 */
+ (NSDictionary *)sg_getModelClassForIvarNameMapDict;

/**
 * 属性名称与字典映射字典
 *
 * keMap : 属性名称在字典中的key  如: 模型中的属性为ID 而网络获取的字典的key为 id keyMap = @{@"ID" : @"id"}
 */
+ (NSDictionary *)sg_getDictionarrayKeyForIvarNameMapDict;

@end



@interface NSObject (ModelKeyValues) <SGModelKeyValuesProtocol>
/**
 * 字典转模型
 *
 * keyValue : 字典
 */
+ (instancetype)sg_objectWithKeyValue:(NSDictionary *)keyValue;

/**
 *  字典数组 转模型数组
 *
 * keyValues : 数组字典、数组、字典
 */
+ (NSArray *)sg_objectArrayFromKeyValues:(id)keyValues;


/** 模型转字典、数组 */
- (id)sg_keyValues;

/**
 模型转字典、数组
 
 @param ignoreKeys 忽略转化的属性名称
 @return 字典、数组
 */
- (id)sg_keyValuesWithIgnoreKey:(NSArray <NSString *> *)ignoreKeys;


/** 对象转JSONString */
- (NSString *)sg_JSONString;

/** 对象转JSONData */
- (NSData *)sg_JSONData;

/** 字符串转字典 */
- (id)sg_JSONDictionary;
@end
