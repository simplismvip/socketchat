//
//  OPAudioMangerTool.h
//  AudioPlayer
//
//  Created by Mac on 16/6/1.
//  Copyright © 2016年 yijia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@protocol OPAudioMangerToolDelegate <NSObject>

// 音乐播放的总时间和当前时间
- (void)currentTime:(NSInteger)cTime durationTime:(NSInteger)dTime;

@optional
- (void)playEnd:(NSArray *)lrcArr timeArr:(NSArray *)timeArr;
- (void)playStart:(NSArray *)lrcArr timeArr:(NSArray *)timeArr;
- (void)playEnd;

@end

@interface OPAudioMangerTool : NSObject
@property (nonatomic, copy) NSString *songName;
@property (nonatomic, copy) NSString *lastSongName;
@property (nonatomic, weak) id <OPAudioMangerToolDelegate>delegate;

/**
 *  根据传入路径和名字播放音乐
 *
 *  @param path 本地资源路径
 *  @param url  网络资源路径, 如果为本地直接写nil
 *  @param page 页数
 */
- (void)playByPath:(NSString *)path;
/**
 *  下一个资源
 */
- (void)playNext;
/**
 *  暂停播放
 */
- (void)pause;
/**
 *  停止播放
 *
 */
- (void)stop;
/**
 *  开始播放
 */
- (void)play;
/**
 *  上一个资源
 */
- (void)playPrevious;
/**
 *  返回歌词
 *
 *  @param name 歌词名字
 *
 *  @return 返回装有歌词和时间数据的字典
 */
- (NSDictionary *)getLrcName:(NSString *)name;
@end
