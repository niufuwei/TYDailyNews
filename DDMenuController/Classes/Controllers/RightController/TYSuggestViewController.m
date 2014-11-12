//
//  TYSuggestViewController.m
//  TYDaily
//
//  Created by laoniu on 14/10/19.
//
//

#import "TYSuggestViewController.h"

@interface TYSuggestViewController ()
{
    UIScrollView * scrollview;
    UILabel * bgLabel;
    NavCustom * myNav;
    TYHttpRequest * myHttp;
    UIColor * myBlackColor;
    UIColor * myWhiteColor;
}
@end

@implementation TYSuggestViewController

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

    self.view.backgroundColor =myWhiteColor;

    myNav = [[NavCustom alloc] init];
    myNav.NavDelegate =self;
    [myNav setNavRightBtnTitle:@"提交" mySelf:self width:50 height:40];
    
    scrollview= [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    scrollview.delegate = self;
    scrollview.backgroundColor = myWhiteColor;
    [self.view addSubview:scrollview];
    
    UIImageView * view = [[UIImageView alloc] initWithFrame:CGRectMake(15, 15, self.view.frame.size.width-30, 50)];
    [view setImage:[UIImage imageNamed:@"bg1.png"]];
    [scrollview addSubview:view];
    
    _titleField = [[UITextField alloc] initWithFrame:CGRectMake(20, 20, self.view.frame.size.width-40, 40)];
    _titleField.placeholder = @"请输入您的意见或问题标题";
    _titleField.backgroundColor = [UIColor clearColor];
    [scrollview addSubview:_titleField];
    
    UIImageView * view2 = [[UIImageView alloc] initWithFrame:CGRectMake(15, _titleField.frame.size.height+_titleField.frame.origin.y+15, self.view.frame.size.width-30, 260)];
    [view2 setImage:[UIImage imageNamed:@"bg2.png"]];
    [scrollview addSubview:view2];
    
    _textView = [[UITextView alloc] initWithFrame:CGRectMake(20, _titleField.frame.size.height+_titleField.frame.origin.y+20, self.view.frame.size.width-40, 250)];
    _textView.backgroundColor = [UIColor clearColor];
    _textView.delegate =self;
    [scrollview addSubview:_textView];
    
    bgLabel= [[UILabel alloc] initWithFrame:CGRectMake(25, _titleField.frame.size.height+_titleField.frame.origin.y+25, 150, 20)];
    bgLabel.text = @"意见或问题描述";
    bgLabel.textColor = [UIColor blackColor];
    bgLabel.backgroundColor = [UIColor clearColor];
    bgLabel.font = [UIFont systemFontOfSize:14];
    [scrollview addSubview:bgLabel];

    
//    UIButton * baoliao = [UIButton buttonWithType:UIButtonTypeCustom];
//    baoliao.frame = CGRectMake(self.view.frame.size.width-150, _textView.frame.size.height+_textView.frame.origin.y+30, 120,35);
//    [baoliao addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
//    [baoliao setBackgroundImage:[UIImage imageNamed:@"guanzhu"] forState:UIControlStateNormal];
//    [baoliao setTitle:@"提交" forState:UIControlStateNormal];
//    [baoliao setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    baoliao.tag = 102;
//    [scrollview addSubview:baoliao];
    
    scrollview.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height+1);
    // Do any additional setup after loading the view.
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    bgLabel.hidden =YES;
    return YES;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}

-(void)NavRightButtononClick
{
    if([_titleField.text length] ==0 || [_textView.text length] == 0)
    {
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message:@"请填写完整." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
    else
    {
        myHttp = [[TYHttpRequest alloc] init];
        NSDictionary * dic = [[NSDictionary alloc] initWithObjects:[NSArray arrayWithObjects:_titleField.text,_textView.text, nil] forKeys:[NSArray arrayWithObjects:@"title",@"content", nil]];
        [myHttp httpRequest:@"feedback/create" parameter:dic Success:^(id result) {
            
            NSLog(@"%@",result);
            UIWindow *window = [[UIApplication sharedApplication].windows objectAtIndex:[[UIApplication sharedApplication].windows count]-1];
            CBMBProgressHUD *indicator = [[CBMBProgressHUD alloc] initWithWindow:window];
            indicator.labelText = @"反馈成功";
            
            indicator.mode = MBProgressHUDModeText;
            [window addSubview:indicator];
            
            
            [indicator showAnimated:YES whileExecutingBlock:^{
                sleep(1.2);
            } completionBlock:^{
                [indicator removeFromSuperview];
            }];

            
        } Failure:^(NSError *error) {
            
            NSLog(@"%@",error);
            UIWindow *window = [[UIApplication sharedApplication].windows objectAtIndex:[[UIApplication sharedApplication].windows count]-1];
            CBMBProgressHUD *indicator = [[CBMBProgressHUD alloc] initWithWindow:window];
            indicator.labelText = @"反馈失败";
            
            indicator.mode = MBProgressHUDModeText;
            [window addSubview:indicator];
            
            
            [indicator showAnimated:YES whileExecutingBlock:^{
                sleep(1.2);
            } completionBlock:^{
                [indicator removeFromSuperview];
            }];

        } view:self.view isPost:YES];
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
