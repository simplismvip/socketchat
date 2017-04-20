//
//  AFSoundPlayback.h
//  AFSoundManager-Demo
//
//  Created by Alvaro Franco on 21/01/15.
//  Copyright (c) 2015 AlvaroFranco. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>

@class AFSoundItem;
typedef void (^feedbackBlock)(AFSoundItem *item);
typedef void (^finishedBlock)(void);

// 设置代理回去当前正在播放的歌曲名字
@protocol AFSoundPlaybackDelegate <NSObject>

- (void)getName:(NSString *)name;

@end

@interface AFSoundPlayback : NSObject

extern NSString *const AFSoundPlaybackStatus;
extern NSString *const AFSoundStatusDuration;
extern NSString *const AFSoundStatusTimeElapsed;
extern NSString *const AFSoundPlaybackFinishedNotification;

typedef NS_ENUM(NSInteger, AFSoundStatus) {
    
    AFSoundStatusNotStarted = 0,
    AFSoundStatusPlaying,
    AFSoundStatusPaused,
    AFSoundStatusFinished
};
@property (nonatomic, strong) AVPlayer *player;
@property (nonatomic) AFSoundStatus status;
@property (nonatomic, readonly) AFSoundItem *currentItem;

// 设置代理
@property (nonatomic, weak) id <AFSoundPlaybackDelegate>delegate;

- (id)initWithItem:(AFSoundItem *)item;
- (void)play;
- (void)pause;
- (void)restart;
- (void)playAtSecond:(NSInteger)second;
- (void)listenFeedbackUpdatesWithBlock:(feedbackBlock)block andFinishedBlock:(finishedBlock)finishedBlock;
- (NSDictionary *)statusDictionary;

@end