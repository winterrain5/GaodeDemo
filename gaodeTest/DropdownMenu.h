//
//  DropdownMenu.h
//  DropdownMenu
//
//  Created by Sunnyyoung on 16/5/26.
//  Copyright © 2016年 Sunnyyoung. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DropdownMenu;

@protocol DropdownMenuDataSource <NSObject>

@required
- (NSArray<NSString *> *)titleArrayForNavigationDropdownMenu:(DropdownMenu *)navigationDropdownMenu;

@end

@protocol DropdownMenuDelegate <NSObject>

@required
- (void)navigationDropdownMenu:(DropdownMenu *)navigationDropdownMenu didSelectTitleAtIndex:(NSUInteger)index;

@end

@interface DropdownMenu : UIButton

@property (nonatomic, weak) id <DropdownMenuDataSource> dataSource;
@property (nonatomic, weak) id <DropdownMenuDelegate> delegate;
@property (nonatomic, copy) NSString *menuTitle;
- (instancetype)initWithNavigationController:(UINavigationController *)navigationController;

- (void)show;
- (void)hide;

@end
