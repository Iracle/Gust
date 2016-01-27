//
//  ArrayDataSource.m
//  LightVCFirstDemo
//
//  Created by Iracle on 3/18/15.
//  Copyright (c) 2015 Iralce. All rights reserved.
//

#import "ArrayDataSource.h"
@interface ArrayDataSource()

@property (nonatomic, copy) NSString *cellIdentifier;
@property (nonatomic, copy) TableViewConfigureBlock cellCOnfigureBlock;
@property (nonatomic, copy) TableViewCallbackBlock cellDidSeletedBlock;
@end

@implementation ArrayDataSource

- (instancetype)initWithItems:(NSArray *)anItem cellIdentifier:(NSString *)acellIdentifier cellConfigureBlock:(TableViewConfigureBlock)atableViewConfigureBlock{
    self = [super init];
    if (self) {
        
        _items = [anItem copy];
        _cellIdentifier = [acellIdentifier copy];
        _cellCOnfigureBlock = [atableViewConfigureBlock copy];
        
    }
    return self;
}

#pragma mark UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.items.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:self.cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:self.cellIdentifier];
    }
    cell.textLabel.font = [UIFont systemFontOfSize:15.0 weight:UIFontWeightThin];
    id item = [self.items objectAtIndex:indexPath.row];
    self.cellCOnfigureBlock(cell, item);
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.cellDidSeletedBlock(tableView, indexPath,self.items[indexPath.row] );
}

- (void)tableViewDidSelectRowAtIndexPathWithBlock:(TableViewCallbackBlock)callBackBlock {
    self.cellDidSeletedBlock = [callBackBlock copy];
}


@end




















