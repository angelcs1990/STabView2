//
//  STabReuseContainerView.h
//  STabViewDemo
//
//  Created by cs on 17/3/30.
//  Copyright © 2017年 cs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "STabContainerBaseView.h"

@interface STabReuseContainerView : STabContainerBaseView<STabContainerBaseViewProtocol>

@property (nonatomic) BOOL preLoad;

- (void)configureCellClass:(Class)cellClass dataCount:(NSInteger)dataCount;

- (BOOL)increaseCount;

@end
