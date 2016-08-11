//
//  HttpRequestClient.h
//  MyDemo
//
//  Created by Joker on 16/7/29.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AFNetworking.h>

/**
 * webservice 地址
 */
#define WEB_SERVICE_URL @"http://113.106.229.206:8088/PhoneDataService.asmx"

/**
 * 创建网络数据请求回调 block
 */
typedef void(^ReslutBlock)(id reslut,NSError *error);

@interface HttpRequestClient : AFHTTPSessionManager

/**
 *  初始化网络请求--单例
 */
+(HttpRequestClient *)httpManager;

/**
 * SOAP 接口请求
 */
-(void)requsetSOAP:(NSString *)strTargetUrl action:(NSString *)strAction param:(NSString *)strParam reslutBlock:(ReslutBlock)reslutBlock;
@end
