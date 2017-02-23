//
//  TeamInfoContentView.m
//  gaodeTest
//
//  Created by 石冬冬 on 2017/2/23.
//  Copyright © 2017年 sdd. All rights reserved.
//

#import "TeamInfoContentView.h"
#import "D3View.h"


#define KContentViewH 180
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
    self.contentView.frame = CGRectMake(10, -KContentViewH, MainScreenW - 20, KContentViewH);
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

- (void) popupDetailViewAnimation {
    self.hidden = NO;
    if (-KContentViewH == self.contentView.layer.frame.origin.y) {
        [self popAnimationWithView:self.contentView offset:KContentViewH + 10];
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
@end
