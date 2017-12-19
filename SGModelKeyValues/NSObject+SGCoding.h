//
//  NSObject+SGCoding.h
//  LeYingTong
//
//  Created by shangen on 17/1/10.
//  Copyright © 2017年 HHLY. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  Coding协议
 */
@protocol SGCoding <NSObject>
@optional
/**
 *  这个数组中的属性名才会进行归档
 */
+ (NSArray *)sg_allowedCodingKeys;

/**
 *  这个数组中的属性名将会被忽略：不进行归档
 */
+ (NSArray *)sg_ignoredCodingKeys;

@end

@interface NSObject (SGCoding) <SGCoding>

/**
 *  编码（将对象写入文件中）
 */
- (void)sg_encode:(NSCoder *)encoder;

/**
 *  解码（从文件中解析对象）
 */
- (void)sg_decode:(NSCoder *)decoder;

@end

/**
 归档的实现
 */
#define SGCodingImplementation \
- (id)initWithCoder:(NSCoder *)decoder \
{ \
if (self = [super init]) { \
[self sg_decode:decoder]; \
} \
return self; \
} \
\
- (void)encodeWithCoder:(NSCoder *)encoder \
{ \
[self sg_encode:encoder]; \
}

#define SGExtentionCodingImplementation SGCodingImplementation
