//
//  POIAnnotation.h
//  gaodeTest
//
//  Created by 石冬冬 on 2017/2/27.
//  Copyright © 2017年 sdd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface POIAnnotation : NSObject <MAAnnotation>
@property (nonatomic, strong, readonly) AMapPOI *poi;
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;

- (id) initWithPOI:(AMapPOI *) poi;

/*!
 @brief 获取annotation标题
 @return 返回annotation的标题信息
 */
- (NSString *)title;

/*!
 @brief 获取annotation副标题
 @return 返回annotation的副标题信息
 */
- (NSString *)subtitle;

@end
