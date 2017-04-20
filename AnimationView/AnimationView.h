//
//  AnimationView.h
//  MusicPlayerPro
//
//  Created by JM Zhao on 16/7/2.
//  Copyright © 2016年 yijia. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AnimationViewDelegate <NSObject>

/**
 *  下载, 喜欢, 消息, 更多按钮
 *
 *  @param playStatus 返回点击事件
 */
- (void)animationViewAction:(NSInteger)playStatus;

// 点按手势代理
- (void)gestureAnimation;
@end

@interface AnimationView : UIView

- (void)animationRun;
@property (nonatomic, weak) id <AnimationViewDelegate>delegate;
@end
