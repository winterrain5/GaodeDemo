//
//  CustomAnnotation.h
//  gaodeTest
//
//  Created by 石冬冬 on 2017/2/22.
//  Copyright © 2017年 sdd. All rights reserved.
//

#import <MAMapKit/MAMapKit.h>
typedef NS_ENUM(NSUInteger,CustomAnnotationType) {
    CustomAnnotationTypeOne = 1,
    CustomAnnotationTypeTwo,
    CustomAnnotationTypeThree,
    CustomAnnotationTypeFour
    
};
@interface CustomAnnotation : MAPointAnnotation
@property (nonatomic, assign) CustomAnnotationType type;
@property (nonatomic, assign) NSInteger number;
@property (nonatomic, copy) NSString *imagePath;


@end
