//
//  TYIPAddress.m
//  TYDaily
//
//  Created by laoniu on 14/11/13.
//
//

#import "TYIPAddress.h"
#include <ifaddrs.h>
#include <arpa/inet.h>
#import "RegexKitLite.h"

@implementation TYIPAddress


-(NSString*)getIP
{
    NSURL *url = [NSURL URLWithString:@"http://ip.qq.com/cgi-bin/index"];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"GET"];
    [request setTimeoutInterval:8.0f];
    NSHTTPURLResponse *response;
    
    //返回的是GBK编码
    
    NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
    
    //    NSLog(@"%@",returnData);
    
    //直接转,将会产生乱码或者字符串为空    NSUTF8StringEncoding
    
    NSString *temp1 = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
    
    //                               NSASCIIStringEncoding
    
    NSString *temp2 = [[NSString alloc] initWithData:returnData encoding:NSASCIIStringEncoding];
    
    //    NSLog(@"---------temp1---%@",temp1);
    
    //    NSLog(@"---------temp2---%@",temp2);
    
    NSLog(@"-------------------------------------");
    
    
    
    // 一、 GBK编码 (通过CFStringCreateWithBytes转码)
    
    CFStringRef GBKCFstirng =CFStringCreateWithBytes(NULL,[returnData bytes], [returnData length],kCFStringEncodingGB_18030_2000,false);
    
    NSString *gbkNSString1 = (__bridge NSString *)GBKCFstirng;
    
    //    NSLog(@"--gbkNSString1---%@",gbkNSString1);
    
    
    
    // 二、 GBK编码 (通过CFStringConvertEncodingToNSStringEncoding转码)
    
    NSStringEncoding nsEncoding =CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    
    NSString *gbkNSString2 = [[NSString alloc] initWithData:returnData encoding:nsEncoding];
    
    //    NSLog(@"--gbkNSString2---%@",gbkNSString2);
    
    
    
    NSLog(@"-------------------------------------");
    
    
    
    //转成NSUTF8StringEncoding的字符串
    
    NSData *tempdata = [gbkNSString1 dataUsingEncoding:NSUTF8StringEncoding];
    
    NSString *UTF8_NSString = [[NSString alloc] initWithData:tempdata encoding:NSUTF8StringEncoding];
    
    //    NSLog(@"--UTF8_NSString--%@",UTF8_NSString);
    
    NSString *regex = @"(1[0-9]{2}|2[0-4][0-9]|25[0-5]|[1-9]?[0-9])\\.(1[0-9]{2}|2[0-4][0-9]|25[0-5]|[1-9]?[0-9])\\.(1[0-9]{2}|2[0-4][0-9]|25[0-5]|[1-9]?[0-9])\\.(1[0-9]{2}|2[0-4][0-9]|25[0-5]|[1-9]?[0-9])";
    
    
    NSString *port = [UTF8_NSString stringByMatching:regex];
    
    NSLog(@"port = %@",port);

    return port;
}
@end
