//
//  DYWChannelItem.h
//  ChannelManagerDemo
//
//  Created by jyd on 2017/7/11.
//  Copyright © 2017年 jyd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DYWChannelItem : UIView

/** 标题 */
@property (nonatomic, copy) NSString *title;

/** 是否占位 */
@property (nonatomic, assign) BOOL isPlaceholder;

/** 第一个 */
@property (nonatomic, assign) BOOL isFirst;

/** 删除 */
@property (nonatomic, strong) UIImageView *deleteImageView;

/** 文本 */
@property (nonatomic, strong) UILabel *textLabel;


@end
