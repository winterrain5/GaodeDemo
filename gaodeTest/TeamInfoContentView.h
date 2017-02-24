//
//  TeamInfoContentView.h
//  gaodeTest
//
//  Created by 石冬冬 on 2017/2/23.
//  Copyright © 2017年 sdd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PGIndexBannerSubiew.h"
@class TeamInfoContentView;
@protocol TeamInfoContentViewDelegate <NSObject>

- (void) teamInfoContentView:(TeamInfoContentView *) view didSelectPageView:(PGIndexBannerSubiew *) pageView index:(NSInteger) index;

- (void) teamInfoContentView:(TeamInfoContentView *) view didScollPageView:(NSInteger) index;

@end
@interface TeamInfoContentView : UIView
@property (nonatomic,weak) id<TeamInfoContentViewDelegate> delegate;
@property (nonatomic, strong) NSMutableArray *dataArray;
- (void) popupDetailViewAnimation:(NSInteger) index;
- (void) hidDetailViewAnimation;
- (void) scrollPageViewToIndex:(NSInteger) index animated:(BOOL) animated;
@end
