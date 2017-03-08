//
//  DropdownMenu.m
//  DropdownMenu
//
//  Created by Sunnyyoung on 16/5/26.
//  Copyright © 2016年 Sunnyyoung. All rights reserved.
//

#import "DropdownMenu.h"

@interface DropdownMenu () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, weak) UINavigationController *navigationController;
@property (nonatomic, strong) UITableView *menuTableView;
@property (nonatomic, strong) UIView *menuHeaderView;
@property (nonatomic, strong) UIView *menuBackgroundView;

@end

@implementation DropdownMenu

- (instancetype)init {
    self = [DropdownMenu buttonWithType:UIButtonTypeCustom];
    if (self) {
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    }
    return self;
}

- (instancetype)initWithNavigationController:(UINavigationController *)navigationController {
    self = [self init];
    if (self) {
        self.frame = navigationController.navigationBar.frame;
        self.navigationController = navigationController;
    }
    return self;
}

#pragma mark Layout method

- (void)layoutSubviews {
    [super layoutSubviews];
    [self updateMenuImage];
    [self updateMenuTitle];
    [self updateMenuHeaderView];
    [self updateMenuBackground];
}

- (CGSize)sizeThatFits:(CGSize)size {
    return CGSizeMake([super sizeThatFits:size].width + self.arrowPadding, [super sizeThatFits:size].height);
}

- (CGSize)intrinsicContentSize {
    return CGSizeMake([super intrinsicContentSize].width + self.arrowPadding, [super intrinsicContentSize].height);
}

- (void)updateMenuImage {
    [self setImage:self.arrowImage forState:UIControlStateNormal];
    [self setImageEdgeInsets:UIEdgeInsetsMake(0.0, CGRectGetWidth(self.titleLabel.frame) + self.arrowPadding, 0.0, -CGRectGetWidth(self.titleLabel.frame))];
}

- (void)updateMenuTitle {
    [self.titleLabel setFont:self.titleFont];
    [self setTitleColor:self.titleColor forState:UIControlStateNormal];
    [self setTitleEdgeInsets:UIEdgeInsetsMake(0.0, -CGRectGetWidth(self.imageView.frame), 0.0, CGRectGetWidth(self.imageView.frame) + self.arrowPadding)];
}

- (void)updateMenuHeaderView {
    CGRect menuHeaderViewFrame = self.menuHeaderView.frame;
    menuHeaderViewFrame.size.width = CGRectGetWidth(self.navigationController.navigationBar.frame);
    menuHeaderViewFrame.size.height = self.cellHeight;
    self.menuHeaderView.frame = menuHeaderViewFrame;
    self.menuHeaderView.backgroundColor = self.cellBackgroundColor;
}

- (void)updateMenuBackground {
    CGRect menuBackgroundViewFrame = [UIScreen mainScreen].bounds;
    menuBackgroundViewFrame.origin.y += CGRectGetMaxY(self.navigationController.navigationBar.frame);
    menuBackgroundViewFrame.size.height -= CGRectGetMaxY(self.navigationController.navigationBar.frame);
    self.menuBackgroundView.frame = menuBackgroundViewFrame;
}

#pragma mark - ScrollView Delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGRect menuHeaderViewFrame = self.menuHeaderView.frame;
    menuHeaderViewFrame.size.height = MAX(0.0, -scrollView.contentOffset.y);
    self.menuHeaderView.frame = menuHeaderViewFrame;
}

#pragma mark - TableView DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.titleArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.cellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    cell.textLabel.text = [self.dataSource titleArrayForNavigationDropdownMenu:self][indexPath.row];
    cell.textLabel.font = self.cellTextFont;
    cell.textLabel.textColor = self.cellTextColor;
    cell.textLabel.textAlignment = self.cellTextAlignment;
    cell.backgroundColor = self.cellBackgroundColor;
    cell.userInteractionEnabled = YES;
    if (self.cellSelectedColor) {
        cell.selectedBackgroundView = [[UIView alloc] init];
        cell.selectedBackgroundView.backgroundColor = self.cellSelectedColor;
    }
    return cell;
}

#pragma mark - TableView Delegate

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:self.cellSeparatorInsets];
    }
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:self.cellSeparatorInsets];
    }
}



#pragma mark - Public method

- (void)show {
    [[UIApplication sharedApplication].keyWindow addSubview:self.menuBackgroundView];
    CGRect menuTableViewFrame = self.menuTableView.frame;
    menuTableViewFrame.origin.y = -(MIN(self.titleArray.count * self.cellHeight, CGRectGetHeight(self.menuBackgroundView.frame)));
    self.menuTableView.frame = menuTableViewFrame;
    self.selected = YES;
    [UIView animateWithDuration:self.animationDuration * 1.5 delay:0.0 usingSpringWithDamping:0.7 initialSpringVelocity:0.5 options:kNilOptions animations:^{
        CGRect menuTableViewFrame = self.menuTableView.frame;
        menuTableViewFrame.origin.y = 0.0;
        self.menuTableView.frame = menuTableViewFrame;
        self.menuBackgroundView.alpha = 1.0;
    } completion:nil];
}

- (void)hide {
    self.selected = NO;
    [UIView animateWithDuration:self.animationDuration animations:^{
        CGRect menuTableViewFrame = self.menuTableView.frame;
        menuTableViewFrame.origin.y = -(MIN(self.titleArray.count * self.cellHeight, CGRectGetHeight(self.menuBackgroundView.frame)));
        self.menuTableView.frame = menuTableViewFrame;
        self.menuBackgroundView.alpha = 0.0;
    } completion:^(BOOL finished) {
        [self.menuBackgroundView removeFromSuperview];
    }];
}

#pragma mark - Event Response

- (void)menuAction:(DropdownMenu *)sender {
    self.isSelected?[self hide]:[self show];
}

- (void) tapAction {
    [self hide];
}
- (void) grabTaskBtnClick {
    NSLog(@"adsfasdfasf");
}
#pragma mark - Property method

- (UITableView *)menuTableView {
    if (_menuTableView == nil) {
        _menuTableView = [[UITableView alloc] initWithFrame:self.menuBackgroundView.bounds style:UITableViewStylePlain];
        _menuTableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
        _menuTableView.dataSource = self;
        _menuTableView.delegate = self;
        _menuTableView.backgroundColor = [UIColor clearColor];
        _menuTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 0.0, CGFLOAT_MIN)];
        [_menuTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
        [self.menuBackgroundView addSubview:_menuTableView];
        UIButton *btn = [[UIButton alloc] init];
        btn.frame = CGRectMake(0, 0, MainScreenW, 54);
        [btn setTitle:@"抢单" forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(grabTaskBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _menuTableView.tableFooterView = btn;
        _menuTableView.tableFooterView.backgroundColor = [UIColor whiteColor];
    }
    return _menuTableView;
}

- (UIView *)menuHeaderView {
    if (_menuHeaderView == nil) {
        _menuHeaderView = [[UIView alloc] initWithFrame:CGRectZero];
        _menuHeaderView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [self.menuBackgroundView addSubview:_menuHeaderView];
    }
    return _menuHeaderView;
}

- (UIView *)menuBackgroundView {
    if (_menuBackgroundView == nil) {
        _menuBackgroundView = [[UIView alloc] initWithFrame:CGRectZero];
        _menuBackgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _menuBackgroundView.clipsToBounds = YES;
        _menuBackgroundView.alpha = 0.0;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
        [_menuBackgroundView addGestureRecognizer:tap];
        _menuBackgroundView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.6];
    }
    return _menuBackgroundView;
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    self.userInteractionEnabled = YES;
    [UIView animateWithDuration:self.animationDuration animations:^{
        self.imageView.transform = CGAffineTransformMakeRotation(selected ? M_PI : 0.0);
    } completion:^(BOOL finished) {
    }];
}

- (void)setDataSource:(id<DropdownMenuDataSource>)dataSource {
    _dataSource = dataSource;
    [self setTitle:@"订单详情" forState:UIControlStateNormal];
}

- (void)setDelegate:(id<DropdownMenuDelegate>)delegate {
    _delegate = delegate;
    [self addTarget:self action:@selector(menuAction:) forControlEvents:UIControlEventTouchUpInside];
    if ([delegate respondsToSelector:@selector(navigationDropdownMenu:didSelectTitleAtIndex:)]) {
        
    }
}

#pragma mark - ReadOnly Property

- (NSArray<NSString *> *)titleArray {
    if ([self.dataSource respondsToSelector:@selector(titleArrayForNavigationDropdownMenu:)]) {
        return [self.dataSource titleArrayForNavigationDropdownMenu:self];
    } else {
        return nil;
    }
}

- (UIFont *)titleFont {
    
    return [UIFont systemFontOfSize:17.0];
   
}

- (UIColor *)titleColor {
    
    return [UIColor blackColor];
    
}

- (UIImage *)arrowImage {
    
    return [UIImage imageNamed:@"detail_arrow_down"];
    
}

- (CGFloat)arrowPadding {
    
    return 8.0;
    
}

- (NSTimeInterval)animationDuration {
    
    return 0.25;
    
}

- (BOOL)keepCellSelection {
    
    return YES;
    
}

- (CGFloat)cellHeight {
    
    return 45.0;
    
}

- (UIEdgeInsets)cellSeparatorInsets {
    
    return UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0);
    
}

- (NSTextAlignment)cellTextAlignment {
    
    return NSTextAlignmentCenter;
    
}

- (UIFont *)cellTextFont {
    
    return [UIFont systemFontOfSize:16.0];
   
}

- (UIColor *)cellTextColor {
    
    return [UIColor blackColor];
    
}

- (UIColor *)cellBackgroundColor {
    
    return [UIColor whiteColor];
    
}

- (UIColor *)cellSelectedColor {
    
    return nil;
   
}

@end
