//
//  NSObject+Model.m
//  KVO
//
//  Created by jyd on 2017/7/6.
//  Copyright © 2017年 jyd. All rights reserved.
//

#import "NSObject+Model.h"
#import <objc/message.h>
@implementation NSObject (Model)

+ (NSArray *)modelWithJson:(id)json
{
    if (!json) {
        return nil;
    }
    NSArray *arr = nil;
    NSData *jsonData = nil;
    if ([json isKindOfClass:[NSArray class]]) {
        arr = json;
    } else if ([json isKindOfClass:[NSString class]]) {
        jsonData = [json dataUsingEncoding:NSUTF8StringEncoding];
    } else if ([json isKindOfClass:[NSData class]]) {
        jsonData = json;
    }
    if (jsonData) {
        arr = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:NULL];
        if (![arr isKindOfClass:[NSArray class]]) {
            return nil;
        }
    }
    return [self modelWithArray:arr];
}

+ (NSArray *)modelWithArray:(NSArray *)array
{
    if (!array) {
        return nil;
    }
    NSMutableArray *result = [NSMutableArray new];
    for (NSDictionary *dic in array) {
        if (![dic isKindOfClass:[NSDictionary class]]) {
            continue;
        }
        NSObject *objc = [self modelWithDic:dic];
        if (objc) {
            [result addObject:objc];
        }
    }
    return result;
}


+ (instancetype)modelWithDic:(NSDictionary *)dic
{
    id objc = [self alloc];
    
    unsigned int count = 0;
    objc_property_t *propertys = class_copyPropertyList([self class], &count);
    for (int i = 0; i < count; i++) {
        objc_property_t property = propertys[i];
        NSString *key = [NSString stringWithUTF8String:property_getName(property)];
        id value = dic[key];
        if ([value isKindOfClass:[NSDictionary class]]) {
            // 生成的是这种T@\"Weman\",&,N,V_weman 类型 -》 @"User" 在OC字符串中 \" -> "，\是转义的意思，不占用字符
            NSString *type = [NSString stringWithUTF8String:property_getAttributes(property)];
            NSRange range = [type rangeOfString:@"\""];
            type = [type substringFromIndex: range.location + range.length];
            range = [type rangeOfString:@"\""];
            type = [type substringToIndex: range.location ];
            //根据字符串类名生成类对象
            Class modelClass = NSClassFromString(type);
            if (modelClass) {
                value = [modelClass modelWithDic:value];
            }
        }
        
        
        if ([value isKindOfClass:[NSArray class]]) {
            value = [self modelWithArray:value];
        }
        
        if (value) {
            [objc setValue:value forKey:key];
        }
        
    }
    
    return objc;
    
}

@end
