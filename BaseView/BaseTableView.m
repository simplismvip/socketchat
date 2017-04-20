//
//  BaseTableView.m
//  MusicPlayerPro
//
//  Created by JM Zhao on 16/7/3.
//  Copyright © 2016年 yijia. All rights reserved.
//

#import "BaseTableView.h"
#import "BaseTableViewCell.h"

@interface BaseTableView()<UITableViewDelegate, UITableViewDataSource>

@end

@implementation BaseTableView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self registerClass:[BaseTableViewCell class] forCellReuseIdentifier:@"cell"];
        self.delegate = self;
        self.dataSource = self;
        
    }
    return self;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    BaseTableViewCell *cell = [BaseTableViewCell lrcCell:tableView cellForRowAtIndexPath:indexPath];
    cell.textLabel.text = self.dataArray[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"选中%ld行", indexPath.row);
}

@end
