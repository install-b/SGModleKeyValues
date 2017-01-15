//
//  SGObject.m
//  runtime-getterValue
//
//  Created by Shangen Zhang on 16/12/20.
//  Copyright © 2016年 HNB. All rights reserved.
//

#import "SGObject.h"
#import "NSObject+ModelKeyValues.h"
#import <MJExtension.h>

@implementation SGObject
#pragma MARK - SG 建立映射关系
+ (void)initialize {
    [self sg_setKeyForIvarNameMapDict:@{@"petdog" : @"dog"}];
    
    [self sg_setModelClassForIvarNameMapDict:@{@"petdog" : [SGSubObject class]}];
}
#pragma mark - MJ 建立映射关系
+ (NSDictionary *)mj_objectClassInArray {
    return @{@"petdog" : [SGSubObject class]};
}

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"petdog" : @"dog"};
}
#pragma mark - YY 建立映射关系
+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper {
    return @{@"petdog" : @"dog"};
}

+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass {
    return @{@"petdog" : [SGSubObject class]};
}
@end
