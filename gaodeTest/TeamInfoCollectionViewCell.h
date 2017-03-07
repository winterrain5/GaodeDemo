//
//  TeamInfoCollectionViewCell.h
//  gaodeTest
//
//  Created by 石冬冬 on 2017/3/3.
//  Copyright © 2017年 sdd. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void(^CheckAptitudeBlock)();
@interface TeamInfoCollectionViewCell : UICollectionViewCell
@property (nonatomic, copy) NSString *imageName;
@property (nonatomic, assign) CheckAptitudeBlock checkAptitudeBlock;

+ (instancetype) teamInfoCollectionViewCell;
@end
