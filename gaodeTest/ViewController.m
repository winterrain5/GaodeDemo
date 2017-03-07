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
#import "POIAnnotation.h"
#import "TipAnnotation.h"
#import "RWDropdownMenu.h"
@interface ViewController ()<MAMapViewDelegate,CLLocationManagerDelegate,TeamInfoContentViewDelegate,AMapSearchDelegate,UISearchResultsUpdating,UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate,RWDropdownMenuDelegate>
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

/// 搜索类
@property (nonatomic, strong) AMapSearchAPI *search;
/// 当前关键字搜索
@property (nonatomic, strong) AMapPOIKeywordsSearchRequest *currentRequest;
///
@property (nonatomic, strong) UISearchController *searchController;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *tips;
/// 菜单视图
@property (nonatomic, strong) NSArray *menuItems;
@property (nonatomic, assign) RWDropdownMenuStyle menuStyle;
@end

@implementation ViewController
#pragma mark ----- 懒加载
- (NSArray *)menuItems
{
    if (!_menuItems)
    {
        _menuItems =
        @[
          [RWDropdownMenuItem itemWithText:@"Twitter" image:[UIImage imageNamed:@"AddToFavouritesIcn"] action:nil],
          [RWDropdownMenuItem itemWithText:@"Facebook" image:[UIImage imageNamed:@"AddToFriendsIcn"] action:nil],
          [RWDropdownMenuItem itemWithText:@"Message" image:[UIImage imageNamed:@"LikeIcn"] action:nil],
          [RWDropdownMenuItem itemWithText:@"Email" image:[UIImage imageNamed:@"SendMessageIcn"] action:nil]
          ];
        
    }
    return _menuItems;
}

- (NSMutableArray *)tips {
    if (_tips == nil) {
        _tips = [NSMutableArray array];
    }
    return _tips;
}
- (NSArray *)anns {
    if (_anns == nil) {
        _anns = [NSMutableArray array];
    }
    return _anns;
}
- (TeamInfoContentView *)teamInfoView {
    if (_teamInfoView == nil) {
        _teamInfoView = [[TeamInfoContentView alloc] init];
        _teamInfoView.frame = CGRectMake(0, 64, MainScreenW, 190);
        _teamInfoView.delegate = self;
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

#pragma mark ----- 生命周期
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initMapView];
    
    [self initOtherViews];
    
    [self setupModels];
    
    [self initSearch];
    
    [self initTableView];
    
    [self initSearchController];
    
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    self.searchController.active = NO;
}
#pragma mark ----- 初始化方法

- (void)initTableView
{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 64) style:UITableViewStylePlain];
    self.tableView.tag = 1;
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.hidden = YES;
    
    [self.view addSubview:self.tableView];
}

- (void)initSearchController
{
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    
    self.searchController.searchResultsUpdater = self;
    self.searchController.dimsBackgroundDuringPresentation = NO;
    self.searchController.hidesNavigationBarDuringPresentation = NO;
    
    self.searchController.searchBar.delegate = self;
    self.searchController.searchBar.placeholder = @"请输入关键字";
    [self.searchController.searchBar sizeToFit];
    [self.searchController.searchBar setValue:@"取消" forKey:@"_cancelButtonText"];
    
    self.navigationItem.titleView = self.searchController.searchBar;
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
    // 是否允许对annotationView根据zIndex进行排序
    self.mapView.allowsAnnotationViewSorting = YES;
    // 隐藏罗盘
    self.mapView.showsCompass = NO;
    // 隐藏比例尺
    self.mapView.showsScale = NO;
    [self.view addSubview:self.mapView];
    [self.view sendSubviewToBack:self.mapView];

}

// 添加地图上的其他组件
- (void) initOtherViews {
    // 添加定位按钮
    [self.view addSubview:self.gpsButton];
    
    // 添加缩放按钮
    [self.view addSubview:[self makeZoomPannelView]];
    
    // 添加固定标注
    [self addtMoveAnotationView];
    
    self.teamInfoView.userInteractionEnabled = NO;
    [self.view addSubview:self.teamInfoView];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"classify"] style:UIBarButtonItemStylePlain target:self action:@selector(classifyBtnClick:)];
}

/// 初始化搜索
- (void) initSearch {
    
    self.search = [[AMapSearchAPI alloc] init];
    self.search.delegate = self;
    
}
// 初始化假数据
- (NSArray *) setupModels {
    
    CustomAnnotation *one = [[CustomAnnotation alloc] init];
    one.type = CustomAnnotationTypeOne;
    one.imagePath = @"gou.jpg";
    one.coordinate = CLLocationCoordinate2DMake(31.347556, 121.373799);
    
    CustomAnnotation *two = [[CustomAnnotation alloc] init];
    two.type = CustomAnnotationTypeTwo;
    two.imagePath = @"gou.jpg";
    two.coordinate = CLLocationCoordinate2DMake(31.351470, 121.369161);
    
    CustomAnnotation *three = [[CustomAnnotation alloc] init];
    three.type = CustomAnnotationTypeThree;
    three.imagePath = @"gou.jpg";
    three.coordinate = CLLocationCoordinate2DMake(31.340159, 121.371575);
    
    CustomAnnotation *four = [[CustomAnnotation alloc] init];
    four.type = CustomAnnotationTypeFour;
    four.imagePath = @"tu.jpg";
    four.coordinate = CLLocationCoordinate2DMake(31.336025, 121.371035);
    
    CustomAnnotation *five = [[CustomAnnotation alloc] init];
    five.type = CustomAnnotationTypeOne;
    five.imagePath = @"gou.jpg";
    five.coordinate = CLLocationCoordinate2DMake(31.342346, 121.376681);
    
    CustomAnnotation *six = [[CustomAnnotation alloc] init];
    six.type = CustomAnnotationTypeTwo;
    six.imagePath = @"gou.jpg";
    six.coordinate = CLLocationCoordinate2DMake(31.342259, 121.370140);
    
    CustomAnnotation *seven = [[CustomAnnotation alloc] init];
    seven.type = CustomAnnotationTypeThree;
    seven.imagePath = @"gou.jpg";
    seven.coordinate = CLLocationCoordinate2DMake(31.340832, 121.367456);
    
    CustomAnnotation *eight = [[CustomAnnotation alloc] init];
    eight.type = CustomAnnotationTypeFour;
    eight.imagePath = @"gou.jpg";
    eight.coordinate = CLLocationCoordinate2DMake(31.344910, 121.365357);
    
    CustomAnnotation *nine = [[CustomAnnotation alloc] init];
    nine.type = CustomAnnotationTypeOne;
    nine.imagePath = @"gou.jpg";
    nine.coordinate = CLLocationCoordinate2DMake(31.348416, 121.365908);
    
    CustomAnnotation *ten = [[CustomAnnotation alloc] init];
    ten.type = CustomAnnotationTypeOne;
    ten.imagePath = @"gou.jpg";
    ten.coordinate = CLLocationCoordinate2DMake(31.347513, 121.371678);
    
    CustomAnnotation *eleven = [[CustomAnnotation alloc] init];
    eleven.type = CustomAnnotationTypeOne;
    eleven.imagePath = @"gou.jpg";
    eleven.coordinate = CLLocationCoordinate2DMake(31.344897, 121.377084);
    
    CustomAnnotation *tewlve = [[CustomAnnotation alloc] init];
    tewlve.type = CustomAnnotationTypeOne;
    tewlve.imagePath = @"gou.jpg";
    tewlve.coordinate = CLLocationCoordinate2DMake(31.341874, 121.375796);
    
    CustomAnnotation *thirdteen = [[CustomAnnotation alloc] init];
    thirdteen.type = CustomAnnotationTypeOne;
    thirdteen.imagePath = @"gou.jpg";
    thirdteen.coordinate = CLLocationCoordinate2DMake(31.337638, 121.373001);
    
    CustomAnnotation *fourteen = [[CustomAnnotation alloc] init];
    fourteen.type = CustomAnnotationTypeOne;
    fourteen.imagePath = @"gou.jpg";
    fourteen.coordinate = CLLocationCoordinate2DMake(31.345576, 121.379075);
    
    CustomAnnotation *fifteen = [[CustomAnnotation alloc] init];
    fifteen.type = CustomAnnotationTypeOne;
    fifteen.imagePath = @"gou.jpg";
    fifteen.coordinate = CLLocationCoordinate2DMake(31.341321, 121.378819);
    
    
    NSArray *annsArray = @[one,two,three,four,five,six,seven,eight,nine,ten,eleven,tewlve,thirdteen,fourteen,fifteen];
    self.anns = annsArray;
    [self.mapView addAnnotations:annsArray];
    
    NSMutableArray *dataarray = [NSMutableArray array];
    for (int index = 0; index < annsArray.count; index++) {
        NSString *imageName = [NSString stringWithFormat:@"Yosemite%d",index];
        [dataarray addObject:imageName];
    }
    self.teamInfoView.dataArray = dataarray;
    return annsArray;
    
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
/// 分类
- (void) classifyBtnClick:(id) sender {
    
    RWDropdownMenuCellAlignment alignment = RWDropdownMenuCellAlignmentCenter;
    alignment = RWDropdownMenuCellAlignmentRight;
    [RWDropdownMenu presentFromViewController:self withItems:self.menuItems align:alignment style:self.menuStyle navBarImage:[sender image] delegate:self completion:nil];
}

/// 定位
- (void) gpsAction {
    
    if (self.mapView.userLocation.updating && self.mapView.userLocation.location) {
        NSLog(@"located%f%f",self.mapView.userLocation.location.coordinate.latitude,self.mapView.userLocation.location.coordinate.longitude);
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


/// 搜索 输入提示
- (void) searchTipsWithKey:(NSString *) key {
    if (key.length == 0) {
        return;
    }
    AMapInputTipsSearchRequest *tips = [[AMapInputTipsSearchRequest alloc] init];
    // 搜索关键词
    tips.keywords = key;
    // 当前搜索的城市
    tips.city = @"上海";
    // 搜索限制为当前城市
    tips.cityLimit = YES;
 
    [self.search AMapInputTipsSearch:tips];
}

/// 根据tip搜索周边poi数据
- (void) searchPOIWithTip:(AMapTip *) tip {
    AMapPOIKeywordsSearchRequest * request = [[AMapPOIKeywordsSearchRequest alloc] init];
    request.cityLimit = YES;
    request.keywords = tip.name;
    request.city = @"上海";
    // 返回扩展消息
    request.requireExtension = YES;
    [self.search AMapPOIKeywordsSearch:request];
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
        self.teamInfoView.userInteractionEnabled = NO;
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
        self.teamInfoView.userInteractionEnabled = NO;
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
        return cusAnnotationView;
        
    } else if ([annotation isKindOfClass:[MAPointAnnotation class]]) {
        static NSString *userLocationID = @"lockLocation";
        MAAnnotationView *lockedAnnotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:userLocationID];
        if (!lockedAnnotationView) {
            lockedAnnotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:userLocationID];
        }
        lockedAnnotationView.image = [UIImage imageNamed:@""];
        return lockedAnnotationView;
    } else if ([annotation isKindOfClass:[POIAnnotation class]] || [annotation isKindOfClass:[TipAnnotation class]]) {
        
        static NSString *tipIdentifier = @"poiIdentifier";
        
        MAPinAnnotationView *poiAnnotationView = (MAPinAnnotationView*)[self.mapView dequeueReusableAnnotationViewWithIdentifier:tipIdentifier];
        if (poiAnnotationView == nil)
        {
            poiAnnotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:tipIdentifier];
        }
        
        poiAnnotationView.canShowCallout = YES;
        
        return poiAnnotationView;
        
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
            // 开启交互 防止影响详情视图的滑动事件
            self.teamInfoView.userInteractionEnabled = YES;
            CustomAnnotation *ann = (CustomAnnotation *) annotationView.annotation;
            self.selectedCustomAnnView = annotationView;
            // 标注动画
            [annotationView startAnimation];
            // 详情动画
            [self.teamInfoView popupDetailViewAnimation];
            // 重新设置中心点
            [self.mapView setCenterCoordinate:ann.coordinate animated:YES];
            // teamInfoView 滑动到指定页面
            NSInteger index = (NSInteger)[self.anns indexOfObject:self.mapView.selectedAnnotations[0]];
            [self.teamInfoView scrollPageViewToIndex:index animated:NO];
            
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
        self.teamInfoView.userInteractionEnabled = NO;

   
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
    // 关闭交互 防止影响标注的点击
    self.teamInfoView.userInteractionEnabled = NO;

}

#pragma mark ----- TeamInfoContentViewDelegate
- (void)teamInfoContentView:(TeamInfoContentView *)view didSelectPageView:(UICollectionView *)collectionView index:(NSInteger)index {
    
}

- (void)teamInfoContentView:(TeamInfoContentView *)view didScollPageView:(NSInteger)index byUser:(BOOL)wasByUser {
    [self.mapView selectAnnotation:self.anns[index] animated:NO];
//    NSLog(@"%s %ld %d",__FUNCTION__,(long)index,wasByUser);
}

#pragma mark ----- AMapSearchDelegate
- (void) AMapSearchRequest:(id)request didFailWithError:(NSError *)error {
    NSLog(@"error %@", error);
}
/// 输入提示回调
- (void)onInputTipsSearchDone:(AMapInputTipsSearchRequest *)request response:(AMapInputTipsSearchResponse *)response {
    if (response.count == 0) {
        return;
    }
    [self.tips setArray:response.tips];
    [self.tableView reloadData];
}
/// POI 搜索回调
- (void)onPOISearchDone:(AMapPOISearchBaseRequest *)request response:(AMapPOISearchResponse *)response {
    
    if (response.pois.count == 0) {
        return;
    }
    NSMutableArray *poiAnnotations = [NSMutableArray arrayWithCapacity:response.pois.count];
    [response.pois enumerateObjectsUsingBlock:^(AMapPOI * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [poiAnnotations addObject:[[POIAnnotation alloc] initWithPOI:obj]];
    }];
    
    // 将结果以annotation的形式加载到地图上
    [self.mapView addAnnotations:poiAnnotations];
    
    // 如果只有一个结果，设置其为中心点
    if (poiAnnotations.count == 1) {
        [self.mapView setCenterCoordinate:[poiAnnotations[0] coordinate]];
    } else {
        // 多个结果，设置地图所有annotation都可见
        [self.mapView showAnnotations:poiAnnotations animated:NO];
        
    }
    
}
#pragma mark ----- UISearchResultsUpdating
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    self.tableView.hidden = !searchController.isActive;
    NSLog(@"%d",searchController.isActive);
    [self searchTipsWithKey:searchController.searchBar.text];
    self.navigationItem.rightBarButtonItem = searchController.isActive ? nil : [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"classify"] style:UIBarButtonItemStylePlain target:self action:@selector(classifyBtnClick:)];
}

#pragma mark ----- UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tips.count;
   
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *rid = @"cellId";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:rid];
    if(cell==nil){
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle      reuseIdentifier:rid];
    }
    AMapTip *tip = self.tips[indexPath.row];
    cell.textLabel.text = tip.name;
    cell.detailTextLabel.text = tip.address;
    return cell;

}
#pragma mark ----- UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.mapView.annotations enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[CustomAnnotation class]] || [obj isKindOfClass:[MAPointAnnotation class]]) {
            return ;
        }
        [self.mapView removeAnnotation:obj];
    }];
    
    AMapTip *tip = self.tips[indexPath.row];
    if (tip.uid != nil && tip.location != nil) {
        TipAnnotation *annotation = [[TipAnnotation alloc] initWithMapTip:tip];
        [self.mapView addAnnotation:annotation];
        [self.mapView setCenterCoordinate:annotation.coordinate];
        [self.mapView selectAnnotation:annotation animated:YES];
        NSLog(@"搜索后的经纬度 == %f %f",annotation.coordinate.latitude,annotation.coordinate.longitude);
    } else {
        [self searchPOIWithTip:tip];
    }
    
    self.searchController.active = NO;
    
    
}
#pragma mark ----- RWDropdownMenuDelegate
- (void)dropdownMenu:(RWDropdownMenu *)menu didSelectMenuItemAtIndex:(NSInteger)index {
    NSLog(@"%ld",index);
}
@end
