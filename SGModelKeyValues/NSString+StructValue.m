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
- (long long)unsignedLongLongValue { // 容错处理
    return llabs([self longLongValue]);
}
- (unsigned int)unsignedIntValue {
    return abs([self intValue]);
}
- (CGSize)sizeValue {
    return CGSizeFromString(self);
}
- (CGPoint)pointValue {
    return CGPointFromString(self);
}
- (CGRect)rectValue {
    return CGRectFromString(self);
}

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
    //return [NSValue value:(__bridge const void * _Nonnull)(self) withObjCType:[structName cStringUsingEncoding:NSUTF8StringEncoding]];
}

@end
//    if ([self containsString:@"{"] && [self containsString:@"}"]) {
//
//        NSRange range1 = [self rangeOfString:@"{"];
//        NSRange range2 = [self rangeOfString:@"}"];
//
//        if (range1.location > range2.location) {
//            return CGSizeZero;
//        }
//
//        NSString *subSrting = [self substringWithRange:NSMakeRange(range1.location + 1, range2.location - range1.location - 1)];
//
//        NSArray *strArray = [subSrting componentsSeparatedByString:@","];
//
//        if (strArray.count < 2) {
//            return CGSizeZero;
//        }
//
//        CGFloat width  = [strArray[0] floatValue];
//        CGFloat height = [strArray[1] floatValue];
//        return CGSizeMake(width, height);
//    }
//
//    return CGSizeZero;
