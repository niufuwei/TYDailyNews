//
//  TYZonglanViewController.m
//  TYDaily
//
//  Created by laoniu on 14/11/2.
//
//

#import "TYZonglanViewController.h"

@interface TYZonglanViewController ()
{
    NavCustom * myNavCustom;
    UIScrollView * myScrollview;
}

@end

@implementation TYZonglanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    myScrollview = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    myScrollview.showsHorizontalScrollIndicator = NO;
    myScrollview.showsVerticalScrollIndicator = NO;
    [self.view addSubview:myScrollview];
    
    self.view.backgroundColor = [UIColor whiteColor];
    myNavCustom = [[NavCustom alloc] init];
    [myNavCustom setNavWithText:@"龙城纵览" mySelf:self];
    [myNavCustom setNavLeftBtnImage:@"left_ios.png" LeftBtnSelectedImage:@"" mySelf:self width:18 height:15];
    [myNavCustom setNavRightBtnImage:@"USER_ios.png" RightBtnSelectedImage:@"" mySelf:self width:18 height:20];
    myNavCustom.NavDelegate = self;
    
//    和谐迎泽、生态万柏林、魅力草坪、醋都采风、古交新闻、关注晋中、聚焦安监、并州法苑、民生价格、城乡管理、钢园风采、龙城社区、工会之窗、碧水蓝天、移动生活、六味飘香
    NSArray * arr = [NSArray arrayWithObjects:@"和谐迎泽",@"生态万柏林",@"魅力草坪",@"醋都采风",@"古交新闻",@"关注晋中",@"聚焦安监",@"并州法苑",@"民生价格",@"城乡管理",@"钢园风采",@"龙城社区",@"工会之窗",@"碧水蓝天",@"移动生活",@"六味飘香", nil];
    
    NSInteger myXX = 50;
    NSInteger myYY = 30;
    
    for(int i =0;i<[arr count];i++)
    {
        UIView * view = [[UIView alloc] initWithFrame:CGRectMake(myXX, myYY, 100, 120)];
        [view setBackgroundColor:[UIColor whiteColor]];
        [myScrollview addSubview:view];
        
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(0, 0, 80, 80);
        button.tag = i+1;
        [button addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
        [button setBackgroundImage:[UIImage imageNamed:@"龙城纵览图"] forState:UIControlStateNormal];
        [view addSubview:button];
        
        UILabel * label =[[UILabel alloc] initWithFrame:CGRectMake(0, button.frame.size.height+button.frame.origin.y, view.frame.size.width, 20)];
        label.text = [arr objectAtIndex:i];
        label.backgroundColor = [UIColor clearColor];
        label.font = [UIFont systemFontOfSize:16];
        label.textColor = [UIColor blackColor];
        [view addSubview:label];
        
        myXX =view.frame.size.width+view.frame.origin.x+20;
        if(myXX>self.view.frame.size.width/2+100)
        {
            myXX = 50;
            myYY =view.frame.size.height + view.frame.origin.y+20;
        }
    }
    
    myScrollview.contentSize = CGSizeMake(self.view.frame.size.width, myYY+30);
    // Do any additional setup after loading the view.
}

-(void)onClick:(id)sender
{
    UIButton * button = (UIButton*)sender;
    NSLog(@"%d",button.tag);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)NavLeftButtononClick
{
    [appDelegate showLeftView];
}

-(void)NavRightButtononClick
{
    [appDelegate showRightView];
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
