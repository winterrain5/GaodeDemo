//
//  POIAnnotation.m
//  gaodeTest
//
//  Created by 石冬冬 on 2017/2/27.
//  Copyright © 2017年 sdd. All rights reserved.
//

#import "POIAnnotation.h"
@interface POIAnnotation ()

@property (nonatomic, readwrite, strong) AMapPOI *poi;

@end
@implementation POIAnnotation
@synthesize poi = _poi;

- (NSString *)title {
    return self.poi.name;
}

- (NSString *)subtitle {
    return self.poi.address;
}

- (CLLocationCoordinate2D)coordinate {
    return CLLocationCoordinate2DMake(self.poi.location.latitude, self.poi.location.longitude);
}

- (id)initWithPOI:(AMapPOI *)poi {
    if (self = [super init]) {
        self.poi = poi;
    }
    return self;
}
@end
