//
//  UIView+AddBadgeView.h
//  RainbowBridge
//
//  Created by FarTeen on 8/15/14.
//  Copyright (c) 2014 cmri. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JSBadgeView.h"

@interface UIView (AddBadgeView)

@property (nonatomic, retain)  JSBadgeView  *badgeView;

- (void)addTabBarBadgeViewWithNumber:(NSInteger)number;
- (void)addBadgeViewWithNumber:(NSInteger)number;

@end
