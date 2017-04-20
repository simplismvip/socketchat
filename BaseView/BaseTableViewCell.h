//
//  BaseTableViewCell.h
//  MusicPlayerPro
//
//  Created by JM Zhao on 16/7/3.
//  Copyright © 2016年 yijia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseTableViewCell : UITableViewCell
+ (BaseTableViewCell *)lrcCell:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;

@end
