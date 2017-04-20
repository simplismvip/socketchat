//
//  LrcView.h
//  MusicPlayerPro
//
//  Created by JM Zhao on 16/7/2.
//  Copyright © 2016年 yijia. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LrcViewDelegate <NSObject>

// 系统音量代理
- (void)setSysTemVolumn:(CGFloat)value;

// 点按手势代理
- (void)gestureLrc;
@end

@interface LrcView : UIView
/**
 *  歌词界面拿到歌词
 *
 *  @param lrcArr  歌词数组
 *  @param timeArr 时间数组
 */
- (void)getLrcArr:(NSArray *)lrcArr timeArr:(NSArray *)timeArr;

@property (nonatomic, weak) id <LrcViewDelegate>delegate;
@property (nonatomic, assign) NSInteger currentTime;
@property (nonatomic, assign) CGFloat currentVolumn;
@end
