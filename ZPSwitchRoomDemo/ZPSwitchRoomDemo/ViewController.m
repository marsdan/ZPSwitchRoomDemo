//
//  ViewController.m
//  ZPSwitchRoomDemo
//
//  Created by mars on 2017/6/17.
//  Copyright © 2017年 ZhaoPeng. All rights reserved.
//

#import "ViewController.h"
#import "ZPScrollView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    ZPScrollView *scrollView = [[ZPScrollView alloc]initWithScrollDataArray:@[@"1",@"2",@"3"]];
    [self.view addSubview:scrollView];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
