//
//  STabViewParams.h
//  STabView2
//
//  Created by cs on 16/10/23.
//  Copyright © 2016年 cs. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

#import "STabConfiguration.h"


@interface STabViewParams : NSObject

+ (instancetype)tabViewParams;

/**
 *  tab滚动条的左边间隔（默认：0）
 */
@property (nonatomic) CGFloat tabLeftMargin;

/**
 *  tab滚动条的右边间隔
 */
@property (nonatomic) CGFloat tabRightMargin;

/**
 *  表明视图控制器是否应该自动调整其insets滚动视图（默认：是）
 */
@property (nonatomic) BOOL autoAdjustsScrollViewInsets;

/**
 *  是否有下划线
 */
@property (nonatomic) BOOL tabIndicator;

/**
 *  下划线圆角
 */
@property (nonatomic) CGFloat tabIndicatorCorner;

/**
 *  是否需要滚动动画（默认：YES)
 */
@property (nonatomic) BOOL needScrollingAnim;

/**
 *  是否有选中遮罩块
 */
@property (nonatomic) BOOL tabMask;

/**
 *  下划线是否跟随文字大小,设置下划线宽度后失效
 */
@property (nonatomic) BOOL tabIndicatorEqualTitleWidth;

/**
 *  字体
 */
@property (nonatomic, strong) UIFont *tabTitleFont;

/**
 *  选中的时候的字体，默认为空，没有
 */
@property (nonatomic, strong) UIFont *tabTitleSelectedFont;

@property (nonatomic, copy) NSString *tabBackgroundImage;

/**
 *  下划线的图片的填充模式，设置后，自动计算的宽度失效，优先级：中
 */
@property (nonatomic) STabIndicatorImageMode tabIndicatorImageMode;

/**
 *  下划线的高度
 */
@property (nonatomic) CGFloat tabIndicatorHeight;

/**
 *  下划线距离顶部的y偏移，设置后（他的优先级高）
 */
@property (nonatomic) CGFloat tabIndicatorOffsetY;

/**
 *  下划线的背景图片Url
 */
@property (nonatomic, copy) NSString *tabIndicatorImage;

/**
 * 下划线的背景高度
 */
@property (nonatomic) CGFloat tabIndicatorBackgroundHeight;

/**
 * 下划线背景偏移距离
 */
@property (nonatomic) CGFloat tabindicatorBackgroundOffset;

/**
 * 分隔线颜色，优先级低于下面的图片
 */
@property (nonatomic, strong) UIColor *tabSplitColor;

/**
 * 分割线图片
 */
@property (nonatomic, strong) NSString *tabSplitImage;

/**
 * 分割线大小，默认宽度1，高度0.8
 */
@property (nonatomic, assign) CGSize tabSplitSize;

/**
 *  tab的高度
 */
@property (nonatomic) CGFloat tabHeight;

/**
 *  tab的y偏移，离top位置，默认0
 */
@property (nonatomic) CGFloat tabTopOffset;

/**
 *  背景色
 */
@property (nonatomic, strong) UIColor *tabBackgroundColor;

/**
 *  下划线的颜色
 */
@property (nonatomic, strong) UIColor *tabIndicatorColor;

/**
 *  下划线的背景色
 */
@property (nonatomic, strong) UIColor *tabIndicatorBackgroundColor;

/**
 *  文字在非选中状态下的颜色
 */
@property (nonatomic, strong) UIColor *tabTitleNormalColor;

/**
 *  文字在选中状态的颜色
 */
@property (nonatomic, strong) UIColor *tabTitleSelectColor;

/**
 *  遮罩颜色
 */
@property (nonatomic, strong) UIColor *tabMaskColor;

@end






@interface STabViewAutoParams : STabViewParams
/**
 * 文字距边框的距离，默认20
 */
@property (nonatomic) CGFloat tabMargin;


/**
 * 文字是否自动填充满这个窗口宽度
 */
@property (nonatomic) BOOL titleAutoFill;

@end





@interface STabViewEqualParams : STabViewParams

@end






@interface STabViewFixedParams : STabViewParams
/**
 *  tab的宽度，如果不设置，不会滚动，设置后哦如果超出屏幕可以滚动
 */
@property (nonatomic) CGFloat tabWidth;

/**
 *  下划线的宽度，设置后，其他的宽度策略失效，优先级：高
 */
@property (nonatomic) CGFloat tabIndicatorWidth;

@end
