//
//  TYZonglanViewController.m
//  TYDaily
//
//  Created by laoniu on 14/11/2.
//
//

#import "TYZonglanViewController.h"
#import "TYZongLan.h"
#import "TYLongInforViewController.h"

@interface TYZonglanViewController ()
{
    NavCustom * myNavCustom;
    UIScrollView * myScrollview;
    NSArray * imageSelectedArr;
    NSInteger buttonIndex;
    NSArray * imageNoSelectArr;
    TYZongLan * zonglan;
    NSArray * titleArr;
    NSArray * urlArray;
}


@end

@implementation TYZonglanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    buttonIndex = -1;
    
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
     titleArr = [NSArray arrayWithObjects:@"和谐迎泽",@"生态万柏林",@"魅力草坪",@"醋都采风",@"古交新闻",@"关注晋中",@"聚焦安监",@"并州法苑",@"民生价格",@"城乡管理",@"钢园风采",@"龙城社区",@"工会之窗",@"碧水蓝天",@"移动生活",@"六味飘香", nil];
    
     imageNoSelectArr = [[NSArray alloc] initWithObjects:@"和谐no",@"生态no",@"魅力no",@"醋都no",@"古交no",@"晋中no",@"安监no",@"法苑no",@"价格no",@"城乡no",@"钢园no",@"龙城no",@"工会no",@"蓝天no",@"移动no",@"六味no", nil];
     imageSelectedArr = [[NSArray alloc] initWithObjects:@"和谐yes",@"生态yes",@"魅力yes",@"醋都yes",@"古交yes",@"晋中yes",@"安监yes",@"法苑yes",@"价格yes",@"城乡yes",@"钢园yes",@"龙城yes",@"工会yes",@"蓝天yes",@"移动yes",@"六味yes", nil];
    
    urlArray = [[NSArray alloc] initWithObjects:@"hxyz/list",@"stwbl/list",@"mlcp/list",@"cdfc/list",@"gjxw/list",@"gzjz/list",@"jjaj/list",@"bzfy/list",@"msjg/list",@"cxgl/list",@"gyfc/list",@"lcsq/list",@"ghzc/list",@"bslt/list",@"ydsh/list",@"lwpx/list", nil];
    
    NSInteger myXX = 50;
    NSInteger myYY = 30;
    
    for(int i =0;i<[titleArr count];i++)
    {
        
        zonglan = [[TYZongLan alloc] initWithFrame:CGRectMake(myXX, myYY, 100, 120)];
        [myScrollview addSubview:zonglan];
        zonglan.tag = 100+i;
        zonglan.button.tag = 100+i;
        [zonglan.button addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
        [zonglan.button setBackgroundImage:[UIImage imageNamed:[imageNoSelectArr objectAtIndex:i]] forState:UIControlStateNormal];
        
        zonglan.titleLabel.text = [titleArr objectAtIndex:i];
        myXX =zonglan.frame.size.width+zonglan.frame.origin.x+20;
        if(myXX>self.view.frame.size.width/2+100)
        {
            myXX = 50;
            myYY =zonglan.frame.size.height + zonglan.frame.origin.y+20;
        }
    }
    
    myScrollview.contentSize = CGSizeMake(self.view.frame.size.width, myYY+30);
    // Do any additional setup after loading the view.
}

-(void)onClick:(id)sender
{
    UIButton * button = (UIButton*)sender;
    NSLog(@"%d",button.tag);
    
    if(buttonIndex ==-1)
    {
        [button setBackgroundImage:[UIImage imageNamed:[imageSelectedArr objectAtIndex:button.tag-100]] forState:UIControlStateNormal];
    }
    else
    {
        if(buttonIndex ==button.tag)
        {
            
        }
        else
        {
            [button setBackgroundImage:[UIImage imageNamed:[imageSelectedArr objectAtIndex:button.tag-100]] forState:UIControlStateNormal];

            
            for(UIView * view in myScrollview.subviews)
            {
                if(view.tag ==  buttonIndex)
                {
                    TYZongLan * temp = (TYZongLan*)view;
                    [temp.button setBackgroundImage:[UIImage imageNamed:[imageNoSelectArr objectAtIndex:buttonIndex-100]] forState:UIControlStateNormal];
                }
            }
        }

    }
    
    TYLongInforViewController * infor = [[TYLongInforViewController alloc] init];
    infor.titleStr = [titleArr objectAtIndex:button.tag-100];
    infor.requestUrl = [urlArray objectAtIndex:button.tag-100];
    [self.navigationController pushViewController:infor animated:YES];

    
    buttonIndex = button.tag;
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
