//
//  NavController.m
//  MusicPlayerPro
//
//  Created by JM Zhao on 16/7/2.
//  Copyright © 2016年 yijia. All rights reserved.
//

#import "NavController.h"

@interface NavController ()<UINavigationControllerDelegate>

@end

@implementation NavController

+ (void)initialize
{
    // 获取当前类的item
    UIBarButtonItem *item = [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[self]];
    // 设置导航条按钮颜色
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    dict[NSForegroundColorAttributeName] = [UIColor whiteColor];
    [item setTitleTextAttributes:dict forState:(UIControlStateNormal)];
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.delegate = self;
    
}

// 导航控制器将要显示的控制器
- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{

    NSLog(@"viewController did show \(viewController) %@", viewController);
    
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    // 这里的viewController参数就是下一个要进入的控制器
    [super pushViewController:viewController animated:animated];
    
    if (self.viewControllers.count != 0) {
        
        UIImage *Image = [UIImage imageNamed:@"share"];
        Image = [Image imageWithRenderingMode:(UIImageRenderingModeAlwaysOriginal)];
        
        UIBarButtonItem *shareItem = [[UIBarButtonItem alloc] initWithImage:Image style:(UIBarButtonItemStylePlain) target:self action:@selector(shareMusic)];
        viewController.navigationItem.rightBarButtonItem = shareItem;
    }
    
}

- (void)shareMusic
{
    NSLog(@"share sction");
}


@end
