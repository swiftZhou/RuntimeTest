//
//  MyClass.h
//  RunTimeTest
//
//  Created by 周海 on 16/7/7.
//  Copyright © 2016年 zhouhai. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface MyClass : NSObject<NSPortDelegate>
@property (nonatomic, strong) NSArray *array;
@property (nonatomic, copy) NSString *string;

- (void)method1;

- (void)method2;

+ (void)classMethod1;
@end
