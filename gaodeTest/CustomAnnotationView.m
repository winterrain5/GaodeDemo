//
//  CustomAnnotationView.m
//  gaodeTest
//
//  Created by 石冬冬 on 2017/2/22.
//  Copyright © 2017年 sdd. All rights reserved.
//

#import "CustomAnnotationView.h"
#import "CustomAnnotation.h"
#import "D3View.h"
#import "CustomCalloutView.h"
@interface CustomAnnotationView()

@property (nonatomic, strong) UIImageView *backgroundImageView;
@property (nonatomic, strong) UIImageView *avatarImageView;
@property (nonatomic, strong) UIImageView *dotImageView;


@end
@implementation CustomAnnotationView
- (UIImageView *)backgroundImageView {
    if (_backgroundImageView == nil) {
        _backgroundImageView = [[UIImageView alloc] init];
        [self addSubview:_backgroundImageView];
    }
    return _backgroundImageView;
}

- (UIImageView *)avatarImageView {
    if (_avatarImageView == nil) {
        _avatarImageView = [[UIImageView alloc] init];
        [self.backgroundImageView addSubview:_avatarImageView];
    }
    return _avatarImageView;
}



- (id)initWithAnnotation:(id<MAAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier {
    CustomAnnotation *anno = (CustomAnnotation *) annotation;
    self = [super initWithAnnotation:anno reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        // 初始化标注
        [self setupAnnotation:anno];
    }
    
    return self;
}



- (void) setAnnotation:(id<MAAnnotation>)annotation {
    [super setAnnotation:annotation];
    CustomAnnotation *ann = (CustomAnnotation *) self.annotation;
    
    // 当annotation滑出地图时，ann为nil时，不进行设置，只有当ann在地图范围内出现时才设置
    if (ann) {
        [self setupAnnotation:ann];
    }
}

// 设置annotation
- (void) setupAnnotation:(CustomAnnotation *) ann {
    NSString *mask = @"";
    CGRect frame = CGRectMake(0, 0, 40, 52);
    switch (ann.type) {
        case CustomAnnotationTypeOne: {
            mask = @"xh_dq_zb_bg.png";
        }
        
        break;
        
        case CustomAnnotationTypeTwo: {
            mask = @"xh_dq_zb_bg.png";
        }
        
        break;
        
        case CustomAnnotationTypeThree: {
            mask = @"xh_dq_zb_bg.png";
        }
        
        break;
        
        case CustomAnnotationTypeFour: {
            mask = @"xh_dq_zb_bg.png";
        }
        
        break;
        
        default:
        break;
    }
    
    self.bounds = frame;
    self.centerOffset = CGPointMake(0, -self.bounds.size.height * 0.5);
    
    // 设置背景图片
    self.backgroundImageView.image = [UIImage imageNamed:mask];
    self.backgroundImageView.frame = self.bounds;
    
    // 设置头像图片
    self.avatarImageView.frame = CGRectMake(3, 3, self.bounds.size.width - 6, self.bounds.size.width - 6);
    self.avatarImageView.layer.cornerRadius = (self.bounds.size.width - 6) * 0.5;
    self.avatarImageView.layer.masksToBounds = YES;
    self.avatarImageView.image = [UIImage imageNamed:ann.imagePath];
    
    
}

#pragma mark ----- 父类方法

// annotation被添加到fuview上做动画
- (void)willMoveToSuperview:(UIView *)newSuperview {
    [super willMoveToSuperview:newSuperview];
    
    if (newSuperview == nil) {
        return;
    }
    
    if (CGRectContainsPoint(newSuperview.bounds, self.center)) {
        CABasicAnimation *growAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
        growAnimation.delegate = (id<CAAnimationDelegate>)self;
        growAnimation.duration = 0.8f;
        growAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
        
        growAnimation.fromValue = [NSNumber numberWithDouble:0.0f];
        
        growAnimation.toValue = [NSNumber numberWithDouble:1.0f];
        
        [self.layer addAnimation:growAnimation forKey:@"growAnimation"];
    }
}

// 事件传递到子控件执行
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView *view = [super hitTest:point withEvent:event];
    if (view == nil) {
        CGPoint tempoint = [self.calloutView.btn convertPoint:point fromView:self];
        if (CGRectContainsPoint(self.calloutView.btn.bounds, tempoint)) {
            view = self.calloutView.btn;
        }
    }
    return view;

}
#pragma mark ----- 外部方法
- (void) startAnimation {
    self.backgroundImageView.image = [UIImage imageNamed:@"xh_zb_red_ic.png"];
    [self d3_scale:1.6];
}
- (void) stopAnimation {
    
    self.backgroundImageView.image = [UIImage imageNamed:@"xh_dq_zb_bg.png"];
    [self d3_scale:1];
}

@end
