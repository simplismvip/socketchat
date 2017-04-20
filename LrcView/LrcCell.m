//
//  LrcCell.m
//  MusicPlayerPro
//
//  Created by JM Zhao on 16/7/2.
//  Copyright © 2016年 yijia. All rights reserved.
//

#import "LrcCell.h"

@implementation LrcCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        // 设置背景透明
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.textLabel.font = [UIFont systemFontOfSize:14];
        self.textLabel.textColor = [UIColor whiteColor];
        self.textLabel.textAlignment = NSTextAlignmentCenter;
    }
    
    return self;
}

+ (LrcCell *)lrcCell:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath lrcArr:(NSArray *)lrcArr
{
    static NSString *ID = @"cell";
    LrcCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    
    if (!cell) {
        
        cell = [[LrcCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:ID];
    }
    
    cell.textLabel.text = @"";
    cell.textLabel.text = lrcArr[indexPath.row];
    
    return cell;
}

@end
