//
//  ViewController.m
//  TYDaily
//
//  Created by laoniu on 14-10-2.
//  Copyright (c) 2014年 xiaoma. All rights reserved.
//

#import "TYHomePageController.h"
#import "TYLoginViewController.h"

#import "TYDayDireetoryView.h"
#import "TYDayFeaturedView.h"
#import "TYDayPageLayoutView.h"
#import "TYNewsViewController.h"
#import "TYNewsCommentViewController.h"

@interface TYHomePageController ()
{
    NavCustom * myNavCustom;
    UIScrollView * myScrollview;
    NSString* ob;
    BOOL FirstIsLoad;
    BOOL secondIsLoad;
    BOOL thirdIsLoad;
    
    TYDayFeaturedView * feat;
    TYDayDireetoryView * diree;
    TYDayPageLayoutView * page ;
    
    UIColor * myBlackColor;
    UIColor * myWhiteColor;
    NSInteger indexPage;
}

@end

@implementation TYHomePageController

#pragma mark - SlideNavigationController Methods -

-(void)viewWillAppear:(BOOL)animated
{
    [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"isNesCenter"];
 
    if([[[NSUserDefaults standardUserDefaults] objectForKey:@"isSetDayShow"] isEqualToString:@"1"])
    {
        [feat viewwill];
        [diree viewwill];
        [page viewwill];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    indexPage = 1;
    
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
    
    //设置导航左右按钮
    myNavCustom = [[NavCustom alloc] init];
//    [myNavCustom setNavWithImage:@"LOGO.png" mySelf:self width:10 height:25];
    [myNavCustom setNavWithText:@"太原日报" mySelf:self];
    [myNavCustom setNavLeftBtnImage:@"left_ios.png" LeftBtnSelectedImage:@"" mySelf:self width:18 height:15];
    [myNavCustom setNavRightBtnImage:@"USER_ios.png" RightBtnSelectedImage:@"" mySelf:self width:18 height:20];
    myNavCustom.NavDelegate = self;
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    myScrollview = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    myScrollview.delegate = self;
    myScrollview.contentSize = CGSizeMake(self.view.frame.size.width*3, self.view.frame.size.height);
    myScrollview.pagingEnabled = YES;
    myScrollview.backgroundColor = myWhiteColor;
    [self.view addSubview:myScrollview];

    feat  = [[TYDayFeaturedView alloc] init];
    diree = [[TYDayDireetoryView alloc] init];
    page = [[TYDayPageLayoutView alloc] init];
    
    //加载菜单
    [self loadMenu];
    
    //注册通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onNotification:) name:@"pushNewsWithUrl" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onNotificationWithID:) name:@"pushNewsWithID" object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onPushComment:) name:@"pushComment" object:nil
//     ];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onLogin:) name:@"login" object:nil];

    
    // Do any additional setup after loading the view, typically from a nib.
}
-(void)onPushComment:(NSNotification*)noti
{
    TYNewsCommentViewController * comment = [[TYNewsCommentViewController alloc] init];
    comment.newsID = noti.object;
    comment.requestURL = @"comment/list";
    [self.navigationController pushViewController:comment animated:YES];
}

-(void)onLogin:(NSNotification*)noti
{
    TYLoginViewController * login = [[TYLoginViewController alloc] init];
    
    NavViewController * nav  = [[NavViewController alloc] initWithRootViewController:login];
    [self.navigationController presentViewController:nav animated:YES completion:^{
        
    }];

}

-(void)loadMenu
{
    NSArray * arr = [NSArray arrayWithObjects:@"本期精选",@"本期目录",@"本期版面", nil];
    NSInteger xx =0 ;
    for(int i =0;i<3;i++)
    {
        UIButton * menuButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [menuButton setTitle:[arr objectAtIndex:i] forState:UIControlStateNormal];
        menuButton.frame = CGRectMake(xx, 0, self.view.frame.size.width/3, 40);
        [menuButton setBackgroundColor:[UIColor colorWithRed:246.0/255.0 green:246.0/255.0 blue:246.0/255.0 alpha:1]];
        [menuButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        menuButton.tag = i+1;
        [menuButton addTarget:self action:@selector(onButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:menuButton];
        
        xx += self.view.frame.size.width/3;
        
        if(i==0)
        {
            [menuButton setBackgroundColor:[UIColor colorWithRed:206.0/255.0 green:0.0/255.0 blue:26.0/255.0 alpha:1]];
            [menuButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }
    }
    
    NSArray * viewArray = [NSArray arrayWithObjects:feat,diree,page, nil];
    NSInteger myX = 0;
    for(int i=0;i<[viewArray count];i++)
    {
        UIView * vc = [viewArray objectAtIndex:i];
        vc.frame = CGRectMake(myX, 40, self.view.frame.size.width, self.view.frame.size.height-40);
        
        myX += self.view.frame.size.width;
        [myScrollview addSubview:vc];
    
    }
    [feat viewLayout:_requestDateString];
    
}

-(void)NavLeftButtononClick
{
    [appDelegate showLeftView];
}

-(void)NavRightButtononClick
{
    [appDelegate showRightView];
}

-(void)onButtonClick:(id)sender
{
    UIButton * btn = (UIButton*)sender;
    switch (btn.tag) {
        case 1:
        {
            if(indexPage ==3)
            {
                [myScrollview scrollRectToVisible:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-40) animated:NO];

            }
            else
            {
                [myScrollview scrollRectToVisible:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-40) animated:YES];

            }
            indexPage = 1;

        }
            break;
        case 2:
        {
             [myScrollview scrollRectToVisible:CGRectMake(self.view.frame.size.width, 0, self.view.frame.size.width, self.view.frame.size.height-40) animated:YES];
            indexPage = 2;

        }
            break;
        case 3:
        {
            if(indexPage ==1)
            {
                [myScrollview scrollRectToVisible:CGRectMake(self.view.frame.size.width*2, 0, self.view.frame.size.width, self.view.frame.size.height-40) animated:NO];
            }
            else
            {
                [myScrollview scrollRectToVisible:CGRectMake(self.view.frame.size.width*2, 0, self.view.frame.size.width, self.view.frame.size.height-40) animated:YES];
            }
            indexPage = 3;

        }
            break;
        default:
            break;
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if(scrollView.contentOffset.x < -30)
    {
        [appDelegate showLeftView];
    }
    
    if(scrollView.contentOffset.x == 0 )
    {
        [self modifyButtonTye:1];
        indexPage = 1;
        if([[[NSUserDefaults standardUserDefaults] objectForKey:@"isSetDayShow"] isEqualToString:@"1"])
        {
            [feat viewwill];
        
        }
    }
    if(scrollView.contentOffset.x ==320)
    {
        //加载第二页
        if(!secondIsLoad)
        {
            secondIsLoad = TRUE;
            [diree viewLayout:_requestDateString];
        }
        else
        {
            if([[[NSUserDefaults standardUserDefaults] objectForKey:@"isSetDayShow"] isEqualToString:@"1"])
            {
                [diree viewwill];
            }
            
        }
       
        
        [self modifyButtonTye:2];
        

    }
    if(scrollView.contentOffset.x == self.view.frame.size.width*2 )
    {
        
        //加载第三页
        if(!thirdIsLoad)
        {
            thirdIsLoad = TRUE;
            [page viewLayout:_requestDateString];
        
        }
        else
        {
            if([[[NSUserDefaults standardUserDefaults] objectForKey:@"isSetDayShow"] isEqualToString:@"1"])
            {
                [page viewwill];
            }
        }
       
        
        [self modifyButtonTye:3];
        indexPage = 3;

    }
    else if(scrollView.contentOffset.x >640)
    {
        [appDelegate showRightView];
    }
}


-(void)modifyButtonTye:(NSInteger)index
{
   
    for(UIView * view in self.view.subviews)
    {
        if(view.tag == 1)
        {
            if(1==index)
            {
                
            }
            else
            {
                UIButton * btn = (UIButton *)view;
                [btn setBackgroundColor:[UIColor colorWithRed:246.0/255.0 green:246.0/255.0 blue:246.0/255.0 alpha:1]];
                [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            }
            
        }
        else if(view.tag ==2)
        {
            if(2==index)
            {
                
            }
            else
            {
                UIButton * btn = (UIButton *)view;
                [btn setBackgroundColor:[UIColor colorWithRed:246.0/255.0 green:246.0/255.0 blue:246.0/255.0 alpha:1]];
                [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            }
           
        }
        else if(view.tag ==3)
        {
            if(3==index)
            {
                
            }
            else
            {
                UIButton * btn = (UIButton *)view;
                [btn setBackgroundColor:[UIColor colorWithRed:246.0/255.0 green:246.0/255.0 blue:246.0/255.0 alpha:1]];
                [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];

            }
        }
        
        if(view.tag ==index)
        {
            UIButton * btn = (UIButton *)view;
            [btn setBackgroundColor:[UIColor colorWithRed:206.0/255.0 green:0.0/255.0 blue:26.0/255.0 alpha:1]];
            [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

        }
    }

}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if(scrollView.contentOffset.x >self.view.frame.size.width)
    {
        if([[[NSUserDefaults standardUserDefaults] objectForKey:@"isLogin"] isEqualToString:@"1"])
        {
            
        }
        else
        {
//            TYLoginViewController * login = [[TYLoginViewController alloc] init];
//            
//            NavViewController * nav  = [[NavViewController alloc] initWithRootViewController:login];
//            [self.navigationController presentViewController:nav animated:YES completion:^{
//                
//            }];
        }
    }
}

-(void)onNotification:(NSNotification*)noti
{
    TYNewsViewController * news = [[TYNewsViewController alloc] init];
    news.newsUrl = noti.object;
    [self.navigationController pushViewController:news animated:YES];
}

-(void)onNotificationWithID:(NSNotification*)noti
{
    TYNewsViewController * news  = [[TYNewsViewController alloc] init];
    news.newsID = noti.object;
    news.address = @"article/view";
    news.isNewsCenter = FALSE;
    [self.navigationController pushViewController:news animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
