//
//  RouteMapHeaderView.m
//  gaodeTest
//
//  Created by 石冬冬 on 2017/3/1.
//  Copyright © 2017年 sdd. All rights reserved.
//

#import "RouteMapController.h"
#import "CustomAnnotation.h"
#import "CustomAnnotationView.h"
#import "CommonUtility.h"
#import "MANaviRoute.h"
#import "RoutePathDetailView.h"
#import <Masonry.h>
#import "YBPopupMenu.h"
#import "DropdownMenu.h"

static const NSInteger RoutePlanningPaddingEdge = 20;
static const NSString *RoutePlanningViewControllerStartTitle = @"起点";
static const NSString *RoutePlanningViewControllerDestinationTitle = @"终点";

@interface RouteMapController ()<MAMapViewDelegate,AMapSearchDelegate,YBPopupMenuDelegate,DropdownMenuDelegate,DropdownMenuDataSource>
@property (strong,nonatomic) MAMapView *mapView;
/// 搜索类
@property (nonatomic, strong) AMapSearchAPI *search;
/// 路径规划信息
@property (nonatomic, strong) AMapRoute *route;
/// 用于显示当前路线方案
@property (nonatomic, strong) MANaviRoute *naviRoute;

@property (nonatomic, strong) MAPointAnnotation *startAnnotation;
@property (nonatomic, strong) MAPointAnnotation *destinationAnnotaiton;

/// 总共规划的线路的条数
@property (nonatomic, assign) NSUInteger totalRouteNums;
/// 当前显示的索引值
@property (nonatomic, assign) NSUInteger currentRouteIndex;

@property (nonatomic, strong) RoutePathDetailView *routeDetailView;

@property (nonatomic, strong) UIButton *menuBtn;
@end
@implementation RouteMapController

static MANaviAnnotationType naviType;
#pragma mark ----- 懒加载

- (RoutePathDetailView *)routeDetailView {
    if (_routeDetailView == nil) {
        _routeDetailView = [RoutePathDetailView routePathDetialView];
        _routeDetailView.frame = CGRectMake(0, MainScreenH - 90, MainScreenW, MainScreenH);
       
        [self.view addSubview:_routeDetailView];
    }
    return _routeDetailView;
}
#pragma mark ----- 生命周期
- (void)viewDidLoad {
    naviType = MANaviAnnotationTypeDrive;
    [super viewDidLoad];
    [self initMenuButton];
    [self initMapView];
    [self resetSearchResultToDefault];
    [self addDefaultAnnotaitions];
    [self searchRoutePlaningDrive];
    [self initDropDownMenu];
    
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.mapView.showsUserLocation = NO;
    self.mapView.delegate = nil;
    
}
#pragma mark ----- 初始化
- (void) initDropDownMenu {
    
    DropdownMenu *menu = [[DropdownMenu alloc] initWithNavigationController:self.navigationController];
    menu.dataSource = self;
    menu.delegate = self;
    menu.menuTitle = @"订单详情";
    self.navigationItem.titleView = menu;
    
}
- (void) initMenuButton{
    self.menuBtn = [[UIButton alloc] init];
    [self.menuBtn setImage:[UIImage imageNamed:@"route_classify"] forState:UIControlStateNormal];
    self.menuBtn.backgroundColor = [UIColor whiteColor];
    [self.menuBtn addTarget:self action:@selector(menuBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.menuBtn];
    [self.menuBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.mas_right).offset(-20);
        make.height.width.mas_equalTo(40);
        make.bottom.equalTo(self.routeDetailView.mas_top).offset(-15);
    }];
    self.menuBtn.layer.cornerRadius = 20;
    self.menuBtn.layer.masksToBounds = YES;
}
/// 初始化地图和搜索api
- (void) initMapView {
    
    // 添加地图
    self.mapView = [[MAMapView alloc] initWithFrame:self.view.bounds];
    self.mapView.delegate = self;
    // 当前地图的中心点
//    self.mapView.centerCoordinate = self.startCoordinate;
    self.mapView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    // 是否显示用户位置
    self.mapView.showsUserLocation = YES;
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
    
    
    self.search = [[AMapSearchAPI alloc] init];
    self.search.delegate = self;
    
}

/// 初始化或者规划失败后，设置数据为默认值
- (void) resetSearchResultToDefault {
    [self.naviRoute removeFromMapView];
}

/// 添加起点和终点标注
- (void) addDefaultAnnotaitions {
    MAPointAnnotation *startAnnotation = [[MAPointAnnotation alloc] init];
    startAnnotation.coordinate = self.startCoordinate;
    startAnnotation.title = (NSString *)RoutePlanningViewControllerStartTitle;
    startAnnotation.subtitle = [NSString stringWithFormat:@"{%f, %f}", self.startCoordinate.latitude, self.startCoordinate.longitude];
    self.startAnnotation = startAnnotation;
    
    MAPointAnnotation *destinationAnnotation = [[MAPointAnnotation alloc] init];
    destinationAnnotation.coordinate = self.destinaCoordinate;
    destinationAnnotation.title = (NSString *)RoutePlanningViewControllerDestinationTitle;
    destinationAnnotation.subtitle = [NSString stringWithFormat:@"{%f, %f}", self.destinaCoordinate.latitude, self.destinaCoordinate.longitude];
    self.destinationAnnotaiton = destinationAnnotation;
    
    [self.mapView addAnnotation:startAnnotation];
    [self.mapView addAnnotation:destinationAnnotation];
}
#pragma mark ----- 路线规划
- (void) searchRoutePlaningDrive {
    switch (naviType) {
        case MANaviAnnotationTypeDrive:
            [self drivingRouteSearch];
            break;
        case MANaviAnnotationTypeBus:
            [self busRouteSearch];
            break;
        case MANaviAnnotationTypeRiding:
            [self rideRouteSearch];
            break;
        
            
        default:
            break;
    }
    

}
/// 驾车路线
- (void) drivingRouteSearch {
    AMapDrivingRouteSearchRequest *drivingRoute = [[AMapDrivingRouteSearchRequest alloc] init];
    // 是否返回扩展信息
    drivingRoute.requireExtension = YES;
    // 驾车策略
    drivingRoute.strategy = 5;
    // 设置数据
    drivingRoute.origin = [AMapGeoPoint locationWithLatitude:self.startCoordinate.latitude longitude:self.startCoordinate.longitude];
    drivingRoute.destination = [AMapGeoPoint locationWithLatitude:self.destinaCoordinate.latitude longitude:self.destinaCoordinate.longitude];
    [self.search AMapDrivingRouteSearch:drivingRoute];
}
/// 公交路线
- (void) busRouteSearch {
    AMapTransitRouteSearchRequest *transitRoute = [[AMapTransitRouteSearchRequest alloc] init];
    transitRoute.requireExtension = YES;
    // 必填
    transitRoute.city = @"shanghai";
    // 设置数据
    transitRoute.origin = [AMapGeoPoint locationWithLatitude:self.startCoordinate.latitude longitude:self.startCoordinate.longitude];
    transitRoute.destination = [AMapGeoPoint locationWithLatitude:self.destinaCoordinate.latitude longitude:self.destinaCoordinate.longitude];
    [self.search AMapTransitRouteSearch:transitRoute];

}
/// 骑行
- (void) rideRouteSearch {
    AMapRidingRouteSearchRequest *rideRoute = [[AMapRidingRouteSearchRequest alloc] init];
    // 设置数据
    rideRoute.origin = [AMapGeoPoint locationWithLatitude:self.startCoordinate.latitude longitude:self.startCoordinate.longitude];
    rideRoute.destination = [AMapGeoPoint locationWithLatitude:self.destinaCoordinate.latitude longitude:self.destinaCoordinate.longitude];
    [self.search AMapRidingRouteSearch:rideRoute];
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

#pragma mark ----- AMapSearchDelegate 
// 地图上覆盖物的渲染 可以设置路径线路的宽度、颜色
- (MAOverlayRenderer *)mapView:(MAMapView *)mapView rendererForOverlay:(id<MAOverlay>)overlay {
    // 虚线 如需要步行的
    if ([overlay isKindOfClass:[LineDashPolyline class]]) {
        
        MAPolylineRenderer *polylineRenderer = [[MAPolylineRenderer alloc] initWithPolyline:((LineDashPolyline *)overlay).polyline];
        polylineRenderer.lineWidth = 0;
        polylineRenderer.lineDash = YES;
        polylineRenderer.strokeColor = [UIColor redColor];
        return polylineRenderer;
    }
    
    // showTraffic 为NO，不需要带实时路况，路径为单一颜色
    if ([overlay isKindOfClass:[MANaviPolyline class]]) {
        MANaviPolyline *naviPolyLine = (MANaviPolyline *)overlay;
        MAPolylineRenderer *polyLineRender = [[MAPolylineRenderer alloc] initWithPolyline:naviPolyLine.polyline];
        polyLineRender.lineWidth = 6;
        if (naviPolyLine.type == MANaviAnnotationTypeWalking) {
            polyLineRender.strokeColor = self.naviRoute.walkingColor;
        } else if (naviPolyLine.type == MANaviAnnotationTypeRailway) {
            polyLineRender.strokeColor = self.naviRoute.railwayColor;
        } else {
            polyLineRender.strokeColor = self.naviRoute.routeColor;
        }
        return polyLineRender;
    }
    
    // 需要带实时路况，路径为多颜色渐变
    if ([overlay isKindOfClass:[MAMultiPolyline class]]) {
        MAMultiColoredPolylineRenderer *polyLineRender = [[MAMultiColoredPolylineRenderer alloc] initWithMultiPolyline:overlay];
        polyLineRender.lineWidth = 6;
        
        polyLineRender.strokeColors = [self.naviRoute.multiPolylineColors copy];
        
        return polyLineRender;
    }
    
    return nil;
}



//地图上的起始点，终点，拐点的标注，可以自定义图标展示等,只要有标注点需要显示，该回调就会被调用
- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation {
    if ([annotation isKindOfClass:[MAPointAnnotation class]]) {
        
        //标注的view的初始化和复用
        static NSString *routePlanningCellIdentifier = @"RoutePlanningCellIdentifier";
        
        MAAnnotationView *poiAnnotationView = (MAAnnotationView*)[self.mapView dequeueReusableAnnotationViewWithIdentifier:routePlanningCellIdentifier];
        
        if (poiAnnotationView == nil) {
            poiAnnotationView = [[MAAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:routePlanningCellIdentifier];
        }
        
        poiAnnotationView.canShowCallout = YES;
        poiAnnotationView.image = nil;
        
        //拐点的图标标注
        if ([annotation isKindOfClass:[MANaviAnnotation class]]) {
            switch (((MANaviAnnotation*)annotation).type) {
                case MANaviAnnotationTypeRiding:
                    poiAnnotationView.image = [UIImage imageNamed:@"ride"];
                    break;
                    
                case MANaviAnnotationTypeBus:
                    poiAnnotationView.image = [UIImage imageNamed:@"bus"];
                    break;
                    
                case MANaviAnnotationTypeDrive:
                    poiAnnotationView.image = [UIImage imageNamed:@"car"];
                    break;
                    
                case MANaviAnnotationTypeWalking:
                    poiAnnotationView.image = [UIImage imageNamed:@"man"];
                    break;
                    
                default:
                    break;
            }
        }else{
            //起点，终点的图标标注
            if ([[annotation title] isEqualToString:(NSString*)RoutePlanningViewControllerStartTitle]) {
                poiAnnotationView.image = [UIImage imageNamed:@"startPoint"];  //起点
            }else if([[annotation title] isEqualToString:(NSString*)RoutePlanningViewControllerDestinationTitle]){
                poiAnnotationView.image = [UIImage imageNamed:@"endPoint"];  //终点
            }
            
        }
        
        return poiAnnotationView;
    }
    
    return nil;
}

// 路径规划搜索请求发生错误
- (void)AMapSearchRequest:(id)request didFailWithError:(NSError *)error {
    NSLog(@"%@",error);
    [self resetSearchResultToDefault];
}
// 路径规划完成回调
- (void)onRouteSearchDone:(AMapRouteSearchBaseRequest *)request response:(AMapRouteSearchResponse *)response {
    if (response.route == nil) {
        [self resetSearchResultToDefault];
    }
    self.route = response.route;
    if (naviType == MANaviAnnotationTypeBus) {
        self.totalRouteNums = self.route.transits.count;
    } else {
         self.totalRouteNums = self.route.paths.count;
    }
   
    self.currentRouteIndex = 0;
    [self presentCurrentRouteCourse];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
         [self presentRouteDetailInfo];
    });
   
}

// 在地图上显示当前选择的路径
- (void)presentCurrentRouteCourse {
    if (self.totalRouteNums <= 0) {
        return;
    }
    // 先清空地图上已有的路线
    [self.naviRoute removeFromMapView];
    
    AMapGeoPoint *startPoint = [AMapGeoPoint locationWithLatitude:self.startAnnotation.coordinate.latitude longitude:self.startAnnotation.coordinate.longitude]; //起点
    
    AMapGeoPoint *endPoint = [AMapGeoPoint locationWithLatitude:self.destinationAnnotaiton.coordinate.latitude longitude:self.destinationAnnotaiton.coordinate.longitude];  //终点
    
    // 根据已经规划的路径，生成显示方案
    if (naviType == MANaviAnnotationTypeBus) {
        self.naviRoute = [MANaviRoute naviRouteForTransit:self.route.transits[self.currentRouteIndex] startPoint:startPoint endPoint:endPoint];
    } else {
        self.naviRoute = [MANaviRoute naviRouteForPath:self.route.paths[self.currentRouteIndex] withNaviType:naviType showTraffic:YES startPoint:startPoint endPoint:endPoint];
    }
    
    
    // 显示到地图上
    [self.naviRoute addToMapView:self.mapView];
    
    UIEdgeInsets edgePaddingRect = UIEdgeInsetsMake(RoutePlanningPaddingEdge, RoutePlanningPaddingEdge, RoutePlanningPaddingEdge, RoutePlanningPaddingEdge);
    
    //缩放地图使其适应polylines的展示
    [self.mapView setVisibleMapRect:[CommonUtility mapRectForOverlays:self.naviRoute.routePolylines]
                        edgePadding:edgePaddingRect
                           animated:NO];
    
}
#pragma mark ----- YBPopMenuDelgate
- (void)ybPopupMenuDidSelectedAtIndex:(NSInteger)index ybPopupMenu:(YBPopupMenu *)ybPopupMenu
{
    switch (index) {
        case 0:
            naviType = MANaviAnnotationTypeDrive;
            break;
        case 1:
            naviType = MANaviAnnotationTypeBus;
            break;
        case 2:
            naviType = MANaviAnnotationTypeRiding;
            break;
        default:
            break;
    }
    [self searchRoutePlaningDrive];
}

#pragma mark ----- dropDownMenuDatasource 
- (NSArray<NSString *> *)titleArrayForNavigationDropdownMenu:(DropdownMenu *)navigationDropdownMenu {
    return @[@"Hello", @"World",@"Hello", @"World",@"Hello", @"World",@"Hello", @"World"];
}



#pragma mark ----- action
// 显示路径规划详情
- (void) presentRouteDetailInfo {
    
    self.routeDetailView.route = self.route;
    if (naviType == MANaviAnnotationTypeBus) {
        if (self.route.transits.count > 0) {
            self.routeDetailView.transit = self.route.transits[self.currentRouteIndex];

        }
        
    } else {
        if (self.route.paths.count > 0) {
            self.routeDetailView.path = self.route.paths[self.currentRouteIndex];
        }
        

    }
    
   
}
- (void) menuBtnClick:(UIButton *) sender {
    NSArray *titles = @[@"驾车",@"公交",@"骑行"];
    [YBPopupMenu showRelyOnView:sender titles:titles icons:nil menuWidth:80 delegate:self];
}


@end
