//
//  NSObject+SGKeyValues.m
//  SGExtention
//
//  Created by Shangen Zhang on 17/1/8.
//  Copyright © 2017年 Shangen Zhang. All rights reserved.
//

#import "NSObject+ClassKeys.h"
#import <objc/message.h>

@implementation NSObject (ClassKeys)

- (void)sg_enumerateAllKeysUsingBlock:(void(^)(NSString *key,BOOL *stop))block {
    [self.class sg_enumerateAllKeysUsingBlock:block];
}

+ (void)sg_enumerateAllKeysUsingBlock:(void(^)(NSString *key,BOOL *stop))block {
    [[self sg_allKeysOfCurrentClass] enumerateObjectsUsingBlock:block];
}

- (NSSet *)sg_allKeysOfCurrentInstance {
    return [self.class sg_allKeysOfCurrentClass];
}

// 核心方法
+ (NSSet *)sg_allKeysOfCurrentClass {
    Class cls = self;
    // 校验foundation 类
    if (cls == [NSSet class] ||
        cls == [NSValue class] ||
        cls == [NSArray class] ||
        cls == [NSObject class] ||
        cls == [NSNumber class] ||
        cls == [NSString class] ||
        cls == [NSMutableSet class] ||
        cls == [NSDictionary class] ||
        cls == [NSMutableArray class] ||
        cls == [NSMutableString class] ||
        cls == [NSMutableDictionary class]
        ) {
        return nil;
    }
    
    // 遍历所有的class
    NSMutableSet *allKeys = [NSMutableSet set];
    do {
        if (cls == [NSObject class]) { // 获取到基类 停止遍历
            return allKeys;
        } else {  // 获取当前class的所有属性
            
            unsigned int ivarsCnt = 0;
            //　获取类成员变量列表，ivarsCnt为类成员数量
            Ivar *ivars = class_copyIvarList(cls, &ivarsCnt);
            
            for (NSInteger i = 0; i < ivarsCnt; i++){
                // 1.获取属性名
                Ivar ivar = ivars[i];
                NSString *ivarName = @(ivar_getName(ivar));
                // 2. 添加到列表
                [allKeys addObject:ivarName];
            }
        }
        // 获取父类class
        cls = class_getSuperclass(cls);
    } while (1);
}
@end
