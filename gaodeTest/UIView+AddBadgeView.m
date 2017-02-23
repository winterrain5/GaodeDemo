//
//  UIView+AddBadgeView.m
//  RainbowBridge
//
//  Created by FarTeen on 8/15/14.
//  Copyright (c) 2014 cmri. All rights reserved.
//

#import "UIView+AddBadgeView.h"
#import <objc/runtime.h>

#define gScreenWidth [UIScreen mainScreen].bounds.size.width

static const char *JSBadgeViewFlag   = "JSBadgeViewFlag";

@implementation UIView (AddBadgeView)

@dynamic badgeView;

- (void)setBadgeView:(JSBadgeView *)badgeView
{
    objc_setAssociatedObject(self, JSBadgeViewFlag, badgeView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (JSBadgeView *)badgeView
{
    return objc_getAssociatedObject(self, JSBadgeViewFlag);
}

- (void)addTabBarBadgeViewWithNumber:(NSInteger)number
{
    if (number >= 0) {
        if (!self.badgeView) {
            self.badgeView = [[JSBadgeView alloc] initWithParentView:self alignment:JSBadgeViewAlignmentTopRight];
            self.badgeView.hidden = YES;
        }
        self.badgeView.hidden = NO;
        if (number == 0) {
            self.badgeView.badgeText = @"";
            self.badgeView.badgePositionAdjustment = CGPointMake(-gScreenWidth/3/2+15, 5);
        }
        else if (number > 50) {
            self.badgeView.badgeText = @"50+";
        } else {
            self.badgeView.badgeText = [NSString stringWithFormat:@"%ld",(long)number];
        }
    } else {
        if (self.badgeView) {
            self.badgeView.hidden = YES;
        }
    }
}

- (void)addBadgeViewWithNumber:(NSInteger)number {
    if (number > 0) {
        if (!self.badgeView) {
            self.badgeView = [[JSBadgeView alloc] initWithParentView:self alignment:JSBadgeViewAlignmentCustomByFarTeen];
        }
        self.badgeView.hidden = NO;
        if (number > 50)
            self.badgeView.badgeText = @"50+";
        else
            self.badgeView.badgeText = [NSString stringWithFormat:@"%ld",(long)number];
    } else {
        if (self.badgeView) {
            self.badgeView.hidden = YES;
        }
    }
}

@end
