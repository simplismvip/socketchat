//
//  MainPlayController.m
//  MusicPlayerPro
//
//  Created by JM Zhao on 16/7/2.
//  Copyright © 2016年 yijia. All rights reserved.
//

#import "MainPlayController.h"
#import "ToolBarView.h"
#import "OPAudioMangerTool.h"
#import "LrcView.h"
#import "AnimationView.h"
#import <MediaPlayer/MediaPlayer.h>
#import "AppDelegate.h"

@interface MainPlayController ()<ToolBarViewDelegate, OPAudioMangerToolDelegate, LrcViewDelegate, AnimationViewDelegate>
@property (nonatomic, strong) OPAudioMangerTool *audioTool;
@property (nonatomic, strong) ToolBarView *toolView;
@property (nonatomic, strong) LrcView *lrcView;
@property (nonatomic, strong) AnimationView *animation;
@property (nonatomic, strong) UISlider *volumeSlider;
@property (nonatomic, assign) BOOL isAnimation;
@property (nonatomic, assign) CGFloat staVolume;
@end

@implementation MainPlayController

- (void)viewDidLoad {
    [super viewDidLoad];

    // 设置子控件
    [self creatSubViews];
    [self getSystemVolum];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(volumeChanged:) name:@"AVSystemController_SystemVolumeDidChangeNotification" object:nil];
    
}

- (void)creatSubViews
{
    // 设置颜色
    self.view.backgroundColor = UIColor.blueColor;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"Navagation"] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
    
    UIImageView *backImage = [[UIImageView alloc] initWithFrame:self.view.bounds];
    backImage.image = [UIImage imageNamed:@"backGround-1"];
    [self.view addSubview:backImage];
    
    NSString *path = [NSHomeDirectory() stringByAppendingString:@"/Documents/Songs"];
    [self.audioTool playByPath:path];
    self.navigationItem.title = _audioTool.songName;

}

#pragma mark -- ToolBarViewDelegate
- (void)toolBarPlayAction:(NSInteger)playStatus
{
    // 禁止自动锁屏
    [UIApplication sharedApplication].idleTimerDisabled=YES;
    
    switch (playStatus) {
        case 0:
            NSLog(@"单曲循环");
            break;
            
        case 1:
            [_audioTool playPrevious];
            break;
            
        case 2:
            
            if (self.toolView.playStatus) {[_audioTool play];}
            else{[_audioTool pause];}
            
            break;
            
        case 3:
            [_audioTool playNext];
            break;
                        
        default:
            break;
    }
}

#pragma mark -- OPAudioMangerToolDelegate
- (void)currentTime:(NSInteger)cTime durationTime:(NSInteger)dTime
{
    [self.toolView getTime:cTime durationTime:dTime];
    
    // 播放动画
    if (self.isAnimation) {
        
        [self.animation animationRun];
    }else{
        // 获取当前时间
        self.lrcView.currentTime = dTime;
    }
}

// 结束播放调用
- (void)playEnd
{
    // 开启自动锁屏
    [UIApplication sharedApplication].idleTimerDisabled=NO;
    
    [_toolView playStatus];
}

#pragma mark -- 播放完成是会调用, 在一首歌播放完成后调用, 传出下一首歌曲歌词
- (void)playEnd:(NSArray *)lrcArr timeArr:(NSArray *)timeArr
{
    [self.lrcView getLrcArr:lrcArr timeArr:timeArr];
    self.navigationItem.title = _audioTool.songName;
}

// 第一次开始播放
- (void)playStart:(NSArray *)lrcArr timeArr:(NSArray *)timeArr
{
    [self.lrcView getLrcArr:lrcArr timeArr:timeArr];
    [self.view addSubview:self.lrcView];
}

#pragma mark -- LrcViewDelegate -- 拿到系统音量赋值给音量slider
- (void)getSystemVolum
{
    // 添加并接收系统的音量条
    MPVolumeView *volum = [[MPVolumeView alloc]initWithFrame:CGRectMake(-100, 0, 30, 30)];
    // 遍历volumView上控件，取出音量slider
    for (UIView *view in volum.subviews) {
        if ([view isKindOfClass:[UISlider class]]) {
            
            // 接收系统音量条
            self.volumeSlider = (UISlider *)view;
            
            self.volumeSlider.value = self.staVolume;
            
            NSLog(@"%@", self.volumeSlider);
            
            // 把系统音量的值赋给自定义音量条
            self.lrcView.currentVolumn = self.volumeSlider.value;
            break;
        }
    }
    [self.view addSubview:volum];
}

- (void)gestureLrc
{
    self.isAnimation = YES;
    
    [UIView animateWithDuration:0.5 animations:^{
        
        [self.lrcView removeFromSuperview];
        
    } completion:^(BOOL finished) {
        
        [self.view addSubview:self.animation];
        
    }];
    
    
}


#pragma mark -- 设置当前音量大小
- (void)setSysTemVolumn:(CGFloat)value
{
    self.volumeSlider.value = value;
}

- (void)volumeChanged:(NSNotification *)noti
{
    self.staVolume = [[[noti userInfo] objectForKey:@"AVSystemController_AudioVolumeNotificationParameter"] floatValue];
    self.lrcView.currentVolumn = self.staVolume;
    NSLog(@"volumn is %f", _staVolume);
}


#pragma mark -- AnimationViewDelegate
- (void)animationViewAction:(NSInteger)playStatus
{

}

// 点按手势代理
- (void)gestureAnimation
{
    self.isAnimation = NO;
    
    [UIView animateWithDuration:0.5 animations:^{
        
        [self.animation removeFromSuperview];
        
    } completion:^(BOOL finished) {
        
        [self.view addSubview:self.lrcView];
    }];

}


#pragma mark -- 懒加载
- (OPAudioMangerTool *)audioTool
{
    if (!_audioTool) {
        
        self.audioTool = [[OPAudioMangerTool alloc] init];
        self.audioTool.delegate = self;
    }
    
    return _audioTool;
}

- (LrcView *)lrcView
{
    if (!_lrcView) {
        
        LrcView *lrcView = [[LrcView alloc] initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, self.view.bounds.size.height-154)];
        lrcView.delegate = self;
        self.lrcView = lrcView;
    }
    
    return _lrcView;
}

- (AnimationView *)animation
{
    if (!_animation) {
        
        AnimationView *animation = [[AnimationView alloc] initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, self.view.bounds.size.height-154)];
        animation.delegate = self;
        self.animation = animation;
    }
    
    return _animation;
}

- (ToolBarView *)toolView
{
    if (!_toolView) {
        
        // toolBarView
        ToolBarView *toolV = [[ToolBarView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height - 90, self.view.bounds.size.width, 90)];
        toolV.delegate = self;
        [self.view addSubview:toolV];
        self.toolView = toolV;
    }
    
    return _toolView;
}



@end
