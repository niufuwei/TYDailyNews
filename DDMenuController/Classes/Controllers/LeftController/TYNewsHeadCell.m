//
//  TYNewsHeadCell.m
//  TYDaily
//
//  Created by laoniu on 14/11/12.
//
//

#import "TYNewsHeadCell.h"
#import "TYHttpRequest.h"

@implementation TYNewsHeadCell
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
        
//        [self sendRequestWithAppImgSlider:_requestDateString];
        
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
    [httpRequest httpRequest:requestString parameter:@"" Success:^(id result) {
        NSData* jsonData = [result dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary * dic = (NSDictionary*)[jsonData objectFromJSONData];
        
        NSLog(@"%@",dic);
        
        imageArray = [[NSMutableArray alloc] init];
        idArray = [[NSMutableArray alloc] init];
        titleArray = [[NSMutableArray alloc] init];
        
        for(int i=0;i<[[dic objectForKey:@"imgs"] count];i++)
        {
            [imageArray addObject:[[[dic objectForKey:@"imgs"] objectAtIndex:i] objectForKey:@"url"]];
            [idArray addObject:[[[dic objectForKey:@"imgs"] objectAtIndex:i] objectForKey:@"article_id"]];
            [titleArray addObject:[CS DealWithString:[[[dic objectForKey:@"imgs"] objectAtIndex:i] objectForKey:@"title"]]];
            
        }
        
        if([[dic objectForKey:@"imgs"] count] !=0)
        {
            if(adView)
            {
                [adView removeFromSuperview];
            }
            
            adView = [[BMAdScrollView alloc] initWithNameArr:imageArray titleArr:titleArray height:190 offsetY:0];
            adView.vDelegate = self;
            adView.pageCenter = CGPointMake(280, 145);
        }
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

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
