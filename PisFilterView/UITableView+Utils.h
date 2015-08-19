//
//  UITableView+Utils.h
//  NeweggLibrary
//
//  Created by cheney on 14-2-19.
//  Copyright (c) 2014年 newegg. All rights reserved.
//
#import <UIKit/UIKit.h>
@interface UITableView (Utils)

- (void)registerCellClasses:(NSArray *)classArray;
- (void)registerHeaderFooterViewClasses:(NSArray *)classArray;

- (void)registerNibCellClasses:(NSArray *)classArray;
- (void)registerNibHeaderFooterViewClasses:(NSArray *)classArray;

- (id)dequeueReusableCellWithCellClass:(Class)cellClass;
- (id)dequeueReusableCellWithCellClass:(Class)cellClass forIndexPath:(NSIndexPath *)indexPath;

- (id)dequeueReusableHeaderFooterViewWithViewClass:(Class)viewClass;

@end
