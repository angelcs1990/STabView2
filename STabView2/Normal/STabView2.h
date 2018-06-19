//
//  STabView2.h
//  STabViewDemo
//
//  Created by cs on 17/3/29.
//  Copyright © 2017年 cs. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "STabBaseView.h"
#import "STabItem.h"

@interface STabView2 : STabBaseView

@property (nonatomic, weak, readonly) UIView *currentView;

@property (nonatomic, weak, readonly) UIView *preView;

#pragma mark - 非复用View
+ (instancetype)tabView:(NSArray<STabItem *> *)items withFrame:(CGRect)frame params:(STabViewParams *)params;

- (void)addTabItem:(STabItem *)item;

- (void)setTabItems:(NSArray<STabItem *> *)items;

- (void)removeTabPage:(NSInteger)pageIdx;

@end
