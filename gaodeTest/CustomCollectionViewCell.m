//
//  CustomCollectionViewCell.m
//  gaodeTest
//
//  Created by 石冬冬 on 2017/2/23.
//  Copyright © 2017年 sdd. All rights reserved.
//

#import "CustomCollectionViewCell.h"
@interface CustomCollectionViewCell()
@property (nonatomic,weak) UIImageView *imageView;
@end
@implementation CustomCollectionViewCell
- (instancetype)init {
    if (self = [super init]) {
        
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 5.0f;
        
        UIImageView *imageView = [[UIImageView alloc] init];
        self.imageView = imageView;
        [self.contentView addSubview:imageView];
        
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.imageView.frame = self.bounds;
}
@end
