//
//  TYNewsView.m
//  TYDaily
//
//  Created by laoniu on 14-10-17.
//
//

#import "TYNews.h"
#import "TYDayFeatSingleImageCell.h"
#import "TYDayFeatMutableImageCell.h"
#import "TYDayFeatNoImageCell.h"
#import "TYHeadCell.h"
#import "MJRefresh.h"


@implementation TYNews
{
    TYHttpRequest * httpRequest;
    __block NSMutableArray * dataArray;
    __block NSMutableArray * imageArray;
    BOOL isHeadViewLoad;
    
    NSInteger pageIndex;
    
    NSString * myDate;
    
}

- (void)viewLayout:(NSString *)requestDateString{
    
    self.backgroundColor = [UIColor whiteColor];

    //    scroller=[[EScrollerView alloc] initWithFrameRect:CGRectMake(0, 0, self.frame.size.width, 160)
    //                                                          ImageArray:[NSArray arrayWithObjects:@"temp.jpg",@"KV图片.png", nil]
    //                                                          TitleArray:[NSArray arrayWithObjects:@"测试图片", nil]];
    //    scroller.delegate=self;
    //    [self addSubview:scroller];
    
    dataArray = [[NSMutableArray alloc] init];
    imageArray = [[NSMutableArray alloc] init];
    
    
    Date * date = [[Date alloc] init];
    
    myDate= [date stringFormDate:[NSDate date] isHorLine:NO];
    if(requestDateString)
    {
        myDate = requestDateString;
    }
    
    pageIndex = 0;
    
    httpRequest = [[TYHttpRequest alloc] init];
    _table = [[UITableView alloc] initWithFrame:CGRectMake(0,0, self.frame.size.width, self.frame.size.height)];
    _table.delegate = self;
    _table.dataSource = self;
    _table.tableFooterView = [[UIView alloc] init];
    [self addSubview:_table];
    
    [self setupRefresh];
    // Do any additional setup after loading the view.
}

-(void)NewshttpRequest:(NSString *)date
{
    
    [httpRequest httpRequest:_newsRequest parameter:[NSString stringWithFormat:@"pageSize=%@&pageNo=%d",@"14",pageIndex] Success:^(id result) {
        NSData* jsonData = [result dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary * dic = (NSDictionary*)[jsonData objectFromJSONData];
        
        NSLog(@">>>>>>>>>>>>%@",dic);
        for(NSDictionary * tempDic in [dic objectForKey:@"articles"])
        {
            [dataArray addObject:tempDic];
        }
        
        if([dataArray count] ==0)
        {
            
        }
        else
        {
            // 刷新表格UI
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                // 刷新表格
                [self.table reloadData];
                
                [self.table headerEndRefreshing];
                [self.table footerEndRefreshing];
                
            });
            
        }
        
        
        
    } Failure:^(NSError *error) {
        NSLog(@"%@",error);
        
    } view:self isPost:FALSE];
    
}

//-(void)getImage
//{
//    if([dataArray count] != 0)
//    {
//        httpRequest = [[TYHttpRequest alloc] init];
//
//        for(int i = 0;i<[dataArray count]; i++)
//        {
//            NSString * strID = [[dataArray objectAtIndex:i] objectForKey:@"id"];
//            [httpRequest httpRequest:@"image/list2" parameter:[NSString stringWithFormat:@"id=%@",strID] Success:^(id result) {
//                NSData* jsonData = [result dataUsingEncoding:NSUTF8StringEncoding];
//                NSLog(@"%@",[jsonData objectFromJSONData]);
//
//                [imageArray addObject:[jsonData objectFromJSONData]];
//
//                if(i == [dataArray count]-1)
//                {
//                    NSLog(@"%@",imageArray);
//
//                    [_table reloadData];
//
//                }
//            } Failure:^(NSError *error) {
//
//            }];
//
//        }
//    }
//
//
//}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section ==0)
    {
        return 1;
    }
    else
    {
        if([dataArray count] !=0)
        {
            return [dataArray count];
            
        }
        else
        {
            return 0;
        }
        
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section ==0)
    {
        if([dataArray count]==0)
        {
        }
        else
        {
            if([[[NSUserDefaults standardUserDefaults] objectForKey:@"showImage"] isEqualToString:@"no"])
            {
                return 0;
            }
            else
            {
                return 160;
                
            }

        }
    }
    else
    {
        if([dataArray count] ==0)
        {
            return 50;
        }
        else
        {
//            if( [[[dataArray objectAtIndex:indexPath.row] objectForKey:@"imgs"] count] == 0)
//            {
//                return 80;
//            }
//            else if([[[dataArray objectAtIndex:indexPath.row] objectForKey:@"imgs"] count] == 1)
//            {
                return 90;
//            }
//            else
//            {
//                return 110;
//            }

        }
        
    }
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
    if([dataArray count ] == 0)
    {
        UITableViewCell * cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"23232"];
        return cell;
    }
    else
    {
        if(indexPath.section ==0)
        {
            static NSString * strID = @"cell1";
            TYHeadCell * cell = [tableView dequeueReusableCellWithIdentifier:strID];
            if(!cell)
            {
                cell = [[TYHeadCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:strID];
            }
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
           
            if([[[NSUserDefaults standardUserDefaults] objectForKey:@"showImage"] isEqualToString:@"no"] )
            {
                
            }
            else
            {
                if(isHeadViewLoad)
                {
                    cell.requestDateString = myDate;
                    NSLog(@"%@",myDate);
                    [cell sendRequestWithAppImgSlider:myDate];
                }
            }
            
            
            return cell;
        }
        else
        {
            if([[[NSUserDefaults standardUserDefaults] objectForKey:@"showImage"] isEqualToString:@"no"])
            {
                static NSString * strID = @"cell2";
                TYDayFeatNoImageCell * cell = [tableView dequeueReusableCellWithIdentifier:strID];
                if(!cell)
                {
                    cell = [[TYDayFeatNoImageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:strID];
                }
                
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                cell.mytitle.text =[CS DealWithString:[[dataArray objectAtIndex:indexPath.row] objectForKey:@"title"]];
//                cell.content.text = [CS DealWithString:[[dataArray objectAtIndex:indexPath.row] objectForKey:@"title"]];
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

                return cell;
                
            }
            else
            {
                static NSString * strID = @"cell3";
                TYDayFeatSingleImageCell * cell = [tableView dequeueReusableCellWithIdentifier:strID];
                if(!cell)
                {
                    cell = [[TYDayFeatSingleImageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:strID];
                }
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
//                [cell.type setTitle:[[dataArray objectAtIndex:indexPath.row] objectForKey:@"PageName"] forState:UIControlStateNormal];
                
                cell.title.text =[CS DealWithString:[[dataArray objectAtIndex:indexPath.row] objectForKey:@"title"]];
                [cell.image setImageWithURL:[NSURL URLWithString:[[dataArray objectAtIndex:indexPath.row] objectForKey:@"img1"]] placeholderImage:[UIImage imageNamed:@""]];
                
//                cell.content.text = [CS DealWithString: [[dataArray objectAtIndex:indexPath.row] objectForKey:@"label"]];
                
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

                
                return cell;
            }
//            else
//            {
//                static NSString * strID = @"cell4";
//                TYDayFeatMutableImageCell * cell = [tableView dequeueReusableCellWithIdentifier:strID];
//                if(!cell)
//                {
//                    cell = [[TYDayFeatMutableImageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:strID];
//                }
//                cell.selectionStyle = UITableViewCellSelectionStyleNone;
//                
//                [cell setImageArray:[[dataArray objectAtIndex:indexPath.row] objectForKey:@"img1"]];
//                
//                cell.title.text =[CS DealWithString:[[dataArray objectAtIndex:indexPath.row] objectForKey:@"title"]];
////                [cell.type setTitle:[[dataArray objectAtIndex:indexPath.row] objectForKey:@"PageName"] forState:UIControlStateNormal];
//                
//                cell.type.hidden = YES;
//                
//                return cell;
//            }
            
        }

    }
    
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%@",dataArray);
    if(indexPath.section ==1)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"pushNewsCenterWithID" object:[[dataArray objectAtIndex:indexPath.row] objectForKey:@"id"]];
            
    }
    
}
-(void)EScrollerViewDidClicked:(NSUInteger)index
{
    NSLog(@"index--%d",index);
}

-(void)requestLoadData{
   
    //新闻页请求数据
    [self NewshttpRequest:_newsRequest];

    
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
    
  
    // 2.上拉加载更多(进入刷新状态就会调用self的footerRereshing)
    [self.table addFooterWithTarget:self action:@selector(footerRereshing)];
    
    self.table.footerPullToRefreshText = @"上拉加载更多数据";
    self.table.footerReleaseToRefreshText = @"松手马上加载更多数据";
    self.table.footerRefreshingText = @"正在努力加载中";
    
    
}

#pragma mark 开始进入刷新状态
- (void)headerRereshing
{
    pageIndex = 0;
    [dataArray removeAllObjects];
    [self requestLoadData];
}

- (void)footerRereshing
{
    pageIndex ++;
    [self requestLoadData];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == [dataArray count]-1  && [dataArray count]>13)
    {
        [self.table footerBeginRefreshing];
    }
}


@end
