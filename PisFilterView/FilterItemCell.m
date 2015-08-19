//
//  FilterItemCell.m
//  PisFilterView
//
//  Created by newegg on 15/8/18.
//  Copyright (c) 2015年 newegg. All rights reserved.
//

#import "FilterItemCell.h"
#import "FilterInfo.h"

@interface FilterItemCell ()
@property (nonatomic, strong) FilterItem    *item;

@end

@implementation FilterItemCell

+ (CGFloat)height{
    return 50.0f;
}

- (void)bindWithFilterItem:(FilterItem *)item{
    self.item = item;
    
    self.textLabel.text = item.ItemTitle;
    self.accessoryView.hidden = !item.IsSelected;
    if (!self.allowCancelSelected) {
        self.selectionStyle = item.IsSelected ? UITableViewCellSelectionStyleNone : UITableViewCellSelectionStyleGray;
    }
}

- (void)awakeFromNib {
    self.allowCancelSelected = YES;
    
    [self initSubviews];
}

#pragma mark - 
#pragma mark - utility methods
- (void)initSubviews{
    self.separatorInset = UIEdgeInsetsMake(0, 20.0f, 0, 0);
    self.textLabel.font = [UIFont systemFontOfSize:15.0];
    self.textLabel.textColor = [UIColor blackColor];
    
    UIImageView *iconSelected = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 18.0f, 18.0f)];
    iconSelected.image = [UIImage imageNamed:@"icon_selected_orange"];
    self.accessoryView = iconSelected;
}
@end
