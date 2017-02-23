//
//  ViewController.m
//  gaodeTest
//
//  Created by 石冬冬 on 2017/2/22.
//  Copyright © 2017年 sdd. All rights reserved.
//

#import "ViewController.h"
#import "CustomAnnotation.h"
#import "CustomAnnotationView.h"
#import "TeamInfoContentView.h"
@interface ViewController ()<MAMapViewDelegate,CLLocationManagerDelegate>
/**标注数组*/
@property (nonatomic, strong) NSArray *anns;
/// 地图控件
@property (nonatomic, strong) MAMapView *mapView;
/// 定位按钮
@property (nonatomic, strong) UIButton *gpsButton;
/// 固定的标注
@property (nonatomic, strong) MAPointAnnotation *moveAnnotation;
/// 选中的标注
@property (nonatomic, strong) CustomAnnotationView *selectedCustomAnnView;
/// 取消了选中的标注
@property (nonatomic, strong) CustomAnnotationView *deslectedCustomAnnView;
/// 团队详情视图
@property (nonatomic, strong) TeamInfoContentView *teamInfoView;
@end

@implementation ViewController
- (TeamInfoContentView *)teamInfoView {
    if (_teamInfoView == nil) {
        _teamInfoView = [[TeamInfoContentView alloc] init];
        _teamInfoView.frame = CGRectMake(0, 64, MainScreenW, 190);
        
    }
    return _teamInfoView;
}
- (UIButton *)gpsButton {
    if (_gpsButton == nil) {
        
        _gpsButton = [[UIButton alloc] initWithFrame:CGRectMake(20, MainScreenH - 60, 40, 40)];
        _gpsButton.backgroundColor = [UIColor whiteColor];
        _gpsButton.layer.cornerRadius = 4;
        
        [_gpsButton setImage:[UIImage imageNamed:@"gpsStat1"] forState:UIControlStateNormal];
        [_gpsButton addTarget:self action:@selector(gpsAction) forControlEvents:UIControlEventTouchUpInside];
       

    }
    return _gpsButton;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initMapView];
    [self setupModels];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.mapView showAnnotations:self.anns animated:YES];
}


/// 初始化地图
- (void) initMapView {
    
    // 添加地图
    self.mapView = [[MAMapView alloc] initWithFrame:CGRectMake(0, 60, MainScreenW, MainScreenH - 60)];
    self.mapView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.mapView.delegate = self;
    // 当前地图的中心点
    self.mapView.centerCoordinate = CLLocationCoordinate2DMake(self.mapView.userLocation.location.coordinate.latitude, self.mapView.userLocation.location.coordinate.longitude);
    // 是否显示用户位置
    self.mapView.showsUserLocation = YES;
    // 设置初始缩放等级
    [self.mapView setZoomLevel:15 animated:YES];
    // 设置trackingMode 则会自动定位到自己的位置
    self.mapView.userTrackingMode = MAUserTrackingModeFollow;
    // 隐藏罗盘
    self.mapView.showsCompass = NO;
    // 隐藏比例尺
    self.mapView.showsScale = NO;
    [self.view addSubview:self.mapView];
    [self.view sendSubviewToBack:self.mapView];
    
    // 添加定位按钮
    [self.view addSubview:self.gpsButton];
    
    // 添加缩放按钮
    [self.view addSubview:[self makeZoomPannelView]];
    
    // 添加固定标注
    [self addtMoveAnotationView];
    
    [self.view addSubview:self.teamInfoView];

}

// 设置model
- (NSArray *) setupModels {
    
    CustomAnnotation *one = [[CustomAnnotation alloc] init];
    one.type = CustomAnnotationTypeOne;
    one.imagePath = @"me.jpg";
    one.coordinate = CLLocationCoordinate2DMake(31.347556, 121.373799);
    
    CustomAnnotation *two = [[CustomAnnotation alloc] init];
    two.type = CustomAnnotationTypeTwo;
    two.imagePath = @"gou.jpg";
    two.coordinate = CLLocationCoordinate2DMake(31.351470, 121.369161);
    
    CustomAnnotation *three = [[CustomAnnotation alloc] init];
    three.type = CustomAnnotationTypeThree;
    three.imagePath = @"smile.jpg";
    three.coordinate = CLLocationCoordinate2DMake(31.340159, 121.371575);
    
    CustomAnnotation *four = [[CustomAnnotation alloc] init];
    four.type = CustomAnnotationTypeFour;
    four.imagePath = @"tu.jpg";
    four.coordinate = CLLocationCoordinate2DMake(31.336025, 121.371035);
    
    CustomAnnotation *five = [[CustomAnnotation alloc] init];
    five.type = CustomAnnotationTypeOne;
    five.imagePath = @"smile.jpg";
    five.coordinate = CLLocationCoordinate2DMake(31.342346, 121.376681);
    
    [self.mapView addAnnotations:@[one,two,three,four,five]];
    return @[one,two,three,four,five];
    
}

// 添加一个固定在屏幕的标注
- (void) addtMoveAnotationView {
 
    // 创建annotation
    MAPointAnnotation *anotation = [[MAPointAnnotation alloc] init];
    self.moveAnnotation = anotation;
    anotation.coordinate = self.mapView.centerCoordinate;
    anotation.lockedToScreen = YES;
    anotation.lockedScreenPoint = self.mapView.center;
    // 添加到地图上
    [self.mapView addAnnotation:anotation];
    
}
- (UIView *)makeZoomPannelView
{
    UIView *ret = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 53, 98)];
    ret.center = CGPointMake(self.view.bounds.size.width -  CGRectGetMidX(ret.bounds) - 10,
                                        self.view.bounds.size.height -  CGRectGetMidY(ret.bounds) - 10);
    UIButton *incBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 53, 49)];
    [incBtn setImage:[UIImage imageNamed:@"increase"] forState:UIControlStateNormal];
    [incBtn sizeToFit];
    [incBtn addTarget:self action:@selector(zoomPlusAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *decBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 49, 53, 49)];
    [decBtn setImage:[UIImage imageNamed:@"decrease"] forState:UIControlStateNormal];
    [decBtn sizeToFit];
    [decBtn addTarget:self action:@selector(zoomMinusAction) forControlEvents:UIControlEventTouchUpInside];
    
    
    [ret addSubview:incBtn];
    [ret addSubview:decBtn];
    
    return ret;
}
#pragma mark ----- 事件

/// 定位
- (void) gpsAction {
    
    if (self.mapView.userLocation.updating && self.mapView.userLocation.location) {
        NSLog(@"located");
        [self.mapView setCenterCoordinate:self.mapView.userLocation.location.coordinate animated:YES];
        [self.mapView setZoomLevel:15 animated:YES];
       
    }
}

/// 放大
- (void) zoomPlusAction {
    
    CGFloat oldZoom = self.mapView.zoomLevel;
    // 设置缩放级别
    [self.mapView setZoomLevel:(oldZoom + 1) animated:YES];
   
    
}

/// 缩小
- (void) zoomMinusAction {
    CGFloat oldZoom = self.mapView.zoomLevel;
    // 设置缩放级别
    [self.mapView setZoomLevel:(oldZoom - 1) animated:YES];

}
#pragma mark ----- MAmapViewDelegate 
/**
 * @brief 地图将要发生移动时调用此接口
 * @param mapView       地图view
 * @param wasUserAction 标识是否是用户动作
 */
- (void)mapView:(MAMapView *)mapView mapWillMoveByUser:(BOOL)wasUserAction {
    if (wasUserAction) {
        // 隐藏详情view
        [self.teamInfoView hidDetailViewAnimation];
        
        // 取消之前选中的标注
        [self.selectedCustomAnnView stopAnimation];
    }
}
/**
 * @brief 地图移动结束后调用此接口
 * @param mapView       地图view
 * @param wasUserAction 标识是否是用户动作
 */
- (void)mapView:(MAMapView *)mapView mapDidMoveByUser:(BOOL)wasUserAction {
    if (wasUserAction) {
        
        NSLog(@"move end latitude == %f , longitude == %f",self.moveAnnotation.coordinate.latitude,self.moveAnnotation.coordinate.longitude);
    }
}
/**
 * @brief 地图将要发生缩放时调用此接口
 * @param mapView       地图view
 * @param wasUserAction 标识是否是用户动作
 */
- (void)mapView:(MAMapView *)mapView mapWillZoomByUser:(BOOL)wasUserAction {
    if (wasUserAction) {
        [self.teamInfoView hidDetailViewAnimation];
    }
}

/**
 * @brief 根据anntation生成对应的View
 * @param mapView 地图View
 * @param annotation 指定的标注
 * @return 生成的标注View
 */
- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation {
    

    if ([annotation isKindOfClass:[CustomAnnotation class]]) {
        CustomAnnotation *cusAnnotation = (CustomAnnotation *)annotation;
        
        static NSString *cusAnnotationID = @"CustomAnnotation";
        CustomAnnotationView *cusAnnotationView = (CustomAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:cusAnnotationID];
        if (!cusAnnotationView) {
            cusAnnotationView = [[CustomAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:cusAnnotationID];
        }
        
        //很重要的，配置关联的模型数据
        cusAnnotationView.annotation = cusAnnotation;
        
        [self.mapView selectAnnotation:self.anns[0] animated:YES];
        
        return cusAnnotationView;
    } else if ([annotation isKindOfClass:[MAPointAnnotation class]]) {
        static NSString *userLocationID = @"lockLocation";
        MAAnnotationView *lockedAnnotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:userLocationID];
        if (!lockedAnnotationView) {
            lockedAnnotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:userLocationID];
        }
        lockedAnnotationView.image = [UIImage imageNamed:@""];
        return lockedAnnotationView;
    }


    return nil;
}

/**
 * @brief 当mapView新添加annotation views时，调用此接口
 * @param mapView 地图View
 * @param views 新添加的annotation views
 */
- (void)mapView:(MAMapView *)mapView didAddAnnotationViews:(NSArray *)views {
    
}

/**
 * @brief 当选中一个annotation views时，调用此接口
 * @param mapView 地图View
 * @param view 选中的annotation views
 */
- (void)mapView:(MAMapView *)mapView didSelectAnnotationView:(MAAnnotationView *)view {
    if ([view isKindOfClass:[CustomAnnotationView class]]) {
        CustomAnnotationView *annotationView = (CustomAnnotationView *) view;
        
        if ([annotationView.annotation isKindOfClass:[CustomAnnotation class]]) {
            
            CustomAnnotation *ann = (CustomAnnotation *) annotationView.annotation;
            
            self.selectedCustomAnnView = annotationView;
            // 标注动画
            [annotationView startAnimation];
            // 详情动画
            [self.teamInfoView popupDetailViewAnimation];
            // 重新设置中心点
            [self.mapView setCenterCoordinate:ann.coordinate animated:YES];
            
            NSLog(@"点击了 %@",ann.imagePath);
        }
        
    }
}

/**
 * @brief 当取消选中一个annotation views时，调用此接口
 * @param mapView 地图View
 * @param view 取消选中的annotation views
 */
- (void)mapView:(MAMapView *)mapView didDeselectAnnotationView:(MAAnnotationView *)view {
    if ([view isKindOfClass:[CustomAnnotationView class]]) {
        CustomAnnotationView *annotationView = (CustomAnnotationView *) view;
        [annotationView stopAnimation];
        if ([annotationView.annotation isKindOfClass:[CustomAnnotation class]]) {
            
            CustomAnnotation *ann = (CustomAnnotation *) annotationView.annotation;
            
            NSLog(@"取消点击了 %@",ann.imagePath);
        }
        
   
    }}


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

/**
 * @brief 单击地图回调，返回经纬度
 * @param mapView 地图View
 * @param coordinate 经纬度
 */
- (void)mapView:(MAMapView *)mapView didSingleTappedAtCoordinate:(CLLocationCoordinate2D)coordinate {
    [self.teamInfoView hidDetailViewAnimation];
}

#pragma mark ----- 工具方法
- (CGSize)offsetToContainRect:(CGRect)innerRect inRect:(CGRect)outerRect
{
    CGFloat nudgeRight = fmaxf(0, CGRectGetMinX(outerRect) - (CGRectGetMinX(innerRect)));
    CGFloat nudgeLeft = fminf(0, CGRectGetMaxX(outerRect) - (CGRectGetMaxX(innerRect)));
    CGFloat nudgeTop = fmaxf(0, CGRectGetMinY(outerRect) - (CGRectGetMinY(innerRect)));
    CGFloat nudgeBottom = fminf(0, CGRectGetMaxY(outerRect) - (CGRectGetMaxY(innerRect)));
    return CGSizeMake(nudgeLeft ?: nudgeRight, nudgeTop ?: nudgeBottom);
}
@end
