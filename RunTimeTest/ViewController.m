//
//  ViewController.m
//  RunTimeTest
//
//  Created by 周海 on 16/7/4.
//  Copyright © 2016年 zhouhai. All rights reserved.
//

#import <objc/runtime.h>
#import "ViewController.h"
#import "MyClass.h"
@interface ViewController ()
@end

@implementation ViewController

- (void)myProtocol{

}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    MyClass *myclass = [[MyClass alloc] init];
    unsigned int outCount = 0;
    Class cls = myclass.class;
    NSLog(@"==========================================================");
    //类名
    NSLog(@"类名: %s",class_getName(cls));
    NSLog(@"==========================================================");
    
    //父类
    NSLog(@"父类: %s",class_getName(class_getSuperclass(cls)));
    NSLog(@"==========================================================");
    
    //是否是元类
    NSLog(@"是否是元类(meta-class):%@",(class_isMetaClass(cls)?@"是":@"否"));
    NSLog(@"==========================================================");
    
    Class meta_class = objc_getMetaClass(class_getName(cls));
    NSLog(@"%s'类的元类是 %s", class_getName(cls), class_getName(meta_class));
    NSLog(@"==========================================================");
    
    // 变量实例大小
    NSLog(@"myclass这个对象实例大小: %zu", class_getInstanceSize(cls));
    NSLog(@"==========================================================");
    
    // 成员变量
    Ivar *ivars = class_copyIvarList(cls, &outCount);
    for (int i = 0; i < outCount; i++) {
        Ivar ivar = ivars[i];
        NSLog(@"成员变量名: %s 和下标: %d", ivar_getName(ivar), i);
    }
    
    //注意！  记得释放ivars
     free(ivars);
    
    // 获取类中指定名称实例成员变量的信息
    Ivar string = class_getInstanceVariable(cls, "_array");
    if (string != NULL) {
        NSLog(@"变量 %s", ivar_getName(string));
    }
    
    NSLog(@"==========================================================");
    
    // 属性操作
    objc_property_t * properties = class_copyPropertyList(cls, &outCount);
    for (int i = 0; i < outCount; i++) {
        objc_property_t property = properties[i];
        NSLog(@"property's name: %s", property_getName(property));
    }
    
    free(properties);
    
    //获取属性名
    objc_property_t array = class_getProperty(cls, "array");
    if (array != NULL) {
        NSLog(@"property %s", property_getName(array));
    }
    NSLog(@"==========================================================");
    
    // 方法操作
    Method *methods = class_copyMethodList(cls, &outCount);
    for (int i = 0; i < outCount; i++) {
        Method method = methods[i];
        NSLog(@"方法 名: %s", method_getName(method));
    }
    
    free(methods);
    
    Method method1 = class_getInstanceMethod(cls, @selector(method1));
    if (method1 != NULL) {
        NSLog(@"method %s", method_getName(method1));
    }
    
    // 获取实例方法
    Method classMethod = class_getClassMethod(cls, @selector(classMethod1));
    if (classMethod != NULL) {
        NSLog(@"class method : %s", method_getName(classMethod));
    }
    
    NSLog(@"MyClass is%@ responsd to selector: method3WithArg1:arg2:", class_respondsToSelector(cls, @selector(method3WithArg1:arg2:)) ? @"" : @" not");
    
    IMP imp = class_getMethodImplementation(cls, @selector(method1));
    imp();
    
    NSLog(@"==========================================================");
    
    
    // 协议
    //获取遵循的协议
    Protocol * __unsafe_unretained * protocols = class_copyProtocolList(cls, &outCount);
    Protocol * protocol;
    for (int i = 0; i < outCount; i++) {
        protocol = protocols[i];
        NSLog(@"protocol name: %s", protocol_getName(protocol));
    }
    
    NSLog(@"MyClass is%@ responsed to protocol %s", class_conformsToProtocol(cls, protocol) ? @"" : @" not", protocol_getName(protocol));
    
    NSLog(@"==========================================================");
    
    
    
}

@end
