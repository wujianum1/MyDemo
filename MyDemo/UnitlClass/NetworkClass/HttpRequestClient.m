//
//  HttpRequestClient.m
//  MyDemo
//
//  Created by Joker on 16/7/29.
//  Copyright © 2016年 Joker. All rights reserved.
//

#import "HttpRequestClient.h"
#import "JSONKit.h"

/**
 *  SOAP 请求接口定义
 */
#define SOAP_REQ_FORMAT @"<%@ xmlns=\"%@\">\n"
/**
 * SOAP 头部
 */
#define HTTP_SOAP_HEAD @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">\n"
#define HTTP_HERDER_CONTENT_TYPE @"text/xml; charset=utf-8"

/**
 * webService 属性
 */
#define web_service_namespace @"http://tempuri.org/"

#define web_service_header_userName_k @"UserName"
#define web_service_header_userName_v @"sttel"

#define web_service_header_password_k @"PassWord"
#define web_service_header_password_v @"12345678"

#define web_service_header_headername_k @"headerName"
#define web_service_header_headername_v @"MySoapHeader"
@interface HttpRequestClient()<NSXMLParserDelegate>
@property(nonatomic,weak)ReslutBlock reslutBlock;

@property(nonatomic,strong)NSMutableString *strReslut;
@end

@implementation HttpRequestClient
+(HttpRequestClient *)httpManager{
    static HttpRequestClient *client = nil;
    
    /*
     * 采用gcd 方法，以保证其唯一性；该方法是线程安全的，所以请放心大胆的在子线程中使用
     */
    static dispatch_once_t pred;
    dispatch_once(&pred, ^{
        client = [[HttpRequestClient alloc]initWithBaseURL:[NSURL URLWithString:WEB_SERVICE_URL]];

        client.requestSerializer = [AFJSONRequestSerializer serializer];
        client.responseSerializer = [AFXMLParserResponseSerializer serializer];
        
        client.strReslut = [[NSMutableString alloc]init];
    });
    
    return client;
}
-(id)initWithBaseURL:(NSURL *)url
{
    self = [super initWithBaseURL:url];
    if (!self) {
        return nil;
    }
    // 特定配置头
//    self.requestSerializer = [AFJSONRequestSerializer new];
//    [self.requestSerializer setValue:@"application/json;charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    
    return self;
}

-(void)requsetSOAP:(NSString *)strTargetUrl action:(NSString *)strAction param:(NSString *)strParam reslutBlock:(ReslutBlock)reslutBlock{
    
    /**
     * http 请求头部定义
     */
    NSString * strReq = [NSString stringWithFormat:SOAP_REQ_FORMAT, strAction, web_service_namespace];
    NSString * strSoapAction = [NSString stringWithFormat:@"%@%@", web_service_namespace, strAction];
    
    /**
     * 组装HTTP请求内容
     */
    NSMutableString *soapMsg = [[NSMutableString alloc]init];
    [soapMsg appendString:HTTP_SOAP_HEAD];
    /**
     * 头部验证
     */
    [soapMsg appendString:@"<soap:Header>\n"];
    [soapMsg appendFormat:SOAP_REQ_FORMAT,web_service_header_headername_v,web_service_namespace];
    [soapMsg appendFormat:@"<UserName>%@</UserName>\n",web_service_header_userName_v];
    [soapMsg appendFormat:@"<PassWord>%@</PassWord>\n",web_service_header_password_v];
    
    // 当前设备UUID
    NSString *strUUID = [UIDevice currentDevice].identifierForVendor.UUIDString;
    [soapMsg appendFormat:@"<DeviceID>%@</DeviceID>\n",strUUID];
    [soapMsg appendFormat:@"<VersionCode>%f</VersionCode>\n",1.0];
    [soapMsg appendFormat:@"<Identity>%d</Identity>\n",1];
    [soapMsg appendString:@"<phoneType>2</phoneType>\n"];
    [soapMsg appendString:@"</MySoapHeader>\n"];
    [soapMsg appendString:@"</soap:Header>\n"];
    
    [soapMsg appendString:@"<soap:Body>\n"];
    [soapMsg appendString:strReq];
    if ( 0 != strParam.length)
    {
        [soapMsg appendString:strParam];
    }
    [soapMsg appendString:[NSString stringWithFormat:@"</%@>\n",strAction]];
    [soapMsg appendString:@"</soap:Body>\n"];
    [soapMsg appendString:@"</soap:Envelope>\n"];
    
    NSString * msgLength = [NSString stringWithFormat:@"%d",(int)[soapMsg length]];
    
    //组装http头
    NSMutableURLRequest * reqHeader = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:strTargetUrl]];
    [reqHeader setHTTPMethod:@"POST"];
    [reqHeader addValue:HTTP_HERDER_CONTENT_TYPE forHTTPHeaderField:@"Content-Type"];
    [reqHeader addValue:strSoapAction forHTTPHeaderField:@"SOAPAction"];
    [reqHeader addValue:msgLength forHTTPHeaderField:@"Content-Length"];
    [reqHeader setHTTPBody:[soapMsg dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLSessionDataTask *task = [self dataTaskWithRequest:reqHeader uploadProgress:nil downloadProgress:nil completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        
        if(error){
            if (reslutBlock) {
                reslutBlock(nil,error);
            }
            NSLog(@"%@",error.description);
        }else{
        
            if (reslutBlock) {
                self.reslutBlock = reslutBlock;
            }
            /*
             * XML 解析
             */
            NSXMLParser *parser = responseObject;
            parser.delegate = self;
            [parser parse];
        }
    }];
    [task resume];
}

#pragma mark --
/**
 *  解析到文档的开头时会调用
 */
- (void)parserDidStartDocument:(NSXMLParser *)parser
{
//        NSLog(@"parserDidStartDocument----");
    if (self.strReslut.length > 0) {
        [self.strReslut deleteCharactersInRange:NSMakeRange(0, self.strReslut.length)];
    }
}

/**
 *  解析到一个元素的开始就会调用
 *
 *  @param elementName   元素名称
 *  @param attributeDict 属性字典
 */
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    
}

/**
 *  解析到一个元素的结束就会调用
 *
 *  @param elementName   元素名称
 */
- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
//        NSLog(@"didEndElement----%@", qName);
}

/**
 *  解析到文档的结尾时会调用（解析结束）
 */
- (void)parserDidEndDocument:(NSXMLParser *)parser
{
//        NSLog(@"parserDidEndDocument----");
    NSString *reslut = self.strReslut;
    
    if (self.reslutBlock) {
        NSDictionary *reslutDic = [reslut objectFromJSONString];
        if (reslutDic) {
            self.reslutBlock(reslutDic,nil);
        }else{
            self.reslutBlock(reslut,nil);
        }
    }
}

-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string{
    //string 就是每个元素中包含的内容，我们需要在这里拿到并记录自己需要的数据
//    NSLog(@"%@",string);
    
    [self.strReslut appendString:string];
}
@end
