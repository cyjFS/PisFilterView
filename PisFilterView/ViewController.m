//
//  ViewController.m
//  PisFilterView
//
//  Created by newegg on 15/8/18.
//  Copyright (c) 2015年 newegg. All rights reserved.
//

#import "ViewController.h"
#import "FilterViewController.h"
#import "FilterInfo.h"

@interface ViewController ()<FilterViewControllerDelegate>
@property (nonatomic, strong) UILabel   *filterInfo;

@property (nonatomic, strong) NSArray   *filters;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"首页";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"筛选" style:UIBarButtonItemStylePlain target:self action:@selector(filterProducts)];
    
    self.filters = [self configurationFilter];
    
    self.filterInfo = [[UILabel alloc] initWithFrame:CGRectMake(30, 150, 260, 30)];
    self.filterInfo.font = [UIFont systemFontOfSize:18.0];
    self.filterInfo.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.filterInfo];
}

- (NSArray *)configurationFilter {
    
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"filterItem" ofType:@"plist"];
    NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
    
    FilterCategory *typeCategory = [[FilterCategory alloc] init];
    typeCategory.CategoryTitle = @"分类";
    typeCategory.CategoryID = 1;
    
    NSMutableArray *subItems = [NSMutableArray arrayWithCapacity:5];
    
    for (int i = 1; i < 6; i++) {
        NSDictionary *dic = [data objectForKey:[NSString stringWithFormat:@"item%d",i]];
        FilterItem *item = [[FilterItem alloc] init];
        item.ItemTitle = [dic objectForKey:@"ItemTitle"];
        item.ItemID = [[dic objectForKey:@"ItemID"] integerValue];
        item.Category = typeCategory;
        
        [subItems addObject:item];
    }
    
    typeCategory.Items = subItems;
    
    FilterCategory *areaCategory = [[FilterCategory alloc] init];
    areaCategory.CategoryTitle = @"城市";
    areaCategory.CategoryID = 2;
    
    subItems = [NSMutableArray arrayWithCapacity:2];
    
    for (int i = 6; i < 8; i++) {
        NSDictionary *dic = [data objectForKey:[NSString stringWithFormat:@"item%d",i]];
        FilterItem *item = [[FilterItem alloc] init];
        item.ItemTitle = [dic objectForKey:@"ItemTitle"];
        item.ItemID = [[dic objectForKey:@"ItemID"] integerValue];
        item.Category = areaCategory;
        
        [subItems addObject:item];
    }
    
    areaCategory.Items = subItems;
    
    return @[typeCategory, areaCategory];
}

- (void)filterProducts{
    FilterViewController *filterController = [[FilterViewController alloc] initWithNibName:nil bundle:nil];
    
    [filterController bindWithFilters:self.filters delegate:self];
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:filterController];
    
    nav.modalPresentationStyle = UIModalPresentationFullScreen;
    nav.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    
    [self presentViewController:nav animated:YES completion:^{
        
    }];
}

#pragma mark -
#pragma mark - filter view controller delegate
- (void)filterViewController:(FilterViewController *)filterViewController filterWithFilters:(NSArray *)filters{
    NSString *str1;
    NSString *str2;
    for(FilterCategory *category in filters){
        if (category.SelectedItem && category.CategoryID == 1) {
            str1 = (category.SelectedItem.ItemTitle ? category.SelectedItem.ItemTitle : @"未选");
        }
        else
            str2 = (category.SelectedItem.ItemTitle ? category.SelectedItem.ItemTitle : @"未选");
    }
    
    self.filterInfo.text = [NSString stringWithFormat:@"选择了 %@ %@",str1, str2];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
