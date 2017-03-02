//
//  TeamInfoContentView.m
//  gaodeTest
//
//  Created by 石冬冬 on 2017/2/23.
//  Copyright © 2017年 sdd. All rights reserved.
//

#import "TeamInfoContentView.h"
#import "D3View.h"
#import "TeamInfoFlowLayout.h"
#define KContentViewH 190
#define CellID @"teamInfoCell"
@interface TeamInfoContentView()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic,weak) UIView *contentView;

@property (nonatomic,strong) UIScrollView *bottomScrollView;

@property (nonatomic, weak) UICollectionView *collectionView;



@end
@implementation TeamInfoContentView

- (instancetype)init {
    if (self = [super init]) {
        self.backgroundColor = [UIColor clearColor];
        
        UIView *contentView = [[UIView alloc] init];
        contentView.backgroundColor = [UIColor clearColor];
        self.contentView = contentView;
        [self addSubview:contentView];
        
        [self setupInfoView];
        
    }
    return self;
}

- (void)setupInfoView {
    
    self.contentView.frame = CGRectMake(0, -KContentViewH, MainScreenW, KContentViewH);
    TeamInfoFlowLayout *flowLayout = [[TeamInfoFlowLayout alloc] init];
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:self.contentView.bounds collectionViewLayout:flowLayout];
    self.collectionView = collectionView;
    [self.contentView addSubview:collectionView];
    collectionView.backgroundColor = [UIColor clearColor];
    collectionView.showsHorizontalScrollIndicator = NO;
    collectionView.delegate = self;
    collectionView.dataSource = self;
    collectionView.pagingEnabled = YES;
    [collectionView registerClass:[TeamInfoCollectionViewCell class] forCellWithReuseIdentifier:CellID];

    
}


- (void)layoutSubviews {
    [super layoutSubviews];
    
    
}


- (void)setDataArray:(NSMutableArray *)dataArray {
    _dataArray = dataArray;
    [self.collectionView reloadData];
}
#pragma mark ----- 动画
- (void) popAnimationWithView:(UIView *) view offset:(CGFloat) offset{
    POPSpringAnimation * popSpring = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionY];
    popSpring.toValue = @(view.center.y + offset);
    popSpring.beginTime = CACurrentMediaTime();
    popSpring.springBounciness = 11.0;
    popSpring.springSpeed = 15;
    [view pop_addAnimation:popSpring forKey:@"positionY"];
}


#pragma mark ----- 外部方法
- (void) popupDetailViewAnimation {
    self.hidden = NO;
    if (-KContentViewH == self.contentView.layer.frame.origin.y) {
        [self popAnimationWithView:self.contentView offset:KContentViewH];
    }
}

- (void) hidDetailViewAnimation {
    [UIView animateWithDuration:0.15 animations:^{
        CGRect tempFrame = self.contentView.frame;
        tempFrame.origin.y = -KContentViewH;
        self.contentView.frame = tempFrame;
    } completion:^(BOOL finished) {
        self.hidden = YES;
    }];
}

// 滑动到指定页面
- (void)scrollPageViewToIndex:(NSInteger)index animated:(BOOL)animated{
    
    NSIndexPath *indexpath = [NSIndexPath indexPathForItem:index inSection:0];
    [self.collectionView scrollToItemAtIndexPath:indexpath atScrollPosition:UICollectionViewScrollPositionNone animated:animated];
    
}


#pragma mark ----- UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArray.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TeamInfoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellID forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[TeamInfoCollectionViewCell alloc] init];
    }
    cell.imageName = self.dataArray[indexPath.row];
    return cell;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.delegate respondsToSelector:@selector(teamInfoContentView:didSelectPageView:index:)]) {
        [self.delegate teamInfoContentView:self didSelectPageView:collectionView index:indexPath.row];
    }
}



- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSArray *indexPathArray = [self.collectionView indexPathsForVisibleItems];
    NSIndexPath *indexPath = indexPathArray[0];
    NSLog(@"scrollViewDidEndDragging == %ld",indexPath.row);
    if ([self.delegate respondsToSelector:@selector(teamInfoContentView:didScollPageView:byUser:)]) {
        [self.delegate teamInfoContentView:self didScollPageView:indexPath.row byUser:YES];
    }
}
@end
