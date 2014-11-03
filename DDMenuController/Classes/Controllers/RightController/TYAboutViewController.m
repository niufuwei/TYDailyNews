//
//  TYAboutViewController.m
//  TYDaily
//
//  Created by laoniu on 14/10/19.
//
//

#import "TYAboutViewController.h"

@interface TYAboutViewController ()
{
    UIScrollView * bgScrollview;
}

@end

@implementation TYAboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NavCustom * cus = [[NavCustom alloc] init];
    [cus setNavWithText:@"关于我们" mySelf:self];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    bgScrollview = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [self.view addSubview:bgScrollview];
    
    UIImageView * Icon = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2-40, 50, 80, 80)];
    [Icon setImage:[UIImage imageNamed:@"LOGORED"]];
    [bgScrollview addSubview:Icon];
    
    UIImageView * Icon2 = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2-40, Icon.frame.size.height+Icon.frame.origin.y+10, 80, 20)];
    [Icon2 setImage:[UIImage imageNamed:@"LOGO2"]];
    [bgScrollview addSubview:Icon2];
    
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, Icon2.frame.size.height+Icon2.frame.origin.y+5, self.view.frame.size.width, 15)];
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor grayColor];
    label.font = [UIFont systemFontOfSize:11];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = @"V1.212";
    [bgScrollview addSubview:label];
    
    UIImageView * Icon3 = [[UIImageView alloc] initWithFrame:CGRectMake(20, label.frame.size.height+label.frame.origin.y+10, self.view.frame.size.width-40, 100)];
    [Icon3 setImage:[UIImage imageNamed:@"kuang"]];
    [bgScrollview addSubview:Icon3];
    
    UILabel * label2 = [[UILabel alloc] initWithFrame:CGRectMake(0, label.frame.size.height+label.frame.origin.y+10, self.view.frame.size.width, 50)];
    label2.backgroundColor = [UIColor clearColor];
    label2.textColor = [UIColor grayColor];
    label2.font = [UIFont systemFontOfSize:14];
    label2.textAlignment = NSTextAlignmentCenter;
    label2.text = @"传递太原信息，助力龙城发展";
    [bgScrollview addSubview:label2];
    
    UIButton * label3 = [[UIButton alloc] initWithFrame:CGRectMake(20, label2.frame.size.height+label2.frame.origin.y, self.view.frame.size.width-40, 50)];
    label3.backgroundColor = [UIColor clearColor];
    [label3 setTitle:@"版本更新" forState:UIControlStateNormal];
    label3.titleLabel.font = [UIFont systemFontOfSize:14];
    [label3 setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    label3.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [label3 addTarget:self action:@selector(onClick) forControlEvents:UIControlEventTouchUpInside];
    [bgScrollview addSubview:label3];
    
    UILabel * label4 = [[UILabel alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-80-64, self.view.frame.size.width, 20)];
    label4.backgroundColor = [UIColor clearColor];
    label4.textColor = [UIColor grayColor];
    label4.font = [UIFont systemFontOfSize:13];
    label4.textAlignment = NSTextAlignmentCenter;
    label4.text = @"官网  微博";
    [bgScrollview addSubview:label4];
    
    UILabel * label5 = [[UILabel alloc] initWithFrame:CGRectMake(0, label4.frame.size.height+label4.frame.origin.y, self.view.frame.size.width, 20)];
    label5.backgroundColor = [UIColor clearColor];
    label5.textColor = [UIColor grayColor];
    label5.font = [UIFont systemFontOfSize:13];
    label5.textAlignment = NSTextAlignmentCenter;
    label5.text = @"Copyright 20XX-20XX.TYRB";
    [bgScrollview addSubview:label5];
    
    bgScrollview.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height+1);
    // Do any additional setup after loading the view.
}

-(void)onClick
{
    UIWindow *window = [[UIApplication sharedApplication].windows objectAtIndex:[[UIApplication sharedApplication].windows count]-1];
    CBMBProgressHUD *indicator = [[CBMBProgressHUD alloc] initWithWindow:window];
    indicator.labelText = @"已是最新版本";
    
    indicator.mode = MBProgressHUDModeText;
    [window addSubview:indicator];
    
    
    [indicator showAnimated:YES whileExecutingBlock:^{
        sleep(1.2);
    } completionBlock:^{
        [indicator removeFromSuperview];
    }];

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
