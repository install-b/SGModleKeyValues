//
//  NSString+SGULLValue.m
//  TaiYangHua
//
//  Created by admin on 16/12/22.
//  Copyright © 2016年 hhly. All rights reserved.
//

#import <Foundation/Foundation.h>

@implementation NSString (SGULLValue)
- (long long)unsignedLongLongValue { // 容错处理
    return llabs([self longLongValue]);
}
@end
