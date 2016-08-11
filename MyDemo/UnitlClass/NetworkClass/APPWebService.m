//
//  APPWebService.m
//  MyDemo
//
//  Created by Joker on 16/7/30.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import "APPWebService.h"
@interface APPWebService()

@property (nonatomic,strong)HttpRequestClient *reqClient;
@end

@implementation APPWebService

-(id)init{
    self = [super init];
    if (self) {
        self.reqClient = [HttpRequestClient httpManager];
    }
    return self;
}

-(void)userLogin:(NSString *)userName passWord:(NSString *)passWord reslut:(ReslutBlock)reslutBlock{
    NSString *strAction = @"sendLogin";
    NSString *strParam = [NSString stringWithFormat:@"<phone>%@</phone>\n<pwd>%@</pwd>\n<phoneType>2</phoneType>\n",userName,passWord];
    
    [self.reqClient requsetSOAP:WEB_SERVICE_URL action:strAction param:strParam reslutBlock:reslutBlock];
}

-(void)getUserInfoWithUserName:(NSString *)userName reslut:(ReslutBlock)reslutBlock{
    NSString *strAction = @"getUserInfoForIOS";
    NSString *strParam = [NSString stringWithFormat:@"<imsi>%@</imsi>\n",userName];
    
    [self.reqClient requsetSOAP:WEB_SERVICE_URL action:strAction param:strParam reslutBlock:reslutBlock];
}
@end
