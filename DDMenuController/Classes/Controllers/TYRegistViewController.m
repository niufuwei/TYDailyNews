//
//  TYRegistViewController.m
//  TYDaily
//
//  Created by laoniu on 14-10-3.
//
//

#import "TYRegistViewController.h"

@interface TYRegistViewController ()
{
    NavCustom * myNavcustom;
    UILabel * textType;
    UIScrollView *backGroundScrollview;
    TYHttpRequest * httpRequest;
    NSInteger xingbie ;
}

@end

@implementation TYRegistViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    xingbie = -1;
    myNavcustom = [[NavCustom alloc] init];
    
    backGroundScrollview = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    backGroundScrollview.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height+1);
    backGroundScrollview.delegate =self;
    [self.view addSubview:backGroundScrollview];

    
//    if(![_strType isEqualToString:@"1"])
//    {
//        [myNavcustom setNavWithText:@"邮箱注册" mySelf:self];
//
//    }
//    else
//    {
        [myNavcustom setNavWithText:@"手机号注册" mySelf:self];

//    }
    [self layoutView];
    // Do any additional setup after loading the view.
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
    [UIView animateWithDuration:0.5 animations:^{
        CGRect yy = backGroundScrollview.frame ;
        yy.origin.y =  0;
        backGroundScrollview.frame = yy;
    }];
}

-(void)layoutView
{
    NSString * tempType;
    textType = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, self.view.frame.size.width, 20)];
//    if(![_strType isEqualToString:@"1"])
//    {
//        tempType = @"输入邮箱:";
//
//    }
//    else
//    {
        tempType = @"输入手机号码:";

//    }
    textType.text = tempType;
    textType.textColor = [UIColor grayColor];
    textType.font = [UIFont systemFontOfSize:14];
    [backGroundScrollview addSubview:textType];
    
    UIImageView * imageUN = [[UIImageView alloc] initWithFrame:CGRectMake(20, textType.frame.size.height+textType.frame.origin.y+10, self.view.frame.size.width-40, 40)];
    [imageUN setImage:[UIImage imageNamed:@"ID.png"]];
    [backGroundScrollview addSubview:imageUN];
    
    _Textfield = [[UITextField alloc] initWithFrame:CGRectMake(30, textType.frame.size.height+textType.frame.origin.y+10, self.view.frame.size.width-50, 40)];
    _Textfield.backgroundColor = [UIColor clearColor];
    _Textfield.placeholder = tempType;
    [backGroundScrollview addSubview:_Textfield];
    
//    UIImageView * imagePW = [[UIImageView alloc] initWithFrame:CGRectMake(20, _Textfield.frame.size.height+_Textfield.frame.origin.y+10, 150, 40)];
//    [imagePW setImage:[UIImage imageNamed:@"code.png"]];
//    [backGroundScrollview addSubview:imagePW];
//    
//    _code = [[UITextField alloc] initWithFrame:CGRectMake(30, _Textfield.frame.size.height+_Textfield.frame.origin.y+10, 140, 40)];
//    _code.backgroundColor = [UIColor clearColor];
//    _code.placeholder = @"输入验证码";
//    [backGroundScrollview addSubview:_code];
//    
//    _getCode = [UIButton buttonWithType:UIButtonTypeCustom];
//    _getCode.frame=  CGRectMake(_code.frame.size.width+_code.frame.origin.x+30, _Textfield.frame.size.height+_Textfield.frame.origin.y+15, 100, 30);
//    _getCode.titleLabel.font = [UIFont systemFontOfSize:16];
//    [_getCode setTitle:@"获取验证码" forState:UIControlStateNormal];
//    [_getCode setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [_getCode setBackgroundImage:[UIImage imageNamed:@"button.png"] forState:UIControlStateNormal];
//    _getCode.tag = 101;
//    [_getCode addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
//    [backGroundScrollview addSubview:_getCode];

//    _usePhone = [UIButton buttonWithType:UIButtonTypeCustom];
//    _usePhone.frame=  CGRectMake(self.view.frame.size.width-20-100, _getCode.frame.size.height+_getCode.frame.origin.y+20, 100, 20);
//    _usePhone.titleLabel.font = [UIFont systemFontOfSize:13];
//    if([_strType isEqualToString:@"1"])
//    {
//        [_usePhone setTitle:@"使用邮箱注册" forState:UIControlStateNormal];
//
//    }
//    else
//    {
//        [_usePhone setTitle:@"使用手机注册" forState:UIControlStateNormal];

//    }
//    [_usePhone setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    _usePhone.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
//    _usePhone.tag = 102;
//    [_usePhone addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
//    
//    [backGroundScrollview addSubview:_usePhone];

    
    UIImageView * imageHeng = [[UIImageView alloc] initWithFrame:CGRectMake(20, _Textfield.frame.size.height+_Textfield.frame.origin.y+10, self.view.frame.size.width-40, 1)];
    [imageHeng setImage:[UIImage imageNamed:@"line1.png"]];
    [backGroundScrollview addSubview:imageHeng];
    
    UILabel * touxiangset = [[UILabel alloc] initWithFrame:CGRectMake(20, imageHeng.frame.size.height+imageHeng.frame.origin.y+10, self.view.frame.size.width, 20)];
    
    touxiangset.text = @"账户设置:";
    touxiangset.textColor = [UIColor grayColor];
    touxiangset.font = [UIFont systemFontOfSize:14];
    [backGroundScrollview addSubview:touxiangset];
    
    
    UIButton * nanButton = [UIButton buttonWithType:UIButtonTypeCustom];
    nanButton.frame = CGRectMake(self.view.frame.size.width/2-60, touxiangset.frame.size.height+touxiangset.frame.origin.y+10, 60, 60);
    [nanButton setBackgroundImage:[UIImage imageNamed:@"nan"] forState:UIControlStateNormal];
    nanButton.tag = 10086;
    [nanButton addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
    [backGroundScrollview addSubview:nanButton];
    
    
    UIButton * nvButton = [UIButton buttonWithType:UIButtonTypeCustom];
    nvButton.frame = CGRectMake(nanButton.frame.size.width+nanButton.frame.origin.x+20, touxiangset.frame.size.height+touxiangset.frame.origin.y+10, 60, 60);
    [nvButton setBackgroundImage:[UIImage imageNamed:@"nv"] forState:UIControlStateNormal];
    nvButton.tag = 10010;
    [nvButton addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
    [backGroundScrollview addSubview:nvButton];
    
    UILabel * set = [[UILabel alloc] initWithFrame:CGRectMake(20, nvButton.frame.size.height+nvButton.frame.origin.y+10, self.view.frame.size.width, 20)];
    
    set.text = @"账户设置:";
    set.textColor = [UIColor grayColor];
    set.font = [UIFont systemFontOfSize:14];
    [backGroundScrollview addSubview:set];
    
    UIImageView * imageUNn = [[UIImageView alloc] initWithFrame:CGRectMake(20, set.frame.size.height+set.frame.origin.y+10, self.view.frame.size.width-40, 40)];
    [imageUNn setImage:[UIImage imageNamed:@"ID.png"]];
    [backGroundScrollview addSubview:imageUNn];
    
    _usename = [[UITextField alloc] initWithFrame:CGRectMake(30, set.frame.size.height+set.frame.origin.y+10, self.view.frame.size.width-50, 40)];
    _usename.backgroundColor = [UIColor clearColor];
    _usename.placeholder = @"输入昵称";
    _usename.tag = 101;
    _usename.delegate = self;
    [backGroundScrollview addSubview:_usename];
    
    UIImageView * imagePWw = [[UIImageView alloc] initWithFrame:CGRectMake(20, _usename.frame.size.height+_usename.frame.origin.y+10, self.view.frame.size.width-40, 40)];
    [imagePWw setImage:[UIImage imageNamed:@"password.png"]];
    [backGroundScrollview addSubview:imagePWw];
    
    _password = [[UITextField alloc] initWithFrame:CGRectMake(30, _usename.frame.size.height+_usename.frame.origin.y+10, self.view.frame.size.width-50, 40)];
    _password.backgroundColor = [UIColor clearColor];
    _password.placeholder = @"输入密码";
    _password.tag = 102;
    _password.delegate =self;
    [backGroundScrollview addSubview:_password];

    
    _regist = [UIButton buttonWithType:UIButtonTypeCustom];
    _regist.frame=  CGRectMake(self.view.frame.size.width-20-80, _password.frame.size.height+_password.frame.origin.y+15, 80, 30);
    _regist.titleLabel.font = [UIFont systemFontOfSize:16];
    [_regist setTitle:@"注册" forState:UIControlStateNormal];
    [_regist setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_regist setBackgroundImage:[UIImage imageNamed:@"button.png"] forState:UIControlStateNormal];
    _regist.tag = 103;
    [_regist addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
    [backGroundScrollview addSubview:_regist];
   
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if(textField.tag ==101)
    {
        [UIView animateWithDuration:0.5 animations:^{
            
            CGRect yy = backGroundScrollview.frame ;
            yy.origin.y = -100;
            backGroundScrollview.frame = yy;
        }];
    }
    else if(textField.tag ==102)
    {
        [UIView animateWithDuration:0.5 animations:^{
            
            CGRect yy = backGroundScrollview.frame ;
            yy.origin.y =  -100;
            backGroundScrollview.frame = yy;
        }];
    }
    return YES;
}


-(void)onClick:(id)sender
{
    UIButton * button = (UIButton*)sender;
    switch (button.tag) {
        case 101:
        {
            //获取验证码
        }
            break;
        case 102:
        {
            //切换注册方式
//            if([_strType isEqualToString:@"1"])
//            {
//                textType.text = @"输入邮箱";
//                [_usePhone setTitle:@"使用手机号注册" forState:UIControlStateNormal];
//                _strType = @"2";
//                _Textfield.placeholder = @"请输入邮箱";
//                [myNavcustom setNavWithText:@"邮箱注册" mySelf:self];
//            }
//            else
//            {
//                textType.text = @"输入手机号码";
//                [_usePhone setTitle:@"使用邮箱注册" forState:UIControlStateNormal];
//                _strType = @"1";
//                _Textfield.placeholder = @"请输入手机号";
//                [myNavcustom setNavWithText:@"手机号注册" mySelf:self];
//            }
        }
            break;
        case 103:
        {
            if([_Textfield.text length] ==0 ||[_password.text length] ==0 ||[_usename.text length] ==0 || xingbie ==-1)
            {
                UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"" message:@"请将您的信息填写完整." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alert show];
            }
            else
            {
                //注册
                httpRequest = [[TYHttpRequest alloc] init];
                
                NSString * tb = [NSString stringWithFormat:@"%d",xingbie];
                
                NSDictionary * dic = [[NSDictionary alloc] initWithObjects:[NSArray arrayWithObjects:_Textfield.text,_password.text,_usename.text,tb, nil] forKeys:[NSArray arrayWithObjects:@"account",@"password",@"nick",@"sex", nil]];
                
                [httpRequest httpRequest:@"site/register" parameter:dic Success:^(id result) {
                    
                    NSData * data = [result dataUsingEncoding:NSUTF8StringEncoding];
                    NSDictionary * dic = [data objectFromJSONData];
                    
                    if([[dic objectForKey:@"code"] isEqualToString:@"1"])
                    {
                        UIWindow *window = [[UIApplication sharedApplication].windows objectAtIndex:[[UIApplication sharedApplication].windows count]-1];
                        CBMBProgressHUD *indicator = [[CBMBProgressHUD alloc] initWithWindow:window];
                        indicator.labelText = @"注册成功";
                        
                        indicator.mode = MBProgressHUDModeText;
                        [window addSubview:indicator];
                        
                        [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"isLogin"];
                        [[NSUserDefaults standardUserDefaults] setObject:[dic objectForKey:@"account_id"] forKey:@"userID"];
                        [[NSUserDefaults standardUserDefaults] setObject:[dic objectForKey:@"nick"] forKey:@"userName"];

                        [indicator showAnimated:YES whileExecutingBlock:^{
                            sleep(1.2);
                        } completionBlock:^{
                            [indicator removeFromSuperview];
                            [self dismissViewControllerAnimated:YES completion:^{
                                
                            }];
                        }];
                         
                    }
                    else if([[dic objectForKey:@"code"] isEqualToString:@"0"])
                    {
                        UIWindow *window = [[UIApplication sharedApplication].windows objectAtIndex:[[UIApplication sharedApplication].windows count]-1];
                        CBMBProgressHUD *indicator = [[CBMBProgressHUD alloc] initWithWindow:window];
                        indicator.labelText = @"注册失败";
                        
                        indicator.mode = MBProgressHUDModeText;
                        [window addSubview:indicator];
                        
                        [indicator showAnimated:YES whileExecutingBlock:^{
                            sleep(1.2);
                        } completionBlock:^{
                            [indicator removeFromSuperview];
                            
                        }];
                    }
                    
                 
                    
                } Failure:^(NSError *error) {
                    
                    NSLog(@"%@",error);
                } view:self.view isPost:YES];

            }
            
        }
            break;
        case 10086:
        {
            //男
            xingbie = 1;
        }
            break;
            
        case 10010:
        {
            //女
            xingbie = 0;
        }
            break;
        default:
            break;
    }
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
