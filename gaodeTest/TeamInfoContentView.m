//
//  TeamInfoContentView.m
//  gaodeTest
//
//  Created by 石冬冬 on 2017/2/23.
//  Copyright © 2017年 sdd. All rights reserved.
//

#import "TeamInfoContentView.h"
#import "D3View.h"

@interface TeamInfoContentView()

@property (nonatomic,weak) UIView *contentView;

@end
@implementation TeamInfoContentView

- (instancetype)init {
    if (self = [super init]) {
        self.backgroundColor = [UIColor clearColor];
        UIView *contentView = [[UIView alloc] init];
        self.contentView = contentView;
        contentView.backgroundColor = [UIColor blueColor];
        [self addSubview:contentView];
    }
    return self;
}


- (void)layoutSubviews {
    [super layoutSubviews];
    self.contentView.frame = CGRectMake(10, - 130, MainScreenW - 20, 130);
}

@end
