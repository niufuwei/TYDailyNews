//
//  TYPDFViewController.m
//  TYDaily
//
//  Created by laoniu on 14/11/8.
//
//

#import "TYPDFViewController.h"

@interface TYPDFViewController ()
{
    UIWebView * myWebview;
    UIActivityIndicatorView * testActivityIndicator;
    NavCustom * custom;
}

@end

@implementation TYPDFViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    custom = [[NavCustom alloc] init];
    [custom setNavWithText:@"PDF" mySelf:self];
    
    myWebview = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-64)];
    myWebview.delegate = self;
    [self.view addSubview:myWebview];
    
    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    
    //初始化临时文件路径
    
    NSString *folderPath = [path stringByAppendingPathComponent:@"download"];
    NSString * savePath = [folderPath stringByAppendingPathComponent:[NSString stringWithFormat:@"/%@.pdf",_myDate]];

    NSURL *url = [NSURL fileURLWithPath:savePath];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [myWebview loadRequest:request];
    
    
    testActivityIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    testActivityIndicator.center = CGPointMake(self.view.frame.size.width/2-10,200);
    [self.view addSubview:testActivityIndicator];
    testActivityIndicator.color = [UIColor blackColor]; // 改变圈圈的颜色为红色； iOS5引入
    [testActivityIndicator startAnimating]; // 开始旋转
    // Do any additional setup after loading the view.
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [testActivityIndicator stopAnimating];
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
