//
//  OPAVPlayer.m
//  MediaPlayer
//
//  Created by Mac on 16/9/13.
//  Copyright © 2016年 yijia. All rights reserved.
//

#import "OPAVPlayer.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>

@interface OPAVPlayer ()
@property (nonatomic, strong) AVPlayer *player;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, strong) NSMutableArray *videoItems;

@end

@implementation OPAVPlayer

+ (instancetype)sharePlayer
{
    static OPAVPlayer *avPlayer = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        avPlayer = [[self alloc] init];
    });
    return avPlayer;
}

- (id)init{
    
    if (self = [super init]) {
        self.player = [[AVPlayer alloc] init];
    }
    return self;
}

#pragma mark -- 以上为初始化音频类
- (AVPlayerItem *)getPlayItem:(int)index
{
    NSString *sourceStr = self.videoItems[index];
    sourceStr = [sourceStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    NSString *newString = [sourceStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSRange range = NSMakeRange(0, 4);
    NSString *httpStr = [sourceStr substringWithRange:range];
    
    NSURL *url;
    if ([httpStr isEqualToString:@"http"]) {url = [NSURL URLWithString:newString];
    }else{url = [NSURL fileURLWithPath:newString];}
    AVPlayerItem *item = [AVPlayerItem playerItemWithURL:url];
    return item;
}

- (void)setupAudioByArray:(NSMutableArray *)array
{
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    [[AVAudioSession sharedInstance] setActive:YES error:nil];
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    
    [self.videoItems removeAllObjects];
    self.videoItems = array;
    self.index = 0;
    [self musicPareparePlay];
    [self addNotification];
}

// 播放完成后会通知对象调用这个方法
- (void)playbackFinished:(NSNotification *)noti
{
    if ([self.delegate respondsToSelector:@selector(oplayerEnd:)]) {[self.delegate oplayerEnd:_videoItems[self.index]];}
    [self next];
}

// 播放
- (void)musicPlay
{
    if ([self.delegate respondsToSelector:@selector(oplayerCurrent:)]&&self.videoItems != nil && self.videoItems.count != 0) {
        
        NSString *str = self.videoItems[self.index];
        [self.delegate oplayerCurrent:str];
    }
    
    [self.player play];
}

- (void)musicPareparePlay
{
    if (self.player.currentItem) {[self.player.currentItem removeObserver:self forKeyPath:@"status"];}
    
    AVPlayerItem *playItem = [self getPlayItem:(int)self.index];
    if (playItem) {
        
        [playItem addObserver:self forKeyPath:@"status" options:(NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld) context:nil];
        [self.player replaceCurrentItemWithPlayerItem:playItem];
    }
}

- (void)next
{
    self.index++;
    if (self.index<self.videoItems.count) {
        
        [self removeNotifation];
        [self musicPareparePlay];
        [self addNotification];
        
    }else{
        self.index = 0;
        [self stopPlay];
        if ([self.delegate respondsToSelector:@selector(oplayerEndAll)]) {[self.delegate oplayerEndAll];}
    }
}

- (void)preview
{
    self.index--;
    if (self.index>0) {
        
        [self removeNotifation];
        [self musicPareparePlay];
        [self addNotification];
        
    }else{
        self.index = self.videoItems.count;
        [self stopPlay];
        if ([self.delegate respondsToSelector:@selector(oplayerEndAll)]) {[self.delegate oplayerEndAll];}
    }
}

- (void)removeNotifation
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
}

- (void)addNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackFinished:) name:AVPlayerItemDidPlayToEndTimeNotification object:self.player.currentItem];
}

- (void)addProgessObserver
{
    AVPlayerItem *playItem = self.player.currentItem;
    [self.player addPeriodicTimeObserverForInterval:CMTimeMake(1.0, 1.0) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
        
        float current = CMTimeGetSeconds(time);
        float total  = CMTimeGetSeconds([playItem duration]);
        
        NSLog(@"%.2f--%.2f", current, total);
        
        // NSNumber *currentT = [NSNumber numberWithFloat:current];
        // NSNumber *totalT = [NSNumber numberWithFloat:total];
        // weakSelf.viewAC.cmTime = [NSArray arrayWithObjects:currentT, totalT, nil];
    }];
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    AVPlayerItem *playerItem = object;
    
    if ([keyPath isEqualToString:@"status"]) {
        
        AVPlayerStatus status = [[change objectForKey:@"new"] intValue];
        switch (status) {
            case AVPlayerStatusUnknown:
                
                // [self.delegate audioStatus:playStatusUnKnowError];
                break;
                
            case AVPlayerStatusReadyToPlay:
                
                [self musicPlay];
                break;
                
            case AVPlayerStatusFailed:
                
                // [self.delegate audioStatus:playStatusFileError];
                [self next];
                break;
                
            default:
                break;
        }
    }else if ([keyPath isEqualToString:@"loadedTimeRanges"]){
        
        NSArray *array = playerItem.loadedTimeRanges;
        CMTimeRange timeRange = [array.firstObject CMTimeRangeValue];
        float startSecond = CMTimeGetSeconds(timeRange.start);
        float durationSeconds = CMTimeGetSeconds(timeRange.duration);
        NSTimeInterval totalBuffer = startSecond + durationSeconds;
        NSLog(@"总共缓存时间为:%.2f", totalBuffer);
    }
}

#pragma mark -- 播放控制
- (void)previewPlay
{
    [self preview];
}

- (void)nextPlay
{
    [self next];
}

- (void)pause
{
    [self.player pause];
}

- (void)startPlay
{
    [self.player play];
}

- (void)stopPlay
{
    if (self.player) {
        
        [self.player pause];
        [self removeNotifation];
    }
}


@end
