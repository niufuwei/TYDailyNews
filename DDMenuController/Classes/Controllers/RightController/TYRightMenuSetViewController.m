//
//  TYRightMenuSetViewController.m
//  TYDaily
//
//  Created by laoniu on 14-10-2.
//
//

#import "TYRightMenuSetViewController.h"
#import "TYRightMenuFontViewController.h"
#import "TYSuggestViewController.h"
#import "TYAboutViewController.h"

@interface TYRightMenuSetViewController ()
{
    NavCustom * myCustom;
    NSMutableArray * dataArray;
    UISwitch *switchButton;
    NSMutableArray * fontArray;
    UIColor * myBlackColor;
    UIColor * myWhiteColor;
}

@end

@implementation TYRightMenuSetViewController

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
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    myCustom = [[NavCustom alloc] init];

    [myCustom setNavWithText:@"个人设置" mySelf:self];
    [self setLeftItem];

    dataArray = [[NSMutableArray alloc] initWithObjects:@"正文字号",@"新闻推送",@"夜间模式",@"只在wifi模式下加载图片",@"清除缓存",@"意见反馈",@"关于我们", nil];
    
    _table = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-64)];
    _table.delegate =self;
    _table.dataSource =self;
    _table.tableFooterView = [[UIView alloc] init];
    _table.backgroundColor = myWhiteColor;
    [self.view addSubview:_table];

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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * strID = @"cell";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:strID];
    if(!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewRowActionStyleDefault reuseIdentifier:strID];
    }
    
    if(indexPath.row ==0)
    {
        UILabel * daxiao = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width-170, 0, 130, 50)];
        if([[NSUserDefaults standardUserDefaults] objectForKey:@"font"])
        {
            daxiao.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"font"];

        }
        else
        {
            daxiao.text = @"中字体";

        }
        daxiao.textAlignment = NSTextAlignmentRight;
        daxiao.backgroundColor = [UIColor clearColor];
        daxiao.textColor = myBlackColor;
        daxiao.font = [UIFont systemFontOfSize:15];
        daxiao.tag = 10086;
        [cell addSubview:daxiao];
        
        UIImageView * image = [[UIImageView alloc] initWithFrame:CGRectMake(daxiao.frame.size.width+daxiao.frame.origin.x+5, 15, 20, 20)];
        [image setImage:[UIImage imageNamed:@"youbian"]];
        [cell addSubview:image];
    }
    
    if(indexPath.row ==1)
    {
        switchButton = [[UISwitch alloc] initWithFrame:CGRectMake(self.view.frame.size.width-60, 10, 20, 10)];
        [switchButton setOn:YES];
        switchButton.tag = 101;
        [switchButton addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
        [cell addSubview:switchButton];
    }
    else if(indexPath.row ==2)
    {
        switchButton = [[UISwitch alloc] initWithFrame:CGRectMake(self.view.frame.size.width-60, 10, 20, 10)];
        if([[NSUserDefaults standardUserDefaults] objectForKey:@"isDayShow"])
        {
            if([[[NSUserDefaults standardUserDefaults] objectForKey:@"isDayShow"] isEqualToString:@"0"])
            {
                [switchButton setOn:YES];

            }
            else
            {
                [switchButton setOn:NO];

            }
        }
        else
        {
            [switchButton setOn:NO];

        }
        switchButton.tag = 102;
        [switchButton addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
        [cell addSubview:switchButton];
    }
    if(indexPath.row ==3)
    {
        switchButton = [[UISwitch alloc] initWithFrame:CGRectMake(self.view.frame.size.width-60, 10, 20, 10)];
        [switchButton setOn:YES];
        if([[NSUserDefaults standardUserDefaults] objectForKey:@"showImage"])
        {
            if([[[NSUserDefaults standardUserDefaults] objectForKey:@"showImage"] isEqualToString:@"ok"])
            {
                [switchButton setOn:NO];
                
            }
            else
            {
                [switchButton setOn:YES];
                
            }
        }
        else
        {
            [switchButton setOn:YES];
            
        }

        switchButton.tag = 103;
        [switchButton addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
        [cell addSubview:switchButton];
    }

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.text = [dataArray objectAtIndex:indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    cell.textLabel.textColor = myBlackColor;
    
    cell.backgroundColor = myWhiteColor;
    return cell;
}

-(void)switchAction:(id)sender
{
    UISwitch *switchBT = (UISwitch*)sender;
    if(switchBT.tag == 101)
    {
        //新闻推送
        BOOL isButtonOn = [switchBT isOn];
        if (isButtonOn) {
            NSLog(@"打开");
        }else {
            NSLog(@"关闭");
        }
    }
    else if(switchBT.tag ==102)
    {
        //夜间模式
        BOOL isButtonOn = [switchBT isOn];
        if (isButtonOn) {
            NSLog(@"打开");
            [[NSUserDefaults standardUserDefaults]setObject:@"0" forKey:@"isDayShow"];
        }else {
            NSLog(@"关闭");
            [[NSUserDefaults standardUserDefaults]setObject:@"1" forKey:@"isDayShow"];

        }
        [self days];

    }
    else
    {
        //加载图片
        BOOL isButtonOn = [switchBT isOn];
        if (isButtonOn) {
            NSLog(@"打开");
            [[NSUserDefaults standardUserDefaults] setObject:@"no" forKey:@"showImage"];
        }else {
            NSLog(@"关闭");
            [[NSUserDefaults standardUserDefaults] setObject:@"ok" forKey:@"showImage"];
        }

    }
    
}

-(void)days
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
    _table.backgroundColor = myWhiteColor;
    [_table reloadData];
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row ==0)
    {
        
        TYRightMenuFontViewController * font = [[TYRightMenuFontViewController alloc] init];
        [font getModifyData:^(NSString *data) {
            
            UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
            
            for(UILabel*view in cell.subviews)
            {
                if(view.tag ==10086)
                {
                    view.text = data;
                }
            }
            
        }];
        [self.navigationController pushViewController:font animated:YES];
    }
    else if(indexPath.row ==4)
    {
    
        dispatch_async(
                       
           dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
           , ^{
               
               NSString *cachPath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory,NSUserDomainMask, YES) objectAtIndex:0];
               
               NSArray *files = [[NSFileManager defaultManager] subpathsAtPath:cachPath];
               
               NSLog(@"files :%d",[files count]);
               
               for (NSString *p in files) {
                   
                   NSError *error;
                   
                   NSString *path = [cachPath stringByAppendingPathComponent:p];
                   
                   if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
                       
                       [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
                       
                   }
                   
               }
               
               [self performSelectorOnMainThread:@selector(clearCacheSuccess) withObject:nil waitUntilDone:YES];
           });

       
    }
    else if(indexPath.row ==5)
    {
        TYSuggestViewController * suggest = [[TYSuggestViewController alloc] init];
        [self.navigationController pushViewController:suggest animated:YES];
    }
    else if(indexPath.row ==6)
    {
        TYAboutViewController * about = [[TYAboutViewController alloc] init];
        [self.navigationController pushViewController:about animated:YES];
    }
}

-(void)clearCacheSuccess

{
    
    UIWindow *window = [[UIApplication sharedApplication].windows objectAtIndex:[[UIApplication sharedApplication].windows count]-1];
    CBMBProgressHUD *indicator = [[CBMBProgressHUD alloc] initWithWindow:window];
    indicator.labelText = @"清除成功";
    
    indicator.mode = MBProgressHUDModeText;
    [window addSubview:indicator];
    [indicator showAnimated:YES whileExecutingBlock:^{
        sleep(1.2);
    } completionBlock:^{
        [indicator removeFromSuperview];
        [self dismissViewControllerAnimated:YES completion:^{
            
        }];
    }];
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

-(void)popself
{
    [appDelegate showRightView];
    [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"isSetDayShow"];
    [self.navigationController popViewControllerAnimated:YES];
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
