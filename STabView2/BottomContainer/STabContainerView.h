//
//  STabContainerView.h
//  STabViewDemo
//
//  Created by cs on 17/3/30.
//  Copyright © 2017年 cs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "STabContainerBaseView.h"

#import "STabItem.h"

@class STabContainerView;

@interface STabContainerView : STabContainerBaseView<STabContainerBaseViewProtocol>

@property (nonatomic, weak, readonly) UIView *currentView;

@property (nonatomic, weak, readonly) UIView *preView;

- (void)setTabItems:(NSArray<STabItem *> *)items;

- (void)addTabItem:(STabItem *)item;

- (void)removeTabPage:(NSInteger)pageIdx;

- (UIView *)queryViewForIndex:(NSInteger)index;

@end
