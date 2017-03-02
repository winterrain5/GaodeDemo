//
//  TipAnnotation.m
//  gaodeTest
//
//  Created by 石冬冬 on 2017/2/27.
//  Copyright © 2017年 sdd. All rights reserved.
//

#import "TipAnnotation.h"
@interface TipAnnotation ()

@property (nonatomic, readwrite, strong) AMapTip *tip;

@end
@implementation TipAnnotation
- (NSString *)title
{
    return self.tip.name;
}


- (NSString *)subtitle
{
    return self.tip.address;
}

- (CLLocationCoordinate2D)coordinate
{
    return CLLocationCoordinate2DMake(self.tip.location.latitude, self.tip.location.longitude);
}

- (instancetype)initWithMapTip:(AMapTip *)tip
{
    self = [super init];
    if (self)
    {
        self.tip = tip;
    }
    return self;
}
@end
