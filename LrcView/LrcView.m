//
//  LrcView.m
//  MusicPlayerPro
//
//  Created by JM Zhao on 16/7/2.
//  Copyright © 2016年 yijia. All rights reserved.
//

#import "LrcView.h"
#import "LrcCell.h"
#import <MediaPlayer/MediaPlayer.h>
#import "UIView+Extension.h"
//#import "GestureHelper.h"
@interface LrcView()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, weak) UISlider *sliderVoice;
@property (nonatomic, weak) UIImageView *imageView;
@property (nonatomic, weak) UIButton *whyBtn;
@property (nonatomic, weak) UITableView *lrcTableView;
@property (nonatomic, strong) NSArray *arrLrc;
@property (nonatomic, strong) NSArray *arrTimer;
@end

@implementation LrcView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        self.alpha = 0.5;
        
        UISlider *slider = [[UISlider alloc] init];
        UIImage *image = [UIImage imageNamed:@"slider"];
        [slider setThumbImage:image forState:(UIControlStateHighlighted)];
        [slider setThumbImage:image forState:(UIControlStateNormal)];
        [slider addTarget:self action:@selector(volumeSliderDragUp:) forControlEvents:(UIControlEventValueChanged)];
        [self addSubview:slider];
        self.sliderVoice = slider;
        
        // 小喇叭
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"voice"]];
        [self addSubview:imageView];
        self.imageView = imageView;
        
        // tableView
        UITableView *tableView = [[UITableView alloc] init];
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.backgroundColor = [UIColor clearColor];
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [tableView registerClass:[LrcCell class] forCellReuseIdentifier:@"cell"];
        [self addSubview:tableView];
        self.lrcTableView = tableView;
        
        // 问好控件
        UIButton *btn = [UIButton buttonWithType:(UIButtonTypeSystem)];
        UIImage *imageWhy = [UIImage imageNamed:@"why01"];
        imageWhy = [imageWhy imageWithRenderingMode:(UIImageRenderingModeAlwaysOriginal)];
        [btn setImage:imageWhy forState:(UIControlStateNormal)];
        [btn addTarget:self action:@selector(whyBtn:) forControlEvents:(UIControlEventTouchUpInside)];
        [self addSubview:btn];
        self.whyBtn = btn;
        
        // 添加手势
        UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)];
        
        [self addGestureRecognizer:tapGes];
        
//        [self addSubview:volum];
        
    }
    return self;
}


// 点按手势
- (void)tapGesture:(UITapGestureRecognizer *)tapGesture
{
    if ([self.delegate respondsToSelector:@selector(gestureLrc)]) {
        
        [self.delegate gestureLrc];
    }
}

- (void)setCurrentVolumn:(CGFloat)currentVolumn
{
    _currentVolumn = currentVolumn;
    
    // 设置系统音量为slider的value
    self.sliderVoice.value = currentVolumn;
}

- (void)volumeSliderDragUp:(UISlider *)sender
{
    if ([self.delegate respondsToSelector:@selector(setSysTemVolumn:)]) {
        
        [self.delegate setSysTemVolumn:sender.value];
    }
    
    NSLog(@"volumeSliderDragUp");
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrLrc.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    LrcCell *cell = [LrcCell lrcCell:tableView cellForRowAtIndexPath:indexPath lrcArr:self.arrLrc];
    
    return cell;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _imageView.frame = CGRectMake(10, 20, 20, 20);
    _sliderVoice.frame = CGRectMake(45, 20, self.bounds.size.width-60,  20);
    _whyBtn.frame = CGRectMake(self.width - 40, CGRectGetMaxY(_sliderVoice.frame), 30, 30);
    _lrcTableView.frame = CGRectMake(0, 60, self.bounds.size.width, self.bounds.size.height - 60);
    
}

// 设置歌词
- (void)setCurrentTime:(NSInteger)currentTime
{
    _currentTime = currentTime;
    
    if (_arrTimer.count == 0) return;
    
    NSInteger flag = 0;
    NSNumber *number;
    for (int i = 0; i < _arrTimer.count; i ++) {
        
        number = _arrTimer[i];
        if (number.integerValue >= currentTime) {
            
            flag = i;
            break;
        }
    }
    
    if (currentTime == number.integerValue - 1) {
        
        [self.lrcTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow: flag inSection:0] animated:YES scrollPosition:(UITableViewScrollPositionMiddle)];
        
        
        UITableViewCell *cellUp = [self.lrcTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:flag inSection:0]];
        cellUp.textLabel.textColor = [UIColor cyanColor];
        cellUp.textLabel.font = [UIFont systemFontOfSize:20];
        cellUp.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UITableViewCell *cellDown = [self.lrcTableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:flag - 1 inSection:0]];
        cellDown.textLabel.font = [UIFont systemFontOfSize:14];
        cellDown.textLabel.textColor = [UIColor whiteColor];
    }
}

- (void)getLrcArr:(NSArray *)lrcArr timeArr:(NSArray *)timeArr
{
    self.arrLrc = lrcArr;
    self.arrTimer = timeArr;
    [self.lrcTableView reloadData];
}

// why 按钮
- (void)whyBtn:(UIButton *)sender
{
    
}

@end
