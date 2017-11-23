//
//  STabReuseContainerView.m
//  STabViewDemo
//
//  Created by cs on 17/3/30.
//  Copyright © 2017年 cs. All rights reserved.
//

#import "STabReuseContainerView.h"
#import "SReuseTabViewFlowLayout.h"
#import "SReuseTabViewCell.h"

@interface STabReuseContainerView ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) Class cellClass;

@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation STabReuseContainerView
{
//    BOOL _bFirst;
//    NSInteger _curIdx;
    NSInteger _dataCount;
}

- (BOOL)increaseCount
{
    if (self.cellClass == Nil) {
        return NO;
    }
    
    _dataCount += 1;
    
    [self baseTabViewSetupUI];
    
    [self setNeedsLayout];
    [self layoutIfNeeded];
    
    return YES;
}

- (void)configureCellClass:(Class)cellClass dataCount:(NSInteger)dataCount
{
    self.cellClass = cellClass;
    
    _dataCount = dataCount;
    [self baseTabViewSetupUI];
    
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

#pragma mark - STabContainerBaseViewProtocol
- (void)tabViewRequestLayoutSubViews
{
    self.collectionView.frame = self.bounds;
}

- (void)tabViewRequestSetupUI
{
    [self.collectionView reloadData];
}

- (void)tabViewRequestSetupData
{
//    _bFirst = YES;
//    self.clickedState = YES;
}

- (void)tabViewRequestCallFunwithIndex:(NSInteger)index
{
//    _curIdx = index;
    
//    if (!self.preLoad) {
//        SReuseTabViewCell *cell = (SReuseTabViewCell*)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0]];
//        [self callbackFun:cell atRow:index];
//    } else if (self.clickedState) {
//        self.clickedState = NO;
//        
//        [self.collectionView reloadData];
//    }
    
    SReuseTabViewCell *cell = (SReuseTabViewCell*)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0]];
    if (cell == nil) {
        [self.collectionView reloadData];
        [self.collectionView layoutIfNeeded];
        cell = (SReuseTabViewCell*)[self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:0]];
    }
    [self callbackFun:cell atRow:index];
}

- (UIScrollView *)tabViewRequestContentView
{
    return self.collectionView;
}

- (void)callbackFun:(SReuseTabViewCell *)cell atRow:(NSInteger)row
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(tabContainer:didTapView:didTapIndex:)]) {
        [self.delegate tabContainer:self didTapView:cell didTapIndex:row];
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _dataCount;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    SReuseTabViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cs_cs" forIndexPath:indexPath];
    
//    if (self.preLoad && self.clickedState == NO) {
//        [self callbackFun:cell atRow:indexPath.row];
//    } else if (_bFirst && indexPath.row == self.currentTab) {
//        [self callbackFun:cell atRow:indexPath.row];
//        _bFirst = NO;
//        self.clickedState = NO;
//    }
    

    
    return cell;
}

#pragma mark -
- (void)setCellClass:(Class)cellClass
{
    _cellClass = cellClass;
    
    [self.collectionView registerClass:cellClass forCellWithReuseIdentifier:@"cs_cs"];
}

- (UICollectionView *)collectionView
{
    if (_collectionView == nil) {
        SReuseTabViewFlowLayout *layout = [[SReuseTabViewFlowLayout alloc] init];
        _collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:layout];
        _collectionView.pagingEnabled = YES;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.bounces = NO;
        
    }
    
    return _collectionView;
}
@end
