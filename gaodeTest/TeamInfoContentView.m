//
//  TeamInfoContentView.m
//  gaodeTest
//
//  Created by 石冬冬 on 2017/2/23.
//  Copyright © 2017年 sdd. All rights reserved.
//

#import "TeamInfoContentView.h"
#import "D3View.h"
#import "NewPagedFlowView.h"
#define KContentViewH 190
@interface TeamInfoContentView()<NewPagedFlowViewDelegate, NewPagedFlowViewDataSource>

@property (nonatomic,weak) UIView *contentView;

@property (nonatomic,strong) UIScrollView *bottomScrollView;

@property (nonatomic, weak) NewPagedFlowView *pageFlowView;



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

    NewPagedFlowView *pageFlowView = [[NewPagedFlowView alloc] init];
    self.pageFlowView = pageFlowView;
    pageFlowView.frame = CGRectMake(0, 0, MainScreenW, (MainScreenW - 84) * 9 / 16 + 24);
    pageFlowView.backgroundColor = [UIColor clearColor];
    pageFlowView.delegate = self;
    pageFlowView.dataSource = self;
    pageFlowView.minimumPageAlpha = 0.1;
    pageFlowView.minimumPageScale = 0.95;
    pageFlowView.isCarousel = NO;
    pageFlowView.orientation = NewPagedFlowViewOrientationHorizontal;
    pageFlowView.isOpenAutoScroll = YES;
    

    self.bottomScrollView = [[UIScrollView alloc] initWithFrame:self.contentView.bounds];
    self.bottomScrollView.backgroundColor = [UIColor clearColor];
    [self.bottomScrollView addSubview:pageFlowView];
    
    [self.contentView addSubview:self.bottomScrollView];
    
}


- (void)layoutSubviews {
    [super layoutSubviews];
    self.contentView.frame = CGRectMake(0, -KContentViewH, MainScreenW, KContentViewH);
    self.bottomScrollView.frame = self.contentView.bounds;
}


- (void)setDataArray:(NSMutableArray *)dataArray {
    _dataArray = dataArray;
    [self.pageFlowView reloadData];
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

- (void)scrollPageViewToIndex:(NSInteger)index animated:(BOOL)animated{
    
    [self.pageFlowView scrollToPage:2 animated:animated];
    
}
#pragma mark NewPagedFlowView Delegate
- (CGSize)sizeForPageInFlowView:(NewPagedFlowView *)flowView {
    return CGSizeMake(MainScreenW - 30, (MainScreenW - 48) * 9 / 16);
}

- (void)didSelectCell:(UIView *)subView withSubViewIndex:(NSInteger)subIndex {
    if ([self.delegate respondsToSelector:@selector(teamInfoContentView:didSelectPageView:index:)]) {
        if ([subView isKindOfClass:[PGIndexBannerSubiew class]]) {
            PGIndexBannerSubiew *banerView = (PGIndexBannerSubiew *) subView;
             [self.delegate teamInfoContentView:self didSelectPageView:banerView index:subIndex];
        }
       
    }
}

#pragma mark NewPagedFlowView Datasource
- (NSInteger)numberOfPagesInFlowView:(NewPagedFlowView *)flowView {
    
    return self.dataArray.count;
    
}

- (UIView *)flowView:(NewPagedFlowView *)flowView cellForPageAtIndex:(NSInteger)index{
    PGIndexBannerSubiew *bannerView = (PGIndexBannerSubiew *)[flowView dequeueReusableCell];
    if (!bannerView) {
        bannerView = [[PGIndexBannerSubiew alloc] initWithFrame:CGRectMake(0, 0, MainScreenW - 30, (MainScreenW - 48) * 9 / 16)];
        bannerView.tag = index;
        bannerView.layer.cornerRadius = 4;
        bannerView.layer.masksToBounds = YES;
    }
    bannerView.mainImageView.image = self.dataArray[index];
    
    return bannerView;
}

- (void)didScrollToPage:(NSInteger)pageNumber inFlowView:(NewPagedFlowView *)flowView {
    
    if ([self.delegate respondsToSelector:@selector(teamInfoContentView:didScollPageView:)]) {
        [self.delegate teamInfoContentView:self didScollPageView:pageNumber];
    }
   
}

@end
