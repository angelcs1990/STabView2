//
//  STabItem.h
//  STabView2Demo
//
//  Created by cs on 2017/11/21.
//  Copyright © 2017年 cs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "STabViewParams.h"

#define SItem(_param, _title, _view) ({STabItem *item = [STabItem tabItemWithParam:_param]; item.view = _view; item.title = _title; item;})

@interface STabItem : NSObject

+ (instancetype)tabItemWithParam:(STabViewParams *)params;

/**
 *  文字未选中的字体
 */
@property (nonatomic, strong) UIFont *titleNormalFont;

/**
 *  文字选中的字体
 */
@property (nonatomic, strong) UIFont *titleSelectedFont;

/**
 *  文字未选中的颜色
 */
@property (nonatomic, strong) UIColor *titleNormalColor;

/**
 *  文字选中的颜色
 */
@property (nonatomic, strong) UIColor *titleSelectedColor;

/**
 *  背景颜色
 */
@property (nonatomic, strong) UIColor *backgroundColor;

/**
 *  对应项的view
 */
@property (nonatomic, strong) UIView *view;

/**
 *  显示文字
 */
@property (nonatomic, strong) NSString *title;

/**
 *  需要统一样式的设置
 */
@property (nonatomic, weak) STabViewParams *params;

@end
