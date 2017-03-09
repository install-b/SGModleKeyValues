//
//  NSObject+SGProperty.h
//  test
//
//  Created by shangen on 17/3/8.
//  Copyright © 2017年 HHLY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (SGProperty)

/**
 获取实际类型字符串（例如: NSObject类返回就是@"NSObject", CGSize结构体就是返回就:@"CGSize"）

 @param propertyName 属性名称
 @return 实际类型的字符串
 */
- (NSString *)sg_typeOfPropertyNamed:(NSString *)propertyName;


/**
 获取属性实际类型 只针对OC对象才有class返回

 @param propertyName 属性名称
 @return 实际类型class
 */
- (Class)sg_classOfPropertyNamed:(NSString *)propertyName;
@end
