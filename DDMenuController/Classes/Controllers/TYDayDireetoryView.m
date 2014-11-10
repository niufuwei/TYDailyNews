//
//  TYDayDireetoryViewController.m
//  TYDaily
//
//  Created by laoniu on 14-10-3.
//
//


#import "TYDayDireetoryView.h"
#import "TYDayDireetionyDoubleCell.h"
#import "TYDayDireetioryHeadView.h"
#import "TYDayDireetiorySingleCell.h"
#import "MJRefresh.h"

@interface TYDayDireetoryView ()
{
    TYHttpRequest * httpRequest;
    NSMutableArray * dataArray;
    NSString * myDate;
    UIColor * myBlackColor;
    UIColor * myWhiteColor;

}

@property (nonatomic,strong) UITableView * table;

@end

@implementation TYDayDireetoryView
@synthesize table;

-(void)viewwill
{
    if([[[NSUserDefaults standardUserDefaults] objectForKey:@"isDayShow"] isEqualToString:@"0"])
    {
        myBlackColor = [UIColor whiteColor];
        myWhiteColor = [UIColor blackColor];
    }
    else
    {
        myWhiteColor = [UIColor whiteColor];
        myBlackColor = [UIColor blackColor];
    }
    self.backgroundColor = myWhiteColor;
    [self setupRefresh];

    
}
- (void)viewLayout:(NSString *)requestDateString {

    [self viewwill];
    
    Date * date = [[Date alloc] init];
    dataArray = [[NSMutableArray alloc] init];
//    
//    UILabel * dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width - 130, 0, 120, 20)];
//    dateLabel.font = [UIFont systemFontOfSize:11];
//    dateLabel.textColor = [UIColor grayColor];
//    dateLabel.backgroundColor = [UIColor clearColor];
//    dateLabel.text = [NSString stringWithFormat:@"%@ %@",[date getYMDInfor:[NSDate date]],[date getWeakInfor:[NSDate date]]];
//    [self addSubview:dateLabel];
    
    table = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height-64)];
    table.delegate = self;
    table.dataSource = self;
    table.tableFooterView = [[UIView alloc] init];

    [self addSubview:table];
    
    myDate= [date stringFormDate:[NSDate date] isHorLine:NO];
    if(requestDateString)
    {
        myDate = requestDateString;
    }
    
 
    [self setupRefresh];

    // Do any additional setup after loading the view.
}

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return [dataArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if([dataArray count] ==0)
    {
        return 0;
    }
    else
    {
        return [[[dataArray objectAtIndex:section] objectForKey:@"articles"] count];

    }
}



// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if(indexPath.row ==0 || indexPath.row ==1 || indexPath.row ==3)
//    {
        static NSString * strID = @"cell1";
        TYDayDireetiorySingleCell * cell = [table dequeueReusableCellWithIdentifier:strID];
        if(!cell)
        {
            cell = [[TYDayDireetiorySingleCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:strID];
        }
        
        NSLog(@"%@",[[[[dataArray objectAtIndex:indexPath.section] objectForKey:@"articles"] objectAtIndex:indexPath.row] objectForKey:@"title"]);
    
        if([[[NSUserDefaults standardUserDefaults] objectForKey:@"isDayShow"] isEqualToString:@"0"])
        {
            cell.isDayShow = TRUE;
        }
        else
        {
            cell.isDayShow = false;
        }
    
        cell.myTitle.text = [CS DealWithString:[[[[dataArray objectAtIndex:indexPath.section] objectForKey:@"articles"] objectAtIndex:indexPath.row] objectForKey:@"title"]];
        
        NSNumberFormatter* numberFormatter = [[NSNumberFormatter alloc] init];
        
        cell.num.text = [numberFormatter stringFromNumber:[[[[dataArray objectAtIndex:indexPath.section] objectForKey:@"articles"] objectAtIndex:indexPath.row] objectForKey:@"ccount"]];
//        cell.num.text = [[[[dataArray objectAtIndex:indexPath.section] objectForKey:@"Articles"] objectAtIndex:indexPath.row] objectForKey:@"Ccount"];
    
        cell.backgroundColor = myWhiteColor;
    
        return cell;
//    }
//    else
//    {
//        static NSString * strID = @"cell";
//        TYDayDireetionyDoubleCell * cell = [table dequeueReusableCellWithIdentifier:strID];
//        if(!cell)
//        {
//            cell = [[TYDayDireetionyDoubleCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:strID];
//        }
//        
//        cell.myTitle.text = []
//        return cell;
//    }
    
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
   TYDayDireetioryHeadView * view = [[TYDayDireetioryHeadView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 30)];;

   [view HeadViewLoad];
    
    view.value.text = [[dataArray objectAtIndex:section] objectForKey:@"pageNo"];
    view.type.text =[[dataArray objectAtIndex:section] objectForKey:@"pageName"];
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if(indexPath.row ==2)
//    {
//        return 90;
//    }
//    else
//    {
        return 70;
//    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    [[NSNotificationCenter defaultCenter] postNotificationName:@"pushNewsWithID" object:[[[[dataArray objectAtIndex:indexPath.section] objectForKey:@"articles"] objectAtIndex:indexPath.row] objectForKey:@"id"]];
    
}

-(void)requestLoadData{
    
    httpRequest = [[TYHttpRequest alloc] init];

    [httpRequest httpRequest:@"article/listall" parameter:[NSString stringWithFormat:@"date=%@",myDate] Success:^(id result) {
        NSLog(@"%@",result);
        
        NSData* jsonData = [result dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary * dic = (NSDictionary*)[jsonData objectFromJSONData];
        dataArray = [dic objectForKey:@"pages"];
        
//        for(int i= 0;i <[arr count];i++)
//        {
//            [dataArray addObject:[arr objectAtIndex:i]];
//        }
//
        [table reloadData];
        [table headerEndRefreshing];
        
    } Failure:^(NSError *error) {
        NSLog(@"%@",error);
        [table headerEndRefreshing];

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
        
    } view:self isPost:FALSE];

}

/**
 *  集成刷新控件
 */
- (void)setupRefresh
{
    // 1.下拉刷新(进入刷新状态就会调用self的headerRereshing)
    [self.table addHeaderWithTarget:self action:@selector(headerRereshing)];
    [self.table headerBeginRefreshing];
    
    // 设置文字(也可以不设置,默认的文字在MJRefreshConst中修改)
    self.table.headerPullToRefreshText = @"下拉刷新";
    self.table.headerReleaseToRefreshText = @"松手立刻刷新";
    self.table.headerRefreshingText = @"正在努力刷新中...";
    
}

#pragma mark 开始进入刷新状态
- (void)headerRereshing
{
    [self requestLoadData];
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
