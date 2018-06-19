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
        NSString *ttmp = [NSString stringWithFormat:@"%@:%s", @"", __func__];
        NSAssert(self.params, ttmp);
        _titleNormalColor = self.params.tabTitleNormalColor;
    }
    
    return _titleNormalColor;
}

- (UIColor *)titleSelectedColor
{
    if (_titleSelectedColor == nil) {
        NSString *ttmp = [NSString stringWithFormat:@"%@:%s", @"", __func__];
        NSAssert(self.params, ttmp);
        _titleSelectedColor = self.params.tabTitleSelectColor;
    }
    
    return _titleSelectedColor;
}

- (UIFont *)titleNormalFont
{
    if (_titleNormalFont == nil) {
        NSString *ttmp = [NSString stringWithFormat:@"%@:%s", @"", __func__];
        NSAssert(self.params, ttmp);
        _titleNormalFont = self.params.tabTitleFont;
    }
    
    return _titleNormalFont;
}

- (UIFont *)titleSelectedFont
{
    if (_titleSelectedFont == nil) {
        NSString *ttmp = [NSString stringWithFormat:@"%@:%s", @"", __func__];
        NSAssert(self.params, ttmp);
        _titleSelectedFont = self.params.tabTitleSelectedFont;
        if (_titleSelectedFont == nil) {
            _titleSelectedFont = self.params.tabTitleFont;
        }
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
