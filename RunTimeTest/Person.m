//
//  Person.m
//  RunTimeTest
//
//  Created by 周海 on 16/7/4.
//  Copyright © 2016年 zhouhai. All rights reserved.
//

#import "Person.h"
@interface Person ()

@property (nonatomic, copy) NSString *score;
@end
@implementation Person

- (instancetype)init{
    self = [super init];
    if (self) {
        self.score = @"75";
    }
    return self;
}
+ (Person*)person{
    Person *p = [[self alloc] init];
    return p;
}
-(NSString *)my{
    NSLog(@"my name:%@ age:%ld",self.name,self.age);
    NSString *str = [NSString stringWithFormat:@"我叫%@,今年%ld岁。",self.name,self.age];
    return str;
}
- (void)founction{

    NSLog(@"%s",__func__);
}
@end
