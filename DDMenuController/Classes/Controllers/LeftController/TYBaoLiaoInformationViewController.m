//
//  TYBaoLiaoInformationViewController.m
//  TYDaily
//
//  Created by laoniu on 14-10-14.
//
//

#import "TYBaoLiaoInformationViewController.h"

@interface TYBaoLiaoInformationViewController ()
{
    UIScrollView * backScrollview;
    TYHttpRequest * httpRequest;
}

@end

@implementation TYBaoLiaoInformationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    httpRequest = [[TYHttpRequest alloc] init];
    NSLog(@"%@",_newsID);
    [httpRequest httpRequest:_requestUrl parameter:[NSString stringWithFormat:@"id=%@",_newsID] Success:^(id result) {
        
        
        NSLog(@"%@",result);
        NSData * data = [result dataUsingEncoding:NSUTF8StringEncoding];
        [self fillDataWithView:(NSDictionary*)[data objectFromJSONData]];
    } Failure:^(NSError *error) {
        
        NSLog(@"%@",error);
        UIWindow *window = [[UIApplication sharedApplication].windows objectAtIndex:[[UIApplication sharedApplication].windows count]-1];
        CBMBProgressHUD *indicator = [[CBMBProgressHUD alloc] initWithWindow:window];
        indicator.labelText = @"请求出错";
        
        indicator.mode = MBProgressHUDModeText;
        [window addSubview:indicator];
        
        
        [indicator showAnimated:YES whileExecutingBlock:^{
            sleep(1.2);
        } completionBlock:^{
            [indicator removeFromSuperview];
        }];

    } view:self.view isPost:NO];
    
    // Do any additional setup after loading the view.
}


-(void)fillDataWithView:(NSDictionary *)dic
{
    
    NSArray *  dataArr = [NSArray arrayWithObjects:@"超大字体",@"大字体",@"中字体",@"小字体", nil];
    
    NSInteger textFont;
    textFont = [dataArr indexOfObject:[[NSUserDefaults standardUserDefaults] objectForKey:@"font"]];
    if(textFont == 0)
    {
        textFont = 30;
        
    }
    else if(textFont ==1)
    {
        textFont = 20;
        
    }
    else if(textFont ==2)
    {
        textFont = 15;
        
    }
    else
    {
        textFont = 12;
    }

    
    
    backScrollview = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    backScrollview.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height+1);
    backScrollview.delegate = self;
    [self.view addSubview:backScrollview];
    
  
    UILabel * PageTitle = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, self.view.frame.size.width-20, 20)];
    PageTitle.text = [CS DealWithString: [dic objectForKey:@"title"]];
    PageTitle.textAlignment = NSTextAlignmentLeft;
    PageTitle.textColor =[UIColor blackColor];
    PageTitle.backgroundColor = [UIColor clearColor];
    PageTitle.font = [UIFont systemFontOfSize:14];
    [backScrollview addSubview:PageTitle];
    
    UILabel * create_time = [[UILabel alloc] initWithFrame:CGRectMake(10, PageTitle.frame.size.height+PageTitle.frame.origin.y+5, self.view.frame.size.width-120, 20)];
    create_time.text = [CS DealWithString: [dic objectForKey:@"create_time"]];
    create_time.textAlignment = NSTextAlignmentLeft;
    create_time.textColor =[UIColor grayColor];
    create_time.backgroundColor = [UIColor clearColor];
    create_time.lineBreakMode = NSLineBreakByCharWrapping;
    create_time.font = [UIFont systemFontOfSize:12];
    [backScrollview addSubview:create_time];
    
    UILabel * type = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width-150, PageTitle.frame.size.height+PageTitle.frame.origin.y+5, 130, 20)];
    type.text = [NSString stringWithFormat:@"爆料来源:%@",[dic objectForKey:@"name"]];
    type.textAlignment = NSTextAlignmentRight;
    type.textColor =[UIColor grayColor];
    type.backgroundColor = [UIColor clearColor];
    type.font = [UIFont systemFontOfSize:12];
    [backScrollview addSubview:type];
    
    UIImageView * imageHeng = [[UIImageView alloc] initWithFrame:CGRectMake(10, create_time.frame.size.height+create_time.frame.origin.y+5, self.view.frame.size.width-20, 1)];
    [imageHeng setImage:[UIImage imageNamed:@"LINE"]];
    [backScrollview addSubview:imageHeng];
    
    //加载图片
    
    NSInteger myYY = imageHeng.frame.size.height+imageHeng.frame.origin.y+10;
//    for(int i = 0; i < [[dic objectForKey:@"Images"] count];i++)
    if([[dic objectForKey:@"img1"] length] !=0)
    {
        UIImageView * image =[[ UIImageView alloc] initWithFrame:CGRectMake(40, myYY, self.view.frame.size.width-80, (self.view.frame.size.width-80)/2)];
        [image setImageWithURL:[NSURL URLWithString:[dic objectForKey:@"img1"]] placeholderImage:[UIImage imageNamed:@""]];
        [backScrollview addSubview:image];
        
        myYY = image.frame.size.height+image.frame.origin.y+10;
    }
    
    UILabel * content = [[UILabel alloc] initWithFrame:CGRectMake(10,myYY+5, self.view.frame.size.width-20, 100)];
    
    content.textAlignment = NSTextAlignmentLeft;
    content.textColor =[UIColor grayColor];
    content.backgroundColor = [UIColor clearColor];
    content.font = [UIFont systemFontOfSize:textFont];
    
    content.numberOfLines =0;
    CGSize labelSize = {0, 0};
    
    NSString * strT = @"    ";
    NSString * strContent = [[dic objectForKey:@"content"] stringByReplacingOccurrencesOfString:@"<p>" withString:@"  "];
    strContent =[strContent stringByReplacingOccurrencesOfString:@"</p>" withString:@"\n"];
    strContent =[strContent stringByReplacingOccurrencesOfString:@"<br />" withString:@""];
    
    strContent = [strT stringByAppendingString:strContent];

    //    NSData* jsonData = [[dic objectForKey:@"Content"] dataUsingEncoding:NSUTF8StringEncoding];
    //    content.text = [jsonData objectFromJSONData];
    
    //    NSLog(@"%@",content.text);
    labelSize = [strContent sizeWithFont:[UIFont systemFontOfSize:textFont]
                 
                       constrainedToSize:CGSizeMake(self.view.frame.size.width-20, 5000)
                 
                           lineBreakMode:NSLineBreakByWordWrapping];
    
    content.text = strContent;
    content.frame =CGRectMake(content.frame.origin.x, content.frame.origin.y, content.frame.size.width, labelSize.height+50);
    [backScrollview addSubview:content];

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
