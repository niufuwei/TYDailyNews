//
//  RightController.m
//  DDMenuController
//
//  Created by Devin Doty on 11/30/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "TYRightController.h"
#import "TYHomePageController.h"
#import "TYRightHeadCell.h"
#import "TYRightItemCellTableViewCell.h"
#import "TYRightCenterTableViewCell.h"
#import "TYRightMenuDownloadViewController.h"
#import "TYRightMenuCollectViewController.h"
#import "TYRightMenuSetViewController.h"
#import "TYRightMenuPayViewController.h"

@implementation TYRightController
{
    TYHttpRequest * myHttp;
    NSString * wendu;
    NSString * tianqi;
    NSArray * imageArr;
}

@synthesize mytable;

- (id)init {
    if ((self = [super init])) {
    }
    return self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return YES;
}


#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self.view setBackgroundColor:[UIColor colorWithRed:28.0/255.0 green:30.0/255.0 blue:37.0/255.0 alpha:1]];
    imageArr = [NSArray arrayWithObjects:@"多云",@"大雨",@"小雨",@"小雪",@"晴",@"阴",@"雪",@"雨夹雪",@"雷阵雨",@"雾", nil];
    

    iconArray = [[NSArray alloc] initWithObjects:@"download",@"like",@"set", nil];
    dataArray = [[NSArray alloc] initWithObjects:@"我的下载",@"我的收藏",@"个人设置", nil];
   
    CGRect frame = self.view.bounds;
    frame.origin.x = 40.0f;
    frame.size.width -= 40.0f;
    
    mytable = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
    mytable.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    mytable.delegate = (id<UITableViewDelegate>)self;
    mytable.dataSource = (id<UITableViewDataSource>)self;
    //        tableView.backgroundColor = [UIColor scrollViewTexturedBackgroundColor];
    [mytable setBackgroundColor:[UIColor clearColor]];
    mytable.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:mytable];

}

-(void)getWeather
{
    myHttp = [[TYHttpRequest alloc] init];
    
    NSString * addr = [NSString stringWithFormat:@"http://www.weather.com.cn/data/cityinfo/%@.html",[[NSUserDefaults standardUserDefaults] objectForKey:@"cityNumber"]];
    [myHttp httpRequestWeiBo:addr parameter:nil Success:^(id result) {
        
        NSLog(@"%@",result);
        NSData* jsonData = [result dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary * dic = (NSDictionary*)[jsonData objectFromJSONData];
        tianqi =  [[dic objectForKey:@"weatherinfo"] objectForKey:@"weather"];
        wendu =[[dic objectForKey:@"weatherinfo"] objectForKey:@"temp1"];
        
        [mytable reloadData];

    } Failure:^(NSError *error) {
        
        NSLog(@"%@",error);
        
    } view:self.view isPost:NO];
    
}

- (void)viewDidUnload {
    [super viewDidUnload];
    mytable = nil;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [mytable deselectRowAtIndexPath:mytable.indexPathForSelectedRow animated:YES];
    
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"cityNumber"])
    {
        //去获取当前位置天气
        [self getWeather];
    }
    else
    {
        
    }
    [mytable reloadData];
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section {
    return [iconArray count]+2;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(indexPath.row ==0)
    {
        static NSString *CellIdentifier = @"CellIdentifier1";
        TYRightHeadCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if(cell == nil) {
            cell = [[TYRightHeadCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        cell.backgroundColor = [UIColor clearColor];
        [cell.Avatar setImage:[UIImage imageNamed:@"user.png"]];
        if(!wendu)
        {
            cell.weather.text = @"0";
        }
        else
        {
            wendu = [wendu substringToIndex:[wendu length]-1];
            cell.weather.text = wendu;

        }
        if(!tianqi)
        {
            
        }
        else
        {
            for(NSString * str in imageArr)
            {
                NSRange range = [str rangeOfString:tianqi];
                if(range.location != NSNotFound)
                {
                    [cell.weatherImage setImage:[UIImage imageNamed:str]];
                }
            }
        }
       
        cell.userName.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"userName"];
        cell.money.text = @"我的资金 12009000元";
        
        if(![[[NSUserDefaults standardUserDefaults] objectForKey:@"isLogin"] isEqualToString:@"1"])
        {
            cell.userName.hidden = YES;
            cell.money.hidden = YES;
            cell.weather.hidden = YES;
            cell.weatherImage.hidden = YES;
            [cell.loginButton setBackgroundImage:[UIImage imageNamed:@"button-ios"] forState:UIControlStateNormal];
            [cell.loginButton addTarget:self action:@selector(onClick) forControlEvents:UIControlEventTouchUpInside];
            cell.loginButton.hidden = NO;
            
        }
        else
        {
            cell.userName.hidden = NO;
            cell.money.hidden = NO;
            cell.weather.hidden = NO;
            cell.weatherImage.hidden = NO;
            cell.loginButton.hidden = YES;
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;

    }
    else if(indexPath.row ==1)
    {
        static NSString *CellIdentifier = @"CellIdentifier2";
        TYRightCenterTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if(cell == nil) {
            cell = [[TYRightCenterTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        cell.backgroundColor = [UIColor clearColor];
        
        Date * date = [[Date alloc] init];
        
        cell.date.text = [date getYMDInfor:[NSDate date]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else
    {
        static NSString *CellIdentifier = @"CellIdentifier2";
        TYRightItemCellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if(cell == nil) {
            cell = [[TYRightItemCellTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        cell.backgroundColor = [UIColor clearColor];


        if(indexPath.row -2 ==0)
        {
            NSString * numberStr = (NSString*)[[NSUserDefaults standardUserDefaults] objectForKey:@"downloadNumer"];
            if([numberStr intValue] ==0)
            {
                cell.number.hidden = YES;
            }
            else
            {
                cell.number.hidden = NO;
                [cell.number setTitle:[NSString stringWithFormat:@"%d",[numberStr intValue]]  forState:UIControlStateNormal];

            }
        }
        else
        {
            [cell.number setHidden:YES];
        }
        [cell.icon setImage:[UIImage imageNamed:[iconArray objectAtIndex:indexPath.row-2]]];
        UIView * view = [[UIView alloc] init];
        [view setBackgroundColor:[UIColor colorWithRed:23.0/255.0 green:24.0/255.0 blue:28.0/255.0 alpha:1]];
        cell.selectedBackgroundView =view;
        cell.title.text = [dataArray objectAtIndex:indexPath.row-2];
        return cell;

    }
    
}

-(void)onClick
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"login" object:nil];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row ==0)
    {
        return 220;
    }
    else if(indexPath.row ==1)
    {
        return 30;
    }
    else
    {
        return 70;
        
    }
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(indexPath.row ==0)
    {
        
    }
    else if(indexPath.row ==1)
    {
        
    }
    else
    {
        // lets just push another feed view
        NavViewController *menuController = (NavViewController*)((AppDelegate*)[[UIApplication sharedApplication] delegate]).menuController;
        
        if(indexPath.row ==2)
        {
            TYRightMenuDownloadViewController *download = [[TYRightMenuDownloadViewController alloc] init];
            NSArray * arr = [[NSArray alloc] init];
            [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"downloadNumer"];
            [menuController pushViewController:download animated:YES];
        }
        else if(indexPath.row ==3)
        {
            TYRightMenuCollectViewController * collect = [[TYRightMenuCollectViewController alloc] init];
            [menuController pushViewController:collect animated:YES];
        }
        else
        {
            TYRightMenuSetViewController * set = [[TYRightMenuSetViewController alloc] init];
            [menuController pushViewController:set animated:YES];
        }
//        else
//        {
//            TYRightMenuPayViewController * pay = [[TYRightMenuPayViewController alloc] init];
//            [menuController pushViewController:pay animated:YES];
//        }
        
        
 
    }
}

@end