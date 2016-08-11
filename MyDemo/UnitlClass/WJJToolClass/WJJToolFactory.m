//
//  WJJToolFactory.m
//  MyDemo
//
//  Created by 吴嘉佳 on 16/8/12.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import "WJJToolFactory.h"

@implementation WJJToolFactory
/** 判断字符串是否为空 */
+(BOOL)isBlankWithString:(NSString *)string{
    BOOL isBlank = NO;
    
    if (string == nil || string == NULL) {
        isBlank = YES;
    }
    
    if ([string isKindOfClass:[NSNull class]]) {
        isBlank = YES;
    }
    
    if ([string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length == 0) {
        isBlank = YES;
    }
    return isBlank;
}
@end
