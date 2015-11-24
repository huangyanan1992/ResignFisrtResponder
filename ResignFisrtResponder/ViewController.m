//
//  ViewController.m
//  ResignFisrtResponder
//
//  Created by 丁丁 on 15/11/24.
//  Copyright © 2015年 huangyanan. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}


/*这个方法比较特殊，总是要么执行外面的，要么执行类目里面的，
 *具体原因我现在也没弄太明白，应该跟这个方法是UIResponse的子类
 *而不是UIViewController的子类有关，
 *所以如果在外面写还需要重新写下收起键盘
 */
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    /*
     这里添加自己的需求
     */
    NSLog(@"tuoch");
    
    //这个时候MethodSwizzing里的方法不会执行，所以要重新调用一下收起键盘
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSLog(@"willAppear");
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    NSLog(@"disappear");
}
@end
