//
//  LrcCell.h
//  MusicPlayerPro
//
//  Created by JM Zhao on 16/7/2.
//  Copyright © 2016年 yijia. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LrcCell : UITableViewCell
+ (LrcCell *)lrcCell:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath lrcArr:(NSArray *)lrcArr;
@end
