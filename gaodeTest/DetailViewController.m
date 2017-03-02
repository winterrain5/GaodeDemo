//
//  DetailViewController.m
//  gaodeTest
//
//  Created by 石冬冬 on 2017/3/1.
//  Copyright © 2017年 sdd. All rights reserved.
//

#import "DetailViewController.h"
#import "RouteMapHeaderView.h"
#import "UIScrollView+VGParallaxHeader.h"
@interface DetailViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak,nonatomic) UITableView *tableView;
@property (nonatomic, weak) RouteMapHeaderView *headerView;


@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    
    NSLog(@"%f,%f",self.customAnn.coordinate.latitude,self.customAnn.coordinate.longitude);
    
    [self initTableView];
}

#pragma mark ----- 初始化
- (void) initTableView {
    UITableView *tableView = [[UITableView alloc] init];
    self.tableView = tableView;
    tableView.frame = CGRectMake(0, 0, MainScreenW, MainScreenH);
    [self.view addSubview:tableView];
    tableView.dataSource = self;
    tableView.delegate = self;
    
    
    RouteMapHeaderView *headerViewVc = [[RouteMapHeaderView alloc] init];
    self.headerView = headerViewVc;
    headerViewVc.currentCoordinate = self.customAnn.coordinate;
    [tableView setParallaxHeaderView:headerViewVc.view mode:VGParallaxHeaderModeFill height:0.4 * MainScreenH];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.tableView shouldPositionParallaxHeader];
}
#pragma mark ----- UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 100;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *rid = @"cellId";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:rid];
    if(cell==nil){
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault      reuseIdentifier:rid];
    }
    return cell;
}

@end
