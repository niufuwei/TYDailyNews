//
//  TYBaoLiaoViewController.m
//  TYDaily
//
//  Created by laoniu on 14-10-14.
//
//

#import "TYBaoLiaoViewController.h"
#import "TYBaoLiaoCell.h"
#import "TYBaoLiaoInformationViewController.h"
#import "UIBaoLiaoPostInforViewController.h"
#import "MJRefresh.h"
#import "TYBaoLiaoContentViewController.h"
#import "TYJDViewController.h"
#import "TYNewsViewController.h"

@interface TYBaoLiaoViewController ()
{
    TYHttpRequest * httpRequest;
    NSMutableArray * dataArray;
    NSInteger indexPage;
    NavCustom * custom;
    
    TYBaoLiaoContentViewController * contenV;
    NSMutableDictionary * selectDic;
    NSInteger indexRecord;
    
    NSString * requestInforUrl;
    NSInteger currentPage;
}

@end

@implementation TYBaoLiaoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    custom = [[NavCustom alloc] init];
    [custom setNavWithText:@"报料台" mySelf:self];
    [custom setNavLeftBtnImage:@"left_ios.png" LeftBtnSelectedImage:@"" mySelf:self width:18 height:15];
    [custom setNavRightBtnImage:@"USER_ios.png" RightBtnSelectedImage:@"" mySelf:self width:18 height:20];
    custom.NavDelegate = self;
    self.view.backgroundColor = [UIColor whiteColor];

    //左边菜单
    _leftButton= [UIButton buttonWithType:UIButtonTypeCustom];
    _leftButton.frame = CGRectMake(0, 0, self.view.frame.size.width/2, 40);
    _leftButton.backgroundColor = [UIColor redColor];
    [_leftButton setTitle:@"新闻线索" forState:UIControlStateNormal];
    [_leftButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _leftButton.tag = 1;
    [_leftButton addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_leftButton];
    
    //右边菜单
    _rightButton= [UIButton buttonWithType:UIButtonTypeCustom];
    _rightButton.frame = CGRectMake(self.view.frame.size.width/2, 0, self.view.frame.size.width/2, 40);
    _rightButton.backgroundColor = [UIColor colorWithRed:246.0/255.0 green:246.0/255.0 blue:246.0/255.0 alpha:1];
    [_rightButton setTitle:@"市容监督" forState:UIControlStateNormal];
    [_rightButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _rightButton.tag = 2;
    [_rightButton addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_rightButton];
    
    //用来记录滑过的页面
    indexRecord = 1;
    selectDic = [[NSMutableDictionary alloc] init];
    [selectDic setObject:@"ok" forKey:@"0"];
    
    //切换视图
    _bgScrollview = [[UIScrollView alloc] initWithFrame:CGRectMake(0, _leftButton.frame.size.height+_leftButton.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height-64-40-40)];
    _bgScrollview.delegate = self;
    _bgScrollview.pagingEnabled = YES;
    _bgScrollview.contentSize = CGSizeMake(self.view.frame.size.width*2, self.view.frame.size.height-64-40-40);
    [self.view addSubview:_bgScrollview];
    
    //添加首页内容
    contenV = [[TYBaoLiaoContentViewController alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, _bgScrollview.frame.size.height) withUrl:@"bl/list"];
    requestInforUrl = @"bl/view";
    [_bgScrollview addSubview:contenV];

    currentPage = 0;
    [self loadBottomView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onNotifaction:) name:@"baoliaoinfo" object:nil];
       // Do any additional setup after loading the view.
}

-(void)onNotifaction:(NSNotification*)noti
{
    TYNewsViewController * news  = [[TYNewsViewController alloc] init];
    news.newsID = noti.object;
    news.address = requestInforUrl;
    news.isNewsCenter = TRUE;
    [self.navigationController pushViewController:news animated:YES];
}

-(void)loadBottomView{
    
    //    UIView * view =[[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-50-64, self.view.frame.size.width, self.view.frame.size.height-50)];
    //
    //    [view setBackgroundColor:[UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:0.5]];
    //    [self.view addSubview:view];
    //
    //    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    //    button.frame = CGRectMake(40, 10, self.view.frame.size.width-80, 30);
    //    [button setTitle:@"我要爆料" forState:UIControlStateNormal];
    //    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    //    button.layer.borderColor = [UIColor grayColor].CGColor;
    //    [button addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
    //    button.layer.borderWidth = 0.3;
    //    [view addSubview:button];
    
    UIView * buttomView= [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-40-64, self.view.frame.size.width, 40)];
    buttomView.backgroundColor = [UIColor colorWithRed:230.0/255.0 green:228.0/255.0 blue:229.0/255.0 alpha:1];
    [self.view addSubview:buttomView];
    
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(self.view.frame.size.width-90, 0, 90, 40);
    [button setBackgroundImage:[UIImage imageNamed:@"guanzhu"] forState:UIControlStateNormal];
    [button setTitle:@"我要报料" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(onBaoliao:) forControlEvents:UIControlEventTouchUpInside];
    [buttomView addSubview:button];
    
    [buttomView bringSubviewToFront:self.view];
    
}

-(void)onClick:(id)sender
{
    UIButton * btn = (UIButton*)sender;
    [_bgScrollview scrollRectToVisible:CGRectMake((btn.tag-1)*self.view.frame.size.width, _leftButton.frame.size.height+_leftButton.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height-64-40) animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if(scrollView.contentOffset.x < -30)
    {
        [appDelegate showLeftView];
    }
    NSInteger xx = scrollView.contentOffset.x;
    NSInteger dd = self.view.frame.size.width;
    currentPage = xx/dd;
    if(currentPage ==0)
    {
         requestInforUrl =@"bl/view";
    }
    else
    {
         requestInforUrl =@"sr/view";
    }
    if( xx% dd ==0)
    {
        NSInteger index = scrollView.contentOffset.x/self.view.frame.size.width;
        if([[selectDic objectForKey:[NSString stringWithFormat:@"%d",index]] isEqualToString:@"ok"])
        {
            
        }
        else
        {
            [selectDic setObject:@"ok" forKey:[NSString stringWithFormat:@"%d",index]];
            //添加内容
            contenV = [[TYBaoLiaoContentViewController alloc] initWithFrame:CGRectMake(index*self.view.frame.size.width, 0, self.view.frame.size.width, _bgScrollview.frame.size.height) withUrl:@"sr/list"];
            [_bgScrollview addSubview:contenV];
        }
        
        [self modifyButtonType:index+1];

    }
    else if(scrollView.contentOffset.x >(self.view.frame.size.width))
    {
        [appDelegate showRightView];
    }
}

-(void)modifyButtonType:(NSInteger)index
{
    if(index == indexRecord)
    {
        
    }
    else
    {
        UIButton * btn2 = (UIButton*)[self.view viewWithTag:indexRecord];
        [btn2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn2 setBackgroundColor:[UIColor colorWithRed:246.0/255.0 green:246.0/255.0 blue:246.0/255.0 alpha:1]];
    }
    NSLog(@"%d---%d",index,indexRecord);
    
    UIButton * btn =(UIButton*)[self.view viewWithTag:index];
    [btn setBackgroundColor:[UIColor redColor]];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    indexRecord = index;
    
}


-(void)onBaoliao:(id)sender
{
    if(currentPage ==0)
    {
        UIBaoLiaoPostInforViewController * baoliao = [[UIBaoLiaoPostInforViewController alloc] init];
        [self.navigationController pushViewController:baoliao animated:YES];
    }
    else
    {
        TYJDViewController * baoliao = [[TYJDViewController alloc] init];
        [self.navigationController pushViewController:baoliao animated:YES];
    }
    
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
