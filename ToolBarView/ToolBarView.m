//
//  ToolBarView.m
//  MusicPlayerPro
//
//  Created by JM Zhao on 16/7/2.
//  Copyright © 2016年 yijia. All rights reserved.
//

#import "ToolBarView.h"
#import "BaseView.h"
#import "UIView+Extension.h"

#define kH [UIScreen mainScreen].bounds.size.height
#define kW [UIScreen mainScreen].bounds.size.width

@interface ToolBarView()
@property (nonatomic, assign) BOOL isExist;
@property (nonatomic, strong) UIButton *playBtn;
@end

@implementation ToolBarView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _playStatus = NO;
        
        UILabel *left = [[UILabel alloc] init];
        left.text = @"00/23";
        left.textColor = [UIColor whiteColor];
        left.font = [UIFont systemFontOfSize:14];
        left.textAlignment = NSTextAlignmentLeft;
        [self addSubview:left];
        self.leftLabel = left;
        
        UISlider *progress = [[UISlider alloc] init];
        UIImage *image = [UIImage imageNamed:@"slider"];
        [progress setThumbImage:image forState:(UIControlStateHighlighted)];
        [progress setThumbImage:image forState:(UIControlStateNormal)];
        [progress addTarget:self action:@selector(sliderDragUp:) forControlEvents:(UIControlEventValueChanged)];
        [self addSubview:progress];
        self.progress = progress;
        
        UILabel *right = [[UILabel alloc] init];
        right.text = @"03/35";
        right.textColor = [UIColor whiteColor];
        right.font = [UIFont systemFontOfSize:14];
        right.textAlignment = NSTextAlignmentRight;
        [self addSubview:right];
        self.rightLabel = right;
        
        NSArray *array = @[@"singleCycle", @"previousSong", @"play", @"nextSong", @"musicList"];
        for (int i =0; i < array.count; i ++) {
            
            UIButton *button = [UIButton buttonWithType:(UIButtonTypeSystem)];
            button.tag = i;
            UIImage *image = [UIImage imageNamed:array[i]];
            image = [image imageWithRenderingMode:(UIImageRenderingModeAlwaysOriginal)];
            [button setImage:image forState:(UIControlStateNormal)];
            [button addTarget:self action:@selector(btnAction:) forControlEvents:(UIControlEventTouchDown)];
            [self addSubview:button];
        }
    }
    return self;
}

// 更改进度
- (void)sliderDragUp:(UISlider *)progress
{
    NSLog(@"value change");
}

// 设置按钮
- (void)btnAction:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(toolBarPlayAction:)]) {
        
        [self.delegate toolBarPlayAction:sender.tag];
    }
    
    switch (sender.tag) {
            
        case 0:
            // 循环/单曲/随机
            
            break;
        
        case 2:
            self.playBtn = sender;
            if (_playStatus) {
                [sender setImage:[UIImage imageNamed:@"play"] forState:(UIControlStateNormal)];
                _playStatus = NO;
                
            }else{
                [sender setImage:[UIImage imageNamed:@"pause"] forState:(UIControlStateNormal)];
                _playStatus = YES;
            }
            
            break;
        case 4:
            
            // 这里需要演出一个列表
            [self subCell];
            
            break;
            
        default:
            break;
    }
}

// 播放完成后设置停止状态
- (void)setPlayStatus
{
    _playStatus = NO;
    UIImage *image = [UIImage imageNamed:@"play"];
    image = [image imageWithRenderingMode:(UIImageRenderingModeAlwaysOriginal)];
    [self.playBtn setImage:image forState:(UIControlStateNormal)];
}

// 弹出子cell
- (void)subCell
{
    NSArray *arr = @[@"11", @"22", @"33", @"44" ,@"88", @"99", @"00"];
    BaseView *base = [[BaseView alloc] initWithFrame:CGRectMake(0, kH*0.6, self.width, kH*0.4)];
    base.dataArray = arr;
    
    [self.superview addSubview:base];
}

- (void)getTime:(NSInteger)cTime durationTime:(NSInteger)dTime
{
    self.leftLabel.text = [NSString stringWithFormat:@"%02ld:%02ld", dTime/60, dTime%60];
    self.rightLabel.text = [NSString stringWithFormat:@"%02ld:%02ld", cTime/60, cTime%60];
    self.progress.value = ((CGFloat)dTime)/((CGFloat)cTime);
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.leftLabel.frame = CGRectMake(10, 2, 45, 30);
    self.progress.frame = CGRectMake(CGRectGetMaxX(_leftLabel.frame), 8, self.bounds.size.width-110,  20);
    self.rightLabel.frame = CGRectMake(CGRectGetMaxX(_progress.frame), 2, 45, 30);
    
    CGFloat y = 20;
    CGFloat edgeOut = 5.0;
    CGFloat edgeIn = 30.0;
    CGFloat witdth = (self.bounds.size.width-edgeOut*2-4*edgeIn)/5;
    CGFloat height = self.bounds.size.height-y;
    for (UIView *view in self.subviews) {
        
        if ([view isKindOfClass:[UIButton class]]) {
            view.frame = CGRectMake(edgeOut+(edgeIn+witdth)*(CGFloat)view.tag, y, witdth, height);
        }
    }
    
}

@end
