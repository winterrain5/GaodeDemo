//
//  TeamInfoContentView.h
//  gaodeTest
//
//  Created by 石冬冬 on 2017/2/23.
//  Copyright © 2017年 sdd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TeamInfoCollectionViewCell.h"
@class TeamInfoContentView;
@protocol TeamInfoContentViewDelegate <NSObject>

- (void) teamInfoContentView:(TeamInfoContentView *) view didSelectPageView:(UICollectionView *) collectionView index:(NSInteger) index;

- (void) teamInfoContentView:(TeamInfoContentView *) view didScollPageView:(NSInteger) index byUser:(BOOL) wasByUser;

@end
@interface TeamInfoContentView : UIView
@property (nonatomic,weak) id<TeamInfoContentViewDelegate> delegate;
@property (nonatomic, strong) NSMutableArray *dataArray;
- (void) popupDetailViewAnimation;
- (void) hidDetailViewAnimation;
- (void) scrollPageViewToIndex:(NSInteger) index animated:(BOOL) animated;
@end
