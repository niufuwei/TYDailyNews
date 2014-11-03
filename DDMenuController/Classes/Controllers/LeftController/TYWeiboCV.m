//
//  TYWeiboCV.m
//  TYDaily
//
//  Created by laoniu on 14/10/19.
//
//

#import "TYWeiboCV.h"

@implementation TYWeiboCV

{
    NSString * NEWSID;
    TYHttpRequest * httpRequest;
    NSString * userip;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

-(id)initWithFrame:(CGRect)frame ID:(NSString *)ID
{
    self = [super initWithFrame:frame];
    
    if(self)
    {
        NEWSID = ID;
        userip = @"192.168.1.1";
        UIImageView * heng = [[UIImageView alloc] initWithFrame:CGRectMake(10, 1, self.frame.size.width-20, 1)];
        [heng setBackgroundColor:[UIColor grayColor]];
        heng.alpha = 0.5;
        [self addSubview:heng];
        
        _textField = [[UITextField alloc] initWithFrame:CGRectMake(10, 10, self.frame.size.width-100, 30)];
        _textField.delegate = self;
        _textField.placeholder=@"请输入评论内容";
        _textField.layer.borderColor = [UIColor grayColor].CGColor;
        _textField.layer.borderWidth = 0.3;
        [_textField.layer setCornerRadius:5];
        [_textField setBackgroundColor:[UIColor whiteColor]];
        [self addSubview:_textField];
        
        
        UIButton * huifu =[ UIButton buttonWithType: UIButtonTypeCustom];
        huifu.frame = CGRectMake(_textField.frame.size.width+_textField.frame.origin.x+10, 10, 50, 30);
        [huifu setTitle:@"评论" forState:UIControlStateNormal];
        [huifu setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [huifu.layer setBorderColor:[UIColor redColor].CGColor];
        [huifu.layer setBorderWidth:0.5];
        [huifu.layer setCornerRadius:5];
        [huifu setBackgroundColor:[UIColor whiteColor]];
        [huifu addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:huifu];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onNotification:) name:@"request" object:nil];

        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex==0)
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
    else
    {
        
    }
}

-(void)onNotification:(NSNotification*)obj
{
    NSLog(@"%@",obj.object);
    
    NSArray * tempArray = (NSArray *)obj.object;
//    NSString * userid = [tempArray objectAtIndex:0];
//    NSString * strToken = [tempArray objectAtIndex:1];
}

-(void)onClick:(id)sender
{
    
    if(_textField.text.length ==0)
    {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"" message:@"评论不能为空" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
    else
    {

        if(![[NSUserDefaults standardUserDefaults] objectForKey:@"accessToken"])
        {
            UIAlertView * alert =[[UIAlertView alloc] initWithTitle:nil message:@"需要授权才能发表评论" delegate:self cancelButtonTitle:@"去授权" otherButtonTitles:@"离开", nil];
            alert.delegate = self;
            [alert show];

        }
        else
        {
            httpRequest = [[TYHttpRequest alloc] init];
            
            NSDictionary * dicT;
            if([[NSUserDefaults standardUserDefaults] objectForKey:@"accessToken"])
            {
                dicT = [[NSDictionary alloc] initWithObjects:[NSArray arrayWithObjects:[[NSUserDefaults standardUserDefaults]objectForKey:@"accessToken"],_textField.text,NEWSID,@"0",userip, nil] forKeys:[NSArray arrayWithObjects:@"access_token",@"comment",@"id",@"comment_ori",@"rip", nil]];
                
                [httpRequest httpRequestWeiBo:@"https://api.weibo.com/2/comments/create.json" parameter:dicT Success:^(id result) {
                    
                    _textField.text = @"";
                    
                    NSLog(@"评论成功-->%@",result);
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"WeiboUpdate" object:nil];
                    UIWindow *window = [[UIApplication sharedApplication].windows objectAtIndex:[[UIApplication sharedApplication].windows count]-1];
                    CBMBProgressHUD *indicator = [[CBMBProgressHUD alloc] initWithWindow:window];
                    indicator.labelText = @"评论成功";
                    
                    indicator.mode = MBProgressHUDModeText;
                    [window addSubview:indicator];
                    
                    //[[NSNotificationCenter defaultCenter] postNotificationName:@"updateComment" object:nil];
                    
                    [indicator showAnimated:YES whileExecutingBlock:^{
                        sleep(1.2);
                    } completionBlock:^{
                        [indicator removeFromSuperview];
                        
                    }];
                    
                    
                } Failure:^(NSError *error) {
                    
                    NSLog(@"ERROR＝＝>%@",error);
                    UIWindow *window = [[UIApplication sharedApplication].windows objectAtIndex:[[UIApplication sharedApplication].windows count]-1];
                    CBMBProgressHUD *indicator = [[CBMBProgressHUD alloc] initWithWindow:window];
                    indicator.labelText = @"评论失败";
                    
                    indicator.mode = MBProgressHUDModeText;
                    [window addSubview:indicator];
                    [indicator showAnimated:YES whileExecutingBlock:^{
                        sleep(1.2);
                    } completionBlock:^{
                        [indicator removeFromSuperview];
                        
                    }];
                } view:self isPost:TRUE];
                
                [self endEditing:YES];

        }
        
    }
    
    
    //    if(![[[NSUserDefaults standardUserDefaults] objectForKey:@"isLogin"] isEqualToString:@"1"])
    //    {
//            UIAlertView * alert =[[UIAlertView alloc] initWithTitle:nil message:@"需要登陆才能发表评论" delegate:self cancelButtonTitle:@"去登陆" otherButtonTitles:@"离开", nil];
//            alert.delegate = self;
//            [alert show];
    //    }
    //    else
    //    {
    //        if(_textField.text.length ==0)
    //        {
    //            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"" message:@"评论不能为空" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    //            [alert show];
    //        }
    //        else
    //        {
    //            httpRequest = [[TYHttpRequest alloc] init];
    //            [httpRequest httpRequest:@"comment/create" parameter:[NSString stringWithFormat:@"content=%@&author=%@",_textField.text,@"测试账号"] Success:^(id result) {
    //
    //                NSLog(@"%@",@"发送成功");
    //            } Failure:^(NSError *error) {
    //
    //                NSLog(@"ERROR");
    //            } view:self];
    //        }
    //
    //    }
    }
}

@end
