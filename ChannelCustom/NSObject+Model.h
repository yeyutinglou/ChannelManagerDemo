//
//  NSObject+Model.h
//  KVO
//
//  Created by jyd on 2017/7/6.
//  Copyright © 2017年 jyd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Model)

///数组转模型
+ (NSArray *_Nullable)modelWithJson:(id _Nullable )json;

///字典转模型
+ (instancetype _Nullable )modelWithDic:(NSDictionary *_Nullable)dic;



@end
