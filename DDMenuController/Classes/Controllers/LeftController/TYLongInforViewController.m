//
//  TYLongInforViewController.m
//  TYDaily
//
//  Created by laoniu on 14-10-12.
//
//

#import "TYLongInforViewController.h"
#import "TYDayFeatSingleImageCell.h"
#import "TYDayFeatMutableImageCell.h"
#import "TYDayFeatNoImageCell.h"
#import "TYNewsViewController.h"
#import "MJRefresh.h"

@interface TYLongInforViewController ()
{
    NSMutableArray * dataArray;
    NSInteger pageIndex;
    TYHttpRequest * httpRequest;
    NavCustom * custom;
    NSString *  myDate;
}
@end

@implementation TYLongInforViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    custom = [[NavCustom alloc] init];
    [custom setNavWithText:_titleStr mySelf:self];
    
    //    scroller=[[EScrollerView alloc] initWithFrameRect:CGRectMake(0, 0, self.frame.size.width, 160)
    //                                                          ImageArray:[NSArray arrayWithObjects:@"temp.jpg",@"KV图片.png", nil]
    //                                                          TitleArray:[NSArray arrayWithObjects:@"测试图片", nil]];
    //    scroller.delegate=self;
    //    [self addSubview:scroller];
    
    dataArray = [[NSMutableArray alloc] init];
    
    
    Date * date = [[Date alloc] init];
    
    myDate= [date stringFormDate:[NSDate date] isHorLine:NO];
    
    pageIndex = 0;
    
   
    
    _table = [[UITableView alloc] initWithFrame:CGRectMake(0,0, self.view.frame.size.width, self.view.frame.size.height-64)];
    _table.delegate = self;
    _table.dataSource = self;
    _table.tableFooterView = [[UIView alloc] init];

    [self.view addSubview:_table];
    
    //新闻页请求数据
    [self setupRefresh];
    // Do any additional setup after loading the view.
}


-(void)NewshttpRequest:(NSString *)date
{
    httpRequest = [[TYHttpRequest alloc] init];
    [httpRequest httpRequest:_requestUrl parameter:[NSString stringWithFormat:@"pageSize=%@&pageNo=%d",@"14",pageIndex] Success:^(id result) {
        NSLog(@"%@",result);
        NSData* jsonData = [result dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary * dic = (NSDictionary*)[jsonData objectFromJSONData];
        for(NSDictionary * tempDic in [dic objectForKey:@"articles"])
        {
            [dataArray addObject:tempDic];
        }
        
        [_table reloadData];
        [_table headerEndRefreshing];
        [_table footerEndRefreshing];
        
    } Failure:^(NSError *error) {
        NSLog(@"%@",error);
    } view:self.view isPost:FALSE];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   return [dataArray count];
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
 
//    if([[[dataArray objectAtIndex:indexPath.row] objectForKey:@"Images"] count] == 0)
//    {
//        return 50;
//    }
//    else if([[[dataArray objectAtIndex:indexPath.row] objectForKey:@"Images"] count] == 1)
//    {
        return 80;
//    }
//    else
//    {
//        return 110;
//    }
}

//-(NSArray*)getImageNumber:(NSString *)imageID
//{
//    NSArray * arr;
//
//    NSLog(@"%@",imageArray);
//    for(int i=0;i<[imageArray count] ;i++)
//    {
//
//        if([[[[imageArray objectAtIndex:i] allKeys] objectAtIndex:0] isEqualToString:imageID])
//        {
//            arr = [[imageArray objectAtIndex:i] objectForKey:imageID];
//        }
//    }
//    return arr;
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([dataArray count] ==0)
    {
        return nil;
    }
    else
    {
        if([[[NSUserDefaults standardUserDefaults] objectForKey:@"showImage"] isEqualToString:@"no"])
        {
            static NSString * strID = @"cell1";
            TYDayFeatNoImageCell * cell = [tableView dequeueReusableCellWithIdentifier:strID];
            if(!cell)
            {
                cell = [[TYDayFeatNoImageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:strID];
            }
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.mytitle.text =[CS DealWithString:[[dataArray objectAtIndex:indexPath.row] objectForKey:@"title"]];
//            cell.content.text = [CS DealWithString:[[dataArray objectAtIndex:indexPath.row] objectForKey:@"SubTitle"]];
            cell.mytitle.frame = CGRectMake(cell.mytitle.frame.origin.x, 0, cell.mytitle.frame.size.width, cell.frame.size.height);
            [cell.type setTitle:[[dataArray objectAtIndex:indexPath.row] objectForKey:@"label"] forState:UIControlStateNormal];
            cell.type.hidden = YES;
            
            return cell;
            
        }
        else
        {
            static NSString * strID = @"cell2";
            TYDayFeatSingleImageCell * cell = [tableView dequeueReusableCellWithIdentifier:strID];
            if(!cell)
            {
                cell = [[TYDayFeatSingleImageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:strID];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell.type setTitle:[[dataArray objectAtIndex:indexPath.row] objectForKey:@"label"] forState:UIControlStateNormal];
            
            NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:13]};
            CGSize size = [[[dataArray objectAtIndex:indexPath.row] objectForKey:@"label"] boundingRectWithSize:CGSizeMake(MAXFLOAT, cell.type.frame.size.height) options:NSStringDrawingTruncatesLastVisibleLine attributes:attribute context:nil].size;
            //根据计算结果重新设置UILabel的尺寸
            if(size.width > 40)
            {
                [cell.type setFrame:CGRectMake(self.view.frame.size.width-size.width - 20, cell.type.frame.origin.y, size.width+10, cell.type.frame.size.height)];
                
            }
            else
            {
                [cell.type setFrame:CGRectMake(self.view.frame.size.width-50, cell.type.frame.origin.y, 40, cell.type.frame.size.height)];
            }


            cell.title.text =[CS DealWithString:[[dataArray objectAtIndex:indexPath.row] objectForKey:@"title"]];
            cell.title.frame = CGRectMake(cell.title.frame.origin.x, 0, cell.title.frame.size.width, 80);

            [cell.image setImageWithURL:[NSURL URLWithString:[[dataArray objectAtIndex:indexPath.row] objectForKey:@"img1"]] placeholderImage:[UIImage imageNamed:@""]];
            
//            cell.content.text = [CS DealWithString: [[dataArray objectAtIndex:indexPath.row] objectForKey:@"SubTitle"]];
           
//            cell.type.hidden = YES;
            
            return cell;
        }
//        else
//        {
//            static NSString * strID = @"cell3";
//            TYDayFeatMutableImageCell * cell = [tableView dequeueReusableCellWithIdentifier:strID];
//            if(!cell)
//            {
//                cell = [[TYDayFeatMutableImageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:strID];
//            }
//            cell.selectionStyle = UITableViewCellSelectionStyleNone;
//            
//            [cell setImageArray:[[dataArray objectAtIndex:indexPath.row] objectForKey:@"Images"]];
//            
//            cell.title.text =[CS DealWithString:[[dataArray objectAtIndex:indexPath.row] objectForKey:@"Title"]];
//            [cell.type setTitle:[[dataArray objectAtIndex:indexPath.row] objectForKey:@"PageName"] forState:UIControlStateNormal];
//            
//            cell.type.hidden = YES;
//            
//            return cell;
//        }
        
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    TYNewsViewController * news = [[TYNewsViewController alloc] init];
    
    news.newsID =[[dataArray objectAtIndex:indexPath.row] objectForKey:@"id"];
    
    news.isNewsCenter = TRUE;
   _requestUrl = [_requestUrl stringByReplacingOccurrencesOfString:@"list" withString:@"view"];
    news.address =_requestUrl;
    
    [self.navigationController pushViewController:news animated:YES];
    
        
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
    pageIndex = 0;
    [dataArray removeAllObjects];
    [self NewshttpRequest:myDate];
}

- (void)footerRereshing
{
    pageIndex++;
    [self NewshttpRequest:myDate];
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == [dataArray count] -1 && [dataArray count]>13)
    {
        [self.table footerBeginRefreshing];
    }
}


-(void)EScrollerViewDidClicked:(NSUInteger)index
{
    NSLog(@"index--%d",index);
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
