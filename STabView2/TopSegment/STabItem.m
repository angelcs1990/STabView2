//
//  STabItem.m
//  STabView2Demo
//
//  Created by cs on 2017/11/21.
//  Copyright © 2017年 cs. All rights reserved.
//

#import "STabItem.h"

@implementation STabItem

+ (instancetype)tabItemWithParam:(STabViewParams *)params
{
    STabItem *item = [STabItem new];
    item.params = params;
    
    return item;
}

- (UIColor *)titleNormalColor
{
    if (_titleNormalColor == nil) {
        _titleNormalColor = self.params.tabTitleNormalColor;
    }
    
    return _titleNormalColor;
}

- (UIColor *)titleSelectedColor
{
    if (_titleSelectedColor == nil) {
        _titleSelectedColor = self.params.tabTitleSelectColor;
    }
    
    return _titleSelectedColor;
}

- (UIFont *)titleNormalFont
{
    if (_titleNormalFont == nil) {
        _titleNormalFont = self.params.tabTitleFont;
    }
    
    return _titleNormalFont;
}

- (UIFont *)titleSelectedFont
{
    if (_titleSelectedFont == nil) {
        _titleSelectedFont = self.params.tabTitleSelectedFont;
    }
    
    return _titleSelectedFont;
}

- (UIView *)view
{
    if (_view == nil) {
        _view = [UIView new];
    }
    
    return _view;
}

@end
