//
//  TYRightMenuCollectViewController.m
//  TYDaily
//
//  Created by laoniu on 14-10-2.
//
//

#import "TYRightMenuCollectViewController.h"
#import "TYCollectCell.h"
#import "TYNewsViewController.h"

@interface TYRightMenuCollectViewController ()
{
    NavCustom *myCustom;
    NSMutableDictionary * selectDictionary;
    BOOL isManager;
    NSMutableArray * dataArray;
    
    UIView * buttomView;
    
    UIColor * myBlackColor;
    UIColor * myWhiteColor;
}

@end

@implementation TYRightMenuCollectViewController

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

    selectDictionary = [[NSMutableDictionary alloc] init];
    myCustom = [[NavCustom alloc] init];
    [myCustom setNavRightBtnTitle:@"管理" mySelf:self width:40 height:40];
    [myCustom setNavWithText:@"我的收藏" mySelf:self];
    myCustom.NavDelegate = self;
    [self setLeftItem];
    
    isManager = FALSE;
    
    dataArray = [[NSMutableArray alloc] init];
    dataArray = (NSMutableArray*)[[NSUserDefaults standardUserDefaults] objectForKey:@"newsid"];
    
    NSLog(@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"newsid"]);
    NSLog(@"%@",dataArray);
    
    _myTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-64)];
    _myTable.delegate =self;
    _myTable.dataSource =self;
    _myTable.tableFooterView = [[UIView alloc] init];
    _myTable.backgroundColor = myWhiteColor;
    [self.view addSubview:_myTable];
    
    buttomView= [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height, self.view.frame.size.width, 40)];
    buttomView.backgroundColor = [UIColor colorWithRed:230.0/255.0 green:228.0/255.0 blue:229.0/255.0 alpha:1];
    [self.view addSubview:buttomView];
    
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(self.view.frame.size.width-70, 0, 70, 40);
    [button setBackgroundImage:[UIImage imageNamed:@"guanzhu"] forState:UIControlStateNormal];
    [button setTitle:@"删除" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(onButtomClick) forControlEvents:UIControlEventTouchUpInside];
    [buttomView addSubview:button];
    
    [buttomView bringSubviewToFront:self.view];
    // Do any additional setup after loading the view.
}

-(void) setLeftItem{
    
    UIButton* backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *image = [UIImage imageNamed:@"back"];
    
    backButton.backgroundColor=[UIColor clearColor];
    backButton.frame = CGRectMake(-20, 0, 12, 20);
    [backButton setBackgroundImage:image forState:UIControlStateNormal];
    [backButton setBackgroundImage: [UIImage imageNamed:@"back"] forState:UIControlStateHighlighted];
    
    [backButton addTarget:self action:@selector(popself) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem* leftButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    if([UIDevice currentDevice].systemVersion.floatValue >= 7.0f){
        UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                           initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                           target:nil action:nil];
        negativeSpacer.width = -7.5;
        self.navigationItem.leftBarButtonItems = @[negativeSpacer, leftButtonItem];
    }
    else{
        self.navigationItem.leftBarButtonItem = leftButtonItem;
    }
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
    TYCollectCell * cell = [tableView dequeueReusableCellWithIdentifier:strID];
    if(!cell)
    {
        cell = [[TYCollectCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:strID];
    }
    
    NSString * key ;
    for(NSString * str in [[dataArray objectAtIndex:indexPath.row] allKeys])
    {
        if([str isEqualToString:@"isNews"])
        {
            
        }
        else if([str isEqualToString:@"address"])
        {
            
        }
        else
        {
            key = str;
        }
    }
    NSDictionary * tempDic = [[NSDictionary alloc] init];
    tempDic  = [dataArray objectAtIndex:indexPath.row];
    
    
    if([[[NSUserDefaults standardUserDefaults] objectForKey:@"showImage"] isEqualToString:@"no"])
    {
        [cell.ICON setImageWithURL:[NSURL URLWithString:[[[[tempDic objectForKey:key] objectForKey:@"imgs"] objectAtIndex:0] objectForKey:@"url"]] placeholderImage:[UIImage imageNamed:@"noImage"]];
    }
    else
    {
        [cell.ICON setImage:[UIImage imageNamed:@"noImage"]];

    }
    
    NSString * title = [[[tempDic objectForKey:key] objectForKey:@"article"] objectForKey:@"title"];
    title =[title stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    title =[title stringByReplacingOccurrencesOfString:@"  " withString:@""];
    cell.titleLabel.text = title;
    cell.titleLabel.textColor = myBlackColor;
    
    NSString * strContent =[[[tempDic objectForKey:key] objectForKey:@"article"] objectForKey:@"content"];
    strContent =[strContent stringByReplacingOccurrencesOfString:@"</p>" withString:@""];
    strContent =[strContent stringByReplacingOccurrencesOfString:@"<br />" withString:@""];
    strContent =[strContent stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    strContent =[strContent stringByReplacingOccurrencesOfString:@"  " withString:@""];
    strContent =[strContent stringByReplacingOccurrencesOfString:@"?" withString:@""];


    cell.contentLabel.text = strContent;
    cell.contentLabel.textColor = myBlackColor;
    
    cell.buttomLabel.text = [[[tempDic objectForKey:key] objectForKey:@"article"] objectForKey:@"create_time"];
    cell.buttomLabel.textColor = myBlackColor;
    cell.buttomLabel.textAlignment = NSTextAlignmentRight;

    if([[selectDictionary objectForKey:[NSString stringWithFormat:@"%d",indexPath.row+1]] isEqualToString:@"ok"])
    {
        [cell.selectButton setBackgroundImage:[UIImage imageNamed:@"selected"] forState:UIControlStateNormal];

    }
    else
    {
        [cell.selectButton setBackgroundImage:[UIImage imageNamed:@"noselect"] forState:UIControlStateNormal];
    }
    
    cell.selectButton.tag = indexPath.row+1;
    [cell.selectButton addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
    
    if(isManager)
    {
        cell.selectButton.hidden= NO;
    }
    else
    {
        cell.selectButton.hidden = YES;
    }
    
    cell.backgroundColor = myWhiteColor;
    return cell;
}

-(void)onClick:(id)sender
{
    UIButton * button = (UIButton*)sender;
    
    NSIndexPath * index = [NSIndexPath indexPathForRow:button.tag-1 inSection:0];
    TYCollectCell * cell = (TYCollectCell*)[_myTable cellForRowAtIndexPath:index];
    
    if([[selectDictionary objectForKey:[NSString stringWithFormat:@"%d",button.tag]] isEqualToString:@"ok"])
    {
        [selectDictionary removeObjectForKey:[NSString stringWithFormat:@"%d",button.tag]];
        [cell.selectButton setBackgroundImage:[UIImage imageNamed:@"noselect"] forState:UIControlStateNormal];

    }
    else
    {
        [selectDictionary setObject:@"ok" forKey:[NSString stringWithFormat:@"%d",button.tag]];
        [cell.selectButton setBackgroundImage:[UIImage imageNamed:@"selected"] forState:UIControlStateNormal];

    }
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(isManager)
    {
        NSIndexPath * index = [NSIndexPath indexPathForRow:indexPath.row inSection:0];
        TYCollectCell * cell = (TYCollectCell*)[_myTable cellForRowAtIndexPath:index];
        
        if([[selectDictionary objectForKey:[NSString stringWithFormat:@"%d",indexPath.row+1]] isEqualToString:@"ok"])
        {
            [selectDictionary removeObjectForKey:[NSString stringWithFormat:@"%d",indexPath.row+1]];
            [cell.selectButton setBackgroundImage:[UIImage imageNamed:@"noselect"] forState:UIControlStateNormal];
            
        }
        else
        {
            [selectDictionary setObject:@"ok" forKey:[NSString stringWithFormat:@"%d",indexPath.row+1]];
            [cell.selectButton setBackgroundImage:[UIImage imageNamed:@"selected"] forState:UIControlStateNormal];
            
        }

    }
    else
    {
        TYNewsViewController * news = [[TYNewsViewController alloc] init];
        
        for(NSString * str in [[dataArray objectAtIndex:indexPath.row] allKeys])
        {
            if([str isEqualToString:@"isNews"])
            {
                
            }
            else if([str isEqualToString:@"address"])
            {
                
            }
            else
            {
                news.newsID = str;
            }
        }


//        NSString * str = [[_urlArray objectAtIndex:indexPage] stringByReplacingOccurrencesOfString:@"list" withString:@"view"];
        news.isNewsCenter = [[[dataArray objectAtIndex:indexPath.row] objectForKey:@"isNews"] isEqualToString:@"1"]?TRUE:FALSE;;
        
        news.address =[[dataArray objectAtIndex:indexPath.row] objectForKey:@"address"];
        
        [self.navigationController pushViewController:news animated:YES];
    }
}

-(void)NavRightButtononClick
{
    isManager = !isManager;
    if(isManager)
    {
        [myCustom setNavRightBtnTitle:@"取消" mySelf:self width:40 height:40];
        
        [UIView animateWithDuration:0.5 animations:^{
            CGRect yy = buttomView.frame;
            yy.origin.y = self.view.frame.size.height-40;
            buttomView.frame = yy;
        }];
    }
    else
    {
        [myCustom setNavRightBtnTitle:@"管理" mySelf:self width:40 height:40];
        [UIView animateWithDuration:0.5 animations:^{
            CGRect yy = buttomView.frame;
            yy.origin.y = self.view.frame.size.height;
            buttomView.frame = yy;
        }];

    }
    
    [selectDictionary removeAllObjects];
    [_myTable reloadData];
}

-(void)popself
{
    [appDelegate showRightView];
    [self.navigationController popViewControllerAnimated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

-(void)onButtomClick
{
    NSMutableArray * tempArray = [[NSMutableArray alloc] init];
    
    NSLog(@"%@",selectDictionary);
    
    NSLog(@"%@",dataArray);

    NSLog(@"%@",[selectDictionary allKeys]);
    
    NSMutableArray * tempArr = [[NSMutableArray alloc] init];

    
    for(int i =0;i<[[selectDictionary allKeys] count];i++)
    {
        NSString * strKey = [[selectDictionary allKeys] objectAtIndex:i];
    
        NSIndexPath * index = [NSIndexPath indexPathForRow:[strKey intValue]-1 inSection:0];
        [tempArray addObject:index];
        
        NSLog(@"%@",[[dataArray objectAtIndex:[strKey intValue]-1] allKeys]);
        for(NSString * str in [[dataArray objectAtIndex:[strKey intValue]-1] allKeys])
        {
            NSLog(@"%@",str);
            if([str isEqualToString:@"isNews"])
            {
                
            }
            else if([str isEqualToString:@"address"])
            {
                
            }
            else
            {
                [tempArr addObject:str];
            }
        }

        
//        [dataArray removeObjectAtIndex:[strKey intValue]-1];
        //清除dataarray中的数据
        
    }
    
    NSLog(@"%@",tempArr);
    NSLog(@"%@",dataArray);

    NSMutableArray * tempDataArray =[[NSMutableArray alloc] initWithArray: dataArray];
    NSLog(@"%d",[dataArray count]);
    
    for(int i=0;i<[dataArray count];i++)
    {
        NSDictionary * dic = [dataArray objectAtIndex:i];
        
        for(int j = 0; j<[[dic allKeys] count];j++)
        {
            if([[[dic allKeys] objectAtIndex:j] isEqualToString:@"isNews"])
            {
                
            }
            else if([[[dic allKeys] objectAtIndex:j] isEqualToString:@"address"])
            {
                
            }
            else
            {
                if([tempArr indexOfObject:[[dic allKeys] objectAtIndex:j]] != NSNotFound)
                {
                    [tempDataArray removeObject:dic];
                    NSLog(@"%@",dataArray);
                }
            }
        }
    }
    
    dataArray =tempDataArray;
    [[NSUserDefaults standardUserDefaults] setObject:dataArray forKey:@"newsid"];
    NSLog(@"%@",dataArray);
    [selectDictionary removeAllObjects];
    [_myTable deleteRowsAtIndexPaths:tempArray withRowAnimation:UITableViewRowAnimationLeft];

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
