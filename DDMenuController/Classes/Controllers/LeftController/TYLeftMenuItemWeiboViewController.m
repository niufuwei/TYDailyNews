//
//  TYLeftMenuItemWeiboViewController.m
//  TYDaily
//
//  Created by laoniu on 14-10-2.
//
//

#import "TYLeftMenuItemWeiboViewController.h"
#import "TYLoginViewController.h"
#import "MJRefresh.h"
#import "TYWeiboHeadCell.h"
#import "TYWeiboContentCell.h"
#import "TYWeiboInformationViewController.h"

@interface TYLeftMenuItemWeiboViewController ()
{
    NavCustom * myNavCustom;
    TYHttpRequest * httpRequest;
    UIActivityIndicatorView * testActivityIndicator;
    UIWebView * myWebView;
    NSInteger indexPage;
    NSMutableArray * dataArray;
    NSNumberFormatter* numberFormatter ;
    NSDictionary * topDic;
    
    UIColor * myBlackColor;
    UIColor * myWhiteColor;
}

@end

@implementation TYLeftMenuItemWeiboViewController

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
    numberFormatter = [[NSNumberFormatter alloc] init];
    topDic = [[NSDictionary alloc] init];
    
    myNavCustom = [[NavCustom alloc] init];
    [myNavCustom setNavWithText:@"太原日报官方微博" mySelf:self];
    [myNavCustom setNavLeftBtnImage:@"left_ios.png" LeftBtnSelectedImage:@"" mySelf:self width:18 height:15];
    [myNavCustom setNavRightBtnImage:@"USER_ios.png" RightBtnSelectedImage:@"" mySelf:self width:18 height:20];
    myNavCustom.NavDelegate = self;
    
    httpRequest = [[TYHttpRequest alloc] init];
    dataArray = [[NSMutableArray alloc] init];
    
    _table = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-64)];
    _table.delegate =self;
    _table.dataSource =self;
    _table.backgroundColor = myWhiteColor;
    [self.view addSubview:_table];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onLogin:) name:@"login" object:nil];

    
//    if([[NSUserDefaults standardUserDefaults] objectForKey:@"weiboweibo"])
//    {
//        dataArray = [[NSMutableArray alloc] initWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"weiboweibo"]];
//    
//        [_table reloadData];
//    }
    
    [self setupRefresh];
    
    //获取用户数和微博数，关注数
    
    // Do any additional setup after loading the view.
}

//-(void)getInfor
//{
//    NSString * paramter ;
//    if([[NSUserDefaults standardUserDefaults] objectForKey:@"accessToken"])
//    {
//        paramter = [NSString stringWithFormat:@"access_token=%@&uids=%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"accessToken"],@"3766677022229351"];
//    }
//    else
//    {
//        paramter = [NSString stringWithFormat:@"source=%@&uids=%@",kAppkey,@"3766677022229351"];
//    }
//    [httpRequest httpRequestWeiBo:@"https://api.weibo.com/2/users/counts.json" parameter:paramter Success:^(id result) {
//        
//        NSLog(@"%@",result);
//        NSData* jsonData = [result dataUsingEncoding:NSUTF8StringEncoding];
//        NSArray * arr  = (NSArray*)[jsonData objectFromJSONData];
//        topDic = [arr objectAtIndex:0];
//        
//        NSIndexPath * index = [NSIndexPath indexPathForRow:0 inSection:0];
//        [_table reloadRowsAtIndexPaths:[NSArray arrayWithObject:index] withRowAnimation:UITableViewRowAnimationAutomatic];
//    } Failure:^(NSError *error) {
//        
//        NSLog(@"%@",error);
//    } view:self.view isPost:NO];
//}

-(void)httpRequest
{
    [httpRequest httpRequestWeiBo:@"http://123.57.17.124/weibo/weibo_list.php" parameter:[NSString stringWithFormat:@"page=%d&count=%@",indexPage,@"8"] Success:^(id result) {
        
        NSLog(@"%@",result);
        NSData* jsonData = [result dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary * dic = (NSDictionary*)[jsonData objectFromJSONData];

        NSArray * arr = [dic objectForKey:@"statuses"];
        for(int i=0;i<[arr count];i++)
        {
            [dataArray addObject:[arr objectAtIndex:i]];
        }
        
        if([dataArray count] ==0)
        {
            
        }
        else
        {
            [_table reloadData];
           
        }
        [_table headerEndRefreshing];
        [_table footerEndRefreshing];
//        [self getInfor];

    } Failure:^(NSError *error) {
        [_table headerEndRefreshing];
        [_table footerEndRefreshing];
        NSLog(@"%@",error);
    } view:self.view isPost:NO];
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

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([dataArray count] ==0)
    {
        UITableViewCell * cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"sss"];
        return cell;
    }
    else
    {
        if(indexPath.row ==0)
        {
            static NSString * strID = @"cell1";
            TYWeiboHeadCell * cell = [tableView dequeueReusableCellWithIdentifier:strID];
            if(!cell)
            {
                cell = [[TYWeiboHeadCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:strID];
            }
            cell.backgroundColor = myWhiteColor;

//            [cell.IconView setImageWithURL:[[[dataArray objectAtIndex:0] objectForKey:@"user"] objectForKey:@"profile_image_url"] placeholderImage:[UIImage imageNamed:@""]];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell.IconView setImage:[UIImage imageNamed:@"weiboICon.jpg"]];
            
            cell.Content.text = [[[dataArray objectAtIndex:0] objectForKey:@"user"] objectForKey:@"description"];
            cell.Content.textColor= myBlackColor;
            cell.URL.text = [[[dataArray objectAtIndex:indexPath.row] objectForKey:@"user"] objectForKey:@"url"];
            cell.URL.textColor = myBlackColor;
            
            NSString * tempString = @"";
            
            cell.ButtomLabel.text = [NSString stringWithFormat:@"%@关注 | %@粉丝 | %@微博 ", [numberFormatter stringFromNumber:[[[dataArray objectAtIndex:0] objectForKey:@"user"] objectForKey:@"friends_count"] ],[numberFormatter stringFromNumber:[[[dataArray objectAtIndex:0] objectForKey:@"user"] objectForKey:@"followers_count"] ],[numberFormatter stringFromNumber:[[[dataArray objectAtIndex:0] objectForKey:@"user"] objectForKey:@"statuses_count"] ]];
            cell.ButtomLabel.textColor= myBlackColor;
            [cell.btnAttention addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
           
            if([[[NSUserDefaults standardUserDefaults] objectForKey:@"guanzhu"] isEqualToString:@"ok"])
            {
                tempString = @"已关注";
            }
            else
            {
                tempString = @"关注";
            }
            [cell.btnAttention setTitle:tempString forState:UIControlStateNormal];
            return cell;
        }
        else
        {
            static NSString * strID = @"cell2";
            TYWeiboContentCell * cell = [tableView dequeueReusableCellWithIdentifier:strID];
            if(!cell)
            {
                cell = [[TYWeiboContentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:strID];
            }
            cell.backgroundColor = myWhiteColor;

            cell.titleLabel.text = [[dataArray objectAtIndex:indexPath.row] objectForKey:@"text"];
            cell.titleLabel.textColor = myBlackColor;
            NSLog(@"%@",[[dataArray objectAtIndex:indexPath.row] objectForKey:@"thumbnail_pic"]);
            
            
            if([[[NSUserDefaults standardUserDefaults] objectForKey:@"showImage"] isEqualToString:@"no"])
            {
                [cell.imageContent setImage:[UIImage imageNamed:@"WB.jpg"]];
            }
            else
            {
                [cell.imageContent setImageWithURL:[NSURL URLWithString:[[dataArray objectAtIndex:indexPath.row] objectForKey:@"thumbnail_pic"]] placeholderImage:[UIImage imageNamed:@"WB.jpg"]];

            }

        
            cell.timeLabel.text = [[dataArray objectAtIndex:indexPath.row] objectForKey:@"created_at"];
            cell.timeLabel.textColor = myBlackColor;
            
            cell.pinglun.text = [numberFormatter stringFromNumber:[[dataArray objectAtIndex:indexPath.row] objectForKey:@"comments_count"]];
            cell.pinglun.textColor = myBlackColor;
            
            cell.zhuanfa.text = [numberFormatter stringFromNumber:[[dataArray objectAtIndex:indexPath.row] objectForKey:@"reposts_count"]];
            cell.zhuanfa.textColor = myBlackColor;
            return cell;
        }
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row ==0)
    {
        
    }
    else
    {
        TYWeiboInformationViewController * infor = [[TYWeiboInformationViewController alloc] init];
        infor.WeiboID = [[dataArray objectAtIndex:indexPath.row] objectForKey:@"id"];
        [self.navigationController pushViewController:infor animated:YES];

    }
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
    indexPage = 1;
    [dataArray removeAllObjects];
    [self httpRequest];
}

- (void)footerRereshing
{
    indexPage++;
    [self httpRequest];
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == [dataArray count] -1 && [dataArray count]>7)
    {
        [self.table footerBeginRefreshing];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row ==0)
    {
        return 200;
    }
    else
    {
        return 200;
    }
}

-(void)onClick:(id)sender
{
    if([[[NSUserDefaults standardUserDefaults] objectForKey:@"guanzhu"] isEqualToString:@"ok"])
    {
        UIAlertView * alert =[[UIAlertView alloc] initWithTitle:nil message:@"您已关注此微博" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];

    }
    else
    {
        if([[NSUserDefaults standardUserDefaults] objectForKey:@"accessToken"])
        {

            NSDictionary * dic = [[NSDictionary alloc] initWithObjects:[NSArray arrayWithObjects:[[NSUserDefaults standardUserDefaults] objectForKey:@"accessToken"],@"3766677022229351",@"太原日报",@"211.156.0.1", nil] forKeys:[NSArray arrayWithObjects:@"access_token",@"uid",@"screen_name",@"rip" ,nil]];
            
            [httpRequest httpRequestWeiBo:@"https://api.weibo.com/2/friendships/create.json" parameter:dic Success:^(id result) {
                
                NSLog(@"%@",result);
                UIWindow *window = [[UIApplication sharedApplication].windows objectAtIndex:[[UIApplication sharedApplication].windows count]-1];
                CBMBProgressHUD *indicator = [[CBMBProgressHUD alloc] initWithWindow:window];
                indicator.labelText = @"关注成功";
                
                [[NSUserDefaults standardUserDefaults] setObject:@"ok" forKey:@"guanzhu"];

                NSIndexPath * index = [NSIndexPath indexPathForRow:0 inSection:0];
                TYWeiboHeadCell * head = (TYWeiboHeadCell*)[_table cellForRowAtIndexPath:index];
                [head.btnAttention setTitle:@"已关注" forState:UIControlStateNormal];
                
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
