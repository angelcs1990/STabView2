//
//  STabContainerView.m
//  STabViewDemo
//
//  Created by cs on 17/3/30.
//  Copyright © 2017年 cs. All rights reserved.
//

#import "STabContainerView.h"


@interface STabContainerView ()<UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollContentView;

@property (nonatomic, strong) NSMutableArray *arrTabItems;

@end

@implementation STabContainerView

#pragma mark - STabContainerBaseViewProtocol
- (void)tabViewRequestLayoutSubViews
{
    self.scrollContentView.frame = self.bounds;
    self.scrollContentView.contentSize = CGSizeMake(self.arrTabItems.count * self.bounds.size.width, 0);
    
    for (int i = 0; i < self.arrTabItems.count; ++i) {
        STabItem *item = [self.arrTabItems objectAtIndex:i];
        item.view.frame = CGRectMake(i * self.scrollContentView.frame.size.width, 0, self.scrollContentView.frame.size.width, self.scrollContentView.frame.size.height);
    }
}

- (void)tabViewRequestSetupUI
{
    [self.scrollContentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    for (int i = 0; i < self.arrTabItems.count; ++i) {
        STabItem *item = [self.arrTabItems objectAtIndex:i];
        [self.scrollContentView addSubview:item.view];
    }
}

- (void)tabViewRequestSetupData
{}

- (void)tabViewRequestCallFunwithIndex:(NSInteger)index
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(tabContainer:didTapView:didTapIndex:)]) {
        [self.delegate tabContainer:self didTapView:[self queryItemForIndex:index].view didTapIndex:index];
    }
}

- (UIScrollView *)tabViewRequestContentView
{
    return self.scrollContentView;
}

- (void)setTabItems:(NSArray<STabItem *> *)items
{
    if (items == nil) {
        return;
    }
    
    [self.arrTabItems removeAllObjects];
    [self.arrTabItems addObjectsFromArray:items];
    
    [self baseTabViewSetupUI];
    
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

- (STabItem *)queryItemForIndex:(NSInteger)index
{
    if (index < self.arrTabItems.count) {
        return self.arrTabItems[index];
    }
    
    return nil;
}

- (void)removeTabPage:(NSInteger)pageIdx
{
    if (pageIdx < self.arrTabItems.count) {
        STabItem *item = self.arrTabItems[pageIdx];
        [item.view removeFromSuperview];
        [self.arrTabItems removeObjectAtIndex:pageIdx];
        
        if (self.currentTab >= self.arrTabItems.count) {
            [self updateCurrentTab:self.arrTabItems.count - 1];
        }
        
        [self tabViewRequestLayoutSubViews];
    }
}

- (void)addTabItem:(STabItem *)item
{
    if (item == nil) {
        return;
    }
    
    [self.arrTabItems addObject:item];
    [self.scrollContentView addSubview:item.view];
    
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

#pragma mark - lazy load
- (NSMutableArray *)arrTabItems
{
    if (_arrTabItems == nil) {
        _arrTabItems = [NSMutableArray array];
    }
    
    return _arrTabItems;
}

- (UIScrollView *)scrollContentView
{
    if (_scrollContentView == nil) {
        _scrollContentView = [[UIScrollView alloc] initWithFrame:self.bounds];
        
        _scrollContentView.backgroundColor = [UIColor greenColor];
        _scrollContentView.pagingEnabled = YES;
        _scrollContentView.showsHorizontalScrollIndicator = NO;
        _scrollContentView.showsVerticalScrollIndicator = NO;
        _scrollContentView.bounces = NO;
        _scrollContentView.delegate = self;
        //        _scrollContentView.contentSize = CGSizeMake(self.titles.count * self.bounds.size.width, 0);
    }
    
    return _scrollContentView;
}
@end
