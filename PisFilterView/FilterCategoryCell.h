//
//  FilterCategoryCell.h
//  PisFilterView
//
//  Created by newegg on 15/8/18.
//  Copyright (c) 2015年 newegg. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FilterCategory;

@interface FilterCategoryCell : UITableViewCell
+ (CGFloat)height;

- (void)bindWithFilterCategory:(FilterCategory *)category;

@end
