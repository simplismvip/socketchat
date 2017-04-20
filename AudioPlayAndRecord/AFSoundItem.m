//
//  AFSoundItem.m
//  AFSoundManager-Demo
//
//  Created by Alvaro Franco on 20/01/15.
//  Copyright (c) 2015 AlvaroFranco. All rights reserved.
//

#import <AudioToolbox/AudioToolbox.h>
#import <MediaPlayer/MediaPlayer.h>
#import "AFSoundItem.h"

@implementation AFSoundItem

- (id)initWithLocalResource:(NSString *)name atPath:(NSString *)path {
    
    if (self == [super init]) {
        
        _type = AFSoundItemTypeLocal;
        _songName = [name componentsSeparatedByString:@"."].firstObject;
        
        NSString *itemPath;
        
        if (!path) {
            
            NSString *resourcePath = [[NSBundle mainBundle] resourcePath];
            itemPath = [resourcePath stringByAppendingPathComponent:name];
            
        } else { itemPath = [path stringByAppendingPathComponent:name];}
        
        _URL = [NSURL fileURLWithPath:itemPath];
    }
    return self;
}

- (id)initWithStreamingURL:(NSURL *)URL {
    
    if (self == [super init]) {
        
        _type = AFSoundItemTypeStreaming;
        _URL = URL;
    }
    return self;
}

- (void)setInfoFromItem:(AVPlayerItem *)item {
    
    _duration = CMTimeGetSeconds(item.duration);
    _timePlayed = CMTimeGetSeconds(item.currentTime);
}


@end
