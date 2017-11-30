//
//  STabView2.m
//  STabViewDemo
//
//  Created by cs on 17/3/29.
//  Copyright © 2017年 cs. All rights reserved.
//

#import "STabView2.h"
#import "STabBarView.h"
#import "STabContainerView.h"
#import "STabContainerBaseView.h"

@interface STabView2 ()

@property (nonatomic, strong) STabContainerView *tabViewContainer;

@end

@implementation STabView2

+ (instancetype)tabView:(NSArray<STabItem *> *)items withFrame:(CGRect)frame params:(STabViewParams *)params
{
    STabView2 *tabView = [self tabViewWithFrame:frame];
    tabView.params = params;
    
    [tabView.tabBarView setTabItems:items];
    [tabView.tabViewContainer setTabItems:items];
    
    return tabView;
}

- (void)dealloc
{
    NSLog(@"Dealloc");
}

#pragma mark -
- (void)addTabItem:(STabItem *)item
{
    if (item == nil) {
        return;
    }
    
    [self.tabBarView addTabItem:item];
    [self.tabViewContainer addTabItem:item];
}

- (void)setTabItems:(NSArray<STabItem *> *)items
{
    NSAssert(self.params != nil, @"请先设置好param");
    
    if (items == nil || items.count == 0) {
        return;
    }
    
    [self hideDefaultView];
    
    [self.tabBarView setTabItems:items];
    [self.tabViewContainer setTabItems:items];
    
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

- (void)removeTabPage:(NSInteger)pageIdx
{
    [self.tabBarView removeTabWithIdx:pageIdx];
    [self.tabViewContainer removeTabPage:pageIdx];
}

- (STabContainerBaseView *)requestContainerView
{
    return self.tabViewContainer;
}

#pragma mark -
- (UIView *)currentView
{
    return [((STabContainerView *)self.tabViewContainer) queryItemForIndex:self.tabBarView.currentIndex].view;
}

- (UIView *)preView
{
    return [self.tabViewContainer queryItemForIndex:self.tabBarView.preIndex].view;
}

- (STabContainerView *)tabViewContainer
{
    if (_tabViewContainer == nil) {
        _tabViewContainer = [[STabContainerView alloc] init];
    }
    
    return _tabViewContainer;
}

@end
