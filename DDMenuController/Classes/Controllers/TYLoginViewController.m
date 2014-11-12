//
//  TYLoginViewController.m
//  TYDaily
//
//  Created by laoniu on 14-10-3.
//
//

#import "TYLoginViewController.h"
#import "TYRegistViewController.h"
#import <TencentOpenAPI/sdkdef.h>
#import <TencentOpenAPI/TencentOAuthObject.h>
#import <TencentOpenAPI/TencentMessageObject.h>
#import <TencentOpenAPI/QQApi.h>
//#import <TencentOpenAPI/TencentOpenSDK.h>
#import <TencentOpenAPI/TencentOAuthObject.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import "TYWeiboAuthor.h"

@interface TYLoginViewController ()<TencentLoginDelegate,TencentSessionDelegate>
{
    UIScrollView * backGroundScrollview;
    NavCustom * custom;
    TencentOAuth *_tencentOAuth;
    NSArray *_permissions;
    TYHttpRequest * httpRequest;
    
    UIColor * myBlackColor;
    UIColor * myWhiteColor;
}

@end
#define kRedirectURI    @"http://www.sina.com"
NSString * appid = @"1103377162";

@implementation TYLoginViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    if([[[NSUserDefaults standardUserDefaults] objectForKey:@"isDayShow"] isEqualToString:@"0"])
    {
        myBlackColor = [UIColor whiteColor];
        myWhiteColor = [UIColor grayColor];
    }
    else
    {
        myWhiteColor = [UIColor whiteColor];
        myBlackColor = [UIColor grayColor];
    }

    
    httpRequest = [[TYHttpRequest alloc] init];
    
    
    backGroundScrollview = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    backGroundScrollview.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height+1);
    [self.view addSubview:backGroundScrollview];
    backGroundScrollview.delegate =self;
    [self.view setBackgroundColor:myWhiteColor];
    backGroundScrollview.backgroundColor = myWhiteColor;
    
    custom = [[NavCustom alloc] init];
    [custom setNavWithText:@"登陆注册" mySelf:self];
    custom.NavDelegate  =self;
    //视图
    [custom setNavLeftBtnImage:@"back.png" LeftBtnSelectedImage:@"" mySelf:self width:10 height:15];

    _permissions = [NSArray arrayWithObjects:
                     kOPEN_PERMISSION_GET_USER_INFO,
                     kOPEN_PERMISSION_GET_SIMPLE_USER_INFO,
                     kOPEN_PERMISSION_ADD_ALBUM,
                     kOPEN_PERMISSION_ADD_IDOL,
                     kOPEN_PERMISSION_ADD_ONE_BLOG,
                     kOPEN_PERMISSION_ADD_PIC_T,
                     kOPEN_PERMISSION_ADD_SHARE,
                     kOPEN_PERMISSION_ADD_TOPIC,
                     kOPEN_PERMISSION_CHECK_PAGE_FANS,
                     kOPEN_PERMISSION_DEL_IDOL,
                     kOPEN_PERMISSION_DEL_T,
                     kOPEN_PERMISSION_GET_FANSLIST,
                     kOPEN_PERMISSION_GET_IDOLLIST,
                     kOPEN_PERMISSION_GET_INFO,
                     kOPEN_PERMISSION_GET_OTHER_INFO,
                     kOPEN_PERMISSION_GET_REPOST_LIST,
                     kOPEN_PERMISSION_LIST_ALBUM,
                     kOPEN_PERMISSION_UPLOAD_PIC,
                     kOPEN_PERMISSION_GET_VIP_INFO,
                     kOPEN_PERMISSION_GET_VIP_RICH_INFO,
                     kOPEN_PERMISSION_GET_INTIMATE_FRIENDS_WEIBO,
                     kOPEN_PERMISSION_MATCH_NICK_TIPS_WEIBO,
                     nil];

    _tencentOAuth  = [[TencentOAuth alloc] initWithAppId:appid andDelegate:self];

    [self layoutView];
    
    // Do any additional setup after loading the view.
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}

-(void)tencentDidNotNetWork
{
    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message:@"请检查网络" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
}


-(void)layoutView
{
    UILabel * text = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, self.view.frame.size.width, 20)];
    text.text = @"已有账户请登录:";
    text.textColor = myBlackColor;
    text.font = [UIFont systemFontOfSize:14];
    [backGroundScrollview addSubview:text];
    
    UIImageView * imageUN = [[UIImageView alloc] initWithFrame:CGRectMake(20, text.frame.size.height+text.frame.origin.y+10, self.view.frame.size.width-40, 40)];
    [imageUN setImage:[UIImage imageNamed:@"ID.png"]];
    [backGroundScrollview addSubview:imageUN];
    
    _userName = [[UITextField alloc] initWithFrame:CGRectMake(30, text.frame.size.height+text.frame.origin.y+10, self.view.frame.size.width-50, 40)];
    _userName.backgroundColor = [UIColor clearColor];
    _userName.placeholder = @"手机号";
    [backGroundScrollview addSubview:_userName];
    
    UIImageView * imagePW = [[UIImageView alloc] initWithFrame:CGRectMake(20, _userName.frame.size.height+_userName.frame.origin.y+10, self.view.frame.size.width-40, 40)];
    [imagePW setImage:[UIImage imageNamed:@"password.png"]];
    [backGroundScrollview addSubview:imagePW];
    
    _passWord = [[UITextField alloc] initWithFrame:CGRectMake(30, _userName.frame.size.height+_userName.frame.origin.y+10, self.view.frame.size.width-50, 40)];
    _passWord.backgroundColor = [UIColor clearColor];
    _passWord.placeholder = @"输入密码";
    [backGroundScrollview addSubview:_passWord];

    _forgetPassword = [UIButton buttonWithType:UIButtonTypeCustom];
    _forgetPassword.frame=  CGRectMake(20, _passWord.frame.size.height+_passWord.frame.origin.y+20, 100, 20);
    _forgetPassword.titleLabel.font = [UIFont systemFontOfSize:13];
    [_forgetPassword setTitle:@"忘记密码" forState:UIControlStateNormal];
    [_forgetPassword setTitleColor:myBlackColor forState:UIControlStateNormal];
    _forgetPassword.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    _forgetPassword.tag = 101;
    [_forgetPassword addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];

    [backGroundScrollview addSubview:_forgetPassword];
    
    
    _login = [UIButton buttonWithType:UIButtonTypeCustom];
    _login.frame=  CGRectMake(self.view.frame.size.width-80, _passWord.frame.size.height+_passWord.frame.origin.y+15, 70, 30);
    _login.titleLabel.font = [UIFont systemFontOfSize:16];
    [_login setTitle:@"登录" forState:UIControlStateNormal];
    [_login setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_login setBackgroundImage:[UIImage imageNamed:@"button.png"] forState:UIControlStateNormal];
    _login.tag = 102;
    [_login addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
    [backGroundScrollview addSubview:_login];
    
    UIImageView * imageHeng = [[UIImageView alloc] initWithFrame:CGRectMake(20, _forgetPassword.frame.size.height+_forgetPassword.frame.origin.y+15, self.view.frame.size.width-40, 1)];
    [imageHeng setImage:[UIImage imageNamed:@"line1.png"]];
    [backGroundScrollview addSubview:imageHeng];
    
    
    UILabel * text2 = [[UILabel alloc] initWithFrame:CGRectMake(20, imageHeng.frame.size.height+imageHeng.frame.origin.y+10,self.view.frame.size.width-40, 20)];
    text2.text = @"使用其他方式登录:";
    text2.font = [UIFont systemFontOfSize:14];
    text2.textColor = myBlackColor;
    [backGroundScrollview addSubview:text2];

    _qq = [UIButton buttonWithType:UIButtonTypeCustom];
    _qq.frame=  CGRectMake(self.view.frame.size.width/2-40, text2.frame.size.height+text2.frame.origin.y+10, 25, 27);
    [_qq setBackgroundImage:[UIImage imageNamed:@"qq.png"] forState:UIControlStateNormal];
    _qq.tag = 103;
    [_qq addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];

    [backGroundScrollview addSubview:_qq];

    
    _weibo = [UIButton buttonWithType:UIButtonTypeCustom];
    _weibo.frame=  CGRectMake(_qq.frame.size.width+_qq.frame.origin.x+40, text2.frame.size.height+text2.frame.origin.y+10, 25, 27);
    [_weibo setBackgroundImage:[UIImage imageNamed:@"weibo.png"] forState:UIControlStateNormal];
    _weibo.tag = 104;
    [_weibo addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];

    [backGroundScrollview addSubview:_weibo];

    UIImageView * imageHeng2 = [[UIImageView alloc] initWithFrame:CGRectMake(20, _weibo.frame.size.height+_weibo.frame.origin.y+15, self.view.frame.size.width-40, 1)];
    [imageHeng2 setImage:[UIImage imageNamed:@"line1.png"]];
    [backGroundScrollview addSubview:imageHeng2];
    
    
    UILabel * text3 = [[UILabel alloc] initWithFrame:CGRectMake(20, imageHeng2.frame.size.height+imageHeng2.frame.origin.y+10,self.view.frame.size.width-40, 20)];
    text3.text = @"选择注册方式:";
    text3.font = [UIFont systemFontOfSize:14];
    text3.textColor =myBlackColor;
    [backGroundScrollview addSubview:text3];
    
    
    _usePhoneRegist = [UIButton buttonWithType:UIButtonTypeCustom];
    _usePhoneRegist.frame=  CGRectMake(self.view.frame.size.width-20-125, text3.frame.size.height+text3.frame.origin.y+10, 125, 25);
    _usePhoneRegist.titleLabel.font = [UIFont systemFontOfSize:14];
    [_usePhoneRegist setTitle:@"使用手机号注册" forState:UIControlStateNormal];
    [_usePhoneRegist setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_usePhoneRegist setBackgroundImage:[UIImage imageNamed:@"button.png"] forState:UIControlStateNormal];
    _usePhoneRegist.tag = 105;
    [_usePhoneRegist addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];

    [backGroundScrollview addSubview:_usePhoneRegist];
    
//    _useEmailRegist = [UIButton buttonWithType:UIButtonTypeCustom];
//    _useEmailRegist.frame=  CGRectMake(self.view.frame.size.width-20-125, text3.frame.size.height+text3.frame.origin.y+10, 125, 25);
//    _useEmailRegist.titleLabel.font = [UIFont systemFontOfSize:14];
//    [_useEmailRegist setTitle:@"使用邮箱注册" forState:UIControlStateNormal];
//    [_useEmailRegist setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [_useEmailRegist setBackgroundImage:[UIImage imageNamed:@"button.png"] forState:UIControlStateNormal];
//    _useEmailRegist.tag = 106;
//    [_useEmailRegist addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
//
//    [backGroundScrollview addSubview:_useEmailRegist];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onNotification:) name:@"request" object:nil];

}

-(void)onClick:(id)sender
{
    UIButton * btn = (UIButton*)sender;
    switch (btn.tag) {
        case 101:
        {
            //忘记密码
            
        }
            break;
        case 102:
        {
            [self httpRequest:_userName.text password:_passWord.text type:@"0"];
        }
            break;
        case 103:
        {
            //qq
            appDelegate.indexShare = 3;
            [_tencentOAuth authorize:_permissions inSafari:YES];
        }
            break;
        case 104:
        {
        
            appDelegate.indexShare = 0;
            
            //weibvo
            
            WBAuthorizeRequest *request = [WBAuthorizeRequest request];
            request.redirectURI = kRedirectURI;
            request.scope = @"all";
            request.userInfo = @{@"SSO_From": @"SendMessageToWeiboViewController",
                                 @"Other_Info_1": [NSNumber numberWithInt:123],
                                 @"Other_Info_2": @[@"obj1", @"obj2"],
                                 @"Other_Info_3": @{@"key1": @"obj1", @"key2": @"obj2"}};
            [WeiboSDK sendRequest:request];
        }
            
            break;
        case 105:
        {
            //手机注册
            TYRegistViewController * regist = [[TYRegistViewController alloc] init];
//            regist.strType = @"1";
            [self.navigationController pushViewController:regist animated:YES];
        }
            break;
        case 106:
        {
            //邮箱注册
//            TYRegistViewController * regist = [[TYRegistViewController alloc] init];
//            regist.strType = @"2";
//            [self.navigationController pushViewController:regist animated:YES];
        }
            break;
            
            
        default:
            break;
    }
}

-(void)httpRequest:(NSString *)user password:(NSString*)password type:(NSString*)type
{
    //登录
    NSMutableDictionary * dic = [[NSMutableDictionary alloc] initWithObjects:[NSArray arrayWithObjects:user,password,type,nil] forKeys:[NSArray arrayWithObjects:@"account",@"password",@"type", nil]];
    [httpRequest httpRequest:@"site/login" parameter:dic Success:^(id result) {
        
        NSLog(@"%@",result);
        NSData * data = [result dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary * dic2 = [data objectFromJSONData];
        
        if([[dic2 objectForKey:@"code"] isEqualToString:@"1"])
        {
            UIWindow *window = [[UIApplication sharedApplication].windows objectAtIndex:[[UIApplication sharedApplication].windows count]-1];
            CBMBProgressHUD *indicator = [[CBMBProgressHUD alloc] initWithWindow:window];
            indicator.labelText = @"登陆成功";
            
            indicator.mode = MBProgressHUDModeText;
            [window addSubview:indicator];
            [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"isLogin"];
            [[NSUserDefaults standardUserDefaults] setObject:[dic2 objectForKey:@"account_id"] forKey:@"userID"];
            [[NSUserDefaults standardUserDefaults] setObject:[dic2 objectForKey:@"nick"] forKey:@"userName"];
            
            [indicator showAnimated:YES whileExecutingBlock:^{
                sleep(1.2);
            } completionBlock:^{
                [indicator removeFromSuperview];
                [self dismissViewControllerAnimated:YES completion:^{
                    
                }];
            }];
            
        }
        else
        {
            UIWindow *window = [[UIApplication sharedApplication].windows objectAtIndex:[[UIApplication sharedApplication].windows count]-1];
            CBMBProgressHUD *indicator = [[CBMBProgressHUD alloc] initWithWindow:window];
            indicator.labelText = @"账号或密码错误";
            
            indicator.mode = MBProgressHUDModeText;
            [window addSubview:indicator];
            
            [indicator showAnimated:YES whileExecutingBlock:^{
                sleep(1.2);
            } completionBlock:^{
                [indicator removeFromSuperview];
                
            }];
            
        }
        
        
    } Failure:^(NSError *error) {
        
    } view:self.view isPost:TRUE];

}


-(void)onNotification:(NSNotification*)obj
{
    NSLog(@"%@",obj.object);
    
    NSArray * tempArray = (NSArray *)obj.object;
    NSString * userid = [tempArray objectAtIndex:0];
    NSString * strToken = [tempArray objectAtIndex:1];
    
    
    NSString *strUrl=[NSString stringWithFormat:@"https://api.weibo.com/2/users/show.json?access_token=%@&uid=%@",strToken,userid];
    ASIFormDataRequest *request=[ASIFormDataRequest requestWithURL:[NSURL URLWithString:strUrl]];
    request.delegate=self;
    [request setRequestMethod:@"GET"];
    request.tag=10010;
    request.timeOutSeconds=60;
    //    [request addPostValue:userid forKey:@"uid"];
    //    [request addPostValue:strToken forKey:@"access_token"];
    [request startAsynchronous];
    
    
}



- (void)requestFinished:(ASIHTTPRequest *)request
{
    // Use when fetching text data
    NSString *responseString = [request responseString];
    
    NSLog(@"%@",responseString);
    NSData * data = [responseString dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary * dic = [data objectFromJSONData];

//    NSLog(@"%@",[dic objectForKey:@"id"]);
    NSLog(@"%@",[dic objectForKey:@"screen_name"]);
 
    [self httpRequest:[dic objectForKey:@"screen_name"] password:@"" type:@"2"];
}

- (void)requestFailed:(ASIHTTPRequest *)request
{
    NSError *error = [request error];
    NSLog(@"%@",error);
    
    UIWindow *window = [[UIApplication sharedApplication].windows objectAtIndex:[[UIApplication sharedApplication].windows count]-1];
    CBMBProgressHUD *indicator = [[CBMBProgressHUD alloc] initWithWindow:window];
    indicator.labelText = @"登陆失败";
    
    indicator.mode = MBProgressHUDModeText;
    [window addSubview:indicator];
    
    [indicator showAnimated:YES whileExecutingBlock:^{
        sleep(1.2);
    } completionBlock:^{
        [indicator removeFromSuperview];
        
    }];

}

- (void)tencentDidLogin {
    // 登录成功
    
    if (_tencentOAuth.accessToken
        && 0 != [_tencentOAuth.accessToken length])
    {
//        _labelAccessToken.text = _tencentOAuth.accessToken;
        NSLog(@"%@",_tencentOAuth.description);
        NSLog(@"%@",_tencentOAuth.debugDescription);
        
//        [_tencentOAuth setAccessToken:];
//        [_tencentOAuth setOpenId:];
//        [_tencentOAuth setExpirationDate:];
//
        
        httpRequest = [[TYHttpRequest alloc] init];
        [httpRequest httpRequestWeiBo:@"https://openmobile.qq.com/user/get_simple_userinfo" parameter:[NSString stringWithFormat:@"access_token=%@&oauth_consumer_key=%@&openid=%@",[_tencentOAuth accessToken],@"1103377162",[_tencentOAuth openId]] Success:^(id result) {
            
            NSLog(@"%@",result);
            
            NSData * data = [result dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary * dic = [data objectFromJSONData];
            [self httpRequest:[dic objectForKey:@"nickname"] password:@"" type:@"1"];
        } Failure:^(NSError *error) {
            
            NSLog(@"%@",error);
        } view:self.view isPost:NO];
    }
    else
    {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message:@"用户登陆失败" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
}


/**
 * Called when the user dismissed the dialog without logging in.
 */
- (void)tencentDidNotLogin:(BOOL)cancelled
{
    if (cancelled){
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message:@"用户取消登陆" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
    else {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message:@"用户登陆失败" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];    }
    
}

-(void)NavLeftButtononClick
{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
