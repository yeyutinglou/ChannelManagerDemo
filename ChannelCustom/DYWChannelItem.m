//
//  DYWChannelItem.m
//  ChannelManagerDemo
//
//  Created by jyd on 2017/7/11.
//  Copyright © 2017年 jyd. All rights reserved.
//


#define BorderColor  [UIColor colorWithRed:227/255.0f green:227/255.0f blue:227/255.0f alpha:1]
#define PlaceholderColor [UIColor colorWithRed:241/255.0f green:241/255.0f blue:241/255.0f alpha:1]
#define TextColor [UIColor colorWithRed:40/255.0f green:40/255.0f blue:40/255.0f alpha:1]

#import "DYWChannelItem.h"

@implementation DYWChannelItem

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createUI];
    }
    return self;
}

- (void)createUI
{
    self.userInteractionEnabled = YES;
    self.backgroundColor = [UIColor whiteColor];
    
    _textLabel = [UILabel new];
    _textLabel.textAlignment = NSTextAlignmentCenter;
    _textLabel.textColor = TextColor;
    _textLabel.font = [UIFont systemFontOfSize:15];
    _textLabel.adjustsFontSizeToFitWidth = true;
    _textLabel.userInteractionEnabled = true;
    _textLabel.layer.cornerRadius = 5.0f;
    _textLabel.layer.borderWidth = 1.0f;
    [self addSubview:_textLabel];
    
    _deleteImageView = [[UIImageView alloc] init];
    _deleteImageView.image = [UIImage imageNamed:@"typeClosed"];
    
    _deleteImageView.hidden = YES;
    [self addSubview:_deleteImageView];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _textLabel.frame = self.bounds;
    
    if (_isPlaceholder) {
        _textLabel.layer.borderColor = PlaceholderColor.CGColor;
        _textLabel.textColor = [UIColor colorWithWhite:0.5 alpha:1];
    } else {
        _textLabel.layer.borderColor = BorderColor.CGColor;
        _textLabel.textColor = TextColor;
    }
    
    if (_isFirst) {
        _textLabel.textColor = [UIColor lightGrayColor];
    }
    
    _deleteImageView.frame = CGRectMake(self.bounds.origin.x +self.bounds.size.width - 5, self.bounds.origin.y-5, 10, 10);
}

- (void)setTitle:(NSString *)title
{
    _title = title;
    _textLabel.text = title;
}

@end
