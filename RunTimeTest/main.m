//
//  main.m
//  RunTimeTest
//
//  Created by 周海 on 16/7/4.
//  Copyright © 2016年 zhouhai. All rights reserved.
//

#import <objc/objc.h>
#import <objc/runtime.h>
#import "Person.h"
#import "AppDelegate.h"



// cfunction 函数
float cfunction(id self,SEL _cmd,NSString *str){
    NSLog(@"1111--%@",str);
    return 10.0f;
}

void cfunction2(id self,SEL _cmd,NSString *str,NSString *str2){
    NSLog(@"str--%@,str2--%@",str,str2);
}


void TestMetaClass(id self, SEL _cmd) {
    
    NSLog(@"This objcet is %p", self);
    NSLog(@"Class is %@, super class is %@", [self class], [self superclass]);
    
    Class currentClass = [self class];
    for (int i = 0; i < 4; i++) {
        NSLog(@"Following the isa pointer %d times gives %p", i, currentClass);
        currentClass = objc_getClass((__bridge void *)currentClass);
    }
    
    NSLog(@"NSObject's class is %p", [NSObject class]);
    NSLog(@"NSObject's meta class is %p", objc_getClass((__bridge void *)[NSObject class]));
}
int main(int argc, char * argv[]) {
    @autoreleasepool {

      
        //-----------------------------------------------------------
    
        //OC代码-------------------------------
/*
        
        Person *p = [[Person alloc] init];
        p.name = @"周海";
        p.age = 18;
        [p my];
 */
        
        //OC运行时的代码------------------------
        /*
        Person *p = ((Person *(*)(id, SEL))(void *)objc_msgSend)((id)((Person *(*)(id, SEL))(void *)objc_msgSend)((id)objc_getClass("Person"), sel_registerName("alloc")), sel_registerName("init"));
        ((void (*)(id, SEL, NSString *))(void *)objc_msgSend)((id)p, sel_registerName("setName:"), (NSString *)&__NSConstantStringImpl__var_folders_c0_bccw4xzn2dg5h41gcsb_qdd40000gn_T_main_e1ba09_mi_0);
        ((void (*)(id, SEL, NSInteger))(void *)objc_msgSend)((id)p, sel_registerName("setAge:"), (NSInteger)18);
        ((void (*)(id, SEL))(void *)objc_msgSend)((id)p, sel_registerName("my"));
        
     
        */
        
   
    //--------------------------------分割---------------------------------------------------
        //简化上面运行时的代码----------------------
        
        //要创建person 首先给person这个类发送一条alloc消息 返回一个person对象
       
         Person *obj = objc_msgSend(objc_getClass("Person"), sel_registerName("alloc"));

        //给person对象发送一条init消息进行初始化
         Person *p = objc_msgSend(obj,sel_registerName("init"));
        
        //给对象p发送一条setName:消息 设置名字为周海
        objc_msgSend(p,sel_registerName("setName:"),@"周海");
        
        //给对象p发送一条setAge:消息 设置年龄为18
        objc_msgSend(p,sel_registerName("setAge:"),18);
    
        //给对象p发送一条"my"消息
        NSString *str = objc_msgSend(p,sel_registerName("my"));
        NSLog(@"%@",str);
    
        // objc_msgSend 可以给对象发送消息 objc_getClass("Person") 可以获取到指定名称的对象 sel_registerName("alloc") 可以调用到对象的方法
        

        //改变 P对象的类为NSString
        Class aClass = object_setClass(p, [NSString class]);
        NSLog(@"aClass:%@",NSStringFromClass(aClass));
        NSLog(@"obj class:%@",NSStringFromClass([p class]));
        

        //获取对象的类名 constchar *object_getClassName(id obj)
        Person *person = [Person new];
        NSString *className = [NSString stringWithCString:object_getClassName(person) encoding:NSUTF8StringEncoding];
        NSLog(@"className:%@", className);
        
        //给Person类添加一个方法 BOOL class_addMethod(Class cls,SEL name,IMP imp,const char *types)
        class_addMethod([Person class],@selector(ocMethod:), (IMP)cfunction,"i@:@");
        if ([person respondsToSelector:@selector(ocMethod:)]) {
            NSLog(@"添加一个只有一个参数方法 ");
        } else{
        
            NSLog(@"添加失败");
        }
        
        //添加两个参数的方法
        class_addMethod([Person class],@selector(towMethod::), (IMP)cfunction2,"v@:@@");
        
        //调用方法
        
         objc_msgSend(person,sel_registerName("ocMethod:"),@"一个参数");
//
//        float fid = (float )ff;
         objc_msgSend(person,sel_registerName("towMethod::"),@"哈哈哈",@"呵呵呵");
        
        //说明
        
        /***
         向一个类动态添加方法
         BOOL class_addMethod(Class cls, SEL name, IMP imp, const char *types)
         参数说明：
         cls：被添加方法的类
         name：可以理解为方法名
         imp：实现这个方法的函数
         types：一个定义该函数返回值类型和参数类型的字符串
        
         
        class_addMethod([Person class],@selector(ocMethod:), (IMP)cfunction,"i@:@");
         
         其中types参数为"i@:@“，按顺序分别表示：
         i：返回值类型int，若是v则表示void  其他具体看https://developer.apple.com/library/mac/documentation/Cocoa/Conceptual/ObjCRuntimeGuide/Articles/ocrtTypeEncodings.html
         
         @：参数id(self)
         :：SEL(_cmd)
         @：id(str)
         
         ***
         */
         
        
        
        //获取一个类所有属性---------------------------------------------
        unsigned  int count = 0;
        //获取类中的属性
        Ivar *members = class_copyIvarList([Person class], &count);
        for (int i = 0; i < count; i++) {
            Ivar var = members[i];
            NSString *memberAddress = [NSString stringWithCString:ivar_getName(var) encoding:NSUTF8StringEncoding];
            NSString *memberType = [NSString stringWithCString:ivar_getTypeEncoding(var) encoding:NSUTF8StringEncoding];
            NSLog(@"属性名 = %@ ; type = %@",memberAddress,memberType);
        }
        
        
        //获取一个类所有方法---------------------------------------------
        
        unsigned int countMethod = 0;
        Method* methods= class_copyMethodList([Person class], &countMethod);
        for (int i = 0; i<countMethod; i++) {
            SEL name = method_getName(methods[i]);
            NSString *strName = [NSString stringWithCString:sel_getName(name) encoding:NSUTF8StringEncoding];
            NSLog(@"方法名:%@",strName);
        }
        
        //获取/设置类的属性变量
        NSString *myScore;
        
        
//        object_getInstanceVariable(person,"age", &myFloatValue);
//        object_getInstanceVariable(person, "score", (void *)&myScore);
        
        id view;
        Ivar ivar = class_getInstanceVariable([person class], [@"score" UTF8String]);
        view = object_getIvar(person, ivar);
        
      
        
        
        
        //--------------------------------------------
        //创建一个TestClass类
        Class newClass = objc_allocateClassPair([NSError class], "TestClass", 0);
        class_addMethod(newClass, @selector(testMetaClass), (IMP)TestMetaClass, "v@:");
        //注册由objc_allocateClassPair创建的类
        objc_registerClassPair(newClass);
        
        id instance = [[newClass alloc] initWithDomain:@"some domain" code:0 userInfo:nil];
        [instance performSelector:@selector(testMetaClass)];
        
        NSLog(@"=============================完=====================");
        //-----------------------------------------------------------------------
        
        
        
        
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}



