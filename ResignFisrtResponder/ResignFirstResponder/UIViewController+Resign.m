//
//  UIViewController+Resign.m
//  ResignFisrtResponder
//
//  Created by 丁丁 on 15/11/24.
//  Copyright © 2015年 huangyanan. All rights reserved.
//

#import "UIViewController+Resign.h"
#import <objc/runtime.h>
static inline void swizzleSelector(Class clazz,SEL originalSelector , SEL swizzledSelector) {
    
    Class class = clazz ;
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
    
    /*判断当前类是否实现了该方法
     *1.如果实现了则不仅要调用原方法还要调用Swizzing实现的方法
     *2.通过class_addMethod添加新方法，而不仅仅是exchange
     *3.如果没有调用，直接exchange
     */
    BOOL didAddMethodInit = class_addMethod(class, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
    if (didAddMethodInit) {
        class_addMethod(class, swizzledSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
    }else{
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}


@implementation UIViewController (Resign)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        swizzleSelector(self, @selector(touchesBegan:withEvent:), @selector(aop_touchesBegan:withEvent:));
        swizzleSelector(self, @selector(viewWillDisappear:), @selector(aop_viewWillDisappear:));
    });
}

- (void)aop_touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}

- (void)aop_viewWillDisappear:(BOOL)animated {
    
    //收起键盘，既然说到这里就把收起键盘的几种方式都说下
    /*
     1.[self.view endEditing:YES];
     2.[[[UIApplication sharedApplication] keyWindow] endEditing:YES];
     3.[[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
     */
    [self.view endEditing:YES];
}

@end
