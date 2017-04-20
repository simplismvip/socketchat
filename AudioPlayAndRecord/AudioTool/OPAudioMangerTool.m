//
//  OPAudioMangerTool.m
//  AudioPlayer
//
//  Created by Mac on 16/6/1.
//  Copyright © 2016年 yijia. All rights reserved.
//

#import "OPAudioMangerTool.h"
#import "AFSoundQueue.h"
#import "AFSoundItem.h"
#import "AFSoundPlayback.h"

@interface OPAudioMangerTool ()<AFSoundPlaybackDelegate>
@property (nonatomic, strong) AFSoundQueue *queue;
@property (nonatomic, strong) AFSoundPlayback *playBack;
@property (nonatomic, assign) NSInteger pageNum;
@property (nonatomic, strong) NSMutableArray *items;
@property (nonatomic, copy) NSString *fileDir;
@property (nonatomic, strong) NSDictionary *dict;
@end

@implementation OPAudioMangerTool

- (void)playByPath:(NSString *)path
{
    // 停止上次
    [self stop];
    NSMutableArray *array = [self getFilesByExtension:@"uri" path:path];
    
    if (array.count == 0) {
        
        [self playByLocal:path];
        
    }else{
    
        [self playByUrl:path];
    }
}

- (void)playByUrl:(NSString *)path
{
    NSMutableArray *array = [self getFilesByExtension:@"uri" path:path];
    NSMutableArray *items = [NSMutableArray array];
    
    for (NSString *name in array) {
        NSString *key = [name componentsSeparatedByString:@"_"][1];
        
        if ([key isEqualToString:@"0"]) {
            NSString *pathString = [path stringByAppendingPathComponent:name];
            NSString *pathStr = [NSString stringWithContentsOfFile:pathString encoding:NSUTF8StringEncoding error:nil];
            pathStr = [pathStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            NSString *newString = [pathStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
            
            AFSoundItem *item = [[AFSoundItem alloc] initWithStreamingURL:[NSURL URLWithString:newString]];
            [items addObject:item];
        }
    }
    
    [self startPlay:items];
}

- (void)playByLocal:(NSString *)path
{
    NSMutableArray *items = [NSMutableArray array];
    // NSMutableArray *array = [self getFilesByExtension:@"mp3" path:path];
    
    NSArray *array = @[@"爱情转移.mp3", @"梁静茹-偶阵雨.mp3", @"林俊杰-背对背拥抱.mp3", @"情非得已.mp3", @"徐佳莹 - 失落沙洲.mp3", @"夜空中最亮的星.mp3"];
    for (NSString *name in array) {
    
        AFSoundItem *item = [[AFSoundItem alloc] initWithLocalResource:name atPath:nil];
       
        // 拿到最后一首歌曲名字
        self.lastSongName = item.songName;
        [items addObject:item];
    }
    
    [self startPlay:items];
}

#pragma mark -- AFSoundPlaybackDelegate -- 实现代理方法
- (void)getName:(NSString *)name
{
    // 在这里拿到歌曲名字
    self.songName = name;
    
    // 保证只调用一次, 就是在开始的时候传出歌词
    NSDictionary *songDic = [self getLrcName:name];
    NSArray *lrcArr = [songDic[@"lrc"] copy];
    NSArray *timeArr = [songDic[@"timer"] copy];
    
    if ([self.delegate respondsToSelector:@selector(playStart:timeArr:)]) {
        
        [self.delegate playStart:lrcArr timeArr:timeArr];
    }
}

- (void)startPlay:(NSMutableArray *)playArr
{
    self.queue = [[AFSoundQueue alloc] initWithItems:playArr];
    
    // 创建出来之后调用代理
    self.queue.queuePlayer.delegate = self;
    
    [_queue playCurrentItem];
    
    // 一首歌曲播放完成的回调
    [_queue listenFeedbackUpdatesWithBlock:^(AFSoundItem *item) {
    
        // 实时传出时间
        if ([self.delegate respondsToSelector:@selector(currentTime:durationTime:)]) {
            
            [self.delegate currentTime:item.duration durationTime:item.timePlayed];
        }
        
    } andFinishedBlock:^(AFSoundItem *nextItem) {
    
        // 判断是否为最后一首歌曲
        if (nextItem.songName == nil) {
            
            if ([self.delegate respondsToSelector:@selector(playEnd)]) [self.delegate playEnd];
            [self stop];
            return;
        }
                
        // 传输去歌曲名字
        self.songName = nextItem.songName;
        NSDictionary *songDic = [self getLrcName:nextItem.songName];
        NSArray *lrcArr = [songDic[@"lrc"] copy];
        NSArray *timeArr = [songDic[@"timer"] copy];

        // 播放完成的时候传出下一首歌的歌词
        if ([self.delegate respondsToSelector:@selector(playEnd:timeArr:)]) {
            
            [self.delegate playEnd:lrcArr timeArr:timeArr];
        }
    }];
}

- (void)playNext {
    
    [_queue playNextItem];
}

- (void)playPrevious {
    
    [_queue playPreviousItem];
}

- (void)play {
    
    [_queue playCurrentItem];
}

- (void)pause {
    
    [_queue pause];
}

- (void)stop {
    
    [_queue pause];
    [_queue clearQueue];
}


- (NSDictionary *)getLrcName:(NSString *)name// path:(NSString *)path
{
    
//    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
//    path = [path stringByAppendingPathComponent:@"Songs"];
//    
//    // 拿到歌词路径资源
//    NSMutableArray *lrcArray = [self getFilesByExtension:@"lrc" path:path];
    
    NSArray *lrcArray = @[@"爱情转移.lrc", @"梁静茹-偶阵雨.lrc", @"林俊杰-背对背拥抱.lrc", @"情非得已.lrc", @"徐佳莹 - 失落沙洲.lrc", @"夜空中最亮的星.lrc"];
    
    // NSArray *lrcArray = @[@"梁静茹-偶阵雨.lrc", @"情非得已.lrc"];
    
    for (NSString *lrcnName in lrcArray) {
        
        NSString *str = [lrcnName componentsSeparatedByString:@"/"].lastObject;
        
        NSString *str1 = [str componentsSeparatedByString:@"."].firstObject;
        
        // 如果传入的名字和取到的名字一样, 就切割改歌词
        if ([name isEqualToString:str1]) {
            
            NSMutableArray *lrc = [NSMutableArray array];
            
            NSMutableArray *timer = [NSMutableArray array];
            
            NSString *fileStr = [NSString stringWithContentsOfFile:[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:lrcnName] encoding:NSUTF8StringEncoding error:nil];
            
            // NSString *fileStr = [NSString stringWithContentsOfFile:[path stringByAppendingPathComponent:lrcnName] encoding:NSUTF8StringEncoding error:nil];
            
            NSArray *array = [fileStr componentsSeparatedByString:@"\n"];
            
            for (int i = 0; i < array.count; i ++) {
                
                // 每一行的歌词
                NSString *strLrc = array[i];
                
                NSArray *time = [strLrc componentsSeparatedByString:@"]"];
                
                if ([time[0] length] > 8) {
                    
                    // 歌词
                    [lrc addObject:time[1]];
                    
                    // 时间
                    NSString *ss = time[0];
                    int m = [ss substringWithRange:NSMakeRange(1, 2)].intValue;
                    int s = [ss substringWithRange:NSMakeRange(4, 2)].intValue;
                    int all = 60 * m + s;
                    NSNumber *number = [NSNumber numberWithInt:all];
                    [timer addObject:number];
                    self.dict = @{@"lrc":lrc, @"timer":timer};
                }
            }
            
        }
    }
    return self.dict;
}


#pragma mark -- 工具方法
// 根据后缀获取文件名
- (NSMutableArray *)getFilesByExtension:(NSString *)extension path:(NSString *)path
{
    NSFileManager *manger = [NSFileManager defaultManager];
    NSMutableArray *arr   = [NSMutableArray array];
    BOOL dir        = NO;
    BOOL exist       = [manger fileExistsAtPath:path isDirectory:&dir];
    
    // 文件不存在
    if (!exist) return 0;
    
    if (dir) {
        
        // int count = 0;
        NSArray *array = [manger contentsOfDirectoryAtPath:path error:nil];
        
        for (NSString *fileName in array) {
            
            NSString *ext = [[fileName pathExtension] lowercaseString];
            
            if ([ext isEqualToString:extension]) {
                
                [arr addObject:fileName];
            }
        }
    }
    return arr;
}

// 根据路径删除文件
- (BOOL)removeFileByPath:(NSString *)path
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    BOOL isDir                = NO;
    BOOL existed               = [fileManager fileExistsAtPath:path isDirectory:&isDir];
    
    // 文件夹不存在直接返回
    if ( !(isDir == YES && existed == YES) ){
        
        return NO;
        
    }else{ // 文件夹存在
        
        return [fileManager removeItemAtPath:path error:nil];
    }
}

@end
