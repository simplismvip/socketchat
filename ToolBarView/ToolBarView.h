//
//  ToolBarView.h
//  MusicPlayerPro
//
//  Created by JM Zhao on 16/7/2.
//  Copyright © 2016年 yijia. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    randomStatus,
    prior,
    play,
    next,
    pauseStatus,
    list
} toolBarPlayStatus;

@protocol ToolBarViewDelegate <NSObject>

- (void)toolBarPlayAction:(NSInteger)playStatus;
@end

//static BOOL _playStatus;
@interface ToolBarView : UIView

- (void)getTime:(NSInteger)cTime durationTime:(NSInteger)dTime;
- (void)setPlayStatus;

@property (nonatomic, weak) UISlider *progress;
@property (nonatomic, weak) UILabel *leftLabel;
@property (nonatomic, weak) UILabel *rightLabel;
@property (nonatomic, assign) BOOL playStatus;
@property (nonatomic, weak) id <ToolBarViewDelegate>delegate;
@end
