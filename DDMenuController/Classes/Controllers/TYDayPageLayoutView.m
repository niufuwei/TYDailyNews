//
//  TYDayPageLayoutViewController.m
//  TYDaily
//
//  Created by laoniu on 14-10-3.
//
//

#import "TYDayPageLayoutView.h"


@interface TYDayPageLayoutView ()
{
    UIWebView * myWebView;
    TYHttpRequest * myHttp;
    __block NSMutableArray * dataArray;
    UIActivityIndicatorView *testActivityIndicator;
    NSString * myDate;
    NSString * myWeak;
    
    UIScrollView * scrollview;
    BOOL isShow;
    UIPageControl * pageController;
    
    NSMutableDictionary * RecordPage;
    
    NSMutableDictionary * InforDic;
    UIColor * myBlackColor;
    UIColor * myWhiteColor;
}
@end

@implementation TYDayPageLayoutView

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
    _centerInformation.textColor = myBlackColor;
    self.backgroundColor = myWhiteColor;
    
}

- (void)viewLayout:(NSString *)requestDateString {
    
    [self viewwill];

    isShow = FALSE;
    
    scrollview = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    scrollview.pagingEnabled= YES;
    scrollview.delegate =self;
    [self addSubview:scrollview];
    
    InforDic = [[NSMutableDictionary alloc] init];
    
    
    //获取当前日期
    Date * date = [[Date alloc] init];
    myDate =[date stringFormDate:[NSDate date] isHorLine:NO];
    myWeak = [date getWeakInfor:[NSDate date]];
    dataArray = [[NSMutableArray alloc] init];
    RecordPage = [[NSMutableDictionary alloc] init];
    
    if(requestDateString)
    {
        NSMutableString * string = [[NSMutableString alloc] initWithString:requestDateString];
        [string insertString:@"-" atIndex:4];
        [string insertString:@"-" atIndex:7];
        myWeak = [date getWeakInfor:[date DateFormString:string]];
        
        myDate = [date getYMDInfor:[date DateFormString:string]];

    }
    
    
    //获取有多少页面
    [self getNumberPage];
    
    //加载版面信息
//    [self loadInformation];

    
    testActivityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    testActivityIndicator.center = CGPointMake(self.frame.size.width/2-10,200);
    [self addSubview:testActivityIndicator];
    testActivityIndicator.color = [UIColor blackColor]; // 改变圈圈的颜色为红色； iOS5引入
    [testActivityIndicator startAnimating]; // 开始旋转
    
    pageController = [[UIPageControl alloc] initWithFrame:CGRectMake(0, self.frame.size.height-64-20, self.frame.size.width, 20)];
    pageController.currentPage=0; //初始页码为 0
    pageController.userInteractionEnabled=NO; //pagecontroller不响应点击操作
    pageController.backgroundColor = [UIColor grayColor];
    [self addSubview:pageController];
    [pageController bringSubviewToFront:self];
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [testActivityIndicator stopAnimating];
}

-(NSString*)timeDealWith
{
    NSString * str = [myDate stringByReplacingOccurrencesOfString:@"年" withString:@""];
    str = [str stringByReplacingOccurrencesOfString:@"月" withString:@""];
    str = [str stringByReplacingOccurrencesOfString:@"日" withString:@""];
    
    str = [str stringByReplacingOccurrencesOfString:@"-" withString:@""];
    str = [str stringByReplacingOccurrencesOfString:@"-" withString:@""];
    str = [str stringByReplacingOccurrencesOfString:@"-" withString:@""];
    
    return str;
}

-(void)loadInformation
{
    _leftInformation = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 90, 30)];

    myHttp  = [[TYHttpRequest alloc] init];

    [myHttp httpRequest:@"pname/view" parameter:[NSString stringWithFormat:@"date=%@&pageNo=%@",[self timeDealWith],@"01"] Success:^(id result){
        _leftInformation.text = [NSString stringWithFormat:@"%@版 %@频道",@"01",result];
        [InforDic setObject:[NSString stringWithFormat:@"%@版 %@频道",@"01",result] forKey:@"01"];
        
    } Failure:^(NSError *error) {
        _leftInformation.text = [NSString stringWithFormat:@"获取失败"];
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

    
    _leftInformation.textColor = [UIColor colorWithRed:165.0/255.0 green:0/255.0 blue:0/255.0 alpha:1];
    _leftInformation.backgroundColor = [UIColor clearColor];
    _leftInformation.font = [UIFont systemFontOfSize:12];
    [self addSubview:_leftInformation];
    [_leftInformation bringSubviewToFront:self];
    
    _centerInformation = [[UILabel alloc] initWithFrame:CGRectMake(_leftInformation.frame.size.width+_leftInformation.frame.origin.x, 0, 135, 30)];
    
//    _centerInformation.text = [NSString stringWithFormat:@"%@ %@",[date stringFormDate:[NSDate date] isHorLine:YES],myWeak];
    
    NSRange rang = [myDate rangeOfString:@"-"];
    NSRange rang2=  [myDate rangeOfString:@"日"];
    if(rang.location == NSNotFound && rang2.location == NSNotFound )
    {
        NSMutableString * string = [[NSMutableString alloc] initWithString:myDate];
        [string insertString:@"年" atIndex:4];
        [string insertString:@"月" atIndex:7];
        [string insertString:@"日" atIndex:10];

        myDate =  string;
    }
    else
    {
        
    }
    
    _centerInformation.text = [NSString stringWithFormat:@"%@ %@",myDate,myWeak];

    _centerInformation.backgroundColor = [UIColor clearColor];
    _centerInformation.textColor = myBlackColor;
    _centerInformation.font = [UIFont systemFontOfSize:12];
    [self addSubview:_centerInformation];
    [_centerInformation bringSubviewToFront:self];

    
    _rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_rightButton setTitle:@"版面选择" forState:UIControlStateNormal];
    [_rightButton setTitleColor: [UIColor colorWithRed:165.0/255.0 green:0/255.0 blue:0/255.0 alpha:1] forState:UIControlStateNormal];
    [_rightButton addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
    _rightButton.frame = CGRectMake(_centerInformation.frame.size.width+_centerInformation.frame.origin.x, 0, 80, 30);
    _rightButton.titleLabel.font = [UIFont systemFontOfSize:12];
    [self addSubview:_rightButton];
    [_rightButton bringSubviewToFront:self];
    
    UIImageView * icon = [[UIImageView alloc] initWithFrame:CGRectMake(_rightButton.frame.size.width+_rightButton.frame.origin.x-15, 8, 12, 12)];
    [icon setImage:[UIImage imageNamed:@"more.png"]];
    [self addSubview:icon];
    [icon bringSubviewToFront:self];
    
    
    _myTable = [[UITableView alloc] initWithFrame:CGRectMake(_rightButton.frame.origin.x, 30, _rightButton.frame.size.width, 300)];
    _myTable.delegate = self;
    _myTable.dataSource = self;
    _myTable.hidden= YES;
    _myTable.tableFooterView = [[UIView alloc] init];
    [self addSubview:_myTable];
    [_myTable bringSubviewToFront:self];
}

-(void)getNumberPage
{
    myHttp  = [[TYHttpRequest alloc] init];
   
    [myHttp httpRequest:@"pagecount/view" parameter:[NSString stringWithFormat:@"date=%@",[self timeDealWith]] Success:^(id result) {
        
        NSLog(@"请求成功，返回--->%@",result);
        
        NSLog(@"%d",[result intValue]);
        for(int i=0;i<[result intValue];i++)
        {
            [dataArray addObject:[NSString stringWithFormat:@"0%d",i+1]];
        }
        scrollview.contentSize = CGSizeMake(self.frame.size.width*[dataArray count], self.frame.size.height);
        
        myWebView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 30, self.frame.size.width, self.frame.size.height-64-30-20)];
        myWebView.delegate = self;
        
        NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://123.57.17.124/epaper/index.php?r=article/paper&date=%@&pageNo=%@",[self timeDealWith],[dataArray objectAtIndex:0]]]];
        NSLog(@"%@",request);
        [myWebView loadRequest:request];
        [myWebView setScalesPageToFit:YES];
        
        [scrollview addSubview:myWebView];
        
        pageController.numberOfPages = [dataArray count];
        [RecordPage setObject:@"ok" forKey:[dataArray objectAtIndex:0]];
        
        [self loadInformation];
        
    } Failure:^(NSError *error) {
        NSLog(@"失败==>%@",error);
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
-(void)onClick:(id)sender
{
    if(!isShow)
    {
        isShow = TRUE;
        //开始动画
        [UIView beginAnimations:nil context:nil];
        //设定动画持续时间
        [UIView setAnimationDuration:1];
        //动画的内容
        _myTable.hidden = NO;
        //动画结束
        [UIView commitAnimations];
        

    }
    else
    {//开始动画
        [UIView beginAnimations:nil context:nil];
        //设定动画持续时间
        [UIView setAnimationDuration:1];
        //动画的内容
        _myTable.hidden = YES;
        
        //动画结束
        [UIView commitAnimations];
        isShow = FALSE;

    }
    
    [_myTable reloadData];
    
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
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:strID];
    if(!cell)
    {
        cell  =[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:strID];
    }
    
    cell.textLabel.text = [dataArray objectAtIndex:indexPath.row];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    NSString * string = [NSString stringWithFormat:@"http://123.57.17.124/epaper/index.php?r=article/paper&date=%@&pageNo=0%d",myDate,indexPath.row+1];
//    
//    NSLog(@"%@",string);
//    NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:string]];
//    [myWebView loadRequest:request];
    
    _myTable.hidden= YES;
//    [testActivityIndicator startAnimating]; // 开始旋转
    
//    [self titleModify:indexPath.row];
    
    [scrollview scrollRectToVisible:CGRectMake(self.frame.size.width*indexPath.row, 0, self.frame.size.width, self.frame.size.height) animated:NO];
}

-(void)titleModify:(NSInteger)index
{
    //获取当前版面信息
    myHttp  = [[TYHttpRequest alloc] init];
    [myHttp httpRequest:@"pname/view" parameter:[NSString stringWithFormat:@"date=%@&pageNo=0%d",[self timeDealWith],index+1] Success:^(id result) {
        _leftInformation.text = [NSString stringWithFormat:@"0%d版 %@频道",index+1,result];
        
        [InforDic setObject:[NSString stringWithFormat:@"0%d版 %@频道",index+1,result] forKey:[NSString stringWithFormat:@"0%d",index+1]];
        NSLog(@"请求成功，返回--->%@",result);
        
    } Failure:^(NSError *error) {
        NSLog(@"失败==>%@",error);
        _leftInformation.text = [NSString stringWithFormat:@"获取失败"];
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

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    
    //判断是否是单击
    
    if (navigationType == UIWebViewNavigationTypeLinkClicked)
        
    {
        
        NSURL *url = [request URL];
        NSLog(@"%@",url);
        
//        if([[UIApplication sharedApplication]canOpenURL:url])
//            
//        {
//            
//            [[UIApplication sharedApplication]openURL:url];
//            
//        }
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"pushNewsWithUrl" object:url];
    
        return NO;
    }
    
    return YES;
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSInteger indexPath = scrollview.contentOffset.x;
    NSInteger currentWidth = self.frame.size.width;
    if(indexPath % currentWidth == 0)
    {
        NSLog(@"%@",RecordPage);
        if([[RecordPage objectForKey:[dataArray objectAtIndex:indexPath/currentWidth]] isEqualToString:@"ok"])
        {
            
            _leftInformation.text = [InforDic objectForKey:[dataArray objectAtIndex:indexPath/currentWidth]];

        }
        else
        {
            [self titleModify:indexPath/currentWidth];

            myWebView = [[UIWebView alloc] initWithFrame:CGRectMake(indexPath/currentWidth*self.frame.size.width, 30, self.frame.size.width, self.frame.size.height-64-30-20)];
            myWebView.delegate = self;
            
            NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://123.57.17.124/epaper/index.php?r=article/paper&date=%@&pageNo=%@",[self timeDealWith],[dataArray objectAtIndex:indexPath/currentWidth]]]];
            NSLog(@"%@",request);
            [myWebView loadRequest:request];
            [myWebView setScalesPageToFit:YES];
            
            [scrollview addSubview:myWebView];
            
            [RecordPage setObject:@"ok" forKey:[dataArray objectAtIndex:indexPath/currentWidth]];

        }
    }
    
    pageController.currentPage = indexPath / currentWidth; //计算当前的页码
    if(scrollView.contentOffset.x >([dataArray count]-1)*self.frame.size.width)
    {
        [appDelegate showRightView];
    }
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
