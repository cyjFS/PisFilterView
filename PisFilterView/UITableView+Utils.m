//
//  UITableView+Utils.m
//  NeweggLibrary
//
//  Created by cheney on 14-2-19.
//  Copyright (c) 2014年 newegg. All rights reserved.
//

#import "UITableView+Utils.h"

@implementation UITableView (Utils)

- (void)registerCellClasses:(NSArray *)classArray
{
    for (Class class in classArray) {
        NSString *className = NSStringFromClass(class);
        
        [self registerClass:class forCellReuseIdentifier:className];
    }
}
- (void)registerHeaderFooterViewClasses:(NSArray *)classArray
{
    for (Class class in classArray) {
        NSString *className = NSStringFromClass(class);
        
        [self registerClass:class forHeaderFooterViewReuseIdentifier:className];
    }
}

- (void)registerNibCellClasses:(NSArray *)classArray
{
    for (Class class in classArray) {
        NSString *className = NSStringFromClass(class);
        UINib *nib = [UINib nibWithNibName:className bundle:nil];
        
        [self registerNib:nib forCellReuseIdentifier:className];
    }
}
- (void)registerNibHeaderFooterViewClasses:(NSArray *)classArray
{
    for (Class class in classArray) {
        NSString *className = NSStringFromClass(class);
        UINib *nib = [UINib nibWithNibName:className bundle:nil];
        
        [self registerNib:nib forHeaderFooterViewReuseIdentifier:className];
    }
}

- (id)dequeueReusableCellWithCellClass:(Class)cellClass
{
    return [self dequeueReusableCellWithCellClass:cellClass forIndexPath:nil];
}
- (id)dequeueReusableCellWithCellClass:(Class)cellClass forIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    
    NSString *identifier = NSStringFromClass(cellClass);
    
    if (indexPath != nil) {
        cell = [self dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    } else {
        cell = [self dequeueReusableCellWithIdentifier:identifier];
    }
    
    return cell;
}

- (id)dequeueReusableHeaderFooterViewWithViewClass:(Class)viewClass
{
    NSString *identifier = NSStringFromClass(viewClass);
    
    return [self dequeueReusableHeaderFooterViewWithIdentifier:identifier];
}

@end
