//
//  ViewController.h
//  TYDaily
//
//  Created by laoniu on 14-10-2.
//  Copyright (c) 2014年 xiaoma. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"

@interface TYHomePageController : UIViewController<NavCustomDelegate,UIScrollViewDelegate,ASIHTTPRequestDelegate>

@property (nonatomic,strong) NSString * requestDateString;
@end

