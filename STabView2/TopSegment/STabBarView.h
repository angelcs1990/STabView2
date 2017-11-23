//
//  STabBarView.h
//  STabViewDemo
//
//  Created by cs on 17/3/29.
//  Copyright © 2017年 cs. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "STabViewParams.h"
#import "STabItem.h"

typedef NS_ENUM(NSInteger, STabTitleWidthType)
{
    //自动计算宽度
    STabTitleWidthAuto,
    //等值宽度
    STabTitleWidthEqual,
    //固定宽度 (此模式下要自己设置宽度）
    STabTitleWidthFixed,
};


@class STabBarView;

#pragma mark - STabBarViewDelegate
@protocol STabBarViewDelegate <NSObject>

@optional
- (void)tabBar:(STabBarView *)tabBar didTapIndex:(NSInteger)tabIndex;

- (void)tabBar:(STabBarView *)tabBar willTapIndex:(NSInteger)tabIndex;

@end


#pragma mark - STabBarView
@interface STabBarView : UIView

@property (nonatomic, weak) id<STabBarViewDelegate> delegate;

@property (nonatomic, strong) STabViewParams *params;

@property (nonatomic) BOOL isScrolling;

//是否做为单独的一个控件来用，default：NO
@property (nonatomic) BOOL thirdParty;

@property (nonatomic, readonly) NSInteger currentIndex;

@property (nonatomic, readonly) NSInteger preIndex;

+ (instancetype)tabBarViewWithPoint:(CGPoint)point;
+ (instancetype)tabBarViewTitles:(NSArray<STabItem *> *)titles withPoint:(CGPoint)point;

- (void)setTabItems:(NSArray<STabItem *> *)items;
- (void)addTabItem:(STabItem *)item;
- (void)removeTabWithIdx:(NSInteger)idx;

- (void)moveTabPos:(CGFloat)pos;
- (void)moveTabIndex:(NSInteger)index;
- (void)moveInitPage:(NSInteger)index;

- (UIButton *)queryButtonWithIdx:(NSInteger)idx;

@end
