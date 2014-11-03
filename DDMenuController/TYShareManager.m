//
//  TYShareManager.m
//  TYDaily
//
//  Created by laoniu on 14/11/3.
//
//

#import "TYShareManager.h"
#import <TencentOpenAPI/sdkdef.h>
#import <TencentOpenAPI/TencentOAuthObject.h>
#import <TencentOpenAPI/TencentMessageObject.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApi.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/QQApiInterfaceObject.h>

@interface TYShareManager ()<WBHttpRequestDelegate>
@property (nonatomic, strong) NSString *shareText;
@property (nonatomic, strong) NSString *shareTitle;
@property (nonatomic, strong) UIImage *shareImage;
@property (nonatomic, strong) NSString *urlString;


@end

@implementation TYShareManager

static TYShareManager *share = nil;

+(TYShareManager *)currentShare{
    
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        share = [[self alloc]init];
    });
    return share;
}

-(void)shareContentString:(NSString *)str title:(NSString *)title image:(UIImage *)image url:(NSString *)url{
    
    self.shareText = str;
    self.shareImage = image;
    self.shareTitle = title;
    self.urlString = url;
}


-(BOOL)hasWeiBoAppInstalled{
    
    return [WeiboSDK isWeiboAppInstalled];
}
-(void)shareWithWeiBo{
  
    [self shareWithContent];
    
    
    /*
     NSString *accessToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"accesstoken_SINA"];
     NSMutableDictionary* parameters = [NSMutableDictionary dictionary];
     //NSData *image =  [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"share_xiaoma@2x" ofType:@"png"]];
     
     
     
     //[parameters setObject:image forKey:@"pic"];
     [parameters setObject:@"小伙伴们，我正在使用#小马bank#理财手机客户端购买理财产品，低风险，零手续费，百元起购！这赚钱的好事还等什么？！  http://www.baidu.com" forKey:@"status"];
     
     NSLog(@"%@",parameters);
     
     [WBHttpRequest requestWithAccessToken:accessToken
     url:[NSString stringWithFormat:@"%@",@"https://api.weibo.com/2/statuses/update.json"]
     httpMethod:@"POST"
     params:parameters
     delegate:self
     withTag:@"1"];
     }
     
     */
    /*
     NSData *image =  [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"share_xiaoma@2x" ofType:@"png"]];
     NSString *status = @"小伙伴们，我正在使用#小马bank#理财手机客户端购买理财产品，低风险，零手续费，百元起购！这赚钱的好事还等什么？！  http://www.baidu.com";
     
     
     
     [parameters setObject:image forKey:@"pic"];
     [parameters setObject:status forKey:@"status"];
     
     // NSString *urlString = @"https://upload.api.weibo.com/2/statuses/upload.json";
     NSString *urlString = @"https://api.weibo.com/2/statuses/update.json";
     
     
     [WBHttpRequest requestWithAccessToken:accessToken
     url:[NSString stringWithFormat:@"%@",urlString]
     httpMethod:@"POST"
     params:parameters
     delegate:self
     withTag:@"1"];
     
     
     
     
     WBMessageObject *message = [WBMessageObject message];
     message.text = @"小伙伴们，我正在使用#小马bank#理财手机客户端购买理财产品，低风险，零手续费，百元起购！这赚钱的好事还等什么？！";
     
     WBImageObject *image = [WBImageObject object];
     
     image.imageData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"share_xiaoma@2x" ofType:@"png"]];
     message.imageObject = image;
     
     
     WBWebpageObject *url = [WBWebpageObject object];
     url.webpageUrl = @"www.baidu.com";
     
     // message.mediaObject = url;
     
     
     
     WBSendMessageToWeiboRequest *request = [WBSendMessageToWeiboRequest requestWithMessage:message];
     request.userInfo = @{@"ShareMessageFrom": @"SendMessageToWeiboViewController",
     @"Other_Info_1": [NSNumber numberWithInt:123],
     @"Other_Info_2": @[@"obj1", @"obj2"],
     @"Other_Info_3": @{@"key1": @"obj1", @"key2": @"obj2"}};
     [WeiboSDK sendRequest:request];
     */
}

-(void)shareWithContent{
    
  
    
     WBMessageObject *message = [WBMessageObject message];
     message.text = self.shareText;
     
     //WBProvideMessageForWeiboResponse *response = [WBProvideMessageForWeiboResponse responseWithMessage:message];
     //if ([WeiboSDK sendResponse:response]) {
     
     //}
     WBSendMessageToWeiboRequest *response = [WBSendMessageToWeiboRequest requestWithMessage:message];
     [WeiboSDK sendRequest:response];
    
}



/**
 收到一个来自微博Http请求的响应
 
 @param response 具体的响应对象
 */
- (void)request:(WBHttpRequest *)request didReceiveResponse:(NSURLResponse *)response{
    
}

/**
 收到一个来自微博Http请求失败的响应
 
 @param error 错误信息
 */
- (void)request:(WBHttpRequest *)request didFailWithError:(NSError *)error{
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 40)];
    label.backgroundColor = [UIColor colorWithRed:0.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:0.6];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    label.text = @"分享失败";
    label.center = [UIApplication sharedApplication].keyWindow.center;
    [[UIApplication sharedApplication].keyWindow addSubview:label];
    
    [self performSelector:@selector(removeLabel:) withObject:label afterDelay:2];
}

/**
 收到一个来自微博Http请求的网络返回
 
 @param result 请求返回结果
 */
- (void)request:(WBHttpRequest *)request didFinishLoadingWithResult:(NSString *)result{
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 40)];
    label.backgroundColor = [UIColor colorWithRed:0.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:0.6];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    label.text = @"分享成功";
    label.center = [UIApplication sharedApplication].keyWindow.center;
    [[UIApplication sharedApplication].keyWindow addSubview:label];
    
    [self performSelector:@selector(removeLabel:) withObject:label afterDelay:2];
}

-(void)removeLabel:(UILabel *)label{
    
    [label removeFromSuperview];
}

/**
 收到一个来自微博Http请求的网络返回
 
 @param data 请求返回结果
 
 - (void)request:(WBHttpRequest *)request didFinishLoadingWithDataResult:(NSData *)data{
 
 }
 */

-(void)shareWithQQZone:(int)way
{
    NSString *utf8String =self.urlString;
    NSString *title = self.shareTitle;
    NSString *description = self.shareText;
    //    NSString *previewImageUrl = @"http://cdni.wired.co.uk/620x413/k_n/NewsForecast%20copy_620x413.jpg";
    //    QQApiNewsObject *newsObj = [QQApiNewsObject
    //                                objectWithURL:[NSURL URLWithString:utf8String]
    //                                title:title
    //                                description:description
    //                                previewImageURL:[NSURL URLWithString:previewImageUrl]];
    
    NSData *data;
    if (UIImagePNGRepresentation(self.shareImage) == nil) {
        
        data = UIImageJPEGRepresentation(self.shareImage, 1);
        
    } else {
        
        data = UIImagePNGRepresentation(self.shareImage);
    }
    
    QQApiNewsObject * newsObj = [QQApiNewsObject objectWithURL:[NSURL URLWithString:utf8String] title:title description:description previewImageData:data];
    
    SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:newsObj];
    //将内容分享到qq
    //    QQApiSendResultCode sent = [QQApiInterface sendReq:req];
    //将内容分享到qzone
    QQApiSendResultCode sent = [QQApiInterface SendReqToQZone:req];
}

-(void)shareWithQQ:(int)way
{
    NSString *utf8String =self.urlString;
    NSString *title = self.shareTitle;
    NSString *description = self.shareText;
    //    NSString *previewImageUrl = @"http://cdni.wired.co.uk/620x413/k_n/NewsForecast%20copy_620x413.jpg";
    //    QQApiNewsObject *newsObj = [QQApiNewsObject
    //                                objectWithURL:[NSURL URLWithString:utf8String]
    //                                title:title
    //                                description:description
    //                                previewImageURL:[NSURL URLWithString:previewImageUrl]];
    
    NSData *data;
    if (UIImagePNGRepresentation(self.shareImage) == nil) {
        
        data = UIImageJPEGRepresentation(self.shareImage, 1);
        
    } else {
        
        data = UIImagePNGRepresentation(self.shareImage);
    }
    
    QQApiNewsObject * newsObj = [QQApiNewsObject objectWithURL:[NSURL URLWithString:utf8String] title:title description:description previewImageData:data];
    
    SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:newsObj];
    //将内容分享到qq
    QQApiSendResultCode sent = [QQApiInterface sendReq:req];
    //将内容分享到qzone
    //    QQApiSendResultCode sent = [QQApiInterface SendReqToQZone:req];
}

#pragma mark-
#pragma mark------微信分享------

-(void)shareWithWeiXin:(int)way{
    
    BOOL weiXin = [WXApi isWXAppInstalled];
    if (!weiXin) {
        UIAlertView * alert =[[UIAlertView alloc] initWithTitle:nil message:@"请先安装微信" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    
    WXMediaMessage *message = [WXMediaMessage message];
    
    
    
    message.title = self.shareTitle;
    message.description = self.shareText;
    [message setThumbImage:self.shareImage];
    
    if (way == 1) {
        message.title = [NSString stringWithFormat:@"%@ %@",self.shareTitle,self.shareText];
    }
    
    
    
    WXWebpageObject *ext = [WXWebpageObject object];
    ext.webpageUrl = self.urlString;
    
    message.mediaObject = ext;
    
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    req.scene = way;
    
    [WXApi sendReq:req];
}

@end
