//
//  TYLeftMenuItemNewsViewController.m
//  TYDaily
//
//  Created by laoniu on 14-10-2.
//
//

#import "TYLeftMenuItemNewsViewController.h"
#import "TYMoreViewController.h"
#import "TYLoginViewController.h"
#import "TYNews.h"
#import "TYNewsViewController.h"
#import "TYNewsCommentViewController.h"

@interface TYLeftMenuItemNewsViewController ()
{
    NavCustom * myNavCustom;
    NSInteger prviousIndex;
    UIScrollView * bgScrollview;
    UIImageView * bgImage;
    
    UIScrollView * contentScrollview;
    
    TYNews *tyNews;
    NSInteger indexPage;
    
    NSMutableDictionary * dataDic;
    NSString * requestURL;
    NSInteger topIndex;
}

@end

@implementation TYLeftMenuItemNewsViewController

-(void)viewWillAppear:(BOOL)animated
{
    [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"isNesCenter"];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];

    dataDic=  [[NSMutableDictionary alloc] init];
    _urlArray = [[NSMutableArray alloc] initWithObjects:@"yw/list",@"jj/list",@"sh/list",@"sy/list",@"gj/list",@"wt/list",nil];
    _menuArray = [NSMutableArray arrayWithObjects:@"要闻",@"经济",@"社会",@"声音",@"国际",@"文体", nil];
    
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"_urlArray"])
    {
        _urlArray = [[NSUserDefaults standardUserDefaults] objectForKey:@"_urlArray"];
        
    }
    else
    {
        [[NSUserDefaults standardUserDefaults] setObject:_urlArray forKey:@"_urlArray"];
    }
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"_menuArray"])
    {
        _menuArray = [[NSUserDefaults standardUserDefaults] objectForKey:@"_menuArray"];
    }
    else
    {
        [[NSUserDefaults standardUserDefaults] setObject:_menuArray forKey:@"_menuArray"];
    }
    
    myNavCustom = [[NavCustom alloc] init];
    [myNavCustom setNavWithText:@"新闻中心" mySelf:self];
    [myNavCustom setNavLeftBtnImage:@"left_ios.png" LeftBtnSelectedImage:@"" mySelf:self width:18 height:15];
    [myNavCustom setNavRightBtnImage:@"USER_ios.png" RightBtnSelectedImage:@"" mySelf:self width:18 height:20];
    myNavCustom.NavDelegate = self;

  
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onNotifaction:) name:@"pushNewsCenterWithID" object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onPushComment:) name:@"pushComment" object:nil
//     ];
//    
    [self loadlayoutView];
    // Do any additional setup after loading the view.
}

-(void)onPushComment:(NSNotification*)noti
{
    TYNewsCommentViewController * comment = [[TYNewsCommentViewController alloc] init];
    comment.newsID = noti.object;
    comment.requestURL = [requestURL stringByReplacingOccurrencesOfString:@"view" withString:@"cs"];
    [self.navigationController pushViewController:comment animated:YES];
}


-(void)onNotifaction:(NSNotification*)noti
{
    NSLog(@"%@",noti.object);
    TYNewsViewController * news = [[TYNewsViewController alloc] init];
    
    news.newsID = noti.object;
    
    NSString * str = [[_urlArray objectAtIndex:indexPage] stringByReplacingOccurrencesOfString:@"list" withString:@"view"];
    requestURL = str;
    news.isNewsCenter = TRUE;
    news.address =str;
    
    [self.navigationController pushViewController:news animated:YES];
}

-(void)loadlayoutView
{
    topIndex= 0;

    prviousIndex = 1;
    
    bgScrollview = [[UIScrollView alloc] initWithFrame:CGRectMake(5, 0, self.view.frame.size.width-40, 50)];
    [bgScrollview setBackgroundColor:[UIColor whiteColor]];
    
    [self.view addSubview:bgScrollview];
    
    bgImage = [[UIImageView alloc] initWithFrame:CGRectMake((self.view.frame.size.width-40)/6/2-((self.view.frame.size.width-40)/6-5)/2-2, 7.5,(self.view.frame.size.width-40)/6-10 +8, 25)];
    //    [bgImage setBackgroundColor:[UIColor redColor]];
    [bgImage.layer setCornerRadius:5];
    [bgImage setImage:[UIImage imageNamed:@"bgImage.png"]];
    [bgScrollview addSubview:bgImage];
    bgScrollview.tag = 101;
    bgScrollview.contentSize = CGSizeMake(self.view.frame.size.width+1, 50);
    bgScrollview.showsHorizontalScrollIndicator = NO;
    
    NSInteger myXX = 0;
    
    
    [dataDic setObject:@"ok" forKey:@"0"];
    
    //加载菜单
    
    [self loadButtonMenu:myXX];
    
    
    [bgScrollview bringSubviewToFront:self.view];
    
    UIButton * buttonAdd = [UIButton buttonWithType:UIButtonTypeCustom];
    [buttonAdd setBackgroundImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
    buttonAdd.frame = CGRectMake(self.view.frame.size.width-45, 0, 30, 30);
    [self.view addSubview:buttonAdd];
    [buttonAdd bringSubviewToFront:self.view];
    buttonAdd.tag = 101;
    [buttonAdd addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView * add = [[UIImageView alloc] initWithFrame:CGRectMake(5, 6, 25, 25)];
    [add setImage:[UIImage imageNamed:@"add.png"]];
    [buttonAdd addSubview:add];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onLogin:) name:@"login" object:nil];
    
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    [bgScrollview bringSubviewToFront:self.view];
    
    contentScrollview = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 50, self.view.frame.size.width, self.view.frame.size.height-64)];
    contentScrollview.delegate = self;
    contentScrollview.contentSize = CGSizeMake(self.view.frame.size.width*[_menuArray count], self.view.frame.size.height-50-64);
    contentScrollview.pagingEnabled = YES;
    contentScrollview.tag = 102;
    [self.view addSubview:contentScrollview];
    
    contentScrollview.showsHorizontalScrollIndicator = NO;
    
    tyNews  = [[TYNews alloc] init];
    UIView * vc = tyNews;
    vc.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-50);
    [contentScrollview addSubview:vc];
    tyNews.newsRequest = [_urlArray objectAtIndex:0];
    
    Date * date = [[Date alloc] init];
    
    [tyNews viewLayout:[date stringFormDate:[NSDate date] isHorLine:NO]];

}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSLog(@"%f",scrollView.contentOffset.x);
    if(scrollView.contentOffset.x < -30)
    {
        [appDelegate showLeftView];
    }
    
    int indexX = scrollView.contentOffset.x;
    int width =self.view.frame.size.width ;
    if(indexX % width == 0 )
    {
        UIButton * btn = (UIButton*)[bgScrollview viewWithTag:indexX/self.view.frame.size.width+1 ];
     
        for(UIView * view in [bgScrollview subviews])
        {
            if(view.tag == prviousIndex)
            {
                [(UIButton*)view setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            }
        }
        
        if(prviousIndex >btn.tag)
        {
           
                //            (5, 0, self.view.frame.size.width-40, 50)
            bgScrollview.contentOffset=CGPointMake(5,0);
            bgScrollview.contentSize = CGSizeMake([_urlArray count] * (self.view.frame.size.width-40)/6+10, 45);
        

        }
        else
        {
            if(indexX/self.view.frame.size.width>4 && [_menuArray count]>6)
            {
                //            (5, 0, self.view.frame.size.width-40, 50)
                bgScrollview.contentOffset=CGPointMake(self.view.frame.size.width-100,0);
                bgScrollview.contentSize = CGSizeMake([_urlArray count] * (self.view.frame.size.width-40)/6+10, 45);
            }

        }
        
        prviousIndex = btn.tag;
        
//        [self modifyButtonTye:1];
        [UIView beginAnimations:nil context:nil];
        //设定动画持续时间
        [UIView setAnimationDuration:0.1];
        //动画的内容
        CGRect xxx = bgImage.frame;
        xxx.origin.x =btn.frame.origin.x;
        bgImage.frame = xxx;
        //动画结束
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        [UIView commitAnimations];
        
        
        indexPage = indexX/self.view.frame.size.width;

        if([[dataDic objectForKey:[NSString stringWithFormat:@"%d",indexPage]] isEqualToString:@"ok"])
        {
            
        }
        else
        {
            
            tyNews  = [[TYNews alloc] init];
            
            
            UIView * vc = tyNews;
            vc.frame = CGRectMake(indexPage*self.view.frame.size.width, 0, self.view.frame.size.width, self.view.frame.size.height+13);
            [contentScrollview addSubview:vc];
            
            tyNews.newsRequest = [_urlArray objectAtIndex:indexPage];
            
            Date * date = [[Date alloc] init];
            
            [tyNews viewLayout:[date stringFormDate:[NSDate date] isHorLine:NO]];

            
            [dataDic setObject:@"ok" forKey:[NSString stringWithFormat:@"%d",indexPage]];
        }
        
        
   
    }
    
//    if(scrollView.contentOffset.x ==320)
//    {
//        //加载第二页
//        if(!secondIsLoad)
//        {
//            secondIsLoad = TRUE;
//            [diree viewLayout];
//            
//        }
//        
//        [self modifyButtonTye:2];
//        
//        
//    }
//    if(scrollView.contentOffset.x == self.view.frame.size.width*2 )
//    {
//        
//        //加载第三页
//        if(!thirdIsLoad)
//        {
//            thirdIsLoad = TRUE;
//            [page viewLayout];
//            
//        }
//        
//        [self modifyButtonTye:3];
//        indexPage = 3;
//        
//    }
    else if(scrollView.contentOffset.x >([_menuArray count]-1)*self.view.frame.size.width)
    {
        [appDelegate showRightView];
    }
}


-(void)onLogin:(NSNotification*)noti
{
    TYLoginViewController * login = [[TYLoginViewController alloc] init];
    
    NavViewController * nav  = [[NavViewController alloc] initWithRootViewController:login];
    [self.navigationController presentViewController:nav animated:YES completion:^{
        
    }];
    
}


-(void)onClick:(id)sender
{
    
    UIButton * btn = (UIButton*)sender;
    
    if(btn.tag ==101)
    {
        TYMoreViewController * more = [[TYMoreViewController alloc] init];
        [more getMoreData:^(NSMutableArray *itemArray, NSMutableArray *urlArray) {
            
            [dataDic removeAllObjects];
            
            for(UIView *view in self.view.subviews)
            {
                [view removeFromSuperview];
            }
            _menuArray = itemArray;
            _urlArray = urlArray;
            
            [[NSUserDefaults standardUserDefaults] setObject:_urlArray forKey:@"_urlArray"];
            [[NSUserDefaults standardUserDefaults] setObject:_menuArray forKey:@"_menuArray"];

            
            [self loadlayoutView];

            
        } itemArray:_menuArray urlArray:_urlArray];
    
        [self.navigationController pushViewController:more animated:YES];
    }
    else
    {
        [contentScrollview scrollRectToVisible:CGRectMake(self.view.frame.size.width*(btn.tag-1), 0, self.view.frame.size.width, self.view.frame.size.height+13) animated:NO];
        
        for(UIView * view in [bgScrollview subviews])
        {
            if(view.tag == prviousIndex)
            {
                [(UIButton*)view setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            }
        }
        
        prviousIndex = btn.tag;
        
        [UIView beginAnimations:nil context:nil];
        //设定动画持续时间
        [UIView setAnimationDuration:0.1];
        //动画的内容
        CGRect xxx = bgImage.frame;
        xxx.origin.x =btn.frame.origin.x;
        bgImage.frame = xxx;
        //动画结束
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
        [UIView commitAnimations];
        
    }

}

-(void)loadButtonMenu:(NSInteger)myXX
{
    for(int i=0;i<[_menuArray count];i++)
    {
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.backgroundColor = [UIColor clearColor];
        [button setTitle:[_menuArray objectAtIndex:i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        if(i==0)
        {
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }
        button.frame = CGRectMake(myXX, 5, (self.view.frame.size.width-40)/6, 30);
        [bgScrollview addSubview:button];
        [button bringSubviewToFront:bgScrollview];
        button.tag = i+1;
        [button addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
        myXX = button.frame.size.width+button.frame.origin.x;
    }
    
    bgScrollview.contentSize = CGSizeMake([_menuArray count] * ((self.view.frame.size.width-40)/6)+10, 50);


}

-(void)NavLeftButtononClick
{
    [appDelegate showLeftView];
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
