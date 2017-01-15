//
//  SGSubObject.m
//  runtime-getterValue
//
//  Created by Shangen Zhang on 16/12/20.
//  Copyright © 2016年 HNB. All rights reserved.
//

#import "SGSubObject.h"
#import "NSObject+ModelKeyValues.h"

@implementation SGSubObject

+ (void)initialize {

    [self sg_setKeyForIvarNameMapDict:@{@"nikeName" : @"nike_Name"}];
}

#pragma mark - MJ 建立映射关系

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    return @{@"nikeName" : @"nike_Name"};
}
#pragma mark - YY 建立映射关系
+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper {
    return @{@"nikeName" : @"nike_Name"};
}


@end
