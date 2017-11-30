//
//  STabBaseView.m
//  STabViewDemo
//
//  Created by cs on 17/3/31.
//  Copyright © 2017年 cs. All rights reserved.
//

#import "STabBaseView.h"
#import "STabReuseContainerView.h"

#import "STabContainerView.h"
#import "STabContainerBaseView.h"

@interface STabBaseView ()<STabBarViewDelegate, STabContainerBaseDelegate>

@property (nonatomic, strong, readwrite) STabBarView *tabBarView;

@property (nonatomic, strong) STabContainerBaseView *tabContainter;

@property (nonatomic, strong) UIView *defaultView;

@end


@implementation STabBaseView

+ (instancetype)tabViewWithFrame:(CGRect)frame defaultView:(UIView *)defaultView
{
    return [[[self class] alloc] initWithFrame:frame defaultView:defaultView];
}

+ (instancetype)tabViewWithFrame:(CGRect)frame
{
    return [self tabViewWithFrame:frame defaultView:nil];
}

- (instancetype)initWithFrame:(CGRect)frame defaultView:(UIView *)defaultView;
{
    self = [super initWithFrame:frame];
    if (self) {
        self.defaultView = defaultView;
        [self tabBase_SetupView];
    }
    
    return self;
}

- (void)didMoveToSuperview
{
    [super didMoveToSuperview];
    
    if (self.params.autoAdjustsScrollViewInsets == NO) {
        for (UIView *next = [self superview]; next; next = next.superview) {
            UIResponder *nextResponder = [next nextResponder];
            if ([nextResponder isKindOfClass:[UIViewController class]]) {
                ((UIViewController *)nextResponder).automaticallyAdjustsScrollViewInsets = NO;
                break;
            }
        }
    }
}

- (void)moveInitPage:(NSInteger)index
{
    [self moveToIndex:index animation:NO];
}

- (void)moveToIndex:(NSInteger)index animation:(BOOL)ani
{
    [self tabBar:self.tabBarView willTapIndex:index];
    if (ani) {
        [self.tabBarView moveTabIndex:index];
    } else {
        [self.tabBarView moveInitPage:index];
    }
}

- (void)hideDefaultView
{
    self.defaultView.hidden = YES;
}

- (void)showDefaultView
{
    self.defaultView.hidden = NO;
}

- (void)tabBaseView_initFrame
{
    self.tabContainter.frame = CGRectMake(0, self.tabBarView.frame.size.height, self.bounds.size.width, self.bounds.size.height - self.tabBarView.frame.size.height);
    self.defaultView.frame = self.tabContainter.frame;
}

- (void)setParams:(STabViewParams *)params
{
    if (_params != params && params != nil) {
        _params = params;
        
        self.tabBarView.params = params;
        self.tabContainter.scrollingNeedAnim = params.needScrollingAnim;
        
        [self tabBaseView_initFrame];
    }
}

#pragma mark - 
- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self tabBaseView_initFrame];
}

#pragma mark - STabContainerBaseDelegate
- (void)tabContainer:(STabContainerBaseView *)tabContainer atPosition:(CGFloat)pos
{
    [self.tabBarView moveTabPos:pos];
}

- (void)tabContainer:(STabContainerBaseView *)tabContainer didTapView:(UIView *)tapView didTapIndex:(NSInteger)tapIndex
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(tabView:didTapView:didTapIndex:)]) {
        [self.delegate tabView:self didTapView:tapView didTapIndex:tapIndex];
    }
}

#pragma mark - STabBarViewDelegate
- (void)tabBar:(STabBarView *)tabBar didTapIndex:(NSInteger)tabIndex
{
    [self.tabContainter _callFun:tabIndex];
}

- (void)tabBar:(STabBarView *)tabBar willTapIndex:(NSInteger)tabIndex
{
    self.tabContainter.clickedState = YES;
    self.tabContainter.currentTab = tabIndex;
}

- (STabContainerBaseView *)requestContainerView
{
    NSAssert(0, @"请重载requestContainerView");
    
    return nil;
}

#pragma mark -
- (void)tabBase_SetupView
{
    [self addSubview:self.tabContainter];
    [self addSubview:self.tabBarView];
    [self addSubview:self.defaultView];
}

- (STabBarView *)tabBarView
{
    if (_tabBarView == nil) {
        _tabBarView = [STabBarView tabBarViewWithPoint:CGPointMake(0, 0)];
        
        _tabBarView.thirdParty = NO;
        _tabBarView.delegate = self;
    }
    
    return _tabBarView;
}

- (STabContainerBaseView *)tabContainter
{
    if (_tabContainter == nil) {
        
        _tabContainter = [self requestContainerView];
        
        _tabContainter.delegate = self;
    }
    
    return _tabContainter;
}

@end
