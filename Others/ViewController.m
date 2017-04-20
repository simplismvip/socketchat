//
//  ViewController.m
//  MusicPlayerPro
//
//  Created by JM Zhao on 16/7/2.
//  Copyright © 2016年 yijia. All rights reserved.
//

#import "ViewController.h"
#import "MainPlayController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (IBAction)nextBtn:(id)sender {
    
    MainPlayController *main = [[MainPlayController alloc] init];
    [self.navigationController pushViewController:main animated:YES];
    
}

@end
