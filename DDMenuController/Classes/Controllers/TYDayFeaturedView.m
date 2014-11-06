//
//  TYDayFeaturedViewController.m
//  TYDaily
//
//  Created by laoniu on 14-10-3.
//
//

#import "TYDayFeaturedView.h"
#import "TYDayFeatSingleImageCell.h"
#import "TYDayFeatMutableImageCell.h"
#import "TYDayFeatNoImageCell.h"
#import "TYHeadCell.h"
#import "MJRefresh.h"

@interface TYDayFeaturedView ()
{
    TYHttpRequest * httpRequest;
   __block NSMutableArray * dataArray;
   __block NSMutableArray * imageArray;
    BOOL isHeadViewLoad;
    
    NSInteger pageIndex;
    
    NSString * myDate;
    UIColor * myBlackColor;
    UIColor * myWhiteColor;
    
}

@end

@implementation TYDayFeaturedView

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
- (void)viewLayout:(NSString *)requestDateString{

    
    [self viewwill];

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
    _table = [[UITableView alloc] initWithFrame:CGRectMake(0,0, self.frame.size.width, self.frame.size.height-64)];
    _table.delegate = self;
    _table.dataSource = self;
    _table.tableFooterView = [[UIView alloc] init];
    [self addSubview:_table];
    [self setupRefresh];

    // Do any additional setup after loading the view.
}


-(void)httpRequest:(NSString *)date
{
    [httpRequest httpRequest:@"article/select" parameter:[NSString stringWithFormat:@"date=%@",date] Success:^(id result) {
        NSData* jsonData = [result dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary * dic = (NSDictionary*)[jsonData objectFromJSONData];
        NSLog(@"%@",result);

        NSLog(@"%@",dic);
        NSLog(@"%@",dataArray);
       for(NSDictionary * tempDic in [dic objectForKey:@"articles"])
       {
           [dataArray addObject:tempDic];
       }
        
        if([dataArray count] ==0)
        {
            
        }
        else
        {
            [_table reloadData];
            [_table headerEndRefreshing];
          

        }
        
    } Failure:^(NSError *error) {
        NSLog(@"%@",error);
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
        if([dataArray count] ==0)
        {
            return 0;
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
//            if([[[dataArray objectAtIndex:indexPath.row] objectForKey:@"imgs"] count] == 0)
//            {
//                return 50;
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
    if([dataArray count] ==0)
    {
        UITableViewCell * cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell444"];
        cell.backgroundColor = myWhiteColor;

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
            
            if([[[NSUserDefaults standardUserDefaults] objectForKey:@"showImage"] isEqualToString:@"no"])
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
            
            cell.backgroundColor = myWhiteColor;
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
                
                if([[[NSUserDefaults standardUserDefaults] objectForKey:@"isDayShow"] isEqualToString:@"0"])
                {
                    cell.isDayShow = TRUE;
                }
                else
                {
                    cell.isDayShow = FALSE;
                }
                
                cell.mytitle.text =[CS DealWithString:[[dataArray objectAtIndex:indexPath.row] objectForKey:@"title"]];
//                cell.content.text = [CS DealWithString:[[dataArray objectAtIndex:indexPath.row] objectForKey:@"title"]];
                [cell.type setTitle:[[dataArray objectAtIndex:indexPath.row] objectForKey:@"label"] forState:UIControlStateNormal];
                NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:13]};
                CGSize size = [[[dataArray objectAtIndex:indexPath.row] objectForKey:@"label"] boundingRectWithSize:CGSizeMake(MAXFLOAT, cell.type.frame.size.height) options:NSStringDrawingTruncatesLastVisibleLine attributes:attribute context:nil].size;
                //根据计算结果重新设置UILabel的尺寸
                [cell.type setFrame:CGRectMake(cell.type.frame.origin.x, cell.type.frame.origin.y, size.width + 50, cell.type.frame.size.height)];
                cell.backgroundColor = myWhiteColor;

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
                
                if([[[NSUserDefaults standardUserDefaults] objectForKey:@"isDayShow"] isEqualToString:@"0"])
                {
                    cell.isDayShow = TRUE;
                }
                else
                {
                    cell.isDayShow = FALSE;
                }
                
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                [cell.type setTitle:[[dataArray objectAtIndex:indexPath.row] objectForKey:@"label"] forState:UIControlStateNormal];
                
                cell.title.text =[CS DealWithString:[[dataArray objectAtIndex:indexPath.row] objectForKey:@"title"]];
                [cell.image setImageWithURL:[NSURL URLWithString:[[dataArray objectAtIndex:indexPath.row] objectForKey:@"img1"]] placeholderImage:[UIImage imageNamed:@""]];
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
                
//                cell.content.text = [CS DealWithString: [[dataArray objectAtIndex:indexPath.row] objectForKey:@"title"]];
                cell.backgroundColor = myWhiteColor;

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
//                
//                if([[[NSUserDefaults standardUserDefaults] objectForKey:@"isDayShow"] isEqualToString:@"0"])
//                {
//                    cell.isDayShow = TRUE;
//                }
//                else
//                {
//                    cell.isDayShow = FALSE;
//                }
//                cell.selectionStyle = UITableViewCellSelectionStyleNone;
//                
//                [cell setImageArray:[[dataArray objectAtIndex:indexPath.row] objectForKey:@"Images"]];
//                
//                cell.title.text =[CS DealWithString:[[dataArray objectAtIndex:indexPath.row] objectForKey:@"Title"]];
//                [cell.type setTitle:[[dataArray objectAtIndex:indexPath.row] objectForKey:@"PageName"] forState:UIControlStateNormal];
//                cell.backgroundColor = myWhiteColor;
//
//                return cell;
//            }
            
        }

    }
    
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section ==1)
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"pushNewsWithID" object:[[dataArray objectAtIndex:indexPath.row] objectForKey:@"id"]];
        
    }
    
    
}
-(void)EScrollerViewDidClicked:(NSUInteger)index
{
    NSLog(@"index--%d",index);
}

-(void)requestLoadData{
    
    //日报请求页面
    if(_oldDate)
    {
        //获取数据
        [self httpRequest:_oldDate];
    }
    else
    {
        //获取数据
        [self httpRequest:myDate];
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
    
    // 设置文字(也可以不设置,默认的文字在MJRefreshConst中修改)
    self.table.headerPullToRefreshText = @"下拉刷新";
    self.table.headerReleaseToRefreshText = @"松手立刻刷新";
    self.table.headerRefreshingText = @"正在努力刷新中...";
    
}

#pragma mark 开始进入刷新状态
- (void)headerRereshing
{
    pageIndex = 0;
    [dataArray removeAllObjects];
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
