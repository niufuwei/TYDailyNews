//
//  TYRightMenuDownloadViewController.m
//  TYDaily
//
//  Created by laoniu on 14-10-2.
//
//

#import "TYRightMenuDownloadViewController.h"
#import "TYCollectCell.h"
#import "TYPDFViewController.h"

@interface TYRightMenuDownloadViewController ()
{
    NavCustom * myCustom;
    NSMutableDictionary * selectDictionary;
    BOOL isManager;
    NSMutableArray * dataArray;
    
    UIView * buttomView;
    
    UIColor * myBlackColor;
    UIColor * myWhiteColor;
}

@end

@implementation TYRightMenuDownloadViewController

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
    myCustom = [[NavCustom alloc] init];
    [myCustom setNavWithText:@"我的下载" mySelf:self];
    [myCustom setNavRightBtnTitle:@"管理" mySelf:self width:40 height:40];
    myCustom.NavDelegate = self;
    [self setLeftItem];
    
    
    isManager = FALSE;
    
    dataArray = [[NSMutableArray alloc] init];
    selectDictionary = [[NSMutableDictionary alloc] init];
    dataArray = (NSMutableArray*)[[NSUserDefaults standardUserDefaults] objectForKey:@"download"];
    
    NSLog(@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"download"]);
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    
    [cell.ICON setImageWithURL:[NSURL URLWithString:@"http://ww4.sinaimg.cn/thumbnail/50be8358jw1elezgzsxnaj20c80850tc.jpg"] placeholderImage:[UIImage imageNamed:@"noImage"]];
    
    NSMutableString * string = [[NSMutableString alloc] initWithString:[[[dataArray objectAtIndex:indexPath.row] allKeys] objectAtIndex:0]];
    [string insertString:@"-" atIndex:4];
    [string insertString:@"-" atIndex:7];

    
    cell.contentLabel.text = [string stringByAppendingString:@" 点击打开PDF报纸"];
    cell.contentLabel.textColor = myBlackColor;
    cell.contentLabel.textAlignment = NSTextAlignmentCenter;
    cell.titleLabel.hidden = YES;
    cell.titleLabel.textColor = myBlackColor;
    cell.buttomLabel.hidden = YES;
    cell.buttomLabel.textColor = myBlackColor;
    
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
        TYPDFViewController * pdf = [[TYPDFViewController alloc] init];
        pdf.myDate = [[NSMutableString alloc] initWithString:[[[dataArray objectAtIndex:indexPath.row] allKeys] objectAtIndex:0]];
        [self.navigationController pushViewController:pdf animated:YES];
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

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

-(void)onButtomClick
{
    NSMutableArray * tempArray = [[NSMutableArray alloc] init];
    
  
    NSMutableArray * dateTmepArray = [[NSMutableArray alloc] initWithArray:dataArray];
    NSLog(@"%@",dataArray);
    
    for(int i =0;i<[[selectDictionary allKeys] count];i++)
    {
        NSString * strKey = [[selectDictionary allKeys] objectAtIndex:i];
        
        NSIndexPath * index = [NSIndexPath indexPathForRow:[strKey intValue]-1 inSection:0];
        [tempArray addObject:index];
        
        for( int j = 0;j<[dataArray count];j++)
        {
            NSLog(@"%@",dataArray);

            if([[[[dataArray objectAtIndex:j] allKeys] objectAtIndex:0] isEqualToString:[[[dataArray objectAtIndex:[strKey integerValue]-1] allKeys] objectAtIndex:0]])
            {
                NSFileManager *fileMgr = [NSFileManager defaultManager];

                [dateTmepArray removeObject:[dataArray objectAtIndex:[strKey integerValue]-1]];
                NSLog(@"%@",dataArray);

                NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
                
                //初始化临时文件路径
                
                NSString *folderPath = [path stringByAppendingPathComponent:@"download"];
                
                NSString * savePath = [folderPath stringByAppendingPathComponent:[NSString stringWithFormat:@"/%@.pdf",[[[dataArray objectAtIndex:j] allKeys] objectAtIndex:0]]];
                NSLog(@"%@",savePath);
                
                NSError *err;
                
                if([fileMgr removeItemAtPath:savePath error:&err])
                {
                    NSLog(@"文件删除成功");
                }
                
            }
        }
        
        dataArray =  dateTmepArray;
        [[NSUserDefaults standardUserDefaults] setObject:dataArray forKey:@"download"];
        //清除dataarray中的数据
        
    }

    for(NSDictionary * dic in dateTmepArray)
    {
        
    }
    
    [selectDictionary removeAllObjects];
    [_myTable deleteRowsAtIndexPaths:tempArray withRowAnimation:UITableViewRowAnimationLeft];
    [_myTable reloadData];
    
}

-(void)popself
{
    [appDelegate showRightView];
    [self.navigationController popViewControllerAnimated:YES];
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
