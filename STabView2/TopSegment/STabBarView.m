//
//  STabBarView.m
//  STabViewDemo
//
//  Created by cs on 17/3/29.
//  Copyright © 2017年 cs. All rights reserved.
//

#import "STabBarView.h"
#define STABVIEW_BUTTON_TAG_BASE 100

@interface STabBarView ()

@property (nonatomic, strong) UIView *scrollHeaderContainer;

@property (nonatomic, strong) UIView *scrollHeaderBackContainer;

@property (nonatomic, strong) UIScrollView *scrollviewHeader;
//下划线
@property (nonatomic, strong) UIImageView *imageViewLine;

@property (nonatomic, strong) NSMutableArray *arrTabItems;

@property (nonatomic, strong) NSMutableArray *titleWidths;

@property (nonatomic, strong) NSMutableArray *splitsArray;

@property (nonatomic, strong) UIView *selectedView;

@property (nonatomic) STabTitleWidthType tabWidthType;

@property (nonatomic, readwrite) NSInteger currentIndex;

@property (nonatomic, readwrite) NSInteger preIndex;

@end

@implementation STabBarView
{
    CGFloat _titlesWidth;
    BOOL _bClicked;
    BOOL _bRemoveAction;
}

+ (instancetype)tabBarViewWithPoint:(CGPoint)point
{
    STabBarView *tabView = [[STabBarView alloc] initWithFrame:CGRectMake(point.x, point.y, 0, 0)];
    
    return tabView;
}

+ (instancetype)tabBarViewTitles:(NSArray<STabItem *> *)titles withPoint:(CGPoint)point
{
    STabBarView *tabView = [[STabBarView alloc] initWithFrame:CGRectMake(point.x, point.y, 0, 0)];
    
    [tabView.arrTabItems addObjectsFromArray:titles];
    [tabView baseTabViewSetupUI];
    
    return tabView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupData];
        [self setupView];
    }
    
    return self;
}

#pragma mark - 公共方法
- (UIButton *)queryButtonWithIdx:(NSInteger)idx
{
    return [self.scrollviewHeader viewWithTag:idx + STABVIEW_BUTTON_TAG_BASE];
}

- (void)moveTabPos:(CGFloat)pos
{
    if (self.arrTabItems.count == 0) {
        return;
    }
    
    CGRect maskRect, lineRect;
    [self calcLinePos:pos outMaskFrame:&maskRect outLineFrame:&lineRect];
    
    if (self.params.needScrollingAnim == NO && _bClicked == YES) {
        //如果是点击按钮产生的动作 and 禁止底下内容滚动动画 result它自己滚动
        [self animationToIndex:(NSInteger)pos selectedFrame:maskRect lineFrame:lineRect];
        
        _bClicked = NO;
    } else {
        [self updateSelectFrame:maskRect lineFrame:lineRect];
        
        if (pos == (int)pos) {
            [self changePageWithIndex:(NSInteger)pos];
        }
    }
}

- (void)moveInitPage:(NSInteger)index
{
    [self moveTabPos:index];
}

- (void)moveTabIndex:(NSInteger)index
{
    if (self.arrTabItems.count == 0 ) {
        return;
    }
    
    CGRect maskRect, lineRect;
    [self calcLinePos:index outMaskFrame:&maskRect outLineFrame:&lineRect];
    
    [self animationToIndex:index selectedFrame:maskRect lineFrame:lineRect];
}

- (void)setTabItems:(NSArray<STabItem *> *)items
{
    NSAssert(self.params != nil, @"请先设置好param");
    
    if (items == nil || self.arrTabItems.count != 0) {
        return;
    }
    
    [self.arrTabItems addObjectsFromArray:items];
    
    [self baseTabViewSetupUI];
    [self baseTabLayoutUpdate:self.params];
}

- (void)addTabItem:(STabItem *)item
{
    if (item == nil) {
        return;
    }
    
    _titlesWidth = 0;
    
    [self.arrTabItems addObject:item];

    [self addTabButtonWithIndex:self.arrTabItems.count - 1];
    
    [self.scrollviewHeader bringSubviewToFront:self.imageViewLine];
    [self addSplitLines];
    
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

- (void)removeTabWithIdx:(NSInteger)idx
{
    if (self.arrTabItems.count <= idx) {
        return;
    }
    
    _bRemoveAction = YES;
    
    //去掉相应位置的button
    UIButton *btn = [self.scrollviewHeader viewWithTag:idx + STABVIEW_BUTTON_TAG_BASE];
    [btn removeFromSuperview];
    
    NSInteger tag = 0;
    for (int i = 0; i < self.arrTabItems.count; ++i) {
        UIButton *button = [self.scrollviewHeader viewWithTag:i + STABVIEW_BUTTON_TAG_BASE];
        if (button == nil) {
            continue;
        }
        [self updateButton:button withStatus:NO];
        button.tag = tag + STABVIEW_BUTTON_TAG_BASE;
        tag += 1;
    }
    
    //去掉缓存
    [self.arrTabItems removeObjectAtIndex:idx];
    
    //去掉相应的分割线
    [self addSplitLines];
    
    [self.titleWidths removeObjectAtIndex:idx];
    _titlesWidth = 0;
    
    if (self.currentIndex >= self.arrTabItems.count) {
        _currentIndex = self.arrTabItems.count - 1;
    }
        
    [self setNeedsLayout];
    [self layoutIfNeeded];
    
    [self moveInitPage:self.currentIndex];
}

#pragma mark - 私有方法
- (CGFloat)calcAllTitlesWidth
{
    //总的title长度
    if (_titlesWidth != 0) {
        return _titlesWidth;
    }
    
    for (int i = 0; i < self.titleWidths.count; ++i) {
        _titlesWidth += [self.titleWidths[i] floatValue];
    }
    
    return _titlesWidth;
}

- (void)calcTitleWidths
{
    //界面宽度
    CGFloat viewWidth = self.frame.size.width;
    if (viewWidth == 0 || self.arrTabItems.count == 0 || _titlesWidth != 0) {
        return;
    }
    
    viewWidth -= (self.params.tabRightMargin + self.params.tabLeftMargin);

    //分割线
    CGFloat splitWidth = 0.0;
    if(self.params.tabSplitColor || self.params.tabSplitImage) {
        splitWidth = self.params.tabSplitSize.width;
    }
    
    //分割线数量
    NSInteger splitCount = self.arrTabItems.count - 1;
    switch (self.tabWidthType) {
        case STabTitleWidthFixed:
        {
            CGFloat tmpWidth = ((STabViewFixedParams *)self.params).tabWidth - (splitWidth * splitCount) / self.arrTabItems.count;
            for (int i = 0; i < self.arrTabItems.count; ++i) {
                self.titleWidths[i] = [NSNumber numberWithFloat:tmpWidth];
            }
        }
            break;
        case STabTitleWidthAuto:
        {
            CGFloat totalWidth = 0.0f;
            for (int i = 0; i < self.arrTabItems.count; ++i) {
                STabItem *item = [self.arrTabItems objectAtIndex:i];
                CGSize fontSize = [item.title sizeWithAttributes:@{NSFontAttributeName:item.titleNormalFont}];
                CGFloat tmpWidth = (fontSize.width + ((STabViewAutoParams *)self.params).tabMargin * 2);
                totalWidth += tmpWidth;
                self.titleWidths[i] = [NSNumber numberWithFloat:tmpWidth];
            }
            
            if (((STabViewAutoParams *)self.params).titleAutoFill) {
                if (totalWidth < viewWidth) {
                    CGFloat perMarginWidth = (viewWidth - totalWidth) / self.titleWidths.count;
                    for (int i = 0; i < self.titleWidths.count; ++i) {
                        CGFloat tmp = [self.titleWidths[i] floatValue];
                        self.titleWidths[i] = [NSNumber numberWithFloat:(tmp + perMarginWidth)];
                    }
                    perMarginWidth = (perMarginWidth / 2.0);
                    ((STabViewAutoParams *)self.params).tabMargin += perMarginWidth;
                }
            }
            
        }
            break;
        case STabTitleWidthEqual:
        {
            CGFloat tmpWidth = (viewWidth - splitWidth * splitCount) / self.arrTabItems.count;
            for (int i = 0; i < self.arrTabItems.count; ++i) {
                self.titleWidths[i] = [NSNumber numberWithFloat:tmpWidth];;
            }
        }
            break;
        default:
            NSAssert(1 ,@"请设置Type");
            break;
    }
}

#pragma mark - 私有函数（初始化）
- (void)setupData
{
    _currentIndex = -1;
    self.preIndex = -1;
}

- (void)setupView
{
    self.backgroundColor = [UIColor whiteColor];
    
    self.scrollviewHeader.clipsToBounds = NO;
//    self.clipsToBounds = YES;   忘记当时为什么要加这个了
    self.scrollHeaderContainer.clipsToBounds = YES;
    
    [self addSubview:self.scrollHeaderBackContainer];
    [self.scrollHeaderBackContainer addSubview:self.scrollHeaderContainer];
    [self.scrollHeaderContainer addSubview:self.scrollviewHeader];
    [self.scrollviewHeader addSubview:self.selectedView];
    [self.scrollviewHeader addSubview:self.imageViewLine];
}

- (void)makeScrollHeaderFrame
{
    CGFloat viewWidth = self.frame.size.width;
    //是否有左右间隔
    viewWidth -= (self.params.tabRightMargin + self.params.tabLeftMargin);
    //按钮数量 X 按钮宽度 ＝ 所需宽度
    CGFloat totalWidth = [self calcAllTitlesWidth];
    self.scrollviewHeader.frame = CGRectMake(0, /*64*/0, viewWidth, self.params.tabTopOffset + self.params.tabHeight +  self.params.tabindicatorBackgroundOffset);
    self.scrollviewHeader.contentSize = CGSizeMake(totalWidth, 0);
    self.scrollHeaderContainer.frame = CGRectMake(self.params.tabLeftMargin, 0, viewWidth, self.scrollviewHeader.frame.size.height  + self.params.tabIndicatorBackgroundHeight);
    self.scrollHeaderBackContainer.frame = CGRectMake(0, 0, self.frame.size.width, self.scrollviewHeader.frame.size.height  + self.params.tabIndicatorBackgroundHeight);
}

- (void)makeSelectedViewFrame
{
    //分割线
    CGFloat splitWidth = 0.0;
    if(self.params.tabSplitColor || self.params.tabSplitImage) {
        splitWidth = self.params.tabSplitSize.width;
    }
    NSInteger realCurIndex = self.currentIndex > 0 ? self.currentIndex : 0;
    
    //每个按钮的宽度
    CGFloat perWidth = 0;
    if (self.titleWidths.count > realCurIndex) {
        perWidth = [self.titleWidths[realCurIndex] floatValue];
    }
    
    self.selectedView.frame = CGRectMake(realCurIndex * perWidth + (realCurIndex * splitWidth), self.params.tabTopOffset, perWidth,  self.params.tabHeight + self.params.tabIndicatorHeight);
    
    if (self.params.tabIndicatorCorner > 0) {
        self.imageViewLine.layer.cornerRadius = self.params.tabIndicatorCorner;
    }
    
    //下划线
    CGFloat lineXPos = self.selectedView.frame.origin.x;
    if (self.tabWidthType == STabTitleWidthFixed && ((STabViewFixedParams *)self.params).tabIndicatorWidth > 1) {
        if (self.params.tabIndicatorOffsetY != -1) {
            self.imageViewLine.frame = CGRectMake(lineXPos, self.params.tabIndicatorOffsetY, ((STabViewFixedParams *)self.params).tabIndicatorWidth, self.params.tabIndicatorHeight);
        } else {
            self.imageViewLine.frame = CGRectMake(lineXPos, self.params.tabTopOffset + self.params.tabHeight, ((STabViewFixedParams *)self.params).tabIndicatorWidth, self.params.tabIndicatorHeight);
        }
        
        CGFloat xPos, yPos;
        xPos = lineXPos + self.selectedView.frame.size.width / 2.f;
        yPos = self.imageViewLine.center.y;
        CGPoint centerPt = CGPointMake(xPos, yPos);
        self.imageViewLine.center = centerPt;
    } else {
        if (self.params.tabIndicatorOffsetY != -1) {
            self.imageViewLine.frame = CGRectMake(lineXPos, self.params.tabIndicatorOffsetY, self.selectedView.frame.size.width, self.params.tabIndicatorHeight);
        } else {
            self.imageViewLine.frame = CGRectMake(lineXPos, self.params.tabTopOffset + self.params.tabHeight, self.selectedView.frame.size.width, self.params.tabIndicatorHeight);
        }
    }
    
    //下划线是否跟随字体一样宽度
    if (self.params.tabIndicatorEqualTitleWidth == YES) {
        STabItem *item = self.arrTabItems[realCurIndex];
        CGSize fontSize = [item.title sizeWithAttributes:@{NSFontAttributeName:item.titleNormalFont}];
        CGRect rectSelectedView = self.selectedView.frame;
        CGRect rectImageViewLine = self.imageViewLine.frame;
        
        CGFloat offsetX = 0;
        for (int i = 0; i < realCurIndex; ++i) {
            offsetX += [self.titleWidths[i] floatValue];
        }
        
        self.selectedView.frame = CGRectMake(offsetX + (perWidth - fontSize.width) / 2.0 + (realCurIndex * splitWidth), rectSelectedView.origin.y, fontSize.width, rectSelectedView.size.height);
        
        lineXPos = self.selectedView.frame.origin.x;
        self.imageViewLine.frame = CGRectMake(lineXPos, rectImageViewLine.origin.y, self.selectedView.frame.size.width, rectImageViewLine.size.height);
    }
}

- (void)makeButtonFrame
{
    //分割线
    CGFloat splitWidth = 0.0;
    if(self.params.tabSplitColor || self.params.tabSplitImage) {
        splitWidth = self.params.tabSplitSize.width;
    }
    
    CGFloat titleBtnOffsetX = 0.0f;
    for (int i = 0; i < self.arrTabItems.count; ++i) {
        UIButton *button = [self.scrollviewHeader viewWithTag:i + STABVIEW_BUTTON_TAG_BASE];
        if (button == nil) {
            break;
        }
        CGFloat tmpPerWidth = [self.titleWidths[i] floatValue];
        if (i == self.currentIndex) {
            [self updateButton:button withStatus:YES];
        }
        button.frame = CGRectMake(titleBtnOffsetX + (i * splitWidth), self.params.tabTopOffset, tmpPerWidth, self.params.tabHeight);
        titleBtnOffsetX += tmpPerWidth;
    }
    
    titleBtnOffsetX = 0.0f;
    for (int idx = 0; idx < self.splitsArray.count; ++idx) {
        UIView *tmpView = self.splitsArray[idx];
        CGFloat tmpPerWidth = [self.titleWidths[idx] floatValue];
        titleBtnOffsetX += tmpPerWidth;
        
        CGFloat splitHeight = (self.scrollviewHeader.frame.size.height - tmpView.frame.size.height) / 2.0;
        splitHeight = (splitHeight <= 0 || splitHeight > self.scrollviewHeader.frame.size.height) ? self.scrollviewHeader.frame.size.height : splitHeight;
        tmpView.frame = CGRectMake(titleBtnOffsetX + (idx * splitWidth), self.params.tabTopOffset + splitHeight, tmpView.frame.size.width, tmpView.frame.size.height);
    }
}

#pragma mark - 属性setter
- (void)setCurrentIndex:(NSInteger)currentIndex
{
    _currentIndex = currentIndex;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(tabBar:willTapIndex:)]) {
        [self.delegate tabBar:self willTapIndex:currentIndex];
    }
    
    if (self.thirdParty) {
        //如果是单独使用就移动
        [self moveTabIndex:currentIndex];
    }
}

- (void)setParams:(STabViewParams *)params
{
    if (_params != params && params != nil) {
        _params = params;
        
        [self baseTabLayoutUpdate:params];
    }
}

#pragma mark - 事件方法
- (void)tabDidClicked:(UIButton *)sender
{
    NSInteger tag = ((UIButton *)sender).tag - STABVIEW_BUTTON_TAG_BASE;
    _isScrolling = YES;
    _bClicked = YES;
    self.currentIndex = tag;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (self.frame.size.width == 0 || self.params == nil) {
        return;
    }
    
    if (self.arrTabItems == nil || self.arrTabItems.count == 0) {
        [self makeScrollHeaderFrame];;
    } else {
        [self calcTitleWidths];
        
        //button滚动容器
        [self makeScrollHeaderFrame];
        
        //选中状态View
        [self makeSelectedViewFrame];
        
        [self makeButtonFrame];
    }
}

#pragma mark - 私有方法
- (void)calcLinePos:(CGFloat)pos outMaskFrame:(CGRect *)maskFrame outLineFrame:(CGRect *)lineFrame
{
    int currentIndex = (int)pos;
    int nextIndex = (currentIndex + 1 >= self.arrTabItems.count) ? ((int)self.arrTabItems.count - 1) : (currentIndex + 1);
    
    
    UIButton *btn = [self.scrollviewHeader viewWithTag:currentIndex + STABVIEW_BUTTON_TAG_BASE];
    UIButton *nextBtn = [self.scrollviewHeader viewWithTag:nextIndex + STABVIEW_BUTTON_TAG_BASE];
    
    CGFloat nextTitleWidth = 0.0f;
    CGFloat currentTitleWidth = 0.0f;
    CGRect imageViewLineRect = self.imageViewLine.frame;
    CGRect rect = self.selectedView.frame;
    CGFloat tagCMargin = 0;
    CGFloat tagNMargin = 0;
    
    if (self.tabWidthType == STabTitleWidthAuto) {
        tagNMargin = tagCMargin = ((STabViewAutoParams *)self.params).tabMargin;
    }
    
    if (self.params.tabIndicatorEqualTitleWidth) {
        nextTitleWidth = nextBtn.titleLabel.frame.size.width;
        currentTitleWidth = btn.titleLabel.frame.size.width;
        if (_bRemoveAction || (nextBtn == btn)) {
            STabItem *item = [self.arrTabItems objectAtIndex:currentIndex];
            currentTitleWidth = [item.title sizeWithAttributes:@{NSFontAttributeName:item.titleNormalFont}].width;
        }
        if ([self.params isKindOfClass:[STabViewEqualParams class]] || [self.params isKindOfClass:[STabViewFixedParams class]]) {
            tagCMargin = (btn.frame.size.width - currentTitleWidth) / 2.0f;
            tagNMargin = (nextBtn.frame.size.width - nextTitleWidth) / 2.0f;
        }
        
        rect.origin.x = btn.frame.origin.x + tagCMargin + ((nextBtn.frame.origin.x + tagNMargin) - (btn.frame.origin.x + tagCMargin)) * (pos - currentIndex);
    } else {
        nextTitleWidth = [self.titleWidths[nextIndex] floatValue];
        currentTitleWidth = [self.titleWidths[currentIndex] floatValue];
        rect.origin.x = btn.frame.origin.x + ((nextBtn.frame.origin.x) - (btn.frame.origin.x )) * (pos - currentIndex);
    }
    
    CGFloat maskWidth = currentTitleWidth - (currentTitleWidth - nextTitleWidth) * (pos - currentIndex);
    rect.size.width = maskWidth;
    
//    CGFloat xPos, yPos;
//    xPos = lineXPos + self.selectedView.frame.size.width / 2.f;
//    yPos = self.imageViewLine.center.y;
//    CGPoint centerPt = CGPointMake(xPos, yPos);
//    self.imageViewLine.center = centerPt;
//    imageViewLineRect.origin.x += rect.origin.x;
    //如果有下划线，显示
    if (self.params.tabIndicator) {
        if (self.tabWidthType == STabTitleWidthFixed && ((STabViewFixedParams *)self.params).tabIndicatorWidth > 1) {
            imageViewLineRect.size.width = ((STabViewFixedParams *)self.params).tabIndicatorWidth;
        } else {
            imageViewLineRect.size.width = maskWidth;
        }
    }
    
    imageViewLineRect.origin.x = rect.origin.x + (rect.size.width - imageViewLineRect.size.width) / 2.0f;
    
    _bRemoveAction = NO;
    *maskFrame = rect;
    *lineFrame = imageViewLineRect;
}

- (void)updateSelectFrame:(CGRect)selFrm lineFrame:(CGRect)lineFrm
{
    self.selectedView.frame = selFrm;
    self.imageViewLine.frame = lineFrm;
}

- (void)updateButton:(UIButton *)button withStatus:(BOOL)status
{
    button.selected = status;
    
    NSInteger idex = button.tag - STABVIEW_BUTTON_TAG_BASE;
    STabItem *item = [self.arrTabItems objectAtIndex:idex];
    if (item.titleSelectedFont) {
        if (status) {
            button.titleLabel.font = item.titleSelectedFont;
        } else {
            button.titleLabel.font = item.titleNormalFont;
        }
    }
}

- (void)changePageWithIndex:(NSInteger)index
{
    UIButton *btn = [self.scrollviewHeader viewWithTag:index + STABVIEW_BUTTON_TAG_BASE];
    [self updateButton:btn withStatus:YES];
    _bClicked = NO;
    if (_preIndex != index) {
        UIButton *preBtn = [self.scrollviewHeader viewWithTag:((_preIndex == -1) ? 0 : _preIndex) + STABVIEW_BUTTON_TAG_BASE];
        if (preBtn && preBtn != btn) {
            [self updateButton:preBtn withStatus:NO];
        }
        
        _currentIndex = index;
        _isScrolling = NO;
        [self callDelegateFun:index];
        _preIndex = index;
        
        [self scrollTitlesToIndex:(int)index];
    }
}

- (void)animationToIndex:(NSInteger)index selectedFrame:(CGRect)selectedFrame lineFrame:(CGRect)lineFrame
{
    [UIView animateWithDuration:0.3 animations:^{
        self.selectedView.frame = selectedFrame;
        self.imageViewLine.frame = lineFrame;
    } completion:^(BOOL finished) {
        [self changePageWithIndex:index];
    }];
}

- (void)scrollTitlesToIndex:(int)currentIndex
{
    //标题导航滚动操作
    UIButton *btn = [self.scrollviewHeader viewWithTag:currentIndex + STABVIEW_BUTTON_TAG_BASE];
    CGFloat splitWidth = 0.0f;
    NSInteger splitCount = self.arrTabItems.count - 1;
    if(self.params.tabSplitColor || self.params.tabSplitImage) {
        splitWidth = self.params.tabSplitSize.width;
    }
    
    CGFloat viewWidth = self.bounds.size.width;
    viewWidth -= (self.params.tabRightMargin + self.params.tabLeftMargin);
    
    // 设置标题滚动区域的偏移量
    CGFloat offsetX = btn.center.x - viewWidth * 0.5 - splitWidth * splitCount;
    offsetX = offsetX < 0 ? 0 : offsetX;
    
    // 计算下最大的标题视图滚动区域
    CGFloat maxOffsetX = self.scrollviewHeader.contentSize.width - viewWidth;
    maxOffsetX = maxOffsetX < 0 ? 0 : maxOffsetX;
    
    offsetX = offsetX > maxOffsetX ? maxOffsetX : offsetX;
    
    // 滚动区域
    [self.scrollviewHeader setContentOffset:CGPointMake(offsetX, 0) animated:YES];
}

- (void)callDelegateFun:(NSInteger)index
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(tabBar:didTapIndex:)]) {
        [self.delegate tabBar:self didTapIndex:index];
    }
}

- (void)baseTabViewSetupUI
{
    for (int i = 0; i < self.arrTabItems.count; ++i) {
        [self addTabButtonWithIndex:i];
    }
    [self.scrollviewHeader bringSubviewToFront:self.imageViewLine];
}

- (void)addTabButtonWithIndex:(NSInteger)tagIndex
{
    if (self.arrTabItems.count <= tagIndex) {
        return;
    }
    
    STabItem *item = [self.arrTabItems objectAtIndex:tagIndex];
    UIButton *button = [self genButtonWithTitle:item.title withIdx:tagIndex];
    [self updateButtonStyle:button andItem:item];
    [self.scrollviewHeader addSubview:button];
}

- (void)updateButtonStyle:(UIButton *)button andItem:(STabItem *)item
{
    if (item.titleNormalColor) {
        [button setTitleColor:item.titleNormalColor forState:UIControlStateNormal];
    }
    
    if (item.titleSelectedColor) {
        [button setTitleColor:item.titleSelectedColor forState:UIControlStateSelected];
    }
    
    if (item.titleNormalFont) {
        button.titleLabel.font = item.titleNormalFont;
    }
    
    if (item.backgroundColor) {
        button.backgroundColor = item.backgroundColor;
    }
}

- (UIButton *)genButtonWithTitle:(NSString *)title withIdx:(NSInteger)idx
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [button setTitle:title forState:UIControlStateNormal];
    
    button.tag = idx + STABVIEW_BUTTON_TAG_BASE;
    [button addTarget:self action:@selector(tabDidClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    return button;
}

- (void)baseTabLayoutUpdate:(STabViewParams *)params
{
    CGFloat height = self.params.tabIndicatorBackgroundHeight + self.params.tabTopOffset + self.params.tabHeight +  self.params.tabindicatorBackgroundOffset;
    if (self.frame.origin.x !=0 || self.frame.origin.y != 0) {
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, [UIScreen mainScreen].bounds.size.width, height);
    } else {
        self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, height);
    }
    
    if ([params isMemberOfClass:[STabViewAutoParams class]]) {
        self.tabWidthType = STabTitleWidthAuto;
    } else if ([params isMemberOfClass:[STabViewFixedParams class]]) {
        self.tabWidthType = STabTitleWidthFixed;
    } else if ([params isMemberOfClass:[STabViewEqualParams class]]) {
        self.tabWidthType = STabTitleWidthEqual;
    } else {
        NSAssert(1, @"参数错误");
    }
    
    [self updateStyleWithParams:params];
    
    [self layoutIfNeeded];
    [self setNeedsLayout];
}

- (void)addSplitLines
{
    STabViewParams *params = self.params;
    
    if (params.tabSplitImage || params.tabSplitColor) {
        //从父窗口移除
        [self.splitsArray makeObjectsPerformSelector:@selector(removeFromSuperview)];
        self.splitsArray = nil;
        
        if (self.arrTabItems.count != 0) {
            for (int i = 0; i < self.arrTabItems.count - 1; ++i) {
                UIView *tmpView = nil;
                if (params.tabSplitImage) {
                    tmpView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:params.tabSplitImage]];
                } else if (params.tabSplitColor) {
                    tmpView = [UIView new];
                    tmpView.backgroundColor = params.tabSplitColor;
                }
                
                tmpView.frame = CGRectMake(0, 0, params.tabSplitSize.width, params.tabSplitSize.height);
                [self.splitsArray addObject:tmpView];
                [self.scrollviewHeader addSubview:tmpView];
            }
        }
    }
}

- (void)updateStyleWithParams:(STabViewParams *)params
{
    [self addSplitLines];
    
    self.selectedView.backgroundColor = params.tabMask ? params.tabMaskColor : [UIColor clearColor];
    self.imageViewLine.backgroundColor = params.tabIndicatorColor;
    self.scrollHeaderContainer.backgroundColor = params.tabIndicatorBackgroundColor;
    self.scrollviewHeader.backgroundColor = params.tabBackgroundColor;
    if (params.tabBackgroundImage) {
        self.scrollHeaderBackContainer.layer.contents = (id)[UIImage imageNamed:params.tabBackgroundImage].CGImage;
        self.scrollHeaderContainer.backgroundColor = [UIColor clearColor];
        self.scrollviewHeader.backgroundColor = [UIColor clearColor];
    }
    
    if (params.tabIndicatorImage != nil) {
        self.imageViewLine.image = [UIImage imageNamed:params.tabIndicatorImage];
        
        if ((self.tabWidthType == STabTitleWidthFixed && ((STabViewFixedParams*)params).tabIndicatorWidth < 1 ) || params.tabIndicatorImageMode != STabIndicatorImageModeNone) {
            self.imageViewLine.contentMode = (UIViewContentMode)params.tabIndicatorImageMode;
        }
    }
    
    self.imageViewLine.hidden = !self.params.tabIndicator;
}

#pragma mark - lazy load
- (UIView *)selectedView
{
    if (_selectedView == nil) {
        _selectedView = [UIView new];
    }
    
    return _selectedView;
}

- (UIView *)scrollHeaderContainer
{
    if (_scrollHeaderContainer == nil) {
        _scrollHeaderContainer = [UIView new];
    }
    
    return _scrollHeaderContainer;
}

- (UIView *)scrollHeaderBackContainer
{
    if (_scrollHeaderBackContainer == nil) {
        _scrollHeaderBackContainer = [UIView new];
    }
    
    return _scrollHeaderBackContainer;
}

- (UIImageView *)imageViewLine
{
    if (_imageViewLine == nil) {
        _imageViewLine = [UIImageView new];
    }
    
    return _imageViewLine;
}

- (UIScrollView *)scrollviewHeader
{
    if (_scrollviewHeader == nil) {
        _scrollviewHeader = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 0)];
        
        _scrollviewHeader.showsHorizontalScrollIndicator = NO;
        _scrollviewHeader.showsVerticalScrollIndicator = NO;
    }
    
    return _scrollviewHeader;
}

- (NSMutableArray *)arrTabItems
{
    if (_arrTabItems == nil) {
        _arrTabItems = [NSMutableArray array];
    }
    
    return _arrTabItems;
}

- (NSMutableArray *)titleWidths
{
    if (_titleWidths == nil) {
        _titleWidths = [NSMutableArray array];
    }
    
    return _titleWidths;
}

- (NSMutableArray *)splitsArray
{
    if (_splitsArray == nil) {
        _splitsArray = [NSMutableArray array];
    }
    
    return _splitsArray;
}

@end
