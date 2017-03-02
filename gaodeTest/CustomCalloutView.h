//
//  CustomCalloutView.h
//  gaodeTest
//
//  Created by 石冬冬 on 2017/3/1.
//  Copyright © 2017年 sdd. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CustomCalloutView;
@class CustomAnnotation;
@protocol CustomCalloutViewDelegate <NSObject>

- (void) detailButtonClicked:(UIButton *) sender calloutView:(CustomCalloutView *) calloutView customAnn:(CustomAnnotation *) ann;

@end
@interface CustomCalloutView : UIView
@property (nonatomic,weak) id<CustomCalloutViewDelegate> delegate;
@property (nonatomic, weak) CustomAnnotation *customAnn;
@property (nonatomic,weak) UIButton *btn;
- (void) dismissCalloutView;
@end
