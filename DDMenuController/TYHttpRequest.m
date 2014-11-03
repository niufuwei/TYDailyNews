//
//  TYHttpRequest.m
//  TYDaily
//
//  Created by laoniu on 14-10-4.
//
//

#import "TYHttpRequest.h"

@implementation TYHttpRequest
{
    UIActivityIndicatorView * testActivityIndicator;
    BOOL isWeibo;
}

-(void)httpRequestWeiBo:(NSString*)service parameter:(id)parameter Success:(void(^)(id result))Success Failure:(void(^)(NSError*error))Failure view:(UIView*)view isPost:(BOOL)isPost
{
    testActivityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    testActivityIndicator.center = CGPointMake(view.frame.size.width/2-10,200);
    [view addSubview:testActivityIndicator];
    [testActivityIndicator bringSubviewToFront:view];
    testActivityIndicator.color = [UIColor blackColor]; // 改变圈圈的颜色为红色； iOS5引入
    [testActivityIndicator startAnimating]; // 开始旋转
    
    
    isWeibo = TRUE;
    
    if(self)
    {
        _mySuccess = Success;
        _myFailure = Failure;
    }
    
    if(parameter)
    {
        [self myHttpRequest:service parameter:parameter isPost:isPost];
        
    }
    else
    {
        [self myHttpRequest:service isPost:isPost];
        
    }

}

-(void)httpRequest:(NSString *)service parameter:(id )parameter Success:(void (^)(id result))Success Failure:(void (^)(NSError *error))Failure view:(UIView*)view isPost:(BOOL)isPost
{
    
    isWeibo = FALSE;
    
    testActivityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    testActivityIndicator.center = CGPointMake(view.frame.size.width/2-10,200);
    [view addSubview:testActivityIndicator];
    [testActivityIndicator bringSubviewToFront:view];
    testActivityIndicator.color = [UIColor blackColor]; // 改变圈圈的颜色为红色； iOS5引入
    [testActivityIndicator startAnimating]; // 开始旋转
    
    if(self)
    {
        _mySuccess = Success;
        _myFailure = Failure;
    }
    
    if(parameter)
    {
        [self myHttpRequest:service parameter:parameter isPost:isPost];

    }
    else
    {
        [self myHttpRequest:service isPost:isPost];

    }
}

-(void)myHttpRequest:(NSString *)service isPost:(BOOL)isPost
{
    NSString *strUrl=[NSString stringWithFormat:@"%@",service];
    NSLog(@"%@",strUrl);
    ASIFormDataRequest *request=[ASIFormDataRequest requestWithURL:[NSURL URLWithString:strUrl]];
    request.delegate=self;
    if(isPost)
    {
        [request setRequestMethod:@"POST"];

    }
    else
    {
        [request setRequestMethod:@"GET"];

    }
    
    
    request.tag=10010;
    request.timeOutSeconds=20;
    //    [request addPostValue:userid forKey:@"uid"];
    //    [request addPostValue:strToken forKey:@"access_token"];
    [request startAsynchronous];

}


-(void)myHttpRequest:(NSString *)service parameter:(id)parameter isPost:(BOOL)isPost
{
    if(isPost)
    {
        NSString *strUrl;
        if(isWeibo)
        {
            strUrl =[NSString stringWithFormat:@"%@",service];
        }
        else
        {
            strUrl =[NSString stringWithFormat:@"%@%@",SERVICEADDR,service];

        }
        NSLog(@"%@",strUrl);
        ASIFormDataRequest *request=[ASIFormDataRequest requestWithURL:[NSURL URLWithString:strUrl]];
        request.delegate=self;
        [request setRequestMethod:@"POST"];
        
        for(int i =0;i<[[parameter allKeys] count];i++)
        {
            NSLog(@"key=->%@,value-->%@",[[parameter allKeys ]objectAtIndex:i],[parameter objectForKey:[[parameter allKeys]objectAtIndex:i]]);
            [request addPostValue:[parameter objectForKey:[[parameter allKeys]objectAtIndex:i]] forKey:[[parameter allKeys ]objectAtIndex:i]];

        }
        
        request.tag=10010;
        request.timeOutSeconds=20;
        //    [request addPostValue:userid forKey:@"uid"];
        //    [request addPostValue:strToken forKey:@"access_token"];
        [request startAsynchronous];
        

    }
    else
    {
        NSString *strUrl;
        if(isWeibo)
        {
            if(parameter)
            {
                strUrl=[NSString stringWithFormat:@"%@?%@",service,parameter];

            }
            else
            {
                strUrl=[NSString stringWithFormat:@"%@",service];

            }
        }
        else
        {
            strUrl=[NSString stringWithFormat:@"%@%@&%@",SERVICEADDR,service,parameter];
        }
        NSLog(@"%@",strUrl);
        ASIFormDataRequest *request=[ASIFormDataRequest requestWithURL:[NSURL URLWithString:strUrl]];
        request.delegate=self;

        [request setRequestMethod:@"GET"];

        request.tag=10010;
        request.timeOutSeconds=20;
        //    [request addPostValue:userid forKey:@"uid"];
        //    [request addPostValue:strToken forKey:@"access_token"];
        [request startAsynchronous];

    }
 
        // Do any additional setup after loading the view.
}

- (void)requestFinished:(ASIHTTPRequest *)request
{
    
    [testActivityIndicator stopAnimating];
    // Use when fetching text data
    NSString *responseString = [request responseString];
    
    NSLog(@"%@",responseString);
    if(isWeibo)
    {
        _mySuccess(responseString);
    }
    else
    {
        const char* c = [responseString cStringUsingEncoding:NSISOLatin1StringEncoding];
        NSString * newString = [[NSString alloc] initWithCString:c encoding:NSUTF8StringEncoding];
        
        NSLog(@"%@",newString);
        _mySuccess(newString);
    }

    
    // Use when fetching binary data
    //    NSData *responseData = [request responseData];
    
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    [testActivityIndicator stopAnimating];

    NSError *error = [request error];

    _myFailure(error);
}
@end
