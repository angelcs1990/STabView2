//
//  OneViewController.m
//  STabView2Demo
//
//  Created by cs on 17/3/31.
//  Copyright © 2017年 cs. All rights reserved.
//

#import "OneViewController.h"
#import "STabBarView.h"
#import "STabView2.h"
#import "SReuseTabViewCell.h"
#import "CellView.h"
#import "SReuseTabView2.h"
@interface OneViewController ()<STabView2Delegate>

@property (nonatomic, strong) NSArray *arrayTitles;

@end

@implementation OneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.arrayTitles = @[@"热门", @"中国",  @"韩国", @"市领导圣诞节", @"市领导看风景"];
    
    SReuseTabView2 *tabView = [SReuseTabView2 tabViewWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, self.view.bounds.size.height - 64)];
    [self.view addSubview:tabView];
    
    STabViewAutoParams *params = [STabViewAutoParams tabViewParams];
    
    params.tabindicatorBackgroundOffset = 0.0;
    params.tabHeight = 33;
    
    //是否需要遮罩块 NO没有，yes有
    params.tabMask = NO;
    //是否填充满一屏幕宽度
//    params.titleAutoFill = NO;
    //左边偏移
    params.tabLeftMargin = 20;
    //选项卡控件的背景色
    params.tabBackgroundColor = [UIColor blackColor];
    //选项卡选中的文字颜色
    params.tabTitleSelectColor = [UIColor redColor];
    params.tabTitleNormalColor = [UIColor blueColor];
    
    params.needScrollingAnim = YES;
    
    
    params.tabTitleSelectedFont = [UIFont systemFontOfSize:18];
    
    tabView.delegate = self;
    tabView.params = params;
    
    tabView.preLoad = YES;
//    [tabView setTabTitles:self.arrayTitles withCellClass:[CellView class]];
    [tabView setTabItems:@[SItem(params, @"热门", nil),
                           SItem(params, @"中国", nil),
                           SItem(params, @"韩国", nil),
                           SItem(params, @"市领导圣诞节", nil),
                           SItem(params, @"市领导看风景", nil)] withCellClass:[CellView class]];
    [self createButtonWithTitle:@"关闭" andFrame:CGRectMake(30, 10, 140, 45)];
    
    [tabView moveInitPage:0];
    
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)tabView:(STabView2 *)tabView didTapView:(UIView *)tapView didTapIndex:(NSInteger)tabIndex
{
    //    UIView *view = tabView.currentView;
    //    UIView *view2 = tabView.preView;
    if ([tapView isKindOfClass:[SReuseTabViewCell class]]) {
        [((SReuseTabViewCell *)tapView) configurationItem:self.arrayTitles[tabIndex]];
    }
    
    NSLog(@"点击%ld", tabIndex);
}

@end
