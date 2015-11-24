//
//  UIScrollView+Resign.m
//  ResignFisrtResponder
//
//  Created by 丁丁 on 15/11/24.
//  Copyright © 2015年 huangyanan. All rights reserved.
//

#import "UIScrollView+Resign.h"
#import <objc/runtime.h>

//添加该类目是因为用autolayout的用户大多数都是底层垫一个UIScrollView
static inline void swizzleSelector(Class clazz,SEL originalSelector , SEL swizzledSelector) {
    
    Class class = clazz ;
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
    BOOL didAddMethodInit = class_addMethod(class, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
    if (didAddMethodInit) {
        class_addMethod(class, swizzledSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
    }else{
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}
@implementation UIScrollView (Resign)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        swizzleSelector(self, @selector(touchesBegan:withEvent:), @selector(aop_touchesBegan:withEvent:));
    });
}

- (void)aop_touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}

@end
