//
//  FirstViewController.m
//  gaodeTest
//
//  Created by 石冬冬 on 2017/2/22.
//  Copyright © 2017年 sdd. All rights reserved.
//

#import "FirstViewController.h"
#import "SecondViewController.h"
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


- (IBAction)jumpBtnCLick:(id)sender {
    
    [self.navigationController pushViewController:[ViewController new] animated:YES];
}
- (IBAction)jumpbtn2Click:(UIButton *)sender {
    
    
    [self.navigationController pushViewController:[SecondViewController new] animated:YES];
}

@end
