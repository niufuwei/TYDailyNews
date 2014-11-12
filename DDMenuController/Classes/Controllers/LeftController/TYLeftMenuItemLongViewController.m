//
//  TYLeftMenuItemLongViewController.m
//  TYDaily
//
//  Created by laoniu on 14-10-2.
//
//

#import "TYLeftMenuItemLongViewController.h"
#import "TYLoginViewController.h"
#import "TYLongCell.h"
#import "TYLongInforViewController.h"

@interface TYLeftMenuItemLongViewController ()
{
    NavCustom * myNavCustom;
    NSMutableArray *dataArray;
  
    UIColor * myBlackColor;
    UIColor * myWhiteColor;
    
    TYHttpRequest * myHttp;
}
@end

@implementation TYLeftMenuItemLongViewController

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
   
    dataArray = [[NSMutableArray alloc] init];
    
    myNavCustom = [[NavCustom alloc] init];
    [myNavCustom setNavWithText:@"龙城专栏" mySelf:self];
    [myNavCustom setNavLeftBtnImage:@"left_ios.png" LeftBtnSelectedImage:@"" mySelf:self width:18 height:15];
    [myNavCustom setNavRightBtnImage:@"USER_ios.png" RightBtnSelectedImage:@"" mySelf:self width:18 height:20];
    myNavCustom.NavDelegate = self;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onLogin:) name:@"login" object:nil];

    _table = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-64)];
    _table.delegate = self;
    _table.dataSource = self;
    _table.separatorStyle = UITableViewCellSeparatorStyleNone;
    _table.tableFooterView = [[UIView alloc] init];
    _table.backgroundColor = myWhiteColor;
    [self.view addSubview:_table];
    
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"longcheng"])
    {
        dataArray = [[NSMutableArray alloc] initWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"longcheng"]];
        [_table reloadData];
    }

    [self loadRequest];
    
    // Do any additional setup after loading the view.
}

-(void)loadRequest
{
    myHttp = [[TYHttpRequest alloc] init];
    [myHttp httpRequest:@"ztimg/view" parameter:@"type=ios&size=160" Success:^(id result) {
        
        NSLog(@"%@",result);
        NSData * data = [result dataUsingEncoding:NSUTF8StringEncoding];
        dataArray =(NSMutableArray *)[data objectFromJSONData];
        
        [[NSUserDefaults standardUserDefaults] setObject:dataArray forKey:@"longcheng"];
        [_table reloadData];
        
    } Failure:^(NSError *error) {
        
        NSLog(@"%@",error);
    } view:self.view isPost:NO];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [dataArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * strID = @"cell";
    TYLongCell * cell = [tableView dequeueReusableCellWithIdentifier:strID];
    if(!cell)
    {
        cell = [[TYLongCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:strID];
    }
    cell.backgroundColor = myWhiteColor;

    [cell.image setImageWithURL:[NSURL URLWithString:[[dataArray objectAtIndex:indexPath.row] objectForKey:@"img"]] placeholderImage:[UIImage imageNamed:@"noImage"]];
    
    return cell;
}

-(void)onLogin:(NSNotification*)noti
{
    TYLoginViewController * login = [[TYLoginViewController alloc] init];
    
    NavViewController * nav  = [[NavViewController alloc] initWithRootViewController:login];
    [self.navigationController presentViewController:nav animated:YES completion:^{
        
    }];
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 95;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
        TYLongInforViewController * infor = [[TYLongInforViewController alloc] init];
        infor.titleStr = @"专题报道";
    infor.requestUrl = [[dataArray objectAtIndex:indexPath.row] objectForKey:@"url"];
        [self.navigationController pushViewController:infor animated:YES];
    
    
}

-(void)NavLeftButtononClick
{
    [appDelegate showLeftView];
}

-(void)NavRightButtononClick
{
    [appDelegate showRightView];
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
