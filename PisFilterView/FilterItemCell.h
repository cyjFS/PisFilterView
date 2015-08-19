//
//  FilterItemCell.h
//  PisFilterView
//
//  Created by newegg on 15/8/18.
//  Copyright (c) 2015年 newegg. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FilterItem;

@interface FilterItemCell : UITableViewCell
@property (nonatomic, assign) BOOL  allowCancelSelected;

+ (CGFloat)height;

- (void)bindWithFilterItem:(FilterItem *)item;
@end
