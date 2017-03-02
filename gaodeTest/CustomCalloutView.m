//
//  CustomCalloutView.m
//  gaodeTest
//
//  Created by 石冬冬 on 2017/3/1.
//  Copyright © 2017年 sdd. All rights reserved.
//

#import "CustomCalloutView.h"
#import "CustomAnnotation.h"
const NSInteger kArrorHeight = 10;
const NSInteger kCornerRadius = 6;


@interface CustomCalloutView()

@end
@implementation CustomCalloutView


#pragma mark ----- 初始化
- (instancetype)init {
    if (self = [super init]) {
        [self setupUI];
        self.userInteractionEnabled = YES;
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void) setupUI {
    
    UIButton *btn = [[UIButton alloc] init];
    [self addSubview:btn];
    self.btn = btn;
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitle:@"点我跳转" forState:UIControlStateNormal];
    btn.backgroundColor = [UIColor blueColor];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
   
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
}

- (void)setCustomAnn:(CustomAnnotation *)customAnn {
    _customAnn = customAnn;
    self.btn.frame = CGRectMake(kCornerRadius, kCornerRadius, 100, 40);
    [self setNeedsDisplay];
}
#pragma mark ----- 事件
- (void) btnClick:(UIButton *) sender {
    NSLog(@"dianwola");
    if ([self.delegate respondsToSelector:@selector(detailButtonClicked:calloutView:customAnn:)]) {
        [self.delegate detailButtonClicked:sender calloutView:self customAnn:self.customAnn];
    }
}

#pragma mark ----- 外部方法
- (void) dismissCalloutView {
    [self removeFromSuperview];
}

#pragma mark - draw rect

- (void)drawRect:(CGRect)rect
{
    [self drawInContext:UIGraphicsGetCurrentContext()];
    
    self.layer.shadowColor = [[UIColor blackColor] CGColor];
    self.layer.shadowOpacity = 1.0;
    self.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
}

- (void)drawInContext:(CGContextRef)context
{
    CGContextSetLineWidth(context, 3.0);
    CGContextSetFillColorWithColor(context, [UIColor colorWithRed:1 green:1 blue:1 alpha:1].CGColor);
    
    [self drawPath:context];
    CGContextFillPath(context);
}

- (void)drawPath:(CGContextRef)context
{
    CGRect rrect = self.bounds;
    CGFloat radius = kCornerRadius;
    CGFloat minx = CGRectGetMinX(rrect),
    midx = CGRectGetMidX(rrect),
    maxx = CGRectGetMaxX(rrect);
    CGFloat miny = CGRectGetMinY(rrect),
    maxy = CGRectGetMaxY(rrect)-kArrorHeight;
    
    CGContextMoveToPoint(context, midx+kArrorHeight, maxy);
    CGContextAddLineToPoint(context,midx, maxy+kArrorHeight);
    CGContextAddLineToPoint(context,midx-kArrorHeight, maxy);
    
    CGContextAddArcToPoint(context, minx, maxy, minx, miny, radius);
    CGContextAddArcToPoint(context, minx, minx, maxx, miny, radius);
    CGContextAddArcToPoint(context, maxx, miny, maxx, maxy, radius);
    CGContextAddArcToPoint(context, maxx, maxy, midx+kArrorHeight, maxy, radius);
    CGContextClosePath(context);
}


@end
