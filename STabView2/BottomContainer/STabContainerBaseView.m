//
//  STabContainterBaseView.m
//  STabViewDemo
//
//  Created by cs on 17/3/30.
//  Copyright © 2017年 cs. All rights reserved.
//

#import "STabContainerBaseView.h"



@interface STabContainerBaseView ()

@property (nonatomic, weak) id<STabContainerBaseViewProtocol> protocol;

@property (nonatomic, weak) UIScrollView *scrollContentView;

@end

@implementation STabContainerBaseView
{
    BOOL _bScrolling;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        if ([self conformsToProtocol:@protocol(STabContainerBaseViewProtocol)]) {
            self.protocol = (id<STabContainerBaseViewProtocol>)self;
        } else {
            NSAssert(0, @"请实现STabContainerBaseViewProtocol协议");
        }
        
        [self setupView];
    }
    
    return self;
}

- (void)setupView
{
    self.scrollingNeedAnim = YES;
}

- (void)baseTabViewSetupUI
{
    if (self.protocol && [self.protocol respondsToSelector:@selector(tabViewRequestSetupUI)]) {
        if (_scrollContentView == nil) {
            [self addSubview:self.scrollContentView];
        }
        
        [self.protocol tabViewRequestSetupUI];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (self.frame.size.width == 0 || self.frame.size.height == 0) {
        return;
    }
    
    if (self.protocol && [self.protocol respondsToSelector:@selector(tabViewRequestLayoutSubViews)]) {
        [self.protocol tabViewRequestLayoutSubViews];
    }
}

- (void)_callFun:(NSInteger)index
{
    _bScrolling = NO;
    self.autoMove = 0;
    if (self.protocol && [self.protocol respondsToSelector:@selector(tabViewRequestCallFunwithIndex:)]) {
        [self.protocol tabViewRequestCallFunwithIndex:index];
    }
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    _bScrolling = (scrollView.dragging ? YES : _bScrolling);
    CGFloat index = scrollView.contentOffset.x / scrollView.frame.size.width;
    if (self.delegate && _bScrolling) {
        [self.delegate tabContainer:self atPosition:index];
    }
}

- (void)updateCurrentTab:(NSInteger)tab
{
    _currentTab = tab;
}

#pragma mark -
- (void)setCurrentTab:(NSInteger)currentTab
{
    _currentTab = currentTab;
    
    CGPoint point = self.scrollContentView.contentOffset;
    point.x = currentTab * self.scrollContentView.frame.size.width;
    
    if (self.autoMove != 0) {
        [self.scrollContentView setContentOffset:point animated:(self.autoMove == 1) ? YES : NO];
    } else {
        [self.scrollContentView setContentOffset:point animated:self.scrollingNeedAnim];
    }
}

- (UIScrollView *)scrollContentView
{
    if (_scrollContentView == nil) {
        if (self.protocol && [self.protocol respondsToSelector:@selector(tabViewRequestContentView)]) {
            _scrollContentView = [self.protocol tabViewRequestContentView];
        }
    }
    
    return _scrollContentView;
}

@end
