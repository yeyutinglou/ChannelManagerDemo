//
//  DYWChannelControl.m
//  ChannelManagerDemo
//
//  Created by jyd on 2017/7/11.
//  Copyright © 2017年 jyd. All rights reserved.
//

#import "DYWChannelControl.h"
#import "DYWChannelManagerViewController.h"
@implementation DYWChannelControl

+ (instancetype)shareControl
{
    static DYWChannelControl *control = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        control = [DYWChannelControl new];
    });
    return control;
}

- (void)showInViewController:(UIViewController *)vc completion:(ChannelBlock)channels
{
    DYWChannelManagerViewController *channelVC = [DYWChannelManagerViewController new];
    [channelVC addBackBlock:^{
        if (channels) {channels(self.inUseItems);}
    }];
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:channelVC];
    NSMutableDictionary *dictAtrrs = [NSMutableDictionary dictionary];
    dictAtrrs[NSForegroundColorAttributeName] = [UIColor blackColor];
    dictAtrrs[NSFontAttributeName] = [UIFont systemFontOfSize:19];
    [nav.navigationBar setTitleTextAttributes:dictAtrrs];
    
    // 设置UIBarButtonItem主色
    [[UIBarButtonItem appearance] setTintColor:[UIColor blackColor]];
    [nav.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [vc presentViewController:nav animated:true completion:nil];
}

@end
