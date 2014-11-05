//
//  LeftController.m
//  DDMenuController
//
//  Created by Devin Doty on 11/30/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "TYLeftController.h"
#import "TYHomePageController.h"
#import "TYLeftMenuCell.h"
#import "TYLeftHeadCell.h"
#import "TYLeftMenuItemLongViewController.h"
#import "TYLeftMenuItemOldViewController.h"
#import "TYLeftMenuItemNewsViewController.h"
#import "TYLeftMenuItemWeiboViewController.h"
#import "DDMenuController.h"
#import "TYBaoLiaoViewController.h"
#import "TYZonglanViewController.h"

@implementation TYLeftController
{
    NSArray * selectIconArray;
    NSInteger indexSelect;
}

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
    
    indexSelect = 1;
    
    [self.view setBackgroundColor:[UIColor colorWithRed:27.0/255.0 green:32.0/255.0 blue:36.0/255.0 alpha:1]];
    
    selectIconArray = [[NSArray alloc] initWithObjects:@"HOME-s",@"NEW-S",@"zhuanti-s",@"long-s",@"baoliao-s",@"WB-S",@"OLD-S", nil];
    iconArray = [[NSArray alloc] initWithObjects:@"HOME-n",@"NEW-N",@"zhuanti-n",@"long-n",@"baoliao-n",@"WB-N",@"OLD-N", nil];
    dataArray = [[NSArray alloc] initWithObjects:@"太原日报",@"新闻资讯",@"专题速递",@"龙城纵览",@"我要报料",@"微博互动",@"往期回顾",nil];
    if (!_tableView) {
        UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        tableView.delegate = (id<UITableViewDelegate>)self;
        tableView.dataSource = (id<UITableViewDataSource>)self;
        tableView.backgroundColor = [UIColor clearColor];
        [self.view addSubview:tableView];
        self.tableView = tableView;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
       
        UIView * newFooterView = [[UIView alloc] init];
        self.tableView.tableFooterView = newFooterView;
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onNotifaction:) name:@"pushFirstFromOld" object:nil];
    
}

-(void)onNotifaction:(NSNotification*)noti
{
    DDMenuController *menuController = (DDMenuController*)((AppDelegate*)[[UIApplication sharedApplication] delegate]).menuController;
    NavViewController *navController;
    
    TYHomePageController * taiyuan = [[TYHomePageController alloc] init];
    taiyuan.requestDateString = noti.object;
    navController = [[NavViewController alloc] initWithRootViewController:taiyuan];
    
    [menuController setRootController:navController animated:YES];
    
    NSIndexPath * indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    
    [_tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)viewDidUnload {
    [super viewDidUnload];
    self.tableView = nil;
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section {
    return [iconArray count]+1;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(indexPath.row == 0)
    {
        static NSString *CellIdentifier = @"CellIdentifier1";
        TYLeftHeadCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if(cell == nil) {
            cell = [[TYLeftHeadCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        cell.backgroundColor = [UIColor clearColor];

        [cell.LogoImage setImage:[UIImage imageNamed:@"LOGORED"]];
        [cell.nameImage setImage:[UIImage imageNamed:@"LOGO2"]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else
    {
        static NSString *CellIdentifier = @"CellIdentifier2";
        TYLeftMenuCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if(cell == nil) {
            cell = [[TYLeftMenuCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        
        cell.backgroundColor = [UIColor clearColor];
        /*
         * Content in this cell should be inset the size of kMenuOverlayWidth
         */
        
        
        if(indexSelect ==1 && indexPath.row==1)
        {
            [cell.icon setImage:[UIImage imageNamed:[selectIconArray objectAtIndex:indexPath.row-1]]];
            cell.title.textColor = [UIColor whiteColor];
            UIView * view = [[UIView alloc] init];
            [view setBackgroundColor:[UIColor colorWithRed:23.0/255.0 green:24.0/255.0 blue:28.0/255.0 alpha:1]];
            cell.selectedBackgroundView =view;
        }
        else
        {
            [cell.icon setImage:[UIImage imageNamed:[iconArray objectAtIndex:indexPath.row-1]]];
            UIView * view = [[UIView alloc] init];
            [view setBackgroundColor:[UIColor colorWithRed:27.0/255.0 green:32.0/255.0 blue:36.0/255.0 alpha:1]];
            cell.selectedBackgroundView =view;
        }
        
        cell.title.text = [dataArray objectAtIndex:indexPath.row-1];
       
        return cell;

    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row ==0)
    {
        return 145;
    }
    else
    {
        return 50;

    }
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // set the root controller
    
    DDMenuController *menuController = (DDMenuController*)((AppDelegate*)[[UIApplication sharedApplication] delegate]).menuController;
    NavViewController *navController;
    
    if(indexPath.row == 0)
    {
        
    }
    else
    {
        if(indexPath.row ==1)
        {
            [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"isSetDayShow"];

            TYHomePageController * taiyuan = [[TYHomePageController alloc] init];
            navController = [[NavViewController alloc] initWithRootViewController:taiyuan];
        }
        else if(indexPath.row ==2)
        {
            TYLeftMenuItemNewsViewController * news = [[TYLeftMenuItemNewsViewController alloc] init];
            navController = [[NavViewController alloc] initWithRootViewController:news];

        }
        else if(indexPath.row ==3)
        {
            TYLeftMenuItemLongViewController * Long = [[TYLeftMenuItemLongViewController alloc] init];
            navController = [[NavViewController alloc] initWithRootViewController:Long];

        }
        else if(indexPath.row ==4)
        {
            TYZonglanViewController * Long = [[TYZonglanViewController alloc] init];
            navController = [[NavViewController alloc] initWithRootViewController:Long];
        }
        else if(indexPath.row ==5)
        {
            //爆料
            TYBaoLiaoViewController * baoliao = [[TYBaoLiaoViewController alloc] init];
            navController = [[NavViewController alloc] initWithRootViewController:baoliao];
        }
        else if(indexPath.row ==6)
        {
            //微博
            TYLeftMenuItemWeiboViewController *weibo = [[TYLeftMenuItemWeiboViewController alloc] init];
            navController = [[NavViewController alloc] initWithRootViewController:weibo];

        }
        else
        {
           //往期
            TYLeftMenuItemOldViewController * old = [[TYLeftMenuItemOldViewController alloc] init];
            navController = [[NavViewController alloc] initWithRootViewController:old];

        }
        
        if(indexSelect != indexPath.row)
        {
            NSIndexPath * index = [NSIndexPath indexPathForRow:indexSelect inSection:0];
            TYLeftMenuCell * cell = (TYLeftMenuCell*)[tableView cellForRowAtIndexPath:index];

            [cell.icon setImage:[UIImage imageNamed:[iconArray objectAtIndex:indexSelect-1]]];
            UIView * view = [[UIView alloc] init];
            [view setBackgroundColor:[UIColor colorWithRed:27.0/255.0 green:32.0/255.0 blue:36.0/255.0 alpha:1]];
            cell.selectedBackgroundView =view;
            cell.title.textColor = [UIColor colorWithRed:138.0/255.0 green:146.0/255.0 blue:152.0/255.0 alpha:1];
        }
       
        TYLeftMenuCell * cell = (TYLeftMenuCell*)[tableView cellForRowAtIndexPath:indexPath];
        
        [cell.icon setImage:[UIImage imageNamed:[selectIconArray objectAtIndex:indexPath.row-1]]];
        cell.title.textColor = [UIColor whiteColor];
        UIView * view = [[UIView alloc] init];
        [view setBackgroundColor:[UIColor colorWithRed:23.0/255.0 green:24.0/255.0 blue:28.0/255.0 alpha:1]];
        cell.selectedBackgroundView =view;
        
        indexSelect = indexPath.row;
        
        [menuController setRootController:navController animated:YES];
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
  
}



@end
