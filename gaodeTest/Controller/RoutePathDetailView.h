//
//  RoutePathDetailViewController.h
//  Drive-Route-Demo
//
//  Created by eidan on 16/11/28.
//  Copyright © 2016年 autonavi. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AMapRoute;
@class AMapPath;

@interface RoutePathDetailView : UIView

@property (strong, nonatomic) AMapRoute *route;
@property (strong, nonatomic) AMapPath *path;
@property (nonatomic, strong) AMapTransit *transit;
+ (instancetype) routePathDetialView;

@end
