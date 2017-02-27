//
//  TeamInfoCollectionViewCell.m
//  gaodeTest
//
//  Created by 石冬冬 on 2017/2/27.
//  Copyright © 2017年 sdd. All rights reserved.
//

#import "TeamInfoCollectionViewCell.h"

@interface TeamInfoCollectionViewCell()

@property (weak, nonatomic) UIImageView *imageView;

@end

@implementation TeamInfoCollectionViewCell

- (instancetype)init {
    if (self = [super init]) {
        
        self.layer.cornerRadius = 5;
        self.layer.masksToBounds = YES;
        
        UIImageView *imageView = [[UIImageView alloc] init];
        self.imageView = imageView;
        imageView.frame = self.bounds;
        [self.contentView addSubview:imageView];
        
    }
    return self;
}
- (void)setImageName:(NSString *)imageName{
    _imageName = imageName;
}

@end
