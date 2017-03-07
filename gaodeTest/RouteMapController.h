//
//  RouteMapHeaderView.h
//  gaodeTest
//
//  Created by 石冬冬 on 2017/3/1.
//  Copyright © 2017年 sdd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RouteMapController: UIViewController

/// 起点经纬度
@property (nonatomic, assign) CLLocationCoordinate2D startCoordinate;
/// 终点经纬度
@property (nonatomic, assign) CLLocationCoordinate2D destinaCoordinate;

@end
