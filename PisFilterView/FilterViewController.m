//
//  FilterViewController.m
//  PisFilterView
//
//  Created by newegg on 15/8/17.
//  Copyright (c) 2015年 newegg. All rights reserved.
//

#import "FilterViewController.h"
#import "FilterInfo.h"
#import "FilterItemCell.h"
#import "FilterCategoryCell.h"
#import "UITableView+Utils.h"

@interface FilterViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, assign) id<FilterViewControllerDelegate>  delegate;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray                           *filters;
@property (nonatomic, strong) NSArray                           *dataSource;
@property (nonatomic, strong) NSArray                           *originSelectedItems;
@property (nonatomic, strong) NSArray                           *originExpandedCategory;
@property (nonatomic, assign) BOOL								operationMade;

@property (nonatomic, assign) BOOL                              needBindViews;

@end

@implementation FilterViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"筛选";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancelFilter)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(beginFilter)];
    
    [self.tableView registerNibCellClasses:@[[FilterCategoryCell class],[FilterItemCell class]]];
    
    if (self.needBindViews) {
        [self.tableView reloadData];
        self.needBindViews = NO;
    }
    
    //隐藏多余的分割线
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:(CGRect){0,0,0,0}];
}

#pragma mark - 
#pragma mark - public methods
- (void)bindWithFilters:(NSArray *)filters delegate:(id<FilterViewControllerDelegate>)delegate{
    self.filters = filters;
    self.delegate = delegate;
    [self initOriginSelectedItems];
    [self buildDataSource];
    
    self.needBindViews = YES;
    
    if (self.isViewLoaded) {
        [self.tableView reloadData];
        self.needBindViews = NO;
    }
    
    
}

#pragma mark - 
#pragma mark - table view delegate
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [FilterCategoryCell height];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [FilterCategoryCell height];
}

- (NSInteger)tableView:(UITableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath{
    id data = self.dataSource[indexPath.row];
    
    if ([data isKindOfClass:[FilterCategory class]]) {
        return 0;
    }
    else{
        return 1;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    id data = self.dataSource[indexPath.row];
    if ([data isKindOfClass:[FilterCategory class]]) {
        [self tableView:tableView didSelectFilterCategoryRowAtIndexPath:indexPath withCategory:data];
    }
    else{
        [self tableView:tableView didFilterItemSelectRowAtIndexPath:indexPath withFilterItem:data];
    }
}

#pragma mark - 
#pragma mark - table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = nil;
    
    id data = self.dataSource[indexPath.row];
    if ([data isKindOfClass:[FilterCategory class]]) {
        FilterCategoryCell *categoryCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([FilterCategoryCell class])];
        [categoryCell bindWithFilterCategory:data];
        cell = categoryCell;
    }
    else{
        FilterItemCell *itemCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([FilterItemCell class])];
        [itemCell bindWithFilterItem:data];
        cell = itemCell;
    }

    return cell;
}

#pragma mark - 
#pragma mark - handle touch events
- (void)beginFilter{
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        if (self.operationMade && [self selectedItemsChanged]) {
            [self.delegate filterViewController:self filterWithFilters:self.filters];
        }
    }];
}

- (void)cancelFilter{
    [self.navigationController dismissViewControllerAnimated:YES completion:^{
        [self restoreFilters];
    }];
}

#pragma mark - 
#pragma mark - utility methods
- (void)initOriginSelectedItems{
    self.originSelectedItems = [self selectedItems];
    self.originExpandedCategory = [self expandedCategories];
}

- (NSArray *)selectedItems{
    NSMutableArray *items = [NSMutableArray array];
    
    for (FilterCategory *category in self.filters) {
        for (FilterItem *item in category.Items) {
            if (item.IsSelected) {
                [items addObject:item];
            }
        }
    }
    
    return items;
}

- (NSArray *)expandedCategories{
    NSMutableArray *categories = [NSMutableArray array];
    
    for (FilterCategory *category in self.filters) {
        if (category.IsExpanded) {
            [categories addObject:category];
        }
    }
    
    return categories;
}

- (BOOL)selectedItemsChanged{
    BOOL result = NO;
    
    NSArray *originItems = self.originSelectedItems;
    NSArray *currentItems = [self selectedItems];
    
    result = ![originItems isEqualToArray:currentItems];
    
    return result;
}

- (void)restoreFilters{
    for (FilterCategory *category in self.filters) {
        category.IsExpanded = [self.originExpandedCategory containsObject:category];
        
        FilterItem *selectedItem = nil;
        for (FilterItem *item in category.Items) {
            item.IsSelected = [self.originSelectedItems containsObject:item];
            
            if (item.IsSelected) {
                selectedItem = item;
            }
        }
        
        category.SelectedItem = selectedItem;
    }
}

- (void)buildDataSource{
    NSMutableArray *dataSource = [NSMutableArray array];
    
    for (FilterCategory *category in self.filters) {
        [dataSource addObject:category];
        
        if (category.IsExpanded) {
            for (FilterItem *item in category.Items) {
                [dataSource addObject:item];
            }
        }
    }
    
    self.dataSource = dataSource;
}

- (void)tableView:(UITableView *)tableView didSelectFilterCategoryRowAtIndexPath:(NSIndexPath *)indexPath withCategory:(FilterCategory *)category{
    category.IsExpanded = !category.IsExpanded;
    
    [self buildDataSource];
    
    NSMutableArray *indexPathToChange = [NSMutableArray array];
    
    [category.Items enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSIndexPath *itemIndexPath = [NSIndexPath indexPathForRow:indexPath.row + idx + 1 inSection:indexPath.section];
        [indexPathToChange addObject:itemIndexPath];
    }];
    
    [tableView beginUpdates];
    
    if (category.IsExpanded) {
        [tableView insertRowsAtIndexPaths:indexPathToChange withRowAnimation:UITableViewRowAnimationFade];
    }
    else
    {
        [tableView deleteRowsAtIndexPaths:indexPathToChange withRowAnimation:UITableViewRowAnimationFade];
    }
    
    [tableView endUpdates];
    
}

- (void)tableView:(UITableView *)tableView didFilterItemSelectRowAtIndexPath:(NSIndexPath *)indexPath withFilterItem:(FilterItem *)item{
    item.Category.SelectedItem.IsSelected = NO;
    
    self.operationMade = YES;
    
    if (item != item.Category.SelectedItem) {
        item.IsSelected = YES;
        item.Category.SelectedItem = item;
    }
    else{
        item.Category.SelectedItem = nil;
    }
    
    [tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
