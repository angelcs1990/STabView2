//
//  STabContainterBaseView.h
//  STabViewDemo
//
//  Created by cs on 17/3/30.
//  Copyright © 2017年 cs. All rights reserved.  
//

#import <UIKit/UIKit.h>

@class STabContainerBaseView;

#pragma mark - STabContainerBaseDelegate
@protocol STabContainerBaseDelegate <NSObject>

@required
- (void)tabContainer:(STabContainerBaseView *)tabContainer atPosition:(CGFloat)pos;

@optional
- (void)tabContainer:(STabContainerBaseView *)tabContainer didTapView:(UIView *)tapView didTapIndex:(NSInteger)tapIndex;

@end


#pragma mark - STabContainerBaseViewProtocol
@protocol STabContainerBaseViewProtocol <NSObject>

@required
- (void)tabViewRequestSetupUI;

- (void)tabViewRequestSetupData;

- (void)tabViewRequestLayoutSubViews;

- (void)tabViewRequestCallFunwithIndex:(NSInteger)index;

- (UIScrollView *)tabViewRequestContentView;

@end




#pragma mark - STabContainerBaseView
@interface STabContainerBaseView : UIView

@property (nonatomic, weak) id<STabContainerBaseDelegate> delegate;

@property (nonatomic) NSInteger currentTab;

@property (nonatomic) BOOL clickedState;

@property (nonatomic) BOOL scrollingNeedAnim;

- (void)_callFun:(NSInteger)index;

- (void)updateCurrentTab:(NSInteger)tab;

- (void)baseTabViewSetupUI;

@end
