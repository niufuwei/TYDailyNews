//
//  TYWeiboInformationViewController.m
//  TYDaily
//
//  Created by laoniu on 14/10/18.
//
//

#import "TYWeiboInformationViewController.h"
#import "TYWeiboCommentViewController.h"

@interface TYWeiboInformationViewController ()
{
    TYHttpRequest * httpRequest;
    UILabel * contentLabel;
    UIScrollView * bgScrollview;
    NavCustom * myNavCustom;
    
    UIColor * myWhiteColor;
    UIColor * myBlackColor;

}
@end

@implementation TYWeiboInformationViewController

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
    myNavCustom = [[NavCustom alloc] init];
    //    [myNavCustom setNavWithImage:@"LOGO.png" mySelf:self width:10 height:25];
    [myNavCustom setNavWithText:@"微博" mySelf:self];
    [myNavCustom setNavRightBtnImage:@"zhuanfa.png" RightBtnSelectedImage:@"" mySelf:self width:18 height:20];
    myNavCustom.NavDelegate = self;
    
    httpRequest = [[TYHttpRequest alloc] init];
    bgScrollview = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    bgScrollview.backgroundColor = myWhiteColor;
    [self.view addSubview:bgScrollview];
    
    //加载内容
    [self requestURL];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onNotification:) name:@"request" object:nil];

    // Do any additional setup after loading the view.
}

-(void)requestURL
{
    [httpRequest httpRequestWeiBo:@"http://123.57.17.124/weibo/show_status.php" parameter:[NSString stringWithFormat:@"id=%@",_WeiboID] Success:^(id result) {
        NSData* jsonData = [result dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary * dic = (NSDictionary*)[jsonData objectFromJSONData];

        [self loadTextContent:dic];
    } Failure:^(NSError *error) {
        
        NSLog(@"%@",error);
    } view:self.view isPost:NO];
}

-(void)loadTextContent:(NSDictionary*)dic
{
    contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, self.view.frame.size.width-20, 0)];
    contentLabel.backgroundColor = [UIColor clearColor];
    contentLabel.textColor = myBlackColor;
    contentLabel.font =[UIFont systemFontOfSize:15];
    contentLabel.textAlignment = NSTextAlignmentLeft;
    [bgScrollview addSubview:contentLabel];
    
    contentLabel.numberOfLines =0;
    CGSize labelSize = {0, 0};
    
    NSString * string = [@"\t" stringByAppendingString:[dic objectForKey:@"text"]];
    
    labelSize = [string sizeWithFont:[UIFont systemFontOfSize:15]
                 
                       constrainedToSize:CGSizeMake(self.view.frame.size.width-20, 5000)
                 
                           lineBreakMode:NSLineBreakByWordWrapping];
    
    contentLabel.text = string;
    contentLabel.frame =CGRectMake(contentLabel.frame.origin.x, contentLabel.frame.origin.y, contentLabel.frame.size.width, labelSize.height+50);
 
    
    UIImageView * imagev = [[UIImageView alloc] initWithFrame:CGRectMake(15, contentLabel.frame.size.height+contentLabel.frame.origin.y+10, self.view.frame.size.width-30, 200)];
    if([[[NSUserDefaults standardUserDefaults] objectForKey:@"showImage"] isEqualToString:@"no"])
    {
        [imagev setImage:[UIImage imageNamed:@"noImage"]];
    }
    else
    {
        [imagev setImageWithURL:[NSURL URLWithString:[dic objectForKey:@"bmiddle_pic"]] placeholderImage:[UIImage imageNamed:@"noImage"]];

    }
    [bgScrollview addSubview:imagev];
    
    if(imagev.frame.size.height+imagev.frame.origin.y < self.view.frame.size.height-64)
    {
        bgScrollview.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height+80);
        
    }
    else
    {
        bgScrollview.contentSize = CGSizeMake(self.view.frame.size.width, imagev.frame.size.height+imagev.frame.origin.y +1);
        
    }
    
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(self.view.frame.size.width-60, self.view.frame.size.height-60, 60, 30);
    button.backgroundColor = [UIColor redColor];
    [button setTitle:@"评论" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button bringSubviewToFront:self.view];
    [button addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
}


-(void)onClick:(id)sender
{
    TYWeiboCommentViewController * comment = [[TYWeiboCommentViewController alloc] init];
    comment.WeiboID = _WeiboID;
    [self.navigationController pushViewController:comment animated:YES];
}

-(void)NavRightButtononClick
{
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"accessToken"])
    {
        NSDictionary * dic = [[NSDictionary alloc] initWithObjects:[NSArray arrayWithObjects:[[NSUserDefaults standardUserDefaults] objectForKey:@"accessToken"],_WeiboID,@"0",@"211.156.0.1", nil] forKeys:[NSArray arrayWithObjects:@"access_token",@"id",@"is_comment",@"rip" ,nil]];
        [httpRequest httpRequestWeiBo:@"https://api.weibo.com/2/statuses/repost.json" parameter:dic Success:^(id result) {
            
            NSLog(@"%@",result);
            UIWindow *window = [[UIApplication sharedApplication].windows objectAtIndex:[[UIApplication sharedApplication].windows count]-1];
            CBMBProgressHUD *indicator = [[CBMBProgressHUD alloc] initWithWindow:window];
            indicator.labelText = @"分享成功";
            
            indicator.mode = MBProgressHUDModeText;
            [window addSubview:indicator];
            
            //[[NSNotificationCenter defaultCenter] postNotificationName:@"updateComment" object:nil];
            
            [indicator showAnimated:YES whileExecutingBlock:^{
                sleep(1.2);
            } completionBlock:^{
                [indicator removeFromSuperview];
                
            }];

        } Failure:^(NSError *error) {
            NSLog(@"%@",error);
        } view:self.view isPost:YES];
    }
    else
    {
        UIAlertView * alert =[[UIAlertView alloc] initWithTitle:nil message:@"需要授权才能授权" delegate:self cancelButtonTitle:@"去授权" otherButtonTitles:@"离开", nil];
        alert.delegate = self;
        [alert show];
    }
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
