//
//  TYLeftMenuItemOldViewController.m
//  TYDaily
//
//  Created by laoniu on 14-10-2.
//
//

#import "TYLeftMenuItemOldViewController.h"
#import "TYLoginViewController.h"
#import "PMCalendar.h"


@interface TYLeftMenuItemOldViewController ()
{
    UIWebView * myWebView;
    NavCustom * myNavCustom ;
    TYHttpRequest * myHttp;
    NSMutableArray * dataArray;
    NSString * yesterday;
    UIScrollView * backGroundScrollview;
    UIPageControl * pageController;
    UIView * bottomview;
    NSMutableDictionary * dataDic;
    BOOL isClick;
    BOOL isDisplay;
    NSInteger indexPath;
    UIButton * buttonDate;
    UIView * bgView;
}
@property (nonatomic, strong) PMCalendarController *pmCC;

@end

@implementation TYLeftMenuItemOldViewController
@synthesize pmCC;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];

    isClick = FALSE;
    isDisplay = FALSE;
    dataDic = [[NSMutableDictionary alloc] init];
    [dataDic setObject:@"ok" forKey:@"0"];
    
    backGroundScrollview = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    backGroundScrollview.pagingEnabled = YES;
    backGroundScrollview.delegate = self;
    [self.view addSubview:backGroundScrollview];
    
    myNavCustom = [[NavCustom alloc] init];
    [myNavCustom setNavWithText:@"往期回顾" mySelf:self];
    [myNavCustom setNavLeftBtnImage:@"left_ios.png" LeftBtnSelectedImage:@"" mySelf:self width:18 height:15];
    [myNavCustom setNavRightBtnImage:@"USER_ios.png" RightBtnSelectedImage:@"" mySelf:self width:18 height:20];
    myNavCustom.NavDelegate = self;

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onLogin:) name:@"login" object:nil];

    dataArray = [[NSMutableArray alloc] init];
    
    [self loadLayotView];
    
    
    // Do any additional setup after loading the view.
}

-(void)loadLayotView
{
    
    
    
    //获取当前日期
    
    Date * date =[[Date alloc] init];

    yesterday = [date stringFormDate:[NSDate date] isHorLine:NO];
    
    buttonDate = [UIButton buttonWithType:UIButtonTypeCustom];
    buttonDate.frame = CGRectMake(0, 0, self.view.frame.size.width, 30);
    [buttonDate setBackgroundColor:[UIColor colorWithRed:232.0/255.0 green:233.0/255.0 blue:232.0/255.0 alpha:1]];
    buttonDate.tag = 103;
    
    NSMutableString * string = [[NSMutableString alloc] initWithString:yesterday];
    [string insertString:@"年" atIndex:4];
    [string insertString:@"月" atIndex:7];
    [string insertString:@"日" atIndex:10];
    
    [buttonDate setTitle:[string stringByAppendingString:@"  v"] forState:UIControlStateNormal];
    [buttonDate setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [buttonDate addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
    [buttonDate bringSubviewToFront:self.view];
    [self.view addSubview:buttonDate];

    
    myWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 30, self.view.frame.size.width, self.view.frame.size.height-64-30)];
    myWebView.delegate = self;
    myWebView.tag = 100;
    NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://123.57.17.124/epaper/index.php?r=article/paper&date=%@&pageNo=01",yesterday]]];
    [myWebView loadRequest:request];
    [myWebView setScalesPageToFit:YES];
    
    [backGroundScrollview addSubview:myWebView];

    
    myHttp  = [[TYHttpRequest alloc] init];
    [myHttp httpRequest:@"pagecount/view" parameter:[NSString stringWithFormat:@"date=%@",yesterday] Success:^(id result) {
        
        NSLog(@"请求成功，返回--->%@",result);
        
        NSLog(@"%d",[result intValue]);
        for(int i=0;i<[result intValue];i++)
        {
            [dataArray addObject:[NSString stringWithFormat:@"0%d",i+1]];
        }
        NSLog(@"%@",dataArray);
        
        pageController.numberOfPages=[dataArray count]; //设置页数为2
        backGroundScrollview.contentSize = CGSizeMake(self.view.frame.size.width*[dataArray count], self.view.frame.size.height-30-64-20);
    } Failure:^(NSError *error) {
        NSLog(@"失败==>%@",error);
        UIWindow *window = [[UIApplication sharedApplication].windows objectAtIndex:[[UIApplication sharedApplication].windows count]-1];
        CBMBProgressHUD *indicator = [[CBMBProgressHUD alloc] initWithWindow:window];
        indicator.labelText = @"请求失败";
        
        indicator.mode = MBProgressHUDModeText;
        [window addSubview:indicator];
                
        [indicator showAnimated:YES whileExecutingBlock:^{
            sleep(1.2);
        } completionBlock:^{
            [indicator removeFromSuperview];
            
        }];

    } view:self.view isPost:FALSE];
    
    //设置
    
    pageController = [[UIPageControl alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-64-20, self.view.frame.size.width, 20)];
    pageController.currentPage=0; //初始页码为 0
    pageController.userInteractionEnabled=NO; //pagecontroller不响应点击操作
    pageController.backgroundColor = [UIColor grayColor];
    [self.view addSubview:pageController];
    [pageController bringSubviewToFront:self.view];
    
    [self loadBottomView];

}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSLog(@"%f",scrollView.contentOffset.x);
    if(scrollView.contentOffset.x < -30)
    {
        [appDelegate showLeftView];
    }
    
    CGPoint offset = scrollView.contentOffset;
    
    NSInteger xxx = (int )scrollView.contentOffset.x;
    NSInteger width = self.view.frame.size.width;
    indexPath = xxx/width;
    if(xxx%width == 0)
    {
        if([[dataDic objectForKey:[NSString stringWithFormat:@"%d",xxx/width]] isEqualToString:@"ok"])
        {
            
        }
        else
        {
            [dataDic setObject:@"ok" forKey:[NSString stringWithFormat:@"%d",xxx/width]];
            myWebView = [[UIWebView alloc] initWithFrame:CGRectMake(self.view.frame.size.width*xxx/width, 30, self.view.frame.size.width, self.view.frame.size.height-30-20)];
            myWebView.delegate = self;
            myWebView.tag = 100+xxx/width;
            NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://123.57.17.124/epaper/index.php?r=article/paper&date=%@&pageNo=%@",yesterday,[dataArray objectAtIndex:xxx/width]]]];
            NSLog(@"%@",request);
            [myWebView loadRequest:request];
            [myWebView setScalesPageToFit:YES];
            
            [backGroundScrollview addSubview:myWebView];

        }
        
    }
    
    pageController.currentPage = offset.x / (self.view.bounds.size.width); //计算当前的页码
    
    if(scrollView.contentOffset.x >([dataArray count]-1)*self.view.frame.size.width)
    {
        [appDelegate showRightView];
    }
}

- (void)onClick:(id)sender
{
    UIButton * btn = (UIButton*)sender;
    switch (btn.tag) {
        case 101:
        {
            [self hideBottom];
            bgView.hidden = YES;
            //阅读报纸
            [[NSNotificationCenter defaultCenter] postNotificationName:@"pushFirstFromOld" object:yesterday];
        }
            break;
        case 102:
        {
            if(isClick)
            {
                [self hideBottom];
                bgView.hidden = YES;
                isClick = FALSE;
            }
        }
            break;
        case 103:
        {
            self.pmCC = [[PMCalendarController alloc] init];
            pmCC.delegate = self;
            pmCC.mondayFirstDayOfWeek = YES;
            
            [pmCC presentCalendarFromView:sender
                 permittedArrowDirections:PMCalendarArrowDirectionAny
                                 animated:YES];
            /*    [pmCC presentCalendarFromRect:[sender frame]
             inView:[sender superview]
             permittedArrowDirections:PMCalendarArrowDirectionAny
             animated:YES];*/
            [self calendarController:pmCC didChangePeriod:pmCC.period];
        }
            break;
        default:
            break;
    }
        
    
}
#pragma mark PMCalendarControllerDelegate methods

- (void)calendarController:(PMCalendarController *)calendarController didChangePeriod:(PMPeriod *)newPeriod
{
    
//    NSString* str = [NSString stringWithFormat:@"%@ - %@"
//                        , [newPeriod.startDate dateStringWithFormat:@"dd-MM-yyyy"]
//                        , [newPeriod.endDate dateStringWithFormat:@"yyyyMMdd"]];
    
    if(!isDisplay)
    {
        isDisplay = TRUE;
    }
    else
    {
        yesterday = [newPeriod.endDate dateStringWithFormat:@"yyyyMMdd"];

        NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://123.57.17.124/epaper/index.php?r=article/paper&date=%@&pageNo=%@",yesterday,[dataArray objectAtIndex:indexPath]]]];
        NSLog(@"%@",request);
        
        
        NSMutableString * string = [[NSMutableString alloc] initWithString:yesterday];
        [string insertString:@"年" atIndex:4];
        [string insertString:@"月" atIndex:7];
        [string insertString:@"日" atIndex:10];
        
        [buttonDate setTitle:[string stringByAppendingString:@"  v"] forState:UIControlStateNormal];
        for(UIWebView * view in backGroundScrollview.subviews)
        {
            if(view.tag-100 == indexPath)
            {
                [view loadRequest:request];
            }
        }
        [dataDic removeAllObjects];
        isDisplay = FALSE;
        [self.pmCC dismissCalendarAnimated:YES];
        
    }
}

-(void)NavLeftButtononClick
{
    [appDelegate showLeftView];
}

-(void)onLogin:(NSNotification*)noti
{
    TYLoginViewController * login = [[TYLoginViewController alloc] init];
    
    NavViewController * nav  = [[NavViewController alloc] initWithRootViewController:login];
    [self.navigationController presentViewController:nav animated:YES completion:^{
        
    }];
    
}
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType

{
    
    //判断是否是单击
    
    if (navigationType == UIWebViewNavigationTypeLinkClicked)
        
    {
        
//        NSURL *url = [request URL];
//        
//        if([[UIApplication sharedApplication]canOpenURL:url])
//            
//        {
//            
//            [[UIApplication sharedApplication]openURL:url];
//            
//        }
        
        if(!isClick)
        {
            isClick = TRUE;
            bgView.hidden = NO;
            [self showBottom];
        }
        else
        {
            isClick = FALSE;
            [self hideBottom];
            bgView.hidden = YES;
        }
        
        if(!isDisplay)
        {
            isDisplay = TRUE;
        }
        else
        {
           
            isDisplay = FALSE;
            [self.pmCC dismissCalendarAnimated:YES];
            
        }

        
        return NO;
        
    }
    
    return YES;
    
}

-(void)hideBottom
{
    [UIView animateWithDuration:0.2 animations:^{
        bottomview.frame = CGRectMake(0, self.view.frame.size.height+70, self.view.frame.size.width, 70);
    }];
}

-(void)showBottom
{
    [UIView animateWithDuration:0.2 animations:^{
        bottomview.frame = CGRectMake(0, self.view.frame.size.height-70, self.view.frame.size.width,70);
    }];
}

-(void)loadBottomView
{
    
    bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [bgView setBackgroundColor:[UIColor colorWithRed:57.0/255.0 green:57.0/255.0 blue:57.0/255.0 alpha:0.5]];
    [self.view addSubview:bgView];
    UITapGestureRecognizer * gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTap:)];
    gesture.numberOfTapsRequired = 1;
    [bgView addGestureRecognizer:gesture];
    
    bgView.hidden = YES;
    
    bottomview = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height+70, self.view.frame.size.width, 70)];
    [bottomview setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:bottomview];
    [bottomview bringSubviewToFront:self.view];
    
    
    UIButton * leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.frame = CGRectMake(0, 0, self.view.frame.size.width/2, 70);
    leftButton.tag = 101;
    [leftButton setBackgroundImage:[UIImage imageNamed:@"leftRead"] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
    [bottomview addSubview:leftButton];
    
    
    UIButton * rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.frame = CGRectMake(self.view.frame.size.width/2, 0, self.view.frame.size.width/2, 70);
    rightButton.tag = 102;
    [rightButton addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
    [rightButton setBackgroundImage:[UIImage imageNamed:@"rightDownload"] forState:UIControlStateNormal];
    [bottomview addSubview:rightButton];
    
}

-(void)onTap:(UITapGestureRecognizer*)tap
{
    if(tap.numberOfTapsRequired ==1)
    {
        bgView.hidden= YES;
        isClick = FALSE;

        [self hideBottom];

    }
}

-(void)NavRightButtononClick
{
    [appDelegate showRightView];
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
