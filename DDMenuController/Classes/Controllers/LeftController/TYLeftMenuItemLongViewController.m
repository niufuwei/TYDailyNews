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
    NSMutableArray * imageArray;
    NSMutableArray * urlArray;
}
@end

@implementation TYLeftMenuItemLongViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    imageArray= [NSMutableArray arrayWithObjects:@"晋韵.jpg",@"美食.jpg",@"生活.jpg",@"娱乐.jpg",@"交通.jpg",nil];
    urlArray = [[NSMutableArray alloc] initWithObjects:@"jy/list",@"jy/list",@"sh/list",@"wt/list",@"ds/list", nil];
    dataArray = [[NSMutableArray alloc] initWithObjects:@"晋韵",@"美食",@"生活",@"娱乐",@"交通", nil];
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
    [self.view addSubview:_table];
    
    // Do any additional setup after loading the view.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [imageArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * strID = @"cell";
    TYLongCell * cell = [tableView dequeueReusableCellWithIdentifier:strID];
    if(!cell)
    {
        cell = [[TYLongCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:strID];
    }
    [cell.image setImage:[UIImage imageNamed:[imageArray objectAtIndex:indexPath.row]]];
    
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
        infor.titleStr = [dataArray objectAtIndex:indexPath.row];
        infor.requestUrl = [urlArray objectAtIndex:indexPath.row];
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
