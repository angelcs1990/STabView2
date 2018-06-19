//
//  FourViewController.m
//  STabViewDemo
//
//  Created by cs on 17/3/29.
//  Copyright © 2017年 cs. All rights reserved.
//

#import "FourViewController.h"
#import "STabBarView.h"
#import "STabView2.h"
#import "SReuseTabViewCell.h"
#import "CellView.h"
@interface FourViewController ()<STabView2Delegate>

@end

@implementation FourViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIView *view4 = [UIView new];
    view4.backgroundColor = [UIColor orangeColor];
    UIView *view1 = [UIView new];
    view1.backgroundColor = [UIColor greenColor];
    UIView *view2 = [UIView new];
    view2.backgroundColor = [UIColor yellowColor];
    UIView *view3 = [UIView new];
    view3.backgroundColor = [UIColor purpleColor];
    UIView *viewDefault = [UIView new];
    UILabel *label = [[UILabel alloc] initWithFrame:self.view.bounds];
    label.text = @"我是defaultView,3秒消失";
    label.textAlignment = NSTextAlignmentCenter;
    [viewDefault addSubview:label];
    

    STabView2 *tabView = [STabView2 tabViewWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, self.view.bounds.size.height - 64) defaultView:viewDefault];
    [self.view addSubview:tabView];
    
    STabViewParams *params = [STabViewFixedParams tabViewParams];
    ((STabViewFixedParams*)params).tabWidth = 100;
//    ((STabViewFixedParams*)params).tabIndicatorWidth = 50;
    params.tabindicatorBackgroundOffset = 0.0;
    params.tabHeight = 33;
    //去掉下划线
//    params.tabIndicator = NO;
    //是否需要遮罩块 NO没有，yes有
    params.tabMask = YES;
    params.tabMaskColor = [UIColor yellowColor];
    //是否填充满一屏幕宽度
//    ((STabViewAutoParams*)params).titleAutoFill = NO;
//    params.tabIndicatorEqualTitleWidth = NO;
    //左边偏移
    params.tabLeftMargin = 20;
    //选项卡控件的背景色
    params.tabBackgroundColor = [UIColor blackColor];
    //选项卡选中的文字颜色
    params.tabTitleSelectColor = [UIColor redColor];
    params.tabIndicatorOffsetY = 20;
    
    params.needScrollingAnim = NO;
    
    //选中的title字体
    params.tabTitleSelectedFont = [UIFont systemFontOfSize:18];
    
    params.tabSplitColor = [UIColor redColor];
    params.tabSplitSize = CGSizeMake(1, params.tabHeight * 0.8);

    params.tabTitleNormalColor = [UIColor whiteColor];
    tabView.delegate = self;
    
    tabView.params = params;
    
   
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{

        STabItem *itemHot = [STabItem tabItemWithParam:params];
        itemHot.title = @"热门";
        itemHot.view = view4;
        itemHot.titleSelectedColor = [UIColor redColor];

        
        STabItem *itemHot1 = [STabItem tabItemWithParam:params];
        itemHot1.title = @"中";
        itemHot1.view = view2;
        itemHot1.titleSelectedColor = [UIColor yellowColor];
        itemHot1.backgroundColor = [UIColor orangeColor];
        
        STabItem *itemHot2 = [STabItem tabItemWithParam:params];
        itemHot2.title = @"韩国不错哟";
        itemHot2.view = view3;
        itemHot2.titleNormalColor = [UIColor purpleColor];
        itemHot2.titleSelectedColor = [UIColor blueColor];

//        STabItem *item4 = ({
//                            STabItem *item = [STabItem tabItemWithParam:params];
//                            item.view = view1;
//                            item.title = @"ss";
//            item;});
        
//        [tabView setTabItems:@[itemHot, itemHot1, itemHot2, SItem(params, @"出错", view1)]];
        [tabView setTabItems:@[itemHot, itemHot1, itemHot2]];
    
        [tabView moveInitPage:2];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            STabItem *itemHot2 = [STabItem tabItemWithParam:params];
            itemHot2.title = @"水电费";
            itemHot2.view = view3;
            itemHot2.titleSelectedColor = [UIColor greenColor];
//            [tabView addTabItem:itemHot2];
            [tabView removeTabPage:2];


        });
    });
    
    
    [self createButtonWithTitle:@"关闭" andFrame:CGRectMake(30, 10, 140, 45)];
    
    
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
    if ([tabView isKindOfClass:[SReuseTabViewCell class]]) {
        [((SReuseTabViewCell *)tapView) configurationItem:@"cs"];
    }
    
    NSLog(@"点击%ld", tabIndex);
}


@end
