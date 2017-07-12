//
//  DYWChannelManagerViewController.m
//  ChannelManagerDemo
//
//  Created by jyd on 2017/7/12.
//  Copyright © 2017年 jyd. All rights reserved.
//

#import "DYWChannelManagerViewController.h"
#import "DYWChannelView.h"
@interface DYWChannelManagerViewController ()
{
    VoidBlock backBlock;
}
@end

@implementation DYWChannelManagerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"频道定制";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(backMethod)];
    
    DYWChannelView *menu = [[DYWChannelView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 64)];
    [self.view addSubview:menu];
}


- (void)addBackBlock:(VoidBlock)block
{
    backBlock = block;
}

- (void)backMethod
{
    //回调返回block
    if (backBlock) {backBlock();}
    //返回
    [self dismissViewControllerAnimated:true completion:nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
