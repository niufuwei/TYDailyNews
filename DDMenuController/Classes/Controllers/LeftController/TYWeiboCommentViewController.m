//
//  TYWeiboCommentViewController.m
//  TYDaily
//
//  Created by laoniu on 14/10/19.
//
//

#import "TYWeiboCommentViewController.h"
#import "TYWeiboCommentCell.h"
#import "TYWeiboCV.h"

@interface TYWeiboCommentViewController ()
{
    TYHttpRequest * httpRequest;
    NSMutableArray * dataArray;
    TYWeiboCV * weiboCV;
    UILabel * noComment;
    NavCustom * myNavCustom;
    UIColor * myWhiteColor;
    UIColor * myBlackColor;
}

@end

@implementation TYWeiboCommentViewController

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
    myNavCustom = [[NavCustom alloc] init];
    //    [myNavCustom setNavWithImage:@"LOGO.png" mySelf:self width:10 height:25];
    [myNavCustom setNavWithText:@"评论" mySelf:self];
    
    dataArray = [[NSMutableArray alloc] init];
    httpRequest = [[TYHttpRequest alloc] init];
    _table = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-64-50)];
    _table.delegate =self;
    _table.dataSource = self;
    _table.tableFooterView = [[UIView alloc] init];
    _table.backgroundColor = myWhiteColor;
    [self.view addSubview:_table];

    weiboCV = [[TYWeiboCV alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-64-50, self.view.frame.size.width, 50) ID:_WeiboID];
    [weiboCV setBackgroundColor:myWhiteColor];
    [self.view addSubview:weiboCV];
    [weiboCV bringSubviewToFront:self.view];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
     
                                             selector:@selector(keyboardWillShow:)
     
                                                 name:UIKeyboardWillShowNotification
     
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
     
                                             selector:@selector(keyboardWillHide:)
     
                                                 name:UIKeyboardWillHideNotification
     
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateWeibo) name:@"WeiboUpdate" object:nil];

     [self loadRequest];
    // Do any additional setup after loading the view.
}

-(void)updateWeibo
{
    [dataArray removeAllObjects];
    [self loadRequest];
}

-(void)loadRequest
{
    [httpRequest httpRequestWeiBo:@"http://123.57.17.124/weibo/comments_show.php" parameter:[NSString stringWithFormat:@"id=%@",_WeiboID] Success:^(id result) {
        
        NSLog(@"%@",result);
        NSData* jsonData = [result dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary * dic = (NSDictionary*)[jsonData objectFromJSONData];
        for(int i=0;i<[[dic objectForKey:@"comments"] count];i++)
        {
            [dataArray addObject:[[dic objectForKey:@"comments"] objectAtIndex:i]];
        }
        if([dataArray count]==0)
        {
            noComment = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
            noComment.backgroundColor = [UIColor clearColor];
            noComment.textColor = myBlackColor;
            noComment.text = @"暂无评论";
            noComment.textAlignment = NSTextAlignmentCenter;
            noComment.font = [UIFont systemFontOfSize:16];
            [self.view addSubview:noComment];
        }
        else
        {
            if(noComment)
            {
                [noComment removeFromSuperview];
            }
            [_table reloadData];
        }
        
    } Failure:^(NSError *error) {
        
        NSLog(@"%@",error);
    } view:self.view isPost:NO];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [dataArray count];
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * strID= @"cell";
    TYWeiboCommentCell * cell = [tableView dequeueReusableCellWithIdentifier:strID];
    if(!cell)
    {
        cell = [[TYWeiboCommentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:strID];
    }
    
    cell.backgroundColor = myWhiteColor;

    cell.content.text = [[dataArray objectAtIndex:indexPath.row] objectForKey:@"text"];
    cell.content.textColor = myBlackColor;
    cell.buttomLabel.text = [NSString stringWithFormat:@"回帖日期:%@",[[dataArray objectAtIndex:indexPath.row] objectForKey:@"created_at"]] ;
    cell.buttomLabel.textColor = myBlackColor;
  
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}


- (void) keyboardWillShow:(NSNotification *) notif
{
    NSDictionary *info = [notif userInfo];
    
    NSValue *value = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
    
    CGSize keyboardSize = [value CGRectValue].size;
    
    [UIView animateWithDuration:0.1 delay:0 options:0 animations:^{
        weiboCV.frame = CGRectMake(0, self.view.frame.size.height- keyboardSize.height-50, 320, 50);
    } completion:^(BOOL finished) {
        
    }];
}

-(void)keyboardWillHide:(NSNotification*)noti
{
    [UIView animateWithDuration:0.1 delay:0 options:0 animations:^{
        weiboCV.frame = CGRectMake(0, self.view.frame.size.height-50
                                      , 320, 50);
    } completion:^(BOOL finished) {
        
    }];
    
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
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
