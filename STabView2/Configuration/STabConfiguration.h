//
//  STabConfiguration.h
//  STabViewDemo
//
//  Created by cs on 16/11/29.
//  Copyright © 2016年 cs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define S_Configuration [STabConfiguration shareInstance]

typedef NS_ENUM(NSInteger, STabIndicatorImageMode) {
    STabIndicatorImageModeScaleToFill,
    STabIndicatorImageModeScaleAspectFit,      // contents scaled to fit with fixed aspect. remainder is transparent
    STabIndicatorImageModeScaleAspectFill,
    STabIndicatorImageModeNone
};

//整个高度是params.tabTopOffset + params.tabHeight + params.tabindicatorBackgroundOffset + params.tabIndicatorBackgroundHeight

@interface STabConfiguration : NSObject

+ (instancetype)shareInstance;

/**
 *  表明视图控制器是否应该自动调整其insets滚动视图（默认：是）
 */
@property (nonatomic) BOOL autoAdjustsScrollViewInsets;

/**
 *  是否需要滚动动画（默认：YES)
 */
@property (nonatomic) BOOL needScrollingAnim;

/**
 *  是否有下划线
 */
@property (nonatomic) BOOL tabIndicator;

/**
 *  下划线圆角
 */
@property (nonatomic) CGFloat tabIndicatorCorner;

/**
 *  是否有选中遮罩块
 */
@property (nonatomic) BOOL tabMask;

/**
 *  下划线是否跟随文字大小
 */
@property (nonatomic) BOOL tabIndicatorEqualTitleWidth;

/**
 *  字体
 */
@property (nonatomic, strong) UIFont *tabTitleFont;

/**
 *  下划线的高度
 */
@property (nonatomic) CGFloat tabIndicatorHeight;

/**
 *  下划线的图片的填充模式，设置后，自动计算的宽度失效，优先级：中
 */
@property (nonatomic) STabIndicatorImageMode tabIndicatorImageMode;

/**
 *  下划线的宽度，设置后，其他的宽度策略失效,默认为0无效
 */
@property (nonatomic) CGFloat tabIndicatorWidth;

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

@property (nonatomic) CGFloat tabIndicatorOffsetY;

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
 *  文字在非选中状态下的颜色组（优先级高于上面，且必须跟titles数量一样）
 */
@property (nonatomic, strong) NSArray<UIColor *> *tabTitleNormalColors;

/**
 *  文字在选中状态的颜色
 */
@property (nonatomic, strong) UIColor *tabTitleSelectColor;

/**
 *  文字在选中状态的颜色组（优先级高于上面，且必须跟titles数量一样）
 */
@property (nonatomic, strong) NSArray<UIColor *> *tabTitleSelectColors;

/**
 *  遮罩颜色
 */
@property (nonatomic, strong) UIColor *tabMaskColor;


//STabViewAutoParams
/**
 * 文字距边框的距离，默认20
 */
@property (nonatomic) CGFloat tabMargin;


/**
 * 文字是否自动填充满这个窗口宽度
 */
@property (nonatomic) BOOL titleAutoFill;

//STabViewFixedParams
/**
 *  tab的宽度，如果不设置，不会滚动，设置后哦如果超出屏幕可以滚动
 */
@property (nonatomic) CGFloat tabWidth;

@end
