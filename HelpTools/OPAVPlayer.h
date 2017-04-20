//
//  OPAVPlayer.h
//  MediaPlayer
//
//  Created by Mac on 16/9/13.
//  Copyright © 2016年 yijia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    playStatusUnKnowError,
    playStatusFileError,
    playStatusList,
    playStatusRondom,
    playStatusSingle,
} playStatus;


@class VideoPlayer;
@protocol OPAVPlayerDelegate <NSObject>
- (void)oplayerCurrent:(NSString *)path;
- (void)oplayerEndAll;
@optional
- (void)oplayerEnd:(NSString *)path;
- (void)oplayerStart;
- (void)audioStatus:(playStatus)status;
@end


typedef void(^progressBlock)(float current, float total);
@interface OPAVPlayer : NSObject

@property (nonatomic, weak) id<OPAVPlayerDelegate>delegate;
+ (instancetype)sharePlayer;
- (void)setupAudioByArray:(NSMutableArray *)array;
- (void)stopPlay;
- (void)previewPlay;
- (void)nextPlay;
- (void)pause;
- (void)startPlay;

- (void)currentProgress:(progressBlock)progress;
@end
