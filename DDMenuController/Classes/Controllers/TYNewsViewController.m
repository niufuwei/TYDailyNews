//
//  TYNewsViewController.m
//  TYDaily
//
//  Created by laoniu on 14-10-5.
//
//

#import "TYNewsViewController.h"
#import "TYNewsView.h"
#import "TYLoginViewController.h"
#import "TYNewsCommentViewController.h"
#import "TYVideoViewController.h"
#import "TYShareManager.h"

@implementation XMShareItem

@synthesize shareButton,shareTitle;
@synthesize shareDelegate;
@synthesize name;
-(id)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        //
    }
    return self;
}

-(id)initWithFrame:(CGRect)frame image:(UIImage *)image title:(NSString *)title delegate:(id)delegate{
    
    self = [self initWithFrame:frame];
    if (self) {
        shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [shareButton setImage:image forState:UIControlStateNormal];
        [shareButton addTarget:self action:@selector(shareButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        shareButton.backgroundColor = [UIColor clearColor];
        [shareButton setFrame:CGRectMake(0, 0, 43, 43)];
        [self addSubview:shareButton];
        
        shareTitle = [[UILabel alloc]initWithFrame:CGRectMake(0, shareButton.frame.size.height, self.bounds.size.width, self.bounds.size.height - 43)];
        [shareTitle setText:title];
        shareTitle.backgroundColor = [UIColor clearColor];
        shareTitle.textAlignment = NSTextAlignmentCenter;
        shareTitle.textColor =[UIColor blackColor];
        shareTitle.font = [UIFont systemFontOfSize:12];
        [self addSubview:shareTitle];
        
        shareDelegate = delegate;
        name = title;
    }
    return self;
    
}


-(void)shareButtonClicked:(id)sender{
    [self.shareDelegate  shareItemDidShare:self];
}

@end


@interface TYNewsViewController ()<XMShareItemDelegate>
{
    TYHttpRequest * httpRequest;
    NSDictionary * dataDictionary;
    TYNewsView * news;
    UIButton *collect;
    UIView * BGView;
}

@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) XMShareItem *weiXin;
@property (nonatomic, strong) XMShareItem *weiBo;
@property (nonatomic, strong) XMShareItem *friends;
@property (nonatomic, strong) XMShareItem *QQ;
@property (nonatomic, strong) XMShareItem *QZone;

@property (nonatomic, strong) UIButton *dismissButton;

@end


@implementation TYNewsViewController
@synthesize newsID;
@synthesize tyleName;
@synthesize tyleValue;
@synthesize newsUrl;
@synthesize contentView,dismissButton;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    dataDictionary=[[NSDictionary alloc] init];
    
    news = [[TYNewsView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [self.view addSubview:news];
    httpRequest = [[TYHttpRequest alloc] init];
    NSLog(@"%@",newsID);

    
    //加载数据
    [self loadData];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onPushComment:) name:@"pushComment" object:nil];

    [self setNavRightBtnImage];
    
    //加载分享内容
    [self loadMengBan];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onNotification:) name:@"startVideo" object:nil];
 
    // Do any additional setup after loading the view.
}


-(void)loadMengBan
{
    BGView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    BGView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onViewTap:)];
    tap.numberOfTapsRequired = 1;
    [BGView addGestureRecognizer:tap];
    
    contentView = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height, self.view.bounds.size.width, 250)];
    contentView.backgroundColor = [UIColor whiteColor];
    [BGView addSubview:contentView];
    
    UILabel *shareLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 77, 32)];
    shareLabel.backgroundColor = [UIColor clearColor];
    shareLabel.text = @"分享到:";
    shareLabel.textAlignment = NSTextAlignmentRight;
    shareLabel.font = [UIFont systemFontOfSize:14];
    [contentView addSubview:shareLabel];
    
    
    
    CGFloat width = ( self.view.bounds.size.width - 3 * 43 )/ 4;
    _weiXin = [[XMShareItem alloc]initWithFrame:CGRectMake(width, 42, 43, 70) image:[UIImage imageNamed:@"share_weixin"] title:@"微信" delegate:self];
    _weiBo = [[XMShareItem alloc]initWithFrame:CGRectMake(_weiXin.frame.origin.x + _weiXin.frame.size.width + width, 42, 43, 70) image:[UIImage imageNamed:@"share_weibo"] title:@"微博" delegate:self];
    _friends = [[XMShareItem alloc]initWithFrame:CGRectMake(_weiBo.frame.origin.x + _weiBo.frame.size.width + width, 42, 43, 70) image:[UIImage imageNamed:@"share_pengyouquan"] title:@"朋友圈" delegate:self];
    
    _QQ = [[XMShareItem alloc]initWithFrame:CGRectMake(width, _weiXin.frame.size.height+_weiXin.frame.origin.y+15, 43, 70) image:[UIImage imageNamed:@"QQ"] title:@"QQ" delegate:self];
    
    _QZone = [[XMShareItem alloc]initWithFrame:CGRectMake(_QQ.frame.origin.x + _QQ.frame.size.width + width, _weiXin.frame.size.height+_weiXin.frame.origin.y+15, 43, 70) image:[UIImage imageNamed:@"QZone"] title:@"QQ空间" delegate:self];
    
    [contentView addSubview:_weiXin];
    [contentView addSubview:_weiBo];
    [contentView addSubview:_friends];
    [contentView addSubview:_QZone];
    [contentView addSubview:_QQ];
    
    dismissButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [dismissButton setTitle:@"取消" forState:UIControlStateNormal];
    [dismissButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    dismissButton.layer.cornerRadius = 2.0f;
    dismissButton.layer.borderColor = [UIColor colorWithRed:180.0/255.0 green:180.0/255.0 blue:180.0/255.0 alpha:1].CGColor;
    dismissButton.layer.borderWidth = .5f;
    dismissButton.frame = CGRectMake(20, _QZone.frame.origin.y + _QZone.frame.size.height + 12, self.view.bounds.size.width - 40, 49);
    dismissButton.backgroundColor = [UIColor whiteColor];
    [dismissButton addTarget:self action:@selector(dismissButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [contentView addSubview:dismissButton];

}

-(void)onNotification:(NSNotification*)noti
{
    TYVideoViewController * video = [[TYVideoViewController alloc] init];
    video.movieURL = noti.object;
    [video readyPlayer];
    [self presentViewController:video animated:YES completion:^{
        
    }];
}

-(void)setNavRightBtnImage
{
    //创建右边按钮
    
    UIView * view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 90, 44)];
    [view setBackgroundColor:[UIColor clearColor]];
    
    collect = [[UIButton alloc] initWithFrame:CGRectMake(10, 10, 24, 24)];
    [collect setBackgroundImage:[UIImage imageNamed:@"nocollect"] forState:UIControlStateNormal];
    [collect addTarget:self action:@selector(NavRightButtononClick:) forControlEvents:UIControlEventTouchUpInside];
    collect.tag = 101;
    [view addSubview:collect];
    
    
    UIButton * buttonAdd = [UIButton buttonWithType:UIButtonTypeCustom];
    [buttonAdd setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    buttonAdd.frame = CGRectMake(55,0, 40, 40);
    [view addSubview:buttonAdd];
    [buttonAdd bringSubviewToFront:self.view];
    buttonAdd.tag = 102;
    [buttonAdd addTarget:self action:@selector(NavRightButtononClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView * share = [[UIImageView alloc] initWithFrame:CGRectMake(0, 12, 20, 20)];
    [share setImage:[UIImage imageNamed:@"share"]];
    [buttonAdd addSubview:share];
    
    //添加进BARBUTTONITEM
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithCustomView:view];
    
    //右按钮
    self.navigationItem.rightBarButtonItem = rightBtn;
    
}

-(void)NavRightButtononClick:(id)sender
{
    UIButton * button = (UIButton*)sender;
    switch (button.tag) {
        case 101:
        {
            NSRange rang = [_address rangeOfString:@"/"];
            NSString * string;
            NSString * newsIDTT = newsID;
            if(newsUrl)
            {
                string =@"article";

                NSRange rang2 = [[newsUrl absoluteString] rangeOfString:@"=" options:NSBackwardsSearch];
                newsIDTT = [[newsUrl absoluteString] substringFromIndex:rang2.location+1];

            }
            else
            {
                string = [_address substringToIndex:rang.location];

            }
            
            [button setBackgroundImage:[UIImage imageNamed:@"collect"] forState:UIControlStateNormal];
            
            NSDictionary  * dic = [[NSDictionary alloc] initWithObjects:[NSArray arrayWithObjects:newsIDTT,string, nil] forKeys:[NSArray arrayWithObjects:@"id",@"type", nil]];
            NSLog(@"%@",dic);
            [httpRequest httpRequest:@"site/collect" parameter:dic Success:^(id result) {
                
                NSData * data = [result dataUsingEncoding:NSUTF8StringEncoding];
                NSDictionary * dic = [data objectFromJSONData];
                
                NSLog(@"%@",result);
                if([[dic objectForKey:@"code"] isEqualToString:@"1"])
                {
                    UIWindow *window = [[UIApplication sharedApplication].windows objectAtIndex:[[UIApplication sharedApplication].windows count]-1];
                    CBMBProgressHUD *indicator = [[CBMBProgressHUD alloc] initWithWindow:window];
                    indicator.labelText = @"收藏成功";
                    
                    indicator.mode = MBProgressHUDModeText;
                    [window addSubview:indicator];
                    
                    [collect setBackgroundImage:[UIImage imageNamed:@"collect.png"] forState:UIControlStateNormal];
                    
                    [indicator showAnimated:YES whileExecutingBlock:^{
                        sleep(1.2);
                    } completionBlock:^{
                        [indicator removeFromSuperview];
                        
                    }];
                }
                else if([[dic objectForKey:@"code"] isEqualToString:@"2"])
                {
                    UIWindow *window = [[UIApplication sharedApplication].windows objectAtIndex:[[UIApplication sharedApplication].windows count]-1];
                    CBMBProgressHUD *indicator = [[CBMBProgressHUD alloc] initWithWindow:window];
                    indicator.labelText = @"已经收藏，不能重复收藏";
                    
                    indicator.mode = MBProgressHUDModeText;
                    [window addSubview:indicator];
                    [collect setBackgroundImage:[UIImage imageNamed:@"collect.png"] forState:UIControlStateNormal];

                    [indicator showAnimated:YES whileExecutingBlock:^{
                        sleep(1.2);
                    } completionBlock:^{
                        [indicator removeFromSuperview];
                        
                    }];
                }
                else
                {
                    UIWindow *window = [[UIApplication sharedApplication].windows objectAtIndex:[[UIApplication sharedApplication].windows count]-1];
                    CBMBProgressHUD *indicator = [[CBMBProgressHUD alloc] initWithWindow:window];
                    indicator.labelText = @"收藏失败";
                    
                    indicator.mode = MBProgressHUDModeText;
                    [window addSubview:indicator];
                    [collect setBackgroundImage:[UIImage imageNamed:@"nocollect.png"] forState:UIControlStateNormal];

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
            break;
        case 102:
        {
            //分享
            
            [self.view addSubview:BGView];
            
            [UIView animateWithDuration:0.3 animations:^{
            
                CGRect yy = contentView.frame;
                yy.origin.y = self.view.frame.size.height-250;
                contentView.frame = yy;
                
            }];
        
        
        }
            break;
        default:
            break;
    }
    
}
     
-(void)onPushComment:(NSNotification*)noti
{
    TYNewsCommentViewController * comment = [[TYNewsCommentViewController alloc] init];
    comment.newsID = noti.object;
    if(_isNewsCenter)
    {
        comment.requestURL =[_address stringByReplacingOccurrencesOfString:@"view" withString:@"cs"];
        
    }
    else
    {
        comment.requestURL = @"comment/list";

    }
    NSLog(@"%@",comment.requestURL);

    [self.navigationController pushViewController:comment animated:YES];
}
-(void)loadData
{
    httpRequest = [[TYHttpRequest alloc] init];

    NSLog(@"%@",newsUrl);
    if(newsUrl)
    {
        [httpRequest httpRequest:[newsUrl absoluteString] parameter:nil Success:^(id result) {
            
            NSData* jsonData = [result dataUsingEncoding:NSUTF8StringEncoding];
            dataDictionary = (NSDictionary*)[jsonData objectFromJSONData];
            
            [news fillDataWithView:dataDictionary];
            
        } Failure:^(NSError *error) {
            
            NSLog(@"error==>%@",error);
        } view:self.view isPost:FALSE];
    }
    else if(newsID)
    {
        [httpRequest httpRequest:_address parameter:[NSString stringWithFormat:@"id=%@",newsID] Success:^(id result) {
            
            NSData* jsonData = [result dataUsingEncoding:NSUTF8StringEncoding];
            dataDictionary =(NSDictionary*)[jsonData objectFromJSONData];
            NSLog(@"%@",dataDictionary);

            news.isNews = _isNewsCenter;
            news.address = _address;
            [news fillDataWithView:dataDictionary];

        } Failure:^(NSError *error) {
            
            NSLog(@"error==>%@",error);
        } view:self.view isPost:FALSE];

    }
    else
    {
        NSLog(@"ERROR");
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onLogin:) name:@"login" object:nil];

}



-(void)onLogin:(NSNotification*)noti
{
    TYLoginViewController * login = [[TYLoginViewController alloc] init];
    
    NavViewController * nav  = [[NavViewController alloc] initWithRootViewController:login];
    [self.navigationController presentViewController:nav animated:YES completion:^{
        
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)onViewTap:(UITapGestureRecognizer*)tap
{
    if(tap.numberOfTapsRequired ==1)
    {
        [UIView animateWithDuration:0.3 animations:^{
            
            CGRect yy = contentView.frame;
            yy.origin.y = self.view.frame.size.height;
            contentView.frame = yy;
            
        } completion:^(BOOL finished) {
            [BGView removeFromSuperview];
            
        }];    }
}


-(void)dismissButtonClicked:(id)sender{
    
    [UIView animateWithDuration:0.3 animations:^{
        
        CGRect yy = contentView.frame;
        yy.origin.y = self.view.frame.size.height;
        contentView.frame = yy;
        
    } completion:^(BOOL finished) {
        [BGView removeFromSuperview];

    }];
    
}

-(void)shareItemDidShare:(XMShareItem *)shareImte{
    
    //分享
//    [UMSocialSnsService presentSnsIconSheetView:self
//                                         appKey:@"543de3e2fd98c5fc580036bd"
//                                      shareText:[dataDictionary objectForKey:@"Content"]
//                                     shareImage:[UIImage imageNamed:@"Icon.png"]
//                                shareToSnsNames:[NSArray arrayWithObjects:UMShareToSina,UMShareToTencent,UMShareToRenren,UMShareToDouban,UMShareToFacebook,UMShareToTwitter,UMShareToQQ,UMShareToQzone,nil]
//                                       delegate:nil];

    
    NSLog(@"%@",dataDictionary);
    TYShareManager * share = [TYShareManager currentShare];
    NSString * strContent = [[dataDictionary objectForKey:@"Content"] stringByReplacingOccurrencesOfString:@"<p>" withString:@""];
    strContent =[strContent stringByReplacingOccurrencesOfString:@"</p>" withString:@"\n"];
    strContent =[strContent stringByReplacingOccurrencesOfString:@"<br />" withString:@""];
    
  
    
    [share shareContentString:strContent title:[dataDictionary objectForKey:@"Title"] image:[UIImage imageNamed:@"Icon.png"] url:@"www.baidu.com"];
    
    NSString *name = shareImte.name;
    
    if ([name isEqualToString:@"微博"]) {
        appDelegate.indexShare = 0;
        if([strContent length] >140)
        {
            strContent = [strContent substringToIndex:135];
            strContent = [strContent stringByAppendingString:@"..."];
        }
        [share shareContentString:strContent title:[dataDictionary objectForKey:@"Title"] image:[UIImage imageNamed:@"Icon.png"] url:@"www.baidu.com"];

        [share shareWithWeiBo];
        
    }
    if ([name isEqualToString:@"微信"]) {
        appDelegate.indexShare = 1;
        [share shareWithWeiXin:0];
    }
    if ([name isEqualToString:@"朋友圈"]) {
        appDelegate.indexShare = 2;
        [share shareWithWeiXin:1];
    }
    if ([name isEqualToString:@"QQ"]) {
        appDelegate.indexShare = 3;
        [share shareWithQQ:2];
    }
    if ([name isEqualToString:@"QQ空间"]) {
        appDelegate.indexShare = 4;
        [share shareWithQQZone:3];
    }
}

-(void)request:(WBHttpRequest *)request didFailWithError:(NSError *)error{
    
}

-(void)request:(WBHttpRequest *)request didFinishLoadingWithDataResult:(NSData *)data{
    
}

-(void)request:(WBHttpRequest *)request didFinishLoadingWithResult:(NSString *)result{
    
}


-(void)createShareDetailBy:(XMShareItem *)shareItem{
    
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
