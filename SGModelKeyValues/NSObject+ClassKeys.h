//
//  NSObject+SGKeyValues.h
//  SGExtention
//
//  Created by Shangen Zhang on 17/1/8.
//  Copyright © 2017年 Shangen Zhang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (ClassKeys)

/**
 遍历当前对象所有的属性

 @param block 遍历block块 key:属性名; *stop == YES时 停止遍历
 */
- (void)sg_enumerateAllKeysUsingBlock:(void(^)(NSString *key,BOOL *stop))block;


/**
 遍历当前类所有的对象属性

 @param block 遍历block块 key:属性名; *stop == YES时 停止遍历
 */
+ (void)sg_enumerateAllKeysUsingBlock:(void(^)(NSString *key,BOOL *stop))block;


/**
 获取当前对象所有属性

 @return 属性名称集合
 */
- (NSSet <NSString *> *)sg_allKeysOfCurrentInstance;

/**
 获取当前类 实例对象所有属性
 
 @return 属性名称集合
 */
+ (NSSet <NSString *> *)sg_allKeysOfCurrentClass;
@end
