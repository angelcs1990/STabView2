//
//  ViewController.m
//  STabView2Demo
//
//  Created by cs on 17/3/31.
//  Copyright © 2017年 cs. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (nonatomic, strong) NSArray *arrayClasses;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    NSArray *arrayData = @[@"跳转普通选项卡", @"跳转复用选项卡", @"跳转有缺省界面"];
    self.arrayClasses = @[NSClassFromString(@"FourViewController"), NSClassFromString(@"OneViewController"), NSClassFromString(@"TwoViewController")];
    
    for (int i = 0; i < arrayData.count; ++i) {
        [self createButtonWithTitle:arrayData[i] andFrame:CGRectMake(30, 70 + (i * 45), 140, 45)];
    }
}

- (void)buttonDidClicked:(id)sender
{
    NSInteger idx = ((UIButton *)sender).tag;
    if (idx < self.arrayClasses.count) {
        UIViewController *vc = [[self.arrayClasses[idx] alloc] init];
        [self presentViewController:vc animated:YES completion:nil];
    }
}

- (UIButton *)createButtonWithTitle:(NSString *)title andFrame:(CGRect)rect
{
    static NSInteger idx = 0;
    UIButton *button1 = [UIButton buttonWithType:UIButtonTypeSystem];
    button1.layer.borderColor = [UIColor blackColor].CGColor;
    button1.layer.borderWidth = 1;
    [button1 setTitle:title forState:UIControlStateNormal];
    [button1 setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [button1 addTarget:self action:@selector(buttonDidClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button1];
    button1.tag = idx;
    //    button1.frame = CGRectMake(30, 70, 140, 45);
    button1.frame = rect;
    ++idx;
    return button1;
}


@end
