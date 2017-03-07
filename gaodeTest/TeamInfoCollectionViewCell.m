//
//  TeamInfoCollectionViewCell.m
//  gaodeTest
//
//  Created by 石冬冬 on 2017/3/3.
//  Copyright © 2017年 sdd. All rights reserved.
//

#import "TeamInfoCollectionViewCell.h"
#import <Masonry.h>
@interface TeamInfoCollectionViewCell()
/// 头像
@property (weak, nonatomic) UIImageView *avatarImageView;
/// 大头针
@property (nonatomic, weak) UIImageView *pinImageView;
/// 地址
@property (nonatomic, weak) UILabel *addressLabel;
/// 行业
@property (nonatomic, weak) UILabel *categoryLabel;
/// 分割线
@property (nonatomic, weak) UIView *splitView;
/// 名称
@property (nonatomic, weak) UILabel *nameLabel;
/// 星级
@property (nonatomic, weak) UIView *starContentView;
/// 订单数
@property (nonatomic, weak) UILabel *orderCountLabel;
/// 好评率
@property (nonatomic, weak) UILabel *goodEvaluateLabel;

@property (nonatomic, weak) UIButton *checkAptitudeBtn;





@end
@implementation TeamInfoCollectionViewCell
+ (instancetype) teamInfoCollectionViewCell {
    return [[[NSBundle mainBundle] loadNibNamed:@"TeamInfoCollectionViewCell" owner:nil options:nil] lastObject];
}
- (void)setImageName:(NSString *)imageName{
    _imageName = imageName;
    self.avatarImageView.image = [UIImage imageNamed:imageName];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor whiteColor];
        [self setupUI];
        
    }
    return self;
}

- (void) setupUI {
    
    UIImageView *pinImageView = [[UIImageView alloc] init];
    self.pinImageView = pinImageView;
    pinImageView.image = [UIImage imageNamed:@"pin.png"];
    [self.contentView addSubview:pinImageView];
    
    UILabel *addressLabel = [[UILabel alloc] init];
    self.addressLabel = addressLabel;
    addressLabel.font = [UIFont systemFontOfSize:12];
    addressLabel.textColor = [UIColor darkGrayColor];
    addressLabel.text = @"宝山区镜泊湖路";
    [self.contentView addSubview:addressLabel];
    
    UILabel *categoryLabel = [[UILabel alloc] init];
    self.categoryLabel = categoryLabel;
    categoryLabel.font = [UIFont systemFontOfSize:14];
    categoryLabel.textColor = [UIColor colorWithRed:41/255.0 green:129/255.0 blue:195/255.0 alpha:1];
    categoryLabel.text = @"电器安装";
    [self.contentView addSubview:categoryLabel];
    
    UIView *splitView = [[UIView alloc] init];
    self.splitView = splitView;
    splitView.backgroundColor = [UIColor colorWithRed:248/255.0 green:248/255.0 blue:248/255.0 alpha:1];
    [self.contentView addSubview:splitView];
    
    UIImageView *imageView = [[UIImageView alloc] init];
    self.avatarImageView = imageView;
    imageView.layer.cornerRadius = 3;
    imageView.layer.masksToBounds = YES;
    [self.contentView addSubview:imageView];
    
    UILabel *nameLabel = [[UILabel alloc] init];
    self.nameLabel = nameLabel;
    nameLabel.font = [UIFont systemFontOfSize:15];
    nameLabel.textColor = [UIColor darkGrayColor];
    nameLabel.text = @"海尚广告安装团队";
    [self.contentView addSubview:nameLabel];
    
    UIView *starContentView = [[UIView alloc] init];
    self.starContentView = starContentView;
    starContentView.backgroundColor = [UIColor darkGrayColor];
    [self.contentView addSubview:starContentView];
    
    UILabel *orderCounteLabel = [[UILabel alloc] init];
    self.orderCountLabel = orderCounteLabel;
    orderCounteLabel.textColor = [UIColor darkGrayColor];
    orderCounteLabel.font = [UIFont systemFontOfSize:15];
    NSString *str = @"已服务订单:1000单";
    NSMutableAttributedString *attributeStr = [[NSMutableAttributedString alloc] initWithString:str];
    NSUInteger len = str.length - 7;
    [attributeStr addAttribute:NSForegroundColorAttributeName value:[UIColor orangeColor] range:NSMakeRange(6, len)];
    [attributeStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:17] range:NSMakeRange(6, len)];
    orderCounteLabel.attributedText = attributeStr;
    [self.contentView addSubview:orderCounteLabel];
    
    UILabel *goodEvaluateLabel = [[UILabel alloc] init];
    self.goodEvaluateLabel = goodEvaluateLabel;
    goodEvaluateLabel.textColor = [UIColor darkGrayColor];
    goodEvaluateLabel.font = [UIFont systemFontOfSize:15];
    NSString *str2 = @"好评率:%99";
    NSMutableAttributedString *attributeStr2 = [[NSMutableAttributedString alloc] initWithString:str2];
    NSUInteger len2 = str2.length - 4;
    [attributeStr2 addAttribute:NSForegroundColorAttributeName value:[UIColor orangeColor] range:NSMakeRange(4, len2)];
    [attributeStr2 addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:17] range:NSMakeRange(4, len2)];
    goodEvaluateLabel.attributedText = attributeStr2;
    [self.contentView addSubview:goodEvaluateLabel];
    
    UIButton *btn = [[UIButton alloc] init];
    self.checkAptitudeBtn = btn;
    [btn setTitle:@"查 看 详 细 资 质" forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:20];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.layer.cornerRadius = 3;
    btn.layer.masksToBounds = YES;
    btn.backgroundColor = [UIColor colorWithRed:75/255.0 green:171/255.0 blue:237/255.0 alpha:1];
    [btn addTarget:self action:@selector(checkAptitudeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:btn];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.pinImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(8);
        make.top.equalTo(self.contentView.mas_top).offset(8);
        make.height.width.mas_equalTo(25);
    }];
    
    [self.addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.pinImageView.mas_right).offset(8);
        make.bottom.equalTo(self.pinImageView.mas_bottom);
    }];
    
    [self.categoryLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-8);
        make.bottom.equalTo(self.pinImageView.mas_bottom);
    }];
    
    [self.splitView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.pinImageView.mas_bottom).offset(4);
        make.width.mas_equalTo(self.contentView);
        make.height.mas_equalTo(1);
    }];
    
    [self.avatarImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.splitView.mas_bottom).offset(15);
        make.left.equalTo(self.contentView.mas_left).offset(15);
        make.height.width.mas_equalTo(70);
    }];
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.avatarImageView.mas_right).offset(8);
        make.top.equalTo(self.avatarImageView.mas_top).offset(8);
    }];
    
    [self.starContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.avatarImageView.mas_right).offset(8);
        make.bottom.equalTo(self.avatarImageView.mas_bottom);
        make.height.mas_equalTo(40);
        make.width.mas_equalTo(120);
    }];
    
    [self.orderCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-8);
        make.centerY.equalTo(self.nameLabel.mas_centerY);
    }];
    
    [self.goodEvaluateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView.mas_right).offset(-8);
        make.centerY.equalTo(self.starContentView.mas_centerY);
    }];
    
    [self.checkAptitudeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-10);
        make.left.equalTo(self.contentView.mas_left).offset(15);
        make.right.equalTo(self.contentView.mas_right).offset(-15);
        make.height.mas_equalTo(45);
    }];
}

#pragma mark ----- 事件
- (void) checkAptitudeBtnClick:(UIButton *) sender {
    if (self.checkAptitudeBlock) {
        self.checkAptitudeBlock();
    }
}

@end
