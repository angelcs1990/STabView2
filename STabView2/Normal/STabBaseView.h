//
//  STabBaseView.h
//  STabViewDemo
//
//  Created by cs on 17/3/31.
//  Copyright © 2017年 cs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "STabViewParams.h"
#import "STabContainerBaseView.h"
#import "STabBarView.h"

@class STabBaseView;

@protocol STabView2Delegate <NSObject>

@optional
- (void)tabView:(STabBaseView *)tabView didTapView:(UIView *)tapView didTapIndex:(NSInteger)tabIndex;

@end

@interface STabBaseView : UIView

@property (nonatomic, strong) STabViewParams *params;

@property (nonatomic, weak) id<STabView2Delegate> delegate;

@property (nonatomic, strong, readonly) STabBarView *tabBarView;

+ (instancetype)tabViewWithFrame:(CGRect)frame;
+ (instancetype)tabViewWithFrame:(CGRect)frame defaultView:(UIView *)defaultView;

- (void)hideDefaultView;
- (void)showDefaultView;

- (void)moveToIndex:(NSInteger)index animation:(BOOL)ani;
- (void)moveInitPage:(NSInteger)index;

//重载
- (STabContainerBaseView *)requestContainerView;

@end
