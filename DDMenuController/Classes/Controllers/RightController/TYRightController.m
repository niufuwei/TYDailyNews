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

@synthesize tableView=_tableView;

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
    
    if (!_tableView) {
        
        CGRect frame = self.view.bounds;
        frame.origin.x = 40.0f;
        frame.size.width -= 40.0f;
        
        UITableView *tableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
        tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        tableView.delegate = (id<UITableViewDelegate>)self;
        tableView.dataSource = (id<UITableViewDataSource>)self;
//        tableView.backgroundColor = [UIColor scrollViewTexturedBackgroundColor];
        [self.view addSubview:tableView];
        [tableView setBackgroundColor:[UIColor clearColor]];
        self.tableView = tableView;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
    }
    
    [self.view setBackgroundColor:[UIColor colorWithRed:28.0/255.0 green:30.0/255.0 blue:37.0/255.0 alpha:1]];

    
    iconArray = [[NSArray alloc] initWithObjects:@"download",@"like",@"set", nil];
    dataArray = [[NSArray alloc] initWithObjects:@"我的下载",@"我的收藏",@"个人设置", nil];

    
}

- (void)viewDidUnload {
    [super viewDidUnload];
    self.tableView = nil;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView deselectRowAtIndexPath:self.tableView.indexPathForSelectedRow animated:YES];
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
        cell.weather.text = @"25";
        [cell.weatherImage setImage:[UIImage imageNamed:@""]];
        cell.userName.text = @"高山流水总是情";
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
            [cell.number setTitle:@"2" forState:UIControlStateNormal];

            cell.number.hidden = NO;

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