//
//  FilterInfo.h
//  PisFilterView
//
//  Created by newegg on 15/8/17.
//  Copyright (c) 2015年 newegg. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FilterCategory;

@interface FilterItem : NSObject
@property (nonatomic, strong) NSString          *ItemTitle;
@property (nonatomic, assign) NSInteger         ItemID;
@property (nonatomic, assign) BOOL              IsSelected;
@property (nonatomic, weak)   FilterCategory    *Category;
@end

@interface FilterCategory : NSObject
@property (nonatomic, strong) NSString      *CategoryTitle;
@property (nonatomic, strong) NSArray       *Items;
@property (nonatomic, assign) NSInteger     CategoryID;
@property (nonatomic, weak)   FilterItem    *SelectedItem;

@property (nonatomic, assign) BOOL          IsExpanded;
@end