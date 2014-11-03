//
//  NavViewController.m
//  KbWireless
//
//  Created by niufuwei on 14-3-9.
//  Copyright (c) 2014年 niufuwei. All rights reserved.
//

#import "NavViewController.h"
#import "TYDefine.h"


@interface NavViewController ()

@end

@implementation NavViewController
#define SYSTEM_VERSION [[UIDevice currentDevice].systemVersion doubleValue]


static NSString *no_select_backImageName = @"back.png";
static NSString *selected_backImageName = @"back.png";



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}
-(id)initWithRootViewController:(UIViewController *)rootViewController{

    if([super initWithRootViewController:rootViewController]){
        
    }
    return self;
}

-(void)popself{

    if([self.viewControllers count]>1){
        [self popViewControllerAnimated:YES];
    }else{
        [self.topViewController dismissViewControllerAnimated:YES completion:nil];
    }
}


-(void) setLeftItem: (UIViewController *)VC{
    
    UIButton* backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *image = [UIImage imageNamed:no_select_backImageName];
    
    backButton.backgroundColor=[UIColor clearColor];
    backButton.frame = CGRectMake(-20, 0, 12, 20);
    [backButton setBackgroundImage:image forState:UIControlStateNormal];
    [backButton setBackgroundImage: [UIImage imageNamed:selected_backImageName] forState:UIControlStateHighlighted];
    
    [backButton addTarget:self action:@selector(popself) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem* leftButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    if([UIDevice currentDevice].systemVersion.floatValue >= 7.0f){
        UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                           initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                           target:nil action:nil];
        negativeSpacer.width = -7.5;
        VC.navigationItem.leftBarButtonItems = @[negativeSpacer, leftButtonItem];
    }
    else{
        VC.navigationItem.leftBarButtonItem = leftButtonItem;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
   
    if (SYSTEM_VERSION >7.0)
    {
        self.interactivePopGestureRecognizer.enabled=NO;
    }
    
    
    static NSString *bgImageName;
    if(SYSTEM_VERSION <7.0)
    {
        
        bgImageName =  @"nav_ios6_ios5";
    }
    else
    {
        bgImageName =  @"nav_ios7";
//        [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor blackColor]}];
//        [[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleDefault];
    }
    [self.navigationBar setBackgroundImage:[UIImage imageNamed:bgImageName] forBarMetrics:UIBarMetricsDefault];
    //    }
    
    
    self.navigationBar.translucent = NO;
    
    if(self.topViewController != nil && self.topViewController.navigationItem.backBarButtonItem == nil && self.topViewController.navigationItem.leftBarButtonItem ==  nil
       ){
        [self setLeftItem:self.topViewController];
    }
}

//- (UIStatusBarStyle)preferredStatusBarStyle{
//    return UIStatusBarStyleLightContent;
//    
//}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    [super pushViewController:viewController animated:animated];
    if(self.navigationBarHidden){
        [self setNavigationBarHidden:NO animated:YES];
    }
    if (viewController.navigationItem.leftBarButtonItem == nil && self.viewControllers.count > 1)   {
        [self setLeftItem:viewController];
        if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
            self.interactivePopGestureRecognizer.delegate = nil;
        }
    }
}

@end
