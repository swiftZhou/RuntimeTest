//
//  MyClass.m
//  RunTimeTest
//
//  Created by 周海 on 16/7/7.
//  Copyright © 2016年 zhouhai. All rights reserved.
//

#import "MyClass.h"


@interface MyClass () {
    NSInteger       _instance1;
    NSString    *   _instance2;
}

@property (nonatomic, assign) NSUInteger integer;
- (void)method3WithArg1:(NSInteger)arg1 arg2:(NSString *)arg2;

@end
@implementation MyClass

+ (void)classMethod1 {
    
}

- (void)method1 {
    NSLog(@"走了方法method1");
}

- (void)method2 {
}

- (void)method3WithArg1:(NSInteger)arg1 arg2:(NSString *)arg2 {
    NSLog(@"参数1arg1 : %ld, 参数2arg2 : %@", arg1, arg2);
}
@end
