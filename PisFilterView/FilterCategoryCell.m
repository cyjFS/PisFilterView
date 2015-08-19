//
//  FilterCategoryCell.m
//  PisFilterView
//
//  Created by newegg on 15/8/18.
//  Copyright (c) 2015年 newegg. All rights reserved.
//

#import "FilterCategoryCell.h"
#import "FilterInfo.h"
@interface FilterCategoryCell ()
@property (weak, nonatomic) IBOutlet UILabel        *categoryTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel        *selectedItemTitleLabel;
@property (weak, nonatomic) IBOutlet UIImageView    *arrowIcon;

@property (nonatomic, strong) FilterCategory        *category;
@end

@implementation FilterCategoryCell

#pragma mark - 
#pragma mark - override methods
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    if (animated) {
        [UIView animateWithDuration:0.2f animations:^{
            self.arrowIcon.transform = self.category.IsExpanded ? CGAffineTransformMakeRotation(M_PI) : CGAffineTransformIdentity;
        }];
    }
}

#pragma mark - 
#pragma mark - public methods
+ (CGFloat)height{
    return 50.0f;
}

- (void)bindWithFilterCategory:(FilterCategory *)category{
    self.category = category;
    
    self.categoryTitleLabel.text = category.CategoryTitle;
    self.selectedItemTitleLabel.text = category.SelectedItem.ItemTitle;
    self.arrowIcon.transform = category.IsExpanded ? CGAffineTransformIdentity : CGAffineTransformMakeRotation(M_PI);
}
@end
