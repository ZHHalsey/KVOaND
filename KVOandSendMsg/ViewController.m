//
//  ViewController.m
//  001--kvc
//
//  Created by 张豪 on 2018/7/25.
//  Copyright © 2018年 张豪. All rights reserved.
//

#import "ViewController.h"
#import "Person.h"
#import <objc/message.h> // 想要发消息就导入这个

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    Person *p = [[Person alloc]init];

//    p.name = @"11";       // 点语法就是调用了setter方法
//    [p setName:@"11"];    // setter方法
    [p performSelector:@selector(setName:) withObject:@"11"]; // 让p响应setName:方法, 并且传@"11"为参数
    // 上面的三行都是p对象调用setName:方法, 下面这个是方法调用的本质, 消息发送机制
    /*
     1 > 首先在build settings里面搜索msg, 然后设置为NO(这样下面的的方法就能使用)
     2 > 导入头文件 message.h, 这个头文件里面也包括runtime.h
     3 > 然后方法调用的本质就是 objc_msgSend 这个方法
         苹果的解释是这个 : objc_msgSend(id _Nullable self, SEL _Nonnull op, ...)
     4 > 这个objc_msgSend方法需要三个参数, 第一个就是self, 也就是方法的调用者, 第二个就是SEL, 方法的编号, 也就是方法的名字, 后面就是需要传入的参数, 这个方法的本质就是 给p对象发送一个setName:消息, 然后传入一个@"11"参数
     
     5 > 拓展 : 这里没有IMP, IMP是一个指向函数的指针, 里面存放的是实现setName:这个函数(这里用函数, 因为是C)的地址, 因为现在这的Person类创建的p, 用的是@property属性, 系统自动给我们创建了setName方法, 并且给这个setName方法自动匹配了一个IMP地址, 这个IMP就是实现setName这个方法的函数, 如果我们自己给一个类创建setName方法(底层C去创建)的时候, 需要用到class_addMethod(<#Class  _Nullable __unsafe_unretained cls#>, <#SEL  _Nonnull name#>, <#IMP  _Nonnull imp#>, <#const char * _Nullable types#>)
         上面这个方法的几个参数, 1>给哪个类添加方法, 2> 添加的方法名字 > 3 就是实现我们这个方法的函数地址(是地址, C语言中函数的地址就是函数的名字4 > 固定写0就行)
     */
    objc_msgSend(p, @selector(setName:), @"11");
    /*
        OC所有的方法调用就是发消息
            整体的流程是这样的, 比如 p.name = @"11";这行代码的流程就是
     1 > p调用setName:方法
     2 > 本质就是给p对象发送@selector(setName:)方法
     3 > 一旦给p对象发这个消息的时候, 就会去Person类中找是不是有这个消息 也就是是不是有class_addMethod这个方法(如果子类没有就去父类找)
     4 > 如果class_addMethod里面的参数有@selector(setName:)消息, 说明有这个消息, 然后在根据函数地址IMP找到这个C语言函数, 就可以进行这个方法的实现了
     */
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
