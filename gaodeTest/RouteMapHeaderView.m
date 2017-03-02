//
//  RouteMapHeaderView.m
//  gaodeTest
//
//  Created by 石冬冬 on 2017/3/1.
//  Copyright © 2017年 sdd. All rights reserved.
//

#import "RouteMapHeaderView.h"
#import "CustomAnnotation.h"
#import "CustomAnnotationView.h"
@interface RouteMapHeaderView ()<MAMapViewDelegate>
@property (strong,nonatomic) MAMapView *mapView;
@end
@implementation RouteMapHeaderView


- (void)viewDidLoad {
    [super viewDidLoad];
    [self initMapView];
}

#pragma mark ----- 初始化

- (void) initMapView {
    
    // 添加地图
    self.mapView = [[MAMapView alloc] initWithFrame:self.view.bounds];
    self.mapView.delegate = self;
    // 当前地图的中心点
    self.mapView.centerCoordinate = CLLocationCoordinate2DMake(self.mapView.userLocation.location.coordinate.latitude, self.mapView.userLocation.location.coordinate.longitude);
    
    // 是否显示用户位置
    self.mapView.showsUserLocation = YES;
    // 设置初始缩放等级
    [self.mapView setZoomLevel:15 animated:YES];
    // 设置trackingMode 则会自动定位到自己的位置
    self.mapView.userTrackingMode = MAUserTrackingModeFollow;
    // 是否允许对annotationView根据zIndex进行排序
    self.mapView.allowsAnnotationViewSorting = YES;
    // 隐藏罗盘
    self.mapView.showsCompass = NO;
    // 隐藏比例尺
    self.mapView.showsScale = NO;
    [self.view addSubview:self.mapView];
    [self.view sendSubviewToBack:self.mapView];
    
    [self addtAnotationView];
}
// 添加标注
- (void) addtAnotationView {
    
    CustomAnnotation *anotation = [[CustomAnnotation alloc] init];
    anotation.type = CustomAnnotationTypeOne;
    anotation.imagePath = @"gou.jpg";
    anotation.coordinate = self.currentCoordinate;
    // 添加到地图上
    [self.mapView addAnnotation:anotation];
    
}

- (void)setCurrentCoordinate:(CLLocationCoordinate2D)currentCoordinate {
    _currentCoordinate = currentCoordinate;
}

#pragma mark ----- MAPViewDelegate

/**
 * @brief 在地图View将要启动定位时，会调用此函数
 * @param mapView 地图View
 */
- (void)mapViewWillStartLocatingUser:(MAMapView *)mapView {
    NSLog(@"定位开始");
}

/**
 * @brief 在地图View停止定位后，会调用此函数
 * @param mapView 地图View
 */
- (void)mapViewDidStopLocatingUser:(MAMapView *)mapView {
    NSLog(@"定位结束");
}

/**
 * @brief 定位失败后，会调用此函数
 * @param mapView 地图View
 * @param error 错误号，参考CLError.h中定义的错误号
 */
- (void)mapView:(MAMapView *)mapView didFailToLocateUserWithError:(NSError *)error {
    NSLog(@"定位失败 error == %@", error);
}

@end
