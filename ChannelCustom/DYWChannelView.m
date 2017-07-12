//
//  DYWChannelView.m
//  ChannelManagerDemo
//
//  Created by jyd on 2017/7/11.
//  Copyright © 2017年 jyd. All rights reserved.
//

#import "DYWChannelView.h"
#import "DYWChannelItem.h"
#import "DYWChannelTitleView.h"
#import "DYWChannelControl.h"
#import "DYWChannelModel.h"

//菜单列数
static NSInteger ColumnNumber = 4;
//横向和纵向的间距
static CGFloat BtnMarginX = 15.0f;
static CGFloat BtnMarginY = 10.0f;


@interface DYWChannelView ()
{
    NSMutableArray *inUseItems;
    NSMutableArray *unUseItems;
    
    NSMutableArray *inUseModels;
    NSMutableArray *unUseModels;
    
    DYWChannelTitleView *inUseTitleView;
    DYWChannelTitleView *unUseTitleView;
    
    UIScrollView *scrollView;
    
    //被拖动卡片
    DYWChannelItem *dragingItem;
    //空白卡片
    DYWChannelItem *placeholderItem;
    //目标卡片
    DYWChannelItem *targetItem;
    //第一个卡片
    DYWChannelItem *firstItem;
}

@end

@implementation DYWChannelView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self == [super initWithFrame:frame]) {
        [self createUI];
    }
    return self;
}


- (void)createUI
{
    //解决向下偏移问题
    [self addSubview:[UIView new]];
    scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    [self addSubview:scrollView];
    
    //上半部分标题
    inUseTitleView = [[DYWChannelTitleView alloc] initWithFrame:CGRectMake(BtnMarginX, BtnMarginY, self.bounds.size.width - 2*BtnMarginX, [self titleViewHeight])];
    inUseTitleView.title = @"已选频道";
    inUseTitleView.subtitle = @"按住拖动调整排序";
    [scrollView addSubview:inUseTitleView];
    
    inUseItems = [NSMutableArray new];
    unUseItems = [NSMutableArray new];
    inUseModels = [NSMutableArray new];
    unUseModels = [NSMutableArray new];
    
    //初始化已选频道按钮
    for (int i = 0; i < [DYWChannelControl shareControl].inUseItems.count; i++) {
        DYWChannelModel *model = [DYWChannelControl shareControl].inUseItems[i];
        DYWChannelItem *item = [[DYWChannelItem alloc] initWithFrame:[self inUserItemFrameOfIndex:i]];
        item.deleteImageView.hidden = NO;
        item.title = model.name;
        [scrollView addSubview:item];
        [inUseItems addObject:item];
        [inUseModels addObject:model];
        
        //第一个频道
        if (i == 0) {
            item.userInteractionEnabled = NO;
            item.isFirst = YES;
            item.deleteImageView.hidden = YES;
            firstItem = item;
        }
        
        //点击手势
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(itemTapMethod:)];
        //第一个不需要移动,无需添加
        if (i != 0) {
            [item addGestureRecognizer:tap];
        }
    }
    
    
    //下半部分标题
    unUseTitleView = [[DYWChannelTitleView alloc] initWithFrame:CGRectMake(BtnMarginX, [self unUseLabelY],  self.bounds.size.width - 2*BtnMarginX, [self titleViewHeight])];
    unUseTitleView.title = @"推荐频道";
    [scrollView addSubview:unUseTitleView];
    
    //初始化推荐频道按钮
    for (int i = 0; i < [DYWChannelControl shareControl].unUseItems.count; i++) {
        DYWChannelModel *model = [DYWChannelControl shareControl].unUseItems[i];
        DYWChannelItem *item = [[DYWChannelItem alloc] initWithFrame:[self unUseItemFrameOfIndex:i]];
        item.title = model.name;
        [scrollView addSubview:item];
        [unUseItems addObject:item];
        [unUseModels addObject:model];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(itemTapMethod:)];
        [item addGestureRecognizer:tap];
        
        scrollView.contentSize = CGSizeMake(0, CGRectGetMaxY(item.frame) + BtnMarginY);
    }
    
    
    //占位按钮
    placeholderItem = [[DYWChannelItem alloc] initWithFrame:CGRectZero];
    placeholderItem.deleteImageView.hidden = YES;
    placeholderItem.isPlaceholder = YES;
    [scrollView addSubview:placeholderItem];
    
    //添加长按拖拽
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressMethod:)];
    longPress.minimumPressDuration = 0.3f;
    [scrollView addGestureRecognizer:longPress];
}

#pragma mark - DraggedMethods
- (void)longPressMethod:(UIGestureRecognizer *)recognizer
{
    switch (recognizer.state) {
        case UIGestureRecognizerStateBegan:
        {
            [self gestureBegan:recognizer];
        }
            break;
        case UIGestureRecognizerStateChanged:
        {
            [self gestureChanged:recognizer];
        }
            break;
        case UIGestureRecognizerStateEnded:
        {
            [self gestureEnd:recognizer];
        }
            break;
        default:
            break;
    }
}

- (void)gestureBegan:(UIGestureRecognizer *)recognizer
{
    scrollView.scrollEnabled = NO;
    CGPoint point = [recognizer locationInView:scrollView];
    //获取被拖拽的频道
    dragingItem = [self getDragingItemWithPoint:point];
    //拖拽的为空或者第一个频道,不执行拖拽方法
    if (!dragingItem || firstItem == dragingItem) {
        return;
    }
    //显示放大效果
    [self showAnimation:dragingItem bigger:YES];
    //用占位频道替代被拖拽的频道
    placeholderItem.title = dragingItem.title;
    NSInteger index = [inUseItems indexOfObject:dragingItem];
    [inUseItems replaceObjectAtIndex:index withObject:placeholderItem];
    placeholderItem.frame = [self inUserItemFrameOfIndex:index];
    //被拖拽的频道移到前面
    [scrollView bringSubviewToFront:dragingItem];
    //更新UI
    [self updateUI];
}
- (void)gestureChanged:(UIGestureRecognizer *)recognizer
{
    //拖拽的为空或者第一个频道,不执行拖拽方法
    if (!dragingItem || firstItem == dragingItem) {
        return;
    }
    //更新被拖拽按钮的frame
    CGPoint point = [recognizer locationInView:self];
    dragingItem.center = point;
    //获取目标频道
    targetItem = [self getTargetItemWithPoint:point];
    //没有找到目标频道或者目标频道是第一频道,则不执行交换方法
    if (!targetItem || firstItem == targetItem) {
        return;
    }
    //交换占位频道和目标频道的位置
    [inUseItems removeObject:placeholderItem];
    NSInteger index = [inUseItems indexOfObject:targetItem];
    if (placeholderItem.frame.origin.y == targetItem.frame.origin.y) {
        if (dragingItem.center.x < targetItem.center.x) {
            index += 1;
        }
    } else if (placeholderItem.frame.origin.y < targetItem.frame.origin.y) {
        index += 1;
    }
    [inUseItems insertObject:placeholderItem atIndex:index];
    //更新位置
    [self updateUI];
}

- (void)gestureEnd:(UIGestureRecognizer *)recognizer
{
    scrollView.scrollEnabled = YES;
    //拖拽频道不存在或者是第一频道,则不执行方法
    if (!dragingItem || firstItem == dragingItem) {
        return;
    }
    //和占位频道交换位置
    [inUseItems replaceObjectAtIndex:[inUseItems indexOfObject:placeholderItem] withObject:dragingItem];
    [self showAnimation:dragingItem bigger:NO];
    //更新UI
    [self updateUI];
    [self saveData];
}


///放大或缩小动画
- (void)showAnimation:(DYWChannelItem *)item  bigger:(BOOL)bigger
{
    CGFloat scale = bigger ? 1.3f : 1.0f;
    [UIView animateWithDuration:0.3 animations:^{
        CGAffineTransform newTransform = CGAffineTransformMakeScale(scale, scale);
        [item setTransform:newTransform];
    }];
    
}

#pragma mark - 辅助方法

///获取被拖动的频道
- (DYWChannelItem *)getDragingItemWithPoint:(CGPoint)point
{
    DYWChannelItem *checkItem = nil;
    if (inUseItems.count == 1) {
        return checkItem;
    }
    CGRect checkRect = CGRectMake(point.x, point.y, 1, 1);
    for (DYWChannelItem *item in inUseItems) {
        if (![item isKindOfClass:[DYWChannelItem class]]) {
            continue;
        }
        if (![inUseItems containsObject:item]) {
            continue;
        }
        if (CGRectIntersectsRect(item.frame, checkRect)) {
            checkItem = item;
            break;
        }
    }
    return checkItem;
}

///获取目标位置的频道
- (DYWChannelItem *)getTargetItemWithPoint:(CGPoint)point
{
    DYWChannelItem *tarItem = nil;
    for (DYWChannelItem *item in scrollView.subviews) {
        if (![item isKindOfClass:[DYWChannelItem class]]) {
            continue;
        }
        if (item == dragingItem) {
            continue;
        }
        if (item == placeholderItem) {
            continue;
        }
        if (![inUseItems containsObject:item]) {
            continue;
        }
        if (CGRectContainsPoint(item.frame, point)) {
            tarItem = item;
        }
    }
    return tarItem;
}


#pragma mark - 添加/删除频道

- (void)itemTapMethod:(UIGestureRecognizer *)recognizer
{
    DYWChannelItem *item = (DYWChannelItem *)recognizer.view;
    [scrollView bringSubviewToFront:item];
    
    //更新数据源
    if ([inUseItems containsObject:item]) {
        if (inUseItems.count == 1) {
            return;
        }
        [inUseItems removeObject:item];
        [unUseItems insertObject:item atIndex:0];
    } else {
        [unUseItems removeObject:item];
        [inUseItems addObject:item];
    }
    
    //更新UI
    [self updateUI];
    [self saveData];
}


#pragma mark - 定义按钮和其他控件的高度、宽度

-(CGFloat)itemWidth
{
    return (self.bounds.size.width - (ColumnNumber + 1) * BtnMarginX)/ColumnNumber;
}

-(CGFloat)itemHeight
{
    return [self itemWidth] / 2.0f;
}


-(CGFloat)titleViewHeight
{
    return 0.09 * self.bounds.size.width;
}


-(CGFloat)unUseLabelY
{
    NSInteger count = inUseItems.count;
    CGFloat y = [self titleViewHeight];
    if (count > 0) {
        y = CGRectGetMaxY([self inUserItemFrameOfIndex:inUseItems.count - 1]) + BtnMarginY;
    }
    return y;
}


#pragma mark - 更新UI方法


/// 更新UI
- (void)updateUI
{
    [UIView animateWithDuration:0.35 animations:^{
        [self updateUnUseTitleViewFrame];
        [self updateItemFrame];
    } completion:^(BOOL finished) {
        if (![inUseItems containsObject:placeholderItem]) {
            placeholderItem.frame = CGRectZero;
            placeholderItem.deleteImageView.hidden = YES;
        }
    }];
}

///更新每个频道
- (void)updateItemFrame
{
    for (int i = 0; i < inUseItems.count; i++) {
        DYWChannelItem *item = inUseItems[i];
        //除了第一个,其余展示删除图片
        if (i != 0) {
            item.deleteImageView.hidden = NO;
        }
        item.frame = [self inUserItemFrameOfIndex:i];
    }
    
    
    for (int i = 0; i < unUseItems.count; i++) {
        DYWChannelItem *item = unUseItems[i];
        item.deleteImageView.hidden = YES;
        item.frame = [self unUseItemFrameOfIndex:i];
        scrollView.contentSize = CGSizeMake(0, CGRectGetMaxY(item.frame) + BtnMarginY);
    }
}


/**
 使用中的item的frame
 */
- (CGRect)inUserItemFrameOfIndex:(NSInteger)index
{
    CGFloat itemY = CGRectGetMaxY(inUseTitleView.frame) + index/ColumnNumber * [self itemHeight] + (index/ColumnNumber + 1)*BtnMarginY;;
    
    CGFloat itemX = index%ColumnNumber*[self itemWidth] + (index%ColumnNumber + 1)*BtnMarginX;
    
    return CGRectMake(itemX, itemY, [self itemWidth], [self itemHeight]);
    
}


/**
 未使用中的item的frame
 */
-(CGRect)unUseItemFrameOfIndex:(NSInteger)index
{
    CGFloat itemY = [self unUseLabelY] + [self titleViewHeight] + index/ColumnNumber * [self itemHeight] + (index/ColumnNumber + 1)*BtnMarginY;
    CGFloat itemX = index%ColumnNumber * [self itemWidth] + (index%ColumnNumber + 1)*BtnMarginX;
    return CGRectMake(itemX, itemY, [self itemWidth], [self itemHeight]);
}

///未订阅标题栏Frame
- (void)updateUnUseTitleViewFrame
{
    CGRect frame = unUseTitleView.frame;
    frame.origin.y = [self unUseLabelY];
    unUseTitleView.frame = frame;
}


///保存数据
- (void)saveData
{
    NSMutableArray *arr1 = [NSMutableArray new];
    NSMutableArray *arr2 = [NSMutableArray new];
    for (int i = 0; i< inUseItems.count; i++) {
        DYWChannelModel *model = [DYWChannelModel new];
        DYWChannelItem *item = inUseItems[i];
        model.name = item.title;
        [arr1 addObject:model];
        
        
    }
        for (int i = 0; i< unUseItems.count; i++) {
            DYWChannelModel *model = [DYWChannelModel new];
            DYWChannelItem *item = unUseItems[i];
            model.name = item.title;
            [arr2 addObject:model];
        }
    [DYWChannelControl shareControl].inUseItems = arr1;
    [DYWChannelControl shareControl].unUseItems = arr2;
}


@end
