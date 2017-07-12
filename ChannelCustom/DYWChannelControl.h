//
//  DYWChannelControl.h
//  ChannelManagerDemo
//
//  Created by jyd on 2017/7/11.
//  Copyright © 2017年 jyd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void(^ChannelBlock)(NSArray *channels);

typedef void(^VoidBlock)(void);

@interface DYWChannelControl : NSObject

+ (instancetype)shareControl;


/** 使用的频道 */
@property (nonatomic, strong) NSMutableArray *inUseItems;

/** 未使用的频道 */
@property (nonatomic, strong) NSMutableArray *unUseItems;


- (void)showInViewController:(UIViewController *)vc completion:(ChannelBlock)channels;

@end
