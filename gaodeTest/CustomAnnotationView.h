//
//  CustomAnnotationView.h
//  gaodeTest
//
//  Created by 石冬冬 on 2017/2/22.
//  Copyright © 2017年 sdd. All rights reserved.
//

#import <MAMapKit/MAMapKit.h>
@class CustomCalloutView;
@interface CustomAnnotationView : MAAnnotationView
@property (nonatomic, strong) CustomCalloutView *calloutView;
- (void) startAnimation;
- (void) stopAnimation;
@end
