//
//  TYBaoLiaoContentViewController.m
//  TYDaily
//
//  Created by laoniu on 14/11/5.
//
//

#import "TYBaoLiaoContentViewController.h"
#import "TYBaoLiaoCell.h"
#import "TYBaoLiaoInformationViewController.h"
#import "MJRefresh.h"

@interface TYBaoLiaoContentViewController ()
{
    TYHttpRequest * httpRequest;
    NSMutableArray * dataArray;
    NSInteger indexPage;
}

@end

@implementation TYBaoLiaoContentViewController

-(id)initWithFrame:(CGRect)frame withUrl:(NSString *)withUrl
{
    if(self = [super initWithFrame:frame])
    {
        [self setBackgroundColor:[UIColor whiteColor]];
        
        _table = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        _table.delegate =self;
        _table.dataSource =self;
        _table.tableFooterView = [[UIView alloc] init];
        [self addSubview:_table];
        
        dataArray = [[NSMutableArray alloc] init];
        
        //加载数据
        //    [self loadlayoutView];
        
        [self setupRefresh];

    }
    return self;
    
    // Do any additional setup after loading the view.
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [dataArray count];
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * strID = @"cell";
    TYBaoLiaoCell * cell = [tableView dequeueReusableCellWithIdentifier:strID];
    if(!cell)
    {
        cell = [[TYBaoLiaoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:strID];
    }
    
    cell.titleLabel.text = [[dataArray objectAtIndex:indexPath.row] objectForKey:@"Title"];
    
    cell.nameWithTimer.text = [[[[dataArray objectAtIndex:indexPath.row] objectForKey:@"author"] stringByAppendingString:@"   "] stringByAppendingString:[[dataArray objectAtIndex:indexPath.row] objectForKey:@"Create_time"]];
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"baoliaoinfo" object:[[dataArray objectAtIndex:indexPath.row] objectForKey:@"id"]];
}
-(void)loadlayoutView
{
    httpRequest = [[TYHttpRequest alloc] init];
    [httpRequest httpRequest:@"bl/list" parameter:[NSString stringWithFormat:@"pageSize=%@&pageNo=%d",@"14",indexPage] Success:^(id result) {
        
        NSLog(@"result===>%@",result);
        NSData* jsonData = [result dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary * dic = (NSDictionary*)[jsonData objectFromJSONData];
        NSArray * arr =  [dic objectForKey:@"bls"];
        
        for(int i= 0;i<[arr count];i++)
        {
            [dataArray addObject:[arr objectAtIndex:i]];
        }
        
        [_table reloadData];
        [_table headerEndRefreshing];
        [_table footerEndRefreshing];
        
    } Failure:^(NSError *error) {
        NSLog(@"error==>%@",error);
        
    } view:self isPost:NO];
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
    indexPage = 0;
    [dataArray removeAllObjects];
    [self loadlayoutView];
}

- (void)footerRereshing
{
    indexPage++;
    [self loadlayoutView];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == [dataArray count] -1 && [dataArray count]>13)
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
