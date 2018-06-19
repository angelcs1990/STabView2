//
//  STabViewParams.m
//  STabView2
//
//  Created by cs on 16/10/23.
//  Copyright © 2016年 cs. All rights reserved.
//

#import "STabViewParams.h"


@implementation STabViewParams

+ (instancetype)tabViewParams
{
    STabViewParams *params = [[[self class] alloc] init];
    [params setupValue];
    return params;
}

- (void)setupValue
{
    _tabIndicator = S_Configuration.tabIndicator;
    _tabMask = S_Configuration.tabMask;
    _tabIndicatorEqualTitleWidth = S_Configuration.tabIndicatorEqualTitleWidth;

    _tabIndicatorHeight = S_Configuration.tabIndicatorHeight;
    _tabHeight = S_Configuration.tabHeight;

    _tabIndicatorBackgroundHeight = S_Configuration.tabIndicatorBackgroundHeight;
    _tabindicatorBackgroundOffset = S_Configuration.tabindicatorBackgroundOffset;

    _tabTitleFont = S_Configuration.tabTitleFont;

    _tabBackgroundColor = S_Configuration.tabBackgroundColor;

    _tabIndicatorColor = S_Configuration.tabIndicatorColor;
    _tabIndicatorBackgroundColor = S_Configuration.tabIndicatorBackgroundColor;

    _tabTitleNormalColor = S_Configuration.tabTitleNormalColor;
    _tabMaskColor = S_Configuration.tabMaskColor;
    
    _autoAdjustsScrollViewInsets = S_Configuration.autoAdjustsScrollViewInsets;
    
    _tabTopOffset = S_Configuration.tabTopOffset;
    

    _tabIndicatorImageMode = S_Configuration.tabIndicatorImageMode;
    
    _tabSplitSize = S_Configuration.tabSplitSize;
    
    _tabIndicatorOffsetY = S_Configuration.tabIndicatorOffsetY;
    
    _needScrollingAnim = S_Configuration.needScrollingAnim;
    
    _tabIndicatorCorner = S_Configuration.tabIndicatorCorner;
    
}

- (CGFloat)tabIndicatorCorner
{
    if (_tabIndicatorCorner > self.tabIndicatorHeight) {
        _tabIndicatorCorner = self.tabIndicatorHeight / 2.0f;
    }
    
    return _tabIndicatorCorner;
}

@end

@implementation STabViewAutoParams
- (void)setupValue
{
    [super setupValue];
    
    _tabMargin = S_Configuration.tabMargin;
    _titleAutoFill = S_Configuration.titleAutoFill;
}
@end
@implementation STabViewEqualParams

@end



#define _STabViewFixed_Default_Width (320 / 3.0f)
@implementation STabViewFixedParams

- (void)setupValue
{
    [super setupValue];
    _tabWidth = S_Configuration.tabWidth;
    _tabIndicatorWidth = S_Configuration.tabIndicatorWidth;
}

- (CGFloat)tabWidth
{
    if (self.tabIndicatorWidth > 1 && _tabWidth < self.tabIndicatorWidth) {
        self.tabIndicatorWidth = _tabWidth;
    }
    if (_tabWidth <= 0) {
        _tabWidth = _STabViewFixed_Default_Width;
    }
    return _tabWidth;
}

- (void)setTabIndicatorWidth:(CGFloat)tabIndicatorWidth
{
    if(!self.tabIndicator) {
        _tabIndicatorWidth = 0;
    } else {
        if (tabIndicatorWidth > 1 && self.tabWidth < tabIndicatorWidth) {
            _tabIndicatorWidth = self.tabWidth;
        } else {
            _tabIndicatorWidth = tabIndicatorWidth;
        }
        
        self.tabIndicatorEqualTitleWidth = NO;
    }
}



@end
