//
//  FirstViewController.m
//  gaodeTest
//
//  Created by 石冬冬 on 2017/2/22.
//  Copyright © 2017年 sdd. All rights reserved.
//

#import "FirstViewController.h"
#import "ViewController.h"
@interface FirstViewController ()<CLLocationManagerDelegate>
@property (nonatomic, strong) CLLocationManager *locationManager;
@end

@implementation FirstViewController
-(CLLocationManager *)locationManager {
    
    if (_locationManager == nil) {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
        // 设置定位精度
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        // 距离过滤器 减少对定位装置的轮询次数 这里是移动100米才去通知代理更新位置
        _locationManager.distanceFilter = 10.0f;
        
    }
    return _locationManager;
}
- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark ----- CLLocationManagerDelegate
// 设置开启定位功能
- (void) setupLocationFunction {
    
    [self.locationManager requestAlwaysAuthorization];//这句话ios8以上版本使用。
    // 更新地理位置 触发代理事件 获取位置信息
    [self.locationManager startUpdatingLocation];
}

// 地理位置发生改变时触发
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    
    CLLocationDegrees latitude= newLocation.coordinate.latitude;
    CLLocationDegrees longitide = newLocation.coordinate.longitude;
    NSLog(@"changeLocation");
    // 停止位置更新
    [manager stopUpdatingLocation];
    
    
}
- (IBAction)jumpBtnCLick:(id)sender {
    
    [self.navigationController pushViewController:[ViewController new] animated:YES];
}

@end
