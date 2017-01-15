//
//  NSObject+SGExtention.m
//  runtime
//
//  Created by Shangen Zhang on 16/12/20.
//  Copyright © 2016年 HNB. All rights reserved.
//

#import "NSObject+ModelKeyValues.h"
#import "NSObject+ClassKeys.h"
#import <objc/message.h>

// 映射字典关联的key值
static NSString * const sg_ModelClassForIvarNameMapDict = @"sg_ModelClassForIvarNameMapDict";
static NSString * const sg_DictKeyForIvarNameMapDict = @"sg_DictKeyForIvarNameMapDict";

@implementation NSObject (ModelKeyValues)
#pragma mark - 字典转模型
/** 核心方法 */
+ (instancetype)sg_objectWithKeyValue:(NSDictionary *)keyValue {
    
    // 0. 校验基本数据类型
    if (
        [self isKindOfClass:[NSValue class]] ||
        [self isKindOfClass:[NSString class]] ||
        [self isKindOfClass:[NSNumber class]] ||
        [self isKindOfClass:[NSData class]]
        ) {
        return nil;
    }

    // 1. 数组校验
    if ([keyValue isKindOfClass:[NSArray class]]) {
        return  [self sg_objectArrayFromKeyValues:keyValue];
    }
    
    // 2. 实际类型校验
    if ([keyValue isKindOfClass:self]) {
        return  keyValue;
    }
    
    if (![keyValue isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    
    // 3. 创建模型
    id object = [[self alloc] init];
    
    // 4. 属性赋值
    [self sg_enumerateAllKeysUsingBlock:^(NSString *key, BOOL *stop) {

        // 1. key值处理 去除下滑线
        NSString * key_ = nil;
        if ([key hasPrefix:@"_"]) { // “_”下划线处理
            key_ = [key substringFromIndex:1];
        }else {
            key_ = key;
        }
        
        // 2. 获取字典中value的key 与对象名称对应关系 对象的key与属性不一样（如：字典为id 模型为：ID） 映射字典 （属性名称与字典key值映射）
        // 2.1 获取映射值
        NSString *mapKey = [self getKeyMapWithIvarName:key] ? : [self getKeyMapWithIvarName:key_];
        // 2.2 获取字典key
        NSString *dictValueKey = mapKey ? : key;
        
        // 3.获取字典的value //  去掉下划线的key
        id value = keyValue[dictValueKey] ? : keyValue[key_];
        
        // 4.字典空值校验
        if (!value) {
            return;
        }
    
        // 5. 判断是否是二级模型  获取到二级模型class 调用sg_objectWithKeyValues:方法 （二级模型映射字典）
        Class subClass = [self getClassWithIvarName:key] ? : [self getClassWithIvarName:key_];
        if (subClass) {
            id subObject = nil;
            if ([value isKindOfClass:[NSArray class]]) {
                subObject = [subClass sg_objectArrayFromKeyValues:value];
            }else if ([value isKindOfClass:[NSDictionary class]]) {
                subObject = [subClass sg_objectWithKeyValue:value];
            }
            !subObject ? : [object setValue:subObject forKey:key]; // 递归转模型
            return;
        }
        
        // 6. 不是二级模型
        // 6.1 数字类型转化为string类型
        if ([value isKindOfClass:[NSNumber class]]) {
            value = [NSString stringWithFormat:@"%@",value];
        }
       
    
        // 6.2 赋值
        [object setValue:value forKey:key];
        
    }];
    
    // 5. 返回模型
    return object;
}

// 字典数组转模型数组
+ (NSArray *)sg_objectArrayFromKeyValues:(id)keyValues {
    // 1、字典校验
    if ([keyValues isKindOfClass:[NSDictionary class]]) {
        return @[[self sg_objectWithKeyValue:keyValues]];
    }
    
    // 2、keyValues对象为自己
    if ([keyValues isKindOfClass:self]) {
        return @[keyValues];
    }

    // 3、数组校验
    if (![keyValues isKindOfClass:[NSArray class]]) {
#ifdef DEBUG // 调试报错处理
        [NSException raise:@"传参错误" format:@"keyValues:%@(%@)不是一个数组类型", NSStringFromClass([keyValues class]),keyValues];
#endif
        return nil;
    }
    
    // 4、数组 --> 模型数组
    NSMutableArray *objecs = [NSMutableArray array];
    id model;
    for (id value in keyValues) {
        model = [self sg_objectWithKeyValue:value];
        !model ?: [objecs addObject:model];
    }
    return objecs;
}

#pragma mark - 对象转字典
- (id)sg_keyValues {
    return [self sg_keyValuesWithIgnoreKey:nil];
}
// 忽略的key值
- (id)sg_keyValuesWithIgnoreKey:(NSArray <NSString *> *)ignoreKeys {
    // 0. 校验基本数据类型
    if (
        [self isKindOfClass:[NSValue class]] ||
        [self isKindOfClass:[NSString class]] ||
        [self isKindOfClass:[NSNumber class]] ||
        [self isKindOfClass:[NSData class]]
        ) {
        return self;
    }
    
    id object;
    // 1、数组/集合
    if ([self isKindOfClass:[NSArray class]] || [self isKindOfClass:[NSSet class]]) {
        object = [NSMutableArray array];
        for (id obj in (NSArray *)self) {
            [object addObject:[obj sg_keyValues]];
        }
        
        return object;
    }
    
    // 2、 字典、模型
    object = [[NSMutableDictionary alloc] init];
    
    // 2.1、 字典
    if ([self isKindOfClass:[NSDictionary class]]) {
        // 获取字典 value的实际类型
        [(NSDictionary *)self enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            
            if ([obj isKindOfClass:[NSString class]] ||
                [obj isKindOfClass:[NSNumber class]] ||
                [obj isKindOfClass:[NSData class]]
                ) {
                [object setObject:obj forKey:key];
            }else {
                [object setObject:[obj sg_keyValues] forKey:key];
            }
        }];
        return object;
    }
    
    // 2.2 模型 --> 字典  获取模型属性列表
    [self sg_enumerateAllKeysUsingBlock:^(NSString *key, BOOL *stop) {
        // 1. key值处理 去除下滑线
        NSString * key_ = nil;
        if ([key hasPrefix:@"_"]) { // “_”下划线处理
            key_ = [key substringFromIndex:1];
        }else {
            key_ = key;
        }
        // 1.1 key值忽略处理
        if ([ignoreKeys containsObject:key] || [ignoreKeys containsObject:key_]) {
            return;
        }
        
        // 2.获取对象的value
        id value = [self valueForKey:key];
        
        // 3.字典空值校验
        if (!value) {
            return;
        }
        // 将子目录转化为字典数组
        value = [value sg_keyValues];
        
        // 4. 获取字典中value的key 与对象名称对应关系 对象的key与属性不一样（如：字典为id 模型为：ID） 映射字典 （属性名称与字典key值映射）
        NSString *mapKey = [self.class getKeyMapWithIvarName:key] ? : [self.class getKeyMapWithIvarName:key_];
        NSString *dictValueKey = mapKey ? : key_;
        
        // 5. 判断是否是二级模型  获取到二级模型class 调用sg_objectWithKeyValues:方法 （二级模型映射字典）
        Class subClass = [self.class getClassWithIvarName:key] ? : [self.class getClassWithIvarName:key_];
        
        if (subClass) {
            id subObject = [value sg_keyValues];
            !subObject ? : [object setValue:subObject forKey:dictValueKey]; // 递归转模型
            return;
        }
        // 6. 不是二级模型
        if ([value isKindOfClass:[NSNumber class]]) {
            value = [NSString stringWithFormat:@"%@",value];
        }
        // 赋值
        [object setValue:value forKey:dictValueKey];
        
    }];
    
    // 返回字典
    return object;
    
}
#pragma mark - 转换为JSON
- (NSString *)sg_JSONString {
    if ([self isKindOfClass:[NSString class]]) {
        return (NSString *)self;
    } else if ([self isKindOfClass:[NSData class]]) {
        return [[NSString alloc] initWithData:(NSData *)self encoding:NSUTF8StringEncoding];
    }
    
    return [[NSString alloc] initWithData:[self sg_JSONData] encoding:NSUTF8StringEncoding];
}

- (NSData *)sg_JSONData {
    if ([self isKindOfClass:[NSString class]]) {
        return [((NSString *)self) dataUsingEncoding:NSUTF8StringEncoding];
    } else if ([self isKindOfClass:[NSData class]]) {
        return (NSData *)self;
    }
    return [NSJSONSerialization dataWithJSONObject:[self sg_keyValues] options:kNilOptions error:nil];
}

- (id)sg_JSONDictionary {
    
    if ([self isKindOfClass:[NSString class]]) {
        return  [NSJSONSerialization JSONObjectWithData:[((NSString *)self) dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:nil];
    }else if ([self isKindOfClass:[NSData class]]) {
        return [NSJSONSerialization JSONObjectWithData:(NSData *)self options:kNilOptions error:nil];
    }
    
    return [self sg_keyValues];
}

#pragma mark - 设置映射关系
// 获取映射类
+ (Class)getClassWithIvarName:(NSString *)ivarName {
    NSDictionary *classMap = [self sg_getModelClassForIvarNameMapDict];
    id className =  classMap[ivarName];
    if (![className isKindOfClass:[NSString class]]) {
        return className;
    }
    return  NSClassFromString(className);
}

// 获取映射key
+ (NSString *)getKeyMapWithIvarName:(NSString *)ivarName {
    NSDictionary *keyMap = [self sg_getDictionarrayKeyForIvarNameMapDict];
    return keyMap[ivarName];
}


// 获取二级模型映射字典
+ (NSDictionary *)sg_getModelClassForIvarNameMapDict {
    return objc_getAssociatedObject(self, (__bridge const void *)(sg_ModelClassForIvarNameMapDict));
}

// 获取属性名称与字典key值映射
+ (NSDictionary *)sg_getDictionarrayKeyForIvarNameMapDict {
    return objc_getAssociatedObject(self, (__bridge const void *)(sg_DictKeyForIvarNameMapDict));
}

// 设置映射字典
+ (void)sg_setKeyForIvarNameMapDict:(NSDictionary *)keyMap {
    
    NSMutableDictionary *dict = [[self sg_getDictionarrayKeyForIvarNameMapDict] mutableCopy];
    
    if (!dict) {
        dict = [NSMutableDictionary dictionary];
    }
    
    [keyMap enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        [dict setObject:obj forKey:key];
    }];
    
    objc_setAssociatedObject(self, (__bridge const void *)(sg_DictKeyForIvarNameMapDict), dict, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

// 设置模型映射字典
+ (void)sg_setModelClassForIvarNameMapDict:(NSDictionary *)classMap {
    
    NSMutableDictionary *dict = [[self sg_getModelClassForIvarNameMapDict] mutableCopy];
    
    if (!dict) {
        dict = [NSMutableDictionary dictionary];
    }
    
    [classMap enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        [dict setObject:obj forKey:key];
    }];
    
    objc_setAssociatedObject(self, (__bridge const void *)(sg_ModelClassForIvarNameMapDict), dict, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
@end
