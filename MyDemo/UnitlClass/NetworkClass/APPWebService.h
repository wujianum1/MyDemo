//
//  APPWebService.h
//  MyDemo
//
//  Created by Joker on 16/7/30.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HttpRequestClient.h"
@interface APPWebService : NSObject
/** 
 *  用户登录
 */
-(void)userLogin:(NSString *)userName passWord:(NSString *)passWord reslut:(ReslutBlock)reslutBlock;

/**
 *  获取用户信息
 */
-(void)getUserInfoWithUserName:(NSString *)userName reslut:(ReslutBlock)reslutBlock;
@end
