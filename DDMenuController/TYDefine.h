//
//  TYDefine.h
//  TYDaily
//
//  Created by laoniu on 14-10-2.
//
//

#ifndef TYDaily_TYDefine_h
#define TYDaily_TYDefine_h

#import "Date.h"
#import "JSONKit.h"
#import "CS.h"
#import "BMDefineUtils.h"
#import "UIImageView+WebCache.h"
#import "CBMBProgressHUD.h"

#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
#define IOS_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]

#define appDelegate ((AppDelegate *)[[UIApplication sharedApplication] delegate])
#define TYDaily_color(rgbValue)   [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define kRedirectURI    @"http://www.sina.com"
#define kAppkey @"540853013"
#define kWXAppkey @"wx2f150bddeaa7369c"
#define SERVICEADDR @"http://123.57.17.124/epaper/index.php?r="
#define RedColor [UIColor colorWithRed:165.0/255.0 green:0/255.0 blue:0/255.0 alpha:1]
#endif
