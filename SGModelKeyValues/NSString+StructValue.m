//
//  NSString+StructValue.m
//  test
//
//  Created by shangen on 17/3/8.
//  Copyright © 2017年 HHLY. All rights reserved.
//

#import "NSString+StructValue.h"
#import <UIKit/UIKit.h>

@implementation NSString (StructValue)
// 容错处理
#pragma mark - number
- (long long)unsignedLongLongValue {
    return llabs([self longLongValue]);
}
- (unsigned int)unsignedIntValue {
    return abs([self intValue]);
}
- (unsigned long long)unsignedIntegerValue {
    return llabs([self unsignedLongLongValue]);
}
- (BOOL)charValue {
    return [self intValue];
}
#pragma  struct
- (CGSize)sizeValue {
    return CGSizeFromString(self);
}
- (CGPoint)pointValue {
    return CGPointFromString(self);
}
- (CGRect)rectValue {
    return CGRectFromString(self);
}
- (NSRange)rangeValue {
    return NSRangeFromString(self);
}

#pragma mark - values
- (id)structValueWithName:(NSString *)structName {
    
    if ([structName isEqualToString:@"UIOffset"]) {
        return [NSValue valueWithUIOffset:UIOffsetFromString(self)];
    }
    
    if ([structName isEqualToString:@"UIEdgeInsets"]) {
        return [NSValue valueWithUIEdgeInsets:UIEdgeInsetsFromString(self)];
    }
    
    if ([structName isEqualToString:@"CGAffineTransform"]) {
        return [NSValue valueWithCGAffineTransform:CGAffineTransformFromString(self)];
    }
    
    if ([structName isEqualToString:@"CGVector"]) {
        return [NSValue valueWithCGVector:CGVectorFromString(self)];
    }
    
    return nil;
}

@end

