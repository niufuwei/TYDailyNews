//
//  TYNewsCommentViewController.m
//  TYDaily
//
//  Created by laoniu on 14-10-8.
//
//

#import "TYNewsCommentViewController.h"
#import "TYNewsCommentCell.h"
#import "TYCommentView.h"
#import "TYLoginViewController.h"
#import "MJRefresh.h"

@interface TYNewsCommentViewController ()
{
    NSMutableArray * dataArray;
    TYHttpRequest * myHttpRequest;
    NSInteger currentPage;
    TYCommentView * ButtomView;
    BOOL isHeadReload;
    UIColor * myBlackColor;
    UIColor * myWhiteColor;
}

@end

@implementation TYNewsCommentViewController

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

    [self.view setBackgroundColor:myWhiteColor];
    
    
    
    dataArray = [[NSMutableArray alloc] init];
    currentPage = 0;
    isHeadReload = TRUE;
    _table = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-64-50)];
    _table.delegate = self;
    _table.dataSource =self;
    _table.backgroundColor = myWhiteColor;
    [self.view addSubview:_table];
    
    ButtomView = [[TYCommentView alloc] initWithFrame:CGRectMake(0, _table.frame.size.height+_table.frame.origin.y, self.view.frame.size.width, 50) ID:_newsID];
    [ButtomView setBackgroundColor:myWhiteColor];
    [ButtomView bringSubviewToFront:self.view];
    [self.view addSubview:ButtomView];
    
    myHttpRequest = [[TYHttpRequest alloc] init];
        
    [[NSNotificationCenter defaultCenter] addObserver:self
     
                                             selector:@selector(keyboardWillShow:)
     
                                                 name:UIKeyboardWillShowNotification
     
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
     
                                             selector:@selector(keyboardWillHide:)
     
                                                 name:UIKeyboardWillHideNotification
     
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onLogin:) name:@"login" object:nil];

    [self setupRefresh];
    // Do any additional setup after loading the view.
}

-(void)requestLoadData
{
    [myHttpRequest httpRequest:_requestURL parameter:[NSString stringWithFormat:@"id=%@&pageSize=%@&pageNo=%d",_newsID,@"14",currentPage] Success:^(id result) {
        NSLog(@"%@",result);
        NSData* jsonData = [result dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary * dic = (NSDictionary*)[jsonData objectFromJSONData];
        NSArray * arr = [dic objectForKey:@"comments"];
        
        for(int i= 0;i<[arr count];i++)
        {
            [dataArray addObject:[arr objectAtIndex:i]];
        }
        // 刷新表格UI
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            // 刷新表格
            [self.table reloadData];
            
            [self.table headerEndRefreshing];
            [self.table footerEndRefreshing];
            
        });
    } Failure:^(NSError *error) {
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
        
        [self.table headerEndRefreshing];
        [self.table footerEndRefreshing];
        
    } view:self.view isPost:FALSE];
}

-(void)onLogin:(NSNotification*)noti
{
    TYLoginViewController * login = [[TYLoginViewController alloc] init];
    
    NavViewController * nav  = [[NavViewController alloc] initWithRootViewController:login];
    [self.navigationController presentViewController:nav animated:YES completion:^{
        
    }];

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [dataArray count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * strID = @"cell";
    TYNewsCommentCell * newsCell = [tableView dequeueReusableCellWithIdentifier:strID];
    if(!newsCell)
    {
        newsCell = [[TYNewsCommentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:strID];
    }
    
    newsCell.backgroundColor = myWhiteColor;
    newsCell.addr.text = [[dataArray objectAtIndex:indexPath.row] objectForKey:@"author"];
    newsCell.addr.textColor = myBlackColor;
    newsCell.time.text = [[dataArray objectAtIndex:indexPath.row] objectForKey:@"create_time"];
    newsCell.time.textColor = myBlackColor;
    newsCell.TTcontent.text = [[dataArray objectAtIndex:indexPath.row] objectForKey:@"content"];
    newsCell.TTcontent.textColor = myBlackColor;
    return newsCell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) keyboardWillShow:(NSNotification *) notif
{
    NSDictionary *info = [notif userInfo];
    
    NSValue *value = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
    
    CGSize keyboardSize = [value CGRectValue].size;
    
    [UIView animateWithDuration:0.1 delay:0 options:0 animations:^{
        ButtomView.frame = CGRectMake(0, self.view.frame.size.height- keyboardSize.height-55, 320, 50);
    } completion:^(BOOL finished) {
        
    }];
}

-(void)keyboardWillHide:(NSNotification*)noti
{
    [UIView animateWithDuration:0.1 delay:0 options:0 animations:^{
        ButtomView.frame = CGRectMake(0, self.view.frame.size.height-50
                                      , 320, 50);
    } completion:^(BOOL finished) {
        
    }];
    
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}

/**
 *  集成刷新控件
 */
- (void)setupRefresh
{
    // 1.下拉刷新(进入刷新状态就会调用self的headerRereshing)
    [self.table addHeaderWithTarget:self action:@selector(headerRereshing)];
    [self.table headerBeginRefreshing];
    
    // 2.上拉加载更多(进入刷新状态就会调用self的footerRereshing)
    [self.table addFooterWithTarget:self action:@selector(footerRereshing)];
    // 设置文字(也可以不设置,默认的文字在MJRefreshConst中修改)
    self.table.headerPullToRefreshText = @"下拉刷新";
    self.table.headerReleaseToRefreshText = @"松手立刻刷新";
    self.table.headerRefreshingText = @"正在努力刷新中...";
    
    self.table.footerPullToRefreshText = @"上拉加载更多数据";
    self.table.footerReleaseToRefreshText = @"松手马上加载更多数据";
    self.table.footerRefreshingText = @"正在努力加载中";
}

#pragma mark 开始进入刷新状态
- (void)headerRereshing
{
    currentPage = 0;
    [dataArray removeAllObjects];
    [self requestLoadData];
}

- (void)footerRereshing
{
    currentPage++;
    [self requestLoadData];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == [dataArray count] -1  && [dataArray count]>13)
    {
        [self.table footerBeginRefreshing];
    }
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
