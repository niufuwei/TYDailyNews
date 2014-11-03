//
//  TYCommentView.m
//  TYDaily
//
//  Created by laoniu on 14-10-8.
//
//

#import "TYCommentView.h"

@implementation TYCommentView
{
    NSString * NEWSID;
    TYHttpRequest * httpRequest;
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
        [self addSubview:_textField];
        
        
        UIButton * huifu =[ UIButton buttonWithType: UIButtonTypeCustom];
        huifu.frame = CGRectMake(_textField.frame.size.width+_textField.frame.origin.x+10, 10, 50, 30);
        [huifu setTitle:@"评论" forState:UIControlStateNormal];
        [huifu setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [huifu.layer setBorderColor:[UIColor redColor].CGColor];
        [huifu.layer setBorderWidth:0.5];
        [huifu.layer setCornerRadius:5];
        [huifu addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:huifu];
        
    }
    return self;
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex==0)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"login" object:nil];
    }
    else
    {
       
    }
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
        httpRequest = [[TYHttpRequest alloc] init];
        
        NSDictionary * dic = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:_textField.text,@"匿名",NEWSID, nil] forKeys:[NSArray arrayWithObjects:@"content",@"author",@"id", nil]];
        
        NSString * strURL = @"";
        if(_isNesCenter)
        {
            strURL = [_address stringByReplacingOccurrencesOfString:@"view" withString:@"cc"];
        }
        else
        {
            strURL = @"comment/create";
        }
        
        [httpRequest httpRequest:strURL parameter:dic Success:^(id result) {
            
            _textField.text = @"";
            
            NSLog(@"评论成功-->%@",result);
            
            UIWindow *window = [[UIApplication sharedApplication].windows objectAtIndex:[[UIApplication sharedApplication].windows count]-1];
            CBMBProgressHUD *indicator = [[CBMBProgressHUD alloc] initWithWindow:window];
            indicator.labelText = @"评论成功";
            
            indicator.mode = MBProgressHUDModeText;
            [window addSubview:indicator];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"updateComment" object:nil];
            
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
    
    
//    if(![[[NSUserDefaults standardUserDefaults] objectForKey:@"isLogin"] isEqualToString:@"1"])
//    {
//        UIAlertView * alert =[[UIAlertView alloc] initWithTitle:nil message:@"需要登陆才能发表评论" delegate:self cancelButtonTitle:@"去登陆" otherButtonTitles:@"离开", nil];
//        alert.delegate = self;
//        [alert show];
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


@end
