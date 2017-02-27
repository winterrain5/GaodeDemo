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


- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        CGRect mainScreen = [UIScreen mainScreen].bounds;
        UIImageView *imageView = [[UIImageView alloc] init];
        self.imageView = imageView;
        imageView.backgroundColor = [UIColor redColor];
        imageView.frame = CGRectMake(0, 0, mainScreen.size.width, 180);
        [self.contentView addSubview:imageView];
    }
    return self;
}
- (void)setImageName:(NSString *)imageName{
    _imageName = imageName;
    self.imageView.image = [UIImage imageNamed:imageName];
}

@end
