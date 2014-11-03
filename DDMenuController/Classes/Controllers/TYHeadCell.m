//
//  TYHeadCell.m
//  TYDaily
//
//  Created by laoniu on 14-10-7.
//
//

#import "TYHeadCell.h"
#import "TYHttpRequest.h"

@implementation TYHeadCell
{
    NSMutableArray * imageArray;
    NSMutableArray * idArray;
    UIPageControl * pageControl;
    BMAdScrollView *adView;
    TYHttpRequest * httpRequest;
    NSMutableArray * titleArray;
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        if(!_requestDateString)
        {
            Date * date = [[Date alloc] init];
            _requestDateString = [date stringFormDate:[NSDate date] isHorLine:NO];
        }
        [self sendRequestWithAppImgSlider:_requestDateString];

    }
    return self;

}
-(void)serdsfd
{
    return ;
}
- (void)buttonClick:(int)vid
{
    if([[[NSUserDefaults standardUserDefaults] objectForKey:@"isNesCenter"] isEqualToString:@"0"])
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"pushNewsWithID" object:[idArray objectAtIndex:vid-1]];
        
    }
    else
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"pushNewsCenterWithID" object:[idArray objectAtIndex:vid-1]];
        
    }
}


-(void)sendRequestWithAppImgSlider:(NSString *)requestString
{
    
    
    NSLog(@">>>>>>>>%@",requestString);
    httpRequest = [[TYHttpRequest alloc] init];
    [httpRequest httpRequest:@"article/selimgs" parameter:[NSString stringWithFormat:@"date=%@",requestString] Success:^(id result) {
        NSData* jsonData = [result dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary * dic = (NSDictionary*)[jsonData objectFromJSONData];
        imageArray = [[NSMutableArray alloc] init];
        idArray = [[NSMutableArray alloc] init];
        titleArray = [[NSMutableArray alloc] init];
        
        for(int i=0;i<[[dic objectForKey:@"Imgs"] count];i++)
        {
            [imageArray addObject:[[[dic objectForKey:@"Imgs"] objectAtIndex:i] objectForKey:@"url"]];
            [idArray addObject:[[[dic objectForKey:@"Imgs"] objectAtIndex:i] objectForKey:@"Articleid"]];
            [titleArray addObject:[CS DealWithString:[[[dic objectForKey:@"Imgs"] objectAtIndex:i] objectForKey:@"Title"]]];

        }
        
        if(adView)
        {
            [adView removeFromSuperview];
        }
        
        adView = [[BMAdScrollView alloc] initWithNameArr:imageArray titleArr:titleArray height:190 offsetY:0];
        adView.vDelegate = self;
        adView.pageCenter = CGPointMake(280, 145);
        [self addSubview:adView];

    } Failure:^(NSError *error) {
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

    } view:self.superview isPost:FALSE];
    
//    [XMHttpRequest requestWithURL:appImgSlider
//                         parasDic:dic
//                    needSignature:NO
//                      byParasRank:nil
//                      needEncrypt:YES
//                          success:^(id data) {
//                              NSLog(@"%@",data);
//                              
//                              NSArray * arr = (NSArray*)data;
//                              NSMutableArray * imageArr = [[NSMutableArray alloc] init];
//                              NSMutableArray *strArr = [[NSMutableArray alloc] init];
//                              httpArr = [[NSMutableArray alloc] init];
//                              for(int i =0;i<arr.count;i++)
//                              {
//                                  [imageArr addObject:[[arr objectAtIndex:i] objectForKey:@"imgUrl"]];
//                                  [strArr addObject:[[arr objectAtIndex:i] objectForKey:@"imgTitle"]];
//                                  [httpArr addObject:[[arr objectAtIndex:i] objectForKey:@"linkUrl"]];
//                              }
//                              
//                              if(adView)
//                              {
//                                  [adView removeFromSuperview];
//                              }
//                              
//                              adView = [[BMAdScrollView alloc] initWithNameArr:imageArr titleArr:strArr height:163 offsetY:0];
//                              adView.vDelegate = self;
//                              adView.pageCenter = CGPointMake(280, 120);
//                              [self addSubview:adView];
//
//                              
//                          } failure:^(NSException *exception) {
//                              
//                              [XMMethods alertMessage:exception.reason];
//                          }];
    
    
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end