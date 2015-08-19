//
//  FilterViewController.h
//  PisFilterView
//
//  Created by newegg on 15/8/17.
//  Copyright (c) 2015年 newegg. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FilterViewController;
@protocol FilterViewControllerDelegate <NSObject>
- (void)filterViewController:(FilterViewController *)filterViewController
           filterWithFilters:(NSArray *)filters;

@end
@interface FilterViewController : UIViewController
- (void)bindWithFilters:(NSArray *)filters delegate:(id<FilterViewControllerDelegate>)delegate;
@end
