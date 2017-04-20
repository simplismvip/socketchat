//
//  BaseView.m
//  MusicPlayerPro
//
//  Created by JM Zhao on 16/7/3.
//  Copyright © 2016年 yijia. All rights reserved.
//

#import "BaseView.h"
#import "BaseTableView.h"
#import "UIView+Extension.h"

@interface BaseView()
@property (nonatomic, weak) UIView *titleView;
//@property (nonatomic, weak) UIView *closeView;
@end

@implementation BaseView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        // 设置颜色
        self.backgroundColor = [UIColor whiteColor];
        
        UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, 44)];
//        titleView.backgroundColor = [UIColor redColor];
        [self addSubview:titleView];
        self.titleView = titleView;
        NSLog(@"%@", titleView);
        
        UIButton *saveBtn = [UIButton buttonWithType:(UIButtonTypeSystem)];
        saveBtn.frame = CGRectMake(10, 0, 60, 44);
        [saveBtn setTitle:@"收藏全部" forState:(UIControlStateNormal)];
        [saveBtn addTarget:self action:@selector(saveBtnAction:) forControlEvents:(UIControlEventTouchUpInside)];
        [titleView addSubview:saveBtn];
        
        
        UIButton *clearBtn = [UIButton buttonWithType:(UIButtonTypeSystem)];
        clearBtn.frame = CGRectMake(self.width-60, 0, 60, 44);
        [clearBtn setTitle:@"清空" forState:(UIControlStateNormal)];
        [clearBtn addTarget:self action:@selector(clearBtnAction:) forControlEvents:(UIControlEventTouchUpInside)];
        [titleView addSubview:clearBtn];
        

        UIButton *closeBtn = [UIButton buttonWithType:(UIButtonTypeSystem)];
        closeBtn.frame = CGRectMake(0, self.height-44, self.width, 44);
        [closeBtn setTitle:@"关闭" forState:(UIControlStateNormal)];
        [closeBtn addTarget:self action:@selector(closeBtnAction:) forControlEvents:(UIControlEventTouchUpInside)];
        [self addSubview:closeBtn];
    }
    return self;
}

- (void)setDataArray:(NSArray *)dataArray
{
    _dataArray = dataArray;
    
    BaseTableView *base = [[BaseTableView alloc] initWithFrame:CGRectMake(0, 44, self.width, self.height-88)];
    base.dataArray = [self.dataArray mutableCopy];
    [self addSubview:base];
}

- (void)saveBtnAction:(UIButton *)sender
{
    
}


- (void)closeBtnAction:(UIButton *)sender
{
    [self removeFromSuperview];    
}


- (void)clearBtnAction:(UIButton *)sender
{
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
//    for (UIView *view in self.subviews) {
//        
//        if ([view isKindOfClass:[UIButton class]]) {
//            
//            view.frame = CGRectMake(0, 0, <#CGFloat width#>, <#CGFloat height#>)
//        }
//    }
}

@end
