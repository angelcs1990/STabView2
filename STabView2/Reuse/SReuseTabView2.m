//
//  SReuseTabView2.m
//  STabViewDemo
//
//  Created by cs on 17/3/31.
//  Copyright © 2017年 cs. All rights reserved.
//

#import "SReuseTabView2.h"
#import "STabReuseContainerView.h"
#import "STabBarView.h"
#import "STabContainerView.h"
#import "STabContainerBaseView.h"

@interface SReuseTabView2 ()

@property (nonatomic, strong) STabReuseContainerView *tabReuseContainer;

@end

@implementation SReuseTabView2

#pragma mark - 父类重载
- (STabContainerBaseView *)requestContainerView
{
    return self.tabReuseContainer;
}

#pragma mark - 公共接口
- (void)setTabItems:(NSArray<STabItem *> *)titles withCellClass:(Class)cellClass
{
    NSAssert(self.params != nil, @"请先设置好param");
    
    if (titles == nil || cellClass == nil) {
        return;
    }
    
    [self hideDefaultView];
    
    [self.tabBarView setTabItems:titles];
    [((STabReuseContainerView *)self.tabReuseContainer) configureCellClass:cellClass dataCount:titles.count];
}

- (void)addTabItem:(STabItem *)item
{
    if (item == nil) {
        return;
    }
    
    if([self.tabReuseContainer increaseCount])
    {
        [self.tabBarView addTabItem:item];
    }
}

#pragma mark - lazy load
- (void)setPreLoad:(BOOL)preLoad
{
    _preLoad = preLoad;
    self.tabReuseContainer.preLoad = preLoad;
}

- (STabReuseContainerView *)tabReuseContainer
{
    if (_tabReuseContainer == nil) {
        _tabReuseContainer = [STabReuseContainerView new];
    }
    
    return _tabReuseContainer;
}

@end
