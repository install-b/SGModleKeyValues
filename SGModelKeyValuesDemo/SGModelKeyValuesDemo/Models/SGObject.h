//
//  SGObject.h
//  runtime-getterValue
//
//  Created by Shangen Zhang on 16/12/20.
//  Copyright © 2016年 HNB. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SGSubObject.h"

@interface SGObject : NSObject
{
    NSString * name;
}

///** name */
//@property (nonatomic,copy) NSString *name;

/** height */
@property (nonatomic,assign) CGFloat height;

/** age */
@property (nonatomic,assign) NSInteger age;


/** id */
@property (nonatomic,assign) NSUInteger indentifer;


/** 二级模型 */
@property (nonatomic,strong) SGSubObject *petdog;


@end
