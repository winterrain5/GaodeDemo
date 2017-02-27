//
//  TeamInfoFlowLayout.m
//  gaodeTest
//
//  Created by 石冬冬 on 2017/2/27.
//  Copyright © 2017年 sdd. All rights reserved.
//

#import "TeamInfoFlowLayout.h"

@implementation TeamInfoFlowLayout
- (void)prepareLayout {
    [super prepareLayout];
    CGRect mainScreen = [UIScreen mainScreen].bounds;
    self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.minimumLineSpacing = 20;
    self.minimumInteritemSpacing = 0;
    self.sectionInset = UIEdgeInsetsMake(0, 10, 0, 0);
    self.itemSize = CGSizeMake(mainScreen.size.width - 20, 180);
}
@end
