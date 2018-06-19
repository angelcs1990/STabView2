//
//  SReuseTabView2.h
//  STabViewDemo
//
//  Created by cs on 17/3/31.
//  Copyright © 2017年 cs. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "STabBaseView.h"
#import "STabItem.h"

@interface SReuseTabView2 : STabBaseView

/**
 *  如果需要预加载，设为YES，默认NO（注意：需要在setTabTitles函数之前调用）
 */
@property (nonatomic) BOOL preLoad;


- (void)setTabItems:(NSArray<STabItem *> *)titles withCellClass:(Class)cellClass;


/**
 *  紧紧做为少数数据添加，调用前，确保先使用了setTabTitles函数

 *  @param item 标题
 */
- (void)addTabItem:(STabItem *)item;

@end
