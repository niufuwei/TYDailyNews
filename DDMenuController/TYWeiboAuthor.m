//
//  TYWeiboAuthor.m
//  TYDaily
//
//  Created by laoniu on 14-10-15.
//
//

#import "TYWeiboAuthor.h"
#import "WeiboSDK.h"

@implementation TYWeiboAuthor

-(void)sendWeiBoAuthorRequest:(void (^)(id))BackResult error:(void (^)(id))error
{
   
    


}


//- (void)request:(WBHttpRequest *)request didFinishLoadingWithResult:(NSString *)result
//{
//    NSString *title = nil;
//    UIAlertView *alert = nil;
//    
//    title = @"收到网络回调";
//    alert = [[UIAlertView alloc] initWithTitle:title
//                                       message:[NSString stringWithFormat:@"登陆成功"]
//                                      delegate:nil
//                             cancelButtonTitle:@"确定"
//                             otherButtonTitles:nil];
//    
//    [alert show];
//    _backBlock(result);
//
//}
//
//- (void)request:(WBHttpRequest *)request didFailWithError:(NSError *)error;
//{
//    NSString *title = nil;
//    UIAlertView *alert = nil;
//    
//    title = @"请求异常";
//    alert = [[UIAlertView alloc] initWithTitle:title
//                                       message:[NSString stringWithFormat:@"%@",error]
//                                      delegate:nil
//                             cancelButtonTitle:@"确定"
//                             otherButtonTitles:nil];
//    [alert show];
//}

@end
