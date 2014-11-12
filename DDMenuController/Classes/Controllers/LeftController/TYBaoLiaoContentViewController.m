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
    
    UIColor * myBlackColor;
    UIColor * myWhiteColor;
}

@end

@implementation TYBaoLiaoContentViewController

-(id)initWithFrame:(CGRect)frame withUrl:(NSString *)withUrl
{
    if(self = [super initWithFrame:frame])
    {
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
        
        [self setBackgroundColor:[UIColor whiteColor]];
        url = withUrl;
        
        _table = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        _table.delegate =self;
        _table.dataSource =self;
        _table.tableFooterView = [[UIView alloc] init];
        _table.backgroundColor = myWhiteColor;
        [self addSubview:_table];
        
        dataArray = [[NSMutableArray alloc] init];
        
        //加载数据
        //    [self loadlayoutView];
        
        
        if([[NSUserDefaults standardUserDefaults] objectForKey:url])
        {
            dataArray = [[NSMutableArray alloc] initWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:url]];
            [_table reloadData];
        }
        
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
    if([dataArray count] ==0)
    {
        
    }
    else
    {
        if([[[NSUserDefaults standardUserDefaults] objectForKey:@"showImage"] isEqualToString:@"no"])
        {
            [cell.icon setImage:[UIImage imageNamed:@"noImage"]];
        }
        else
        {
            [cell.icon setImageWithURL:[NSURL URLWithString:[[dataArray objectAtIndex:indexPath.row] objectForKey:@"img1"]] placeholderImage:[UIImage imageNamed:@"noImage"]];

        }
        if([[[dataArray objectAtIndex:indexPath.row] objectForKey:@"label"] length] ==0)
        {
            cell.type.hidden = YES;
            CGRect height = cell.titleLabel.frame;
            height.size.height = 80;
            cell.titleLabel.frame = height;
            cell.titleLabel.textAlignment = NSTextAlignmentCenter;
            cell.titleLabel.text = [[dataArray objectAtIndex:indexPath.row] objectForKey:@"title"];
        }
        else
        {
            cell.titleLabel.text = [[dataArray objectAtIndex:indexPath.row] objectForKey:@"title"];
            //        cell.contentLabel.text = [[dataArray objectAtIndex:indexPath.row]  objectForKey:@"title"];
            CGRect height = cell.titleLabel.frame;
            height.size.height = 40;
            height.origin.y= 20;
            cell.titleLabel.frame = height;
            cell.titleLabel.textAlignment = NSTextAlignmentCenter;
            [cell.type setTitle:[[dataArray objectAtIndex:indexPath.row] objectForKey:@"label"] forState:UIControlStateNormal];
            
            NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:13]};
            CGSize size = [[[dataArray objectAtIndex:indexPath.row] objectForKey:@"label"] boundingRectWithSize:CGSizeMake(MAXFLOAT, cell.type.frame.size.height) options:NSStringDrawingTruncatesLastVisibleLine attributes:attribute context:nil].size;
            //根据计算结果重新设置UILabel的尺寸
            if(size.width > 40)
            {
                [cell.type setFrame:CGRectMake(self.frame.size.width-size.width - 20, cell.type.frame.origin.y, size.width+10, cell.type.frame.size.height)];
                
            }
            else
            {
                [cell.type setFrame:CGRectMake(self.frame.size.width-50, cell.type.frame.origin.y, 40, cell.type.frame.size.height)];
            }
            
        }
        cell.titleLabel.textColor = myBlackColor;
        cell.bottomLabel.text = [[[[dataArray objectAtIndex:indexPath.row] objectForKey:@"name"] stringByAppendingString:@"   "] stringByAppendingString:[[dataArray objectAtIndex:indexPath.row] objectForKey:@"create_time"]];
        cell.bottomLabel.textColor = myBlackColor;

    }
        cell.backgroundColor = myWhiteColor;
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
    [httpRequest httpRequest:url parameter:[NSString stringWithFormat:@"pageSize=%@&pageNo=%d",@"14",indexPage] Success:^(id result) {
        
        NSLog(@"result===>%@",result);
        NSData* jsonData = [result dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary * dic = (NSDictionary*)[jsonData objectFromJSONData];
        NSArray * arr =  [dic objectForKey:@"articles"];
        
        for(int i= 0;i<[arr count];i++)
        {
            [dataArray addObject:[arr objectAtIndex:i]];
        }
      
        [[NSUserDefaults standardUserDefaults] setObject:dataArray forKey:url];
        [_table reloadData];
        [_table headerEndRefreshing];
        [_table footerEndRefreshing];
        
        
    } Failure:^(NSError *error) {
        NSLog(@"error==>%@",error);
        
        [_table headerEndRefreshing];
        [_table footerEndRefreshing];
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
