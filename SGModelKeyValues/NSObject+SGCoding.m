//
//  NSObject+SGCoding.m
//  LeYingTong
//
//  Created by shangen on 17/1/10.
//  Copyright © 2017年 HHLY. All rights reserved.
//

#import "NSObject+SGCoding.h"
#import "NSObject+ModelKeyValues.h"
#import "NSObject+ClassKeys.h"

@implementation NSObject (SGCoding)

- (void)sg_encode:(NSCoder *)encoder {
    
    NSArray *allows = [self.class allowedCodingKeys];
    NSArray *ignors = [self.class ignoredCodingKeys];
    
    // 归档
    [self sg_enumerateAllKeysUsingBlock:^(NSString *key, BOOL *stop) {
        
        // 检测是否被忽略
        if (allows.count && ![allows containsObject:key]) return;
        if ([ignors containsObject:key]) return;
        
        id value = [self valueForKey:key];
        if (!value) return;
        value = [value sg_keyValues];
        
        @try {
            [encoder encodeObject:value forKey:key];
        } @catch (NSException *exception) {
#ifdef DEBUG
            NSLog(@"%@属性%@不支持%@归档",NSStringFromClass(self.class),key,value);
#endif
        } @finally {
            
        }
       
        
    }];
}

- (void)sg_decode:(NSCoder *)decoder {
    
    NSArray *allows = [self.class allowedCodingKeys];
    NSArray *ignors = [self.class ignoredCodingKeys];
    // 解档
    [self sg_enumerateAllKeysUsingBlock:^(NSString *key, BOOL *stop) {
        
        // 检测是否被忽略
        if (allows.count && ![allows containsObject:key]) return;
        if ([ignors containsObject:key]) return;
        
        id value = [decoder decodeObjectForKey:key];
        if (!value) return ;
        
        // 安全解档
        @try {
            [self setValue:value forKey:key];
        } @catch (NSException *exception) {
#ifdef DEBUG
            NSLog(@"%@属性%@不支持%@解档",NSStringFromClass(self.class),key,value);
#endif
        } @finally {
            
        }
        
    }];
}

/**
 *  这个数组中的属性名才会进行归档
 */
+ (NSArray *)allowedCodingKeys {
    return nil;
}

/**
 *  这个数组中的属性名将会被忽略：不进行归档
 */
+ (NSArray *)ignoredCodingKeys {
    return nil;
}


@end
