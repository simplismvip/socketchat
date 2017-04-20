//
//  AnimationView.m
//  MusicPlayerPro
//
//  Created by JM Zhao on 16/7/2.
//  Copyright © 2016年 yijia. All rights reserved.
//

#import "AnimationView.h"
#import "UIView+Extension.h"

@interface AnimationView()
@property (nonatomic, strong) UIView *cdView;
@property (nonatomic, strong) UIView *picView;
@end

@implementation AnimationView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        // 动画
        self.picView = [self animationCd:self];
        self.cdView = [self animationPic:self image:[UIImage imageNamed:@"beautifulGirl"]];
        
        // 按钮
        NSArray *array = @[@"download", @"like", @"messages", @"more"];
        for (int i =0; i < array.count; i ++) {
            
            UIButton *button = [UIButton buttonWithType:(UIButtonTypeSystem)];
            button.tag = i;
            UIImage *image = [UIImage imageNamed:array[i]];
            image = [image imageWithRenderingMode:(UIImageRenderingModeAlwaysOriginal)];
            [button setImage:image forState:(UIControlStateNormal)];
            [button addTarget:self action:@selector(btnAction:) forControlEvents:(UIControlEventTouchDown)];
            [self addSubview:button];
            
        }
        
        // 添加手势
        UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture:)];
        
        [self addGestureRecognizer:tapGes];
    }
    return self;
}

// 点按手势
- (void)tapGesture:(UITapGestureRecognizer *)tapGesture
{
    if ([self.delegate respondsToSelector:@selector(gestureAnimation)]) {
        
        [self.delegate gestureAnimation];
    }

    // NSLog(@"remove from superview");
}

- (void)btnAction:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(animationViewAction:)]) {
        
        [self.delegate animationViewAction:sender.tag];
    }
    
    switch (sender.tag) {
        case 0:
            
            break;
            
        case 1:
            
            break;
            
        case 2:
            
            break;
            
        case 3:
            
            break;
            
        default:
            break;
    }
    
    // printf("btn tag is %ld", sender.tag);
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    CGFloat y = self.height-64;
    CGFloat edgeOut = 45.0;
    CGFloat edgeIn = 20.0;
    CGFloat witdth = (self.width-edgeOut*2-3*edgeIn)/4;
    CGFloat height = 44;
    
    for (UIView *view in self.subviews) {
        
        if ([view isKindOfClass:[UIButton class]]) {
            view.frame = CGRectMake(edgeOut+(edgeIn+witdth)*(CGFloat)view.tag, y, witdth, height);
        }
    }
    
}

// 动画
- (void)animationRun
{
    self.cdView.transform = CGAffineTransformRotate(self.cdView.transform, 0.05 * M_PI_4);
    self.picView.transform = CGAffineTransformRotate(self.cdView.transform, 0.05 * M_PI_4);
}

- (UIView *)animationCd:(UIView *)view
{
    UIView *viewCd = [[UIView alloc] initWithFrame:CGRectMake(100, 300, self.width*0.725, self.width*0.725)];
    viewCd.center = CGPointMake(view.center.x, view.center.y - 45);
    viewCd.layer.contents = (id)[UIImage imageNamed:@"003"].CGImage;
    [view addSubview:viewCd];
    return viewCd;
}


- (UIView *)animationPic:(UIView *)view image:(UIImage *)image
{
    
    UIView *viewCd = [[UIView alloc] initWithFrame:CGRectMake(100, 300, self.width*0.39, self.width*0.39)];
    viewCd.center = CGPointMake(view.center.x, view.center.y - 45);
    viewCd.layer.contents = (id)image.CGImage;
    viewCd.layer.cornerRadius = self.width*0.39/2;
    viewCd.layer.masksToBounds = YES;
    [view addSubview:viewCd];
    
    return viewCd;
}


@end
