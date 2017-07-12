//
//  DYWChannelTitleView.m
//  ChannelManagerDemo
//
//  Created by jyd on 2017/7/11.
//  Copyright © 2017年 jyd. All rights reserved.
//

#import "DYWChannelTitleView.h"

@interface DYWChannelTitleView ()
{
    UILabel *titleLabel;
    UILabel *subtitleLabel;
}

@end

@implementation DYWChannelTitleView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self == [super initWithFrame:frame]) {
        [self createUI];
    }
    return self;
}

- (void)createUI
{
    CGFloat labelWidth = self.bounds.size.width/2.0f;
    
    titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, labelWidth, self.bounds.size.height)];
    titleLabel.textColor = [UIColor blackColor];
    [self addSubview:titleLabel];
    
    subtitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(labelWidth - 80, 0, labelWidth, self.bounds.size.height)];
    subtitleLabel.textColor = [UIColor lightGrayColor];
    subtitleLabel.textAlignment = NSTextAlignmentLeft;
    subtitleLabel.font = [UIFont systemFontOfSize:15.0f];
    [self addSubview:subtitleLabel];
}

- (void)setTitle:(NSString *)title
{
    _title = title;
    titleLabel.text = title;
}

- (void)setSubtitle:(NSString *)subtitle
{
    _subtitle = subtitle;
    subtitleLabel.text = subtitle;
}
@end
