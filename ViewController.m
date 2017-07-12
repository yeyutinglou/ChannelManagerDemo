//
//  ViewController.m
//  ChannelManagerDemo
//
//  Created by jyd on 2017/7/11.
//  Copyright © 2017年 jyd. All rights reserved.
//
#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#import "ViewController.h"
#import "DYWChannelManager.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    addBtn.frame = CGRectMake(SCREEN_WIDTH - 40, 40, 40, 40);
    [addBtn setImage:[UIImage imageNamed:@"alarmTypeManage"] forState:UIControlStateNormal];
    [addBtn addTarget:self action:@selector(openChannelManager) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:addBtn];
}


- (void)openChannelManager
{
    NSArray * arr1 = @[@{@"name" : @"要闻"}, @{@"name" : @"科技"}, @{@"name" : @"社会"}, @{@"name" : @"娱乐"}, @{@"name" : @"体育"}, @{@"name" : @"图片"}, @{@"name" : @"时尚"}, @{@"name" : @"纪录片"}];
    NSArray *arr2 = @[@{@"name" : @"财经"}, @{@"name" : @"国际"}, @{@"name" : @"文化"}, @{@"name" : @"动漫"}, @{@"name" : @"NBA"}, @{@"name" : @"LOL"}, @{@"name" : @"Dota"}, @{@"name" : @"电视剧"}];
    [DYWChannelControl shareControl].inUseItems = [NSMutableArray arrayWithArray:[DYWChannelModel modelWithJson:arr1]];
    [DYWChannelControl shareControl].unUseItems =  [NSMutableArray arrayWithArray:[DYWChannelModel modelWithJson:arr2]];
    [[DYWChannelControl shareControl] showInViewController:self completion:^(NSArray *channels) {
         NSLog(@"频道管理结束：%@",channels);
    }];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
