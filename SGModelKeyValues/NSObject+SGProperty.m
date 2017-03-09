//
//  NSObject+SGProperty.m
//  test
//
//  Created by shangen on 17/3/8.
//  Copyright © 2017年 HHLY. All rights reserved.
//

#import "NSObject+SGProperty.h"
#import <objc/runtime.h>

static NSString * get_recognisze_type(NSString *typeEencoding);

@implementation NSObject (SGProperty)

- (NSString*)sg_typeOfPropertyNamed:(NSString*) propertyName {
    NSString *propertyType = nil;
    NSString *propertyAttributes;
    
    // Get Class of property.
    Class class = object_getClass(self);
    objc_property_t property = class_getProperty(class, [propertyName UTF8String]);
    
    // Try to get getter method.
    if (property == NULL)
    {
        char typeCString[256];
        Method getter = class_getInstanceMethod(class, NSSelectorFromString(propertyName));
        method_getReturnType(getter, typeCString, 256);
        propertyAttributes = [NSString stringWithCString:typeCString encoding:NSUTF8StringEncoding];
        
        // Mimic type encoding for `typeNameForTypeEncoding:`.
        propertyType = [self sg_typeNameForTypeEncoding:[NSString stringWithFormat:@"T%@", propertyAttributes]];
        
        if (getter == NULL) {
#ifdef DEBUG
            NSLog(@"No property called `%@` of %@", propertyName,NSStringFromClass(self.class));
#endif
        }
    }
    
    // Or go on with property attribute parsing.
    else {
        // Get property attributes.
        const char *propertyAttributesCString;
        propertyAttributesCString = property_getAttributes(property);
        propertyAttributes = [NSString stringWithCString:propertyAttributesCString encoding:NSUTF8StringEncoding];
        
        if (propertyAttributesCString == NULL) {
#ifdef DEBUG
            NSLog(@"Could not get attributes for property called `%@` of <%@>", propertyName, NSStringFromClass(self.class));
#endif
        }
        
        // Parse property attributes.
        NSArray *splitPropertyAttributes = [propertyAttributes componentsSeparatedByString:@","];
        if (splitPropertyAttributes.count > 0) {
            // From Objective-C Runtime Programming Guide.
            // xcdoc://ios//library/prerelease/ios/documentation/Cocoa/Conceptual/ObjCRuntimeGuide/Articles/ocrtPropertyIntrospection.html
            NSString *encodeType = splitPropertyAttributes[0];
            NSArray *splitEncodeType = [encodeType componentsSeparatedByString:@"\""];
            propertyType = (splitEncodeType.count > 1) ? splitEncodeType[1] : [self sg_typeNameForTypeEncoding:encodeType];
        }
        else {
            
            NSLog(@"Could not parse attributes for property called `%@` of <%@>å", propertyName, NSStringFromClass(self.class));
        }
    }
    
    return propertyType;
}
// 提取类型简称
- (NSString *)sg_typeNameForTypeEncoding:(NSString*) typeEncoding {

    // Recognized format.
    NSString *typeName = get_recognisze_type(typeEncoding);
    if (typeName) return typeName;
    
    
    // Struct property.
    if ([typeEncoding hasPrefix:@"T{"]) {
        // Try to get struct name.
        NSCharacterSet *delimiters = [NSCharacterSet characterSetWithCharactersInString:@"{="];
        NSArray *components = [typeEncoding componentsSeparatedByCharactersInSet:delimiters];
        NSString *structName;
        if (components.count > 1) {
            structName = components[1];
        }
        
        // Falls back to `struct` when unknown name encountered.
        if ([structName isEqualToString:@"?"]) structName = @"struct";
        
        return structName;
    }
    
    // Falls back to raw encoding if none of the above.
    return typeEncoding;
}

- (Class)sg_classOfPropertyNamed:(NSString *) propertyName {
    // Attempt to get class of property.
    Class class = nil;
    NSString *className = [self sg_typeOfPropertyNamed:propertyName];
    class = NSClassFromString(className);
    
    // Warning.  没有这个类
    if (class == nil) {
        NSLog(@"No class called `%@` in runtime", className);
    }
    
    return class;
}

// 基本数据类型
static NSString * get_recognisze_type(NSString *typeEncoding) {
    // 参考文档:
    // From Objective-C Runtime Programming Guide.
    // xcdoc://ios//library/prerelease/ios/documentation/Cocoa/Conceptual/ObjCRuntimeGuide/Articles/ocrtTypeEncodings.html
    static NSDictionary *typeNamesForTypeEncodings;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // 构造映射关系 类型简称映射表
        typeNamesForTypeEncodings = @{
                                      
                                      @"Tc" : @"char",
                                      @"Ti" : @"int",
                                      @"Ts" : @"short",
                                      @"Tl" : @"long",
                                      @"Tq" : @"long long",
                                      @"TC" : @"unsigned char",
                                      @"TI" : @"unsigned int",
                                      @"TS" : @"unsigned short",
                                      @"TL" : @"unsigned long",
                                      @"TQ" : @"unsigned long long",
                                      @"Tf" : @"float",
                                      @"Td" : @"double",
                                      @"Tv" : @"void",
                                      @"T^v" : @"void*",
                                      @"T*" : @"char*",
                                      @"T@" : @"id",
                                      @"T#" : @"Class",
                                      @"T:" : @"SEL",
                                      
                                      @"T^c" : @"char*",
                                      @"T^i" : @"int*",
                                      @"T^s" : @"short*",
                                      @"T^l" : @"long*",
                                      @"T^q" : @"long long*",
                                      @"T^C" : @"unsigned char*",
                                      @"T^I" : @"unsigned int*",
                                      @"T^S" : @"unsigned short*",
                                      @"T^L" : @"unsigned long*",
                                      @"T^Q" : @"unsigned long long*",
                                      @"T^f" : @"float*",
                                      @"T^d" : @"double*",
                                      @"T^v" : @"void*",
                                      @"T^*" : @"char**",
                                      
                                      @"T@" : @"id",
                                      @"T#" : @"Class",
                                      @"T:" : @"SEL"
                                      
                                      };
    });
    // 返回映射
    return [typeNamesForTypeEncodings objectForKey:typeEncoding];
}

@end
