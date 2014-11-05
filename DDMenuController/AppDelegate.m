//
//  AppDelegate.m
//  DDMenuController
//
//  Created by Devin Doty on 11/30/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"
#import "TYHomePageController.h"
#import "TYLeftController.h"
#import "TYRightController.h"
#import "NavViewController.h"
#import "DDMenuController.h"
#import "Reachability.h"
#import "WZGuideViewController.h"
#import "db.h"

@implementation AppDelegate
{
    TencentOAuth * _tencentOAuth;
    Reachability  *hostReach;
}

@synthesize window = _window;
@synthesize menuController = _menuController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.

//    [NSThread sleepForTimeInterval:1];
    
    //如果未设置夜间模式，默认白天模式
    if(![[NSUserDefaults standardUserDefaults] objectForKey:@"isDayShow"])
    {
        [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"isDayShow"];
    }
   
   
    TYHomePageController *mainController = [[TYHomePageController alloc] init];
    NavViewController *navController = [[NavViewController alloc] initWithRootViewController:mainController];
    
    TYLeftController *leftController = [[TYLeftController alloc] init];
    
    TYRightController *rightController = [[TYRightController alloc] init];
    
    _menuController = [[DDMenuController alloc] initWithRootViewController:navController];
    
    _menuController.leftViewController = leftController;
    _menuController.rightViewController = rightController;
    
    //集成新浪微博
    [WeiboSDK enableDebugMode:YES];
    [WeiboSDK registerApp:kAppkey];
  
    //微信注册
    [WXApi registerApp:kWXAppkey];
    
    _tencentOAuth  = [[TencentOAuth alloc] initWithAppId:@"1103377162" andDelegate:self];

    
//    [UMSocialWechatHandler setWXAppId:kAppkey appSecret:@"db426a9829e4b49a0dcac7b4162da6b6" url:@"http://www.umeng.com/social"];
//    [UMSocialQQHandler setQQWithAppId:@"1103377162" appKey:@"xYQBT2luupEcQhqZ" url:@"http://www.umeng.com/social"];
  
    self.window.rootViewController = _menuController;
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
//    [UMSocialData setAppKey:@"543de3e2fd98c5fc580036bd"];
    
    [WZGuideViewController show];
    
    // 监测网络情况
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reachabilityChanged:)
                                                 name: kReachabilityChangedNotification
                                               object: nil];
    hostReach = [Reachability reachabilityWithHostName:@"www.baidu.com"];
    [hostReach startNotifier];
    
    
    //定位
    [self Loaction];
    
    return YES;
}

-(void)Loaction
{
    //开始定位
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationManager.distanceFilter = 1000.0f;
    [self.locationManager startUpdatingLocation];
    self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
    [self.locationManager requestAlwaysAuthorization];        //NSLocationAlwaysUsageDescription
    [self.locationManager requestWhenInUseAuthorization];     //NSLocationWhenInUseDescription
    
    self.locationManager.desiredAccuracy =kCLLocationAccuracyBest;
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
}

-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    switch (status) {
        case kCLAuthorizationStatusNotDetermined:
        {
            if([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)])
            {
                [self.locationManager requestWhenInUseAuthorization];
            }
        }
            
            break;
            
        default:
            break;
    }
}

-(void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    //存到本地
    
    [self.locationManager stopUpdatingLocation];
    
    __block NSString * city;
    
    // 获取当前所在的城市名
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
//    double lon = newLocation.coordinate.longitude;
//    double lat = newLocation.coordinate.latitude;
    
    [geocoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray *array, NSError *error)
     {
      
        if (array.count > 0)
         {
             CLPlacemark *placemark = [array objectAtIndex:0];
             
             city = [[placemark.addressDictionary objectForKey:@"State"] stringByReplacingOccurrencesOfString:@"市" withString:@""];
             
         }
         else if (error == nil && [array count] == 0)
         {
             NSLog(@"No results were returned.");
         }
         else if (error != nil)
         {
             NSLog(@"An error occurred = %@", error);
         }
         
         //查询数据库
         sqlite3 * my_db = [db openDB];
         
         NSString *sqlQuery =[NSString stringWithFormat:@"SELECT city_num FROM citys where name like '%%%@'",city];
         
         
         
         NSLog(@"%@",sqlQuery);
         
         sqlite3_stmt * statement;
         if (sqlite3_prepare_v2(my_db, [sqlQuery UTF8String], -1, &statement, nil) == SQLITE_OK) {
             while (sqlite3_step(statement) == SQLITE_ROW) {
                 char *name_db = (char*)sqlite3_column_text(statement, 0);
                 NSString *nsNameStr = [NSString stringWithUTF8String:name_db];
                 [[NSUserDefaults standardUserDefaults] setObject:nsNameStr forKey:@"cityNumber"];
             }
         }

        
     }];

    
    
    NSLog(@"location ok");
}



-(void)reachabilityChanged:(NSNotification *)note {
    Reachability* curReach = [note object];
    NSParameterAssert([curReach isKindOfClass: [Reachability class]]);
    NetworkStatus status = [curReach currentReachabilityStatus];
    
    //设置默认无图模式
    if(![[NSUserDefaults standardUserDefaults] objectForKey:@"wutu"])
    {
        [[NSUserDefaults standardUserDefaults] setObject:@"ok" forKey:@"wutu"];
    }
    
    if (status == NotReachable) {
       
      
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:nil message:@"请检查网络" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
    else if(status == kReachableViaWiFi)
    {
        [[NSUserDefaults standardUserDefaults] setObject:@"ok" forKey:@"showImage"];
    }
    else
    {
        if([[[NSUserDefaults standardUserDefaults] objectForKey:@"wutu"] isEqualToString:@"ok"])
        {
            [[NSUserDefaults standardUserDefaults] setObject:@"ok" forKey:@"showImage"];
        }
        else
        {
            [[NSUserDefaults standardUserDefaults] setObject:@"no" forKey:@"showImage"];
            
        }

    }
}

-(void)showLeftView
{
    [_menuController showLeftController:YES];
}

-(void)showRightView
{
    [_menuController showRightController:YES];
}

-(BOOL)application:(UIApplication*)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    if(_indexShare ==0)
    {
        return [WeiboSDK handleOpenURL:url delegate:self];

    }
    else  if(_indexShare ==3 || _indexShare==4)
    {
        return [TencentOAuth HandleOpenURL:url];

    }
    else
    {
        return [WXApi handleOpenURL:url delegate:self];
    }
}

-(BOOL)application:(UIApplication*)application handleOpenURL:(NSURL *)url
{
    if(_indexShare ==0)
    {
        return [WeiboSDK handleOpenURL:url delegate:self];

    }else if(_indexShare ==3 || _indexShare==4)
    {
        return [TencentOAuth HandleOpenURL:url];

    }
    else
    {
        return [WXApi handleOpenURL:url delegate:self];
    }
}

//-(void)showLeftView
//{
//    [_menuController showLeftController:YES];
//}
//
//-(void)showRightView
//{
//    [_menuController showRightController:YES];
//}
- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

-(void)didReceiveWeiboRequest:(WBBaseRequest *)request
{
    
}

- (void)didReceiveWeiboResponse:(WBBaseResponse *)response
{
    if ([response isKindOfClass:WBSendMessageToWeiboResponse.class])
    {
//        NSString *title = @"发送结果";
//        NSString *message = [NSString stringWithFormat:@"响应状态: %d\n响应UserInfo数据: %@\n原请求UserInfo数据: %@",(int)response.statusCode, response.userInfo, response.requestUserInfo];
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
//                                                        message:@"登陆成功"
//                                                       delegate:nil
//                                              cancelButtonTitle:@"确定"
//                                              otherButtonTitles:nil];
//        [alert show];
    }
    else if ([response isKindOfClass:WBAuthorizeResponse.class])
    {
//        NSString *title = @"认证结果";
        NSString *message = [NSString stringWithFormat:@"响应状态: %d\nresponse.userId: %@\nresponse.accessToken: %@\n响应UserInfo数据: %@\n原请求UserInfo数据: %@",(int)response.statusCode,[(WBAuthorizeResponse *)response userID], [(WBAuthorizeResponse *)response accessToken], response.userInfo, response.requestUserInfo];
        
        self.wbtoken = [(WBAuthorizeResponse *)response accessToken];
        
        NSDictionary * dic =(NSDictionary*)response.userInfo;
        NSLog(@"用户名--->%@",message);
        
        [[NSUserDefaults standardUserDefaults] setObject:[(WBAuthorizeResponse *)response accessToken] forKey:@"accessToken"];
        
//       NSString * str =  [[dic objectForKey:@"app"] objectForKey:@"name"];
        
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
//                                                        message:[NSString stringWithFormat:@"您的微博用户名:%@",str]
//                                                       delegate:nil
//                                              cancelButtonTitle:@"确定"
//                                              otherButtonTitles:nil];
//
//        
//        [alert show];
//
//        NSString *strUrl=[NSString stringWithFormat:@"https://api.weibo.com/2/users/show.json"];
//        ASIFormDataRequest *request=[ASIFormDataRequest requestWithURL:[NSURL URLWithString:strUrl]];
//        request.delegate=self;
//        request.tag=10010;
//        request.timeOutSeconds=60;
//        [request startAsynchronous];
        
        NSArray * arr = [NSArray arrayWithObjects:[(WBAuthorizeResponse *)response userID], [(WBAuthorizeResponse *)response accessToken], nil];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"request" object:arr];
    }
}


@end
