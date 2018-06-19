//
//  DemoViewController.m
//  STabView2Demo
//
//  Created by chens on 2018/6/19.
//  Copyright © 2018年 cs. All rights reserved.
//

#import "DemoViewController.h"
#import "STabBarView.h"
#import "STabView2.h"

@interface DemoViewController ()

@end

@implementation DemoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self createButtonWithTitle:@"关闭" andFrame:CGRectMake(30, 10, 140, 45)];
    
    STabView2 *tabView = [STabView2 tabViewWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, self.view.bounds.size.height - 64)];
    [self.view addSubview:tabView];
    
    STabViewParams *params = [STabViewFixedParams tabViewParams];
    params.needScrollingAnim = NO;
    tabView.params = params;
    
    
    STabItem *item1 = [STabItem tabItemWithParam:params];
    item1.title = @"第一个页面";
    item1.view = [UIView new];
    item1.view.backgroundColor = [UIColor whiteColor];
    item1.titleSelectedColor = [UIColor yellowColor];
    
    STabItem *item2 = [STabItem tabItemWithParam:params];
    item2.title = @"第二";
    item2.view = [UIView new];
    item2.view.backgroundColor = [UIColor blueColor];
    item2.titleSelectedColor = [UIColor yellowColor];
    
    STabItem *item3 = [STabItem tabItemWithParam:params];
    item3.title = @"第三个";
    item3.view = [UIView new];
    item3.view.backgroundColor = [UIColor greenColor];
    item3.titleSelectedColor = [UIColor yellowColor];
    
    [tabView setTabItems:@[item1, item2, item3]];
    [tabView moveInitPage:0];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

- (void)buttonDidClicked:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
