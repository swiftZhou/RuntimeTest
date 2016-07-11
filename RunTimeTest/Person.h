//
//  Person.h
//  RunTimeTest
//
//  Created by 周海 on 16/7/4.
//  Copyright © 2016年 zhouhai. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Person : NSObject
@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) NSInteger age;
+ (Person*)person;
- (NSString *)my;
- (void)founction;
@end
