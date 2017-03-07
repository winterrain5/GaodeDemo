//
//  RoutePathDetailViewController.m
//  Drive-Route-Demo
//
//  Created by eidan on 16/11/28.
//  Copyright © 2016年 autonavi. All rights reserved.
//

#import "RoutePathDetailView.h"
#import "RoutePathDetailTableViewCell.h"
#import <POP.h>
#import "D3View.h"
static const NSString *RoutePathDetailStepInfoImageName = @"RoutePathDetailStepInfoImageName";
static const NSString *RoutePathDetailStepInfoText = @"RoutePathDetailStepInfoText";
@interface RoutePathDetailView ()<UITableViewDelegate,UITableViewDataSource>

//data
@property (strong, nonatomic) NSMutableArray *routeDetailDataArray;  //路径步骤数组
@property (copy, nonatomic) NSDictionary *drivingImageDic;  //根据AMapStep.action获得对应的图片名字


@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *headerView;
@property (weak, nonatomic) IBOutlet UILabel *timeInfoLabel;
@property (weak, nonatomic) IBOutlet UILabel *taxiCostInfoLabel;
@property (weak, nonatomic) IBOutlet UIImageView *upArrowImageView;

@property (nonatomic, weak) RoutePathDetailTableViewCell *cell;


@end

@implementation RoutePathDetailView

+ (instancetype) routePathDetialView{
    return [[[NSBundle mainBundle] loadNibNamed:@"RoutePathDetailView" owner:nil
                                       options:nil] lastObject];
}
- (void)awakeFromNib {
    [super awakeFromNib];
    self.drivingImageDic = @{
                             @"开始":@"start",
                             @"结束":@"end",
                             @"右转":@"right",
                             @"左转":@"left",
                             @"直行":@"straight",
                             @"向右前方行驶":@"rightFront",
                             @"向左前方行驶":@"leftFront",
                             @"向左后方行驶":@"leftRear",
                             @"向右后方行驶":@"rightRear",
                             @"左转调头":@"leftRear",
                             @"靠左":@"leftFront",
                             @"靠右":@"rightFront",
                             @"进入环岛":@"straight",
                             @"离开环岛":@"straight",
                             @"减速行驶":@"dottedStraight",
                             @"插入直行":@"straight",
                             @"":@"straight",
                             };
    
    [self setUpViews];

}
- (void)setPath:(AMapPath *)path {
    _path = path;
    NSInteger hours = path.duration / 3600;
    NSInteger minutes = (NSInteger)(path.duration / 60) % 60;
    self.timeInfoLabel.text = [NSString stringWithFormat:@"%u小时%u分钟（%u公里）",(unsigned)hours,(unsigned)minutes,(unsigned)path.distance / 1000];
    
    
    self.routeDetailDataArray = @[].mutableCopy;
    
   [self.routeDetailDataArray addObject:@{RoutePathDetailStepInfoImageName : @"start",RoutePathDetailStepInfoText : @"开始出发"}]; // 图片的名字，具体步骤的文字信息
    
    for (AMapStep *step in path.steps) {
        [self.routeDetailDataArray addObject:@{RoutePathDetailStepInfoImageName : [self.drivingImageDic objectForKey:step.action],RoutePathDetailStepInfoText : step.instruction}]; // 图片的名字，具体步骤的文字信息
    }
   
    
    [self.routeDetailDataArray addObject:@{RoutePathDetailStepInfoImageName : @"end",RoutePathDetailStepInfoText : @"抵达终点"}];
    
    [self.tableView reloadData];
}

- (void)setTransit:(AMapTransit *)transit {
    _transit = transit;
    NSInteger hours = transit.duration / 3600;
    NSInteger minutes = (NSInteger)(transit.duration / 60) % 60;
    self.timeInfoLabel.text = [NSString stringWithFormat:@"%u小时%u分钟（%u公里）",(unsigned)hours,(unsigned)minutes,(unsigned)transit.distance / 1000];
    
    self.routeDetailDataArray = @[].mutableCopy;

    [self.routeDetailDataArray addObject:@{RoutePathDetailStepInfoImageName : @"start",RoutePathDetailStepInfoText : @"开始出发"}]; // 图片的名字，具体步骤的文字信息
    
    for (AMapSegment *segment in self.transit.segments) {
        AMapRailway *railway = segment.railway; //火车
        AMapBusLine *busline = [segment.buslines firstObject];  // 地铁或者公交线路
        AMapWalking *walking = segment.walking;  //搭乘地铁或者公交前的步行信息
        
        if (walking.distance) {
            NSString *walkInfo = [NSString stringWithFormat:@"步行%u米",(unsigned)walking.distance];
            [self.routeDetailDataArray addObject:@{RoutePathDetailStepInfoImageName : @"walkRoute",RoutePathDetailStepInfoText : walkInfo}];
        }
        
        if (busline.name) {
            NSString *busImageName = @"busRoute";
            if ([busline.type isEqualToString:@"地铁线路"]) { //区分公交和地铁
                busImageName = @"underGround";
            }
            
            //viaBusStops途径的公交车站的数组，如需具体站名，可解析。
            NSString *busInfoText = [NSString stringWithFormat:@"乘坐%@，在 %@ 上车，途经 %u 站，在 %@ 下车",busline.name,busline.departureStop.name,(unsigned)(busline.viaBusStops.count + 1),busline.arrivalStop.name];
            [self.routeDetailDataArray addObject:@{RoutePathDetailStepInfoImageName : busImageName,RoutePathDetailStepInfoText : busInfoText}];
            
        } else if (railway.uid) {
            [self.routeDetailDataArray addObject:@{RoutePathDetailStepInfoImageName : @"railwayRoute",RoutePathDetailStepInfoText : railway.name}];
        }
    }
    
    [self.routeDetailDataArray addObject:@{RoutePathDetailStepInfoImageName : @"end",RoutePathDetailStepInfoText : @"抵达终点"}];
    [self.tableView reloadData];
}
- (void)setRoute:(AMapRoute *)route {
    _route = route;
    self.taxiCostInfoLabel.text = [NSString stringWithFormat:@"打车约%.0f元",route.taxiCost];

}
- (void)setUpViews {
    
    [self.tableView registerNib:[UINib nibWithNibName:@"RoutePathDetailTableViewCell" bundle:nil] forCellReuseIdentifier:RoutePathDetailTableViewCellIdentifier];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (self.origin.y == 64) {
        [self d3_setY:MainScreenH - 90 duration:0.25 completion:nil];
        self.upArrowImageView.image = [UIImage imageNamed:@"detail_arrow_up"];
    } else {
        [self d3_setY:64 duration:0.25 completion:nil];
        self.upArrowImageView.image = [UIImage imageNamed:@"detail_arrow_down"];
    }
    
    
}


#pragma -mark UITableView Delegate and DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.routeDetailDataArray.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    RoutePathDetailTableViewCell *cell = (RoutePathDetailTableViewCell *)[tableView dequeueReusableCellWithIdentifier:RoutePathDetailTableViewCellIdentifier forIndexPath:indexPath];
    self.cell = cell;
    
    NSDictionary *stepInfo = [self.routeDetailDataArray objectAtIndex:indexPath.row];
    cell.infoLabel.text = stepInfo[RoutePathDetailStepInfoText];
    cell.actionImageView.image = [UIImage imageNamed:stepInfo[RoutePathDetailStepInfoImageName]];

    
    cell.topVerticalLine.hidden = indexPath.row == 0;
    cell.bottomVerticalLine.hidden = indexPath.row == self.routeDetailDataArray.count - 1;
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
   
    CGSize cellSize = [self sizeWithText:self.cell.infoLabel.text font:[UIFont systemFontOfSize:14] andMaxSize:CGSizeMake(MainScreenW - 60, 38)];
    return cellSize.height + 38;
}
#pragma -mark 内部方法
- (CGSize)sizeWithText:(NSString *)text font:(UIFont *)font andMaxSize:(CGSize)size;
{
    NSDictionary *attrs = @{NSFontAttributeName : font};
    return [text boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}



@end
