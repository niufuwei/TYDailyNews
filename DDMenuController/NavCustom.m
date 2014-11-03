//
//  NavCustom.m
//  ELiuYan
//
//  Created by laoniu on 14-4-29.
//  Copyright (c) 2014年 chaoyong.com. All rights reserved.
//

#import "NavCustom.h"

@implementation NavCustom
@synthesize NavDelegate;

-(void)setNavWithText:(NSString *)NavTitile mySelf:(UIViewController *)mySelf
{
    UILabel * lab;
    if(IOS_VERSION <7)
    {
        lab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 21)];
    }
    else
    {
        lab = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 21, 21)];
    }
    
    [lab setFont:[UIFont systemFontOfSize:20]];
    lab.textColor = [UIColor colorWithRed:184.0/255.0 green:72.0/255.0 blue:76.0/255.0 alpha:1];
    lab.text = NavTitile;
    lab.textAlignment = NSTextAlignmentCenter;
    lab.backgroundColor = [UIColor clearColor];
    mySelf.navigationItem.titleView = lab;
    
}

-(void)setNavWithImage:(NSString *)imgName mySelf:(UIViewController *)mySelf width:(int)width height:(int)height
{
    UIImageView * image = [[UIImageView alloc] initWithFrame:CGRectMake(150, 0, width, height)];
    [image setImage:[UIImage imageNamed:imgName]];
    mySelf.navigationItem.titleView = image;
}

-(void)setNavRightBtnTitle:(NSString *)RightBtnTitle mySelf:(UIViewController *)mySelf width:(int)width height:(int)height
{
    //创建右边按钮
    UIButton *rightBackBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    
    [rightBackBtn setTitle:RightBtnTitle forState:UIControlStateNormal];
    [rightBackBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [rightBackBtn addTarget:self action:@selector(NavRightButtononClick) forControlEvents:UIControlEventTouchUpInside];
    
    //添加进BARBUTTONITEM
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithCustomView:rightBackBtn];
    
    //右按钮
    mySelf.navigationItem.rightBarButtonItem = rightBtn;
}

-(void)setNavRightBtnImage:(NSString *)RightBtnImage RightBtnSelectedImage:(NSString *)RightBtnSelectedImage mySelf:(UIViewController *)mySelf width:(int)width height:(int)height
{
    //创建右边按钮
    UIButton *rightBackBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    
    [rightBackBtn setBackgroundImage:[UIImage imageNamed:RightBtnImage] forState:UIControlStateNormal];
    [rightBackBtn setBackgroundImage:[UIImage imageNamed:RightBtnSelectedImage] forState:UIControlStateHighlighted];
    [rightBackBtn addTarget:self action:@selector(NavRightButtononClick) forControlEvents:UIControlEventTouchUpInside];
    
    //添加进BARBUTTONITEM
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithCustomView:rightBackBtn];
    
    //右按钮
    mySelf.navigationItem.rightBarButtonItem = rightBtn;
    
}

- (void) NavRightButtononClick{
    
    if ([NavDelegate respondsToSelector:@selector(NavRightButtononClick)])
    {//判断方法是否实现
        [NavDelegate NavRightButtononClick];
    }
}


-(void)setNavLeftBtnTitle:(NSString *)LeftBtnTitle mySelf:(UIViewController *)mySelf width:(int)width height:(int)height
{
    //创建右边按钮
    UIButton *LeftBackBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    
    [LeftBackBtn setTitle:LeftBtnTitle forState:UIControlStateNormal];
    [LeftBackBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [LeftBackBtn addTarget:self action:@selector(NavLeftButtononClick) forControlEvents:UIControlEventTouchUpInside];
    
    //添加进BARBUTTONITEM
    UIBarButtonItem *LeftBtn = [[UIBarButtonItem alloc] initWithCustomView:LeftBackBtn];
    
    //右按钮
    mySelf.navigationItem.leftBarButtonItem = LeftBtn;
}

-(void)setNavLeftBtnImage:(NSString *)LeftBtnImage LeftBtnSelectedImage:(NSString *)LeftBtnSelectedImage mySelf:(UIViewController *)mySelf width:(int)width height:(int)height
{
    //创建右边按钮
    UIButton *LeftBackBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    
    [LeftBackBtn setBackgroundImage:[UIImage imageNamed:LeftBtnImage] forState:UIControlStateNormal];
    [LeftBackBtn setBackgroundImage:[UIImage imageNamed:LeftBtnSelectedImage] forState:UIControlStateHighlighted];
    [LeftBackBtn addTarget:self action:@selector(NavLeftButtononClick) forControlEvents:UIControlEventTouchUpInside];
    
    //添加进BARBUTTONITEM
    UIBarButtonItem *LeftBtn = [[UIBarButtonItem alloc] initWithCustomView:LeftBackBtn];
    
    //右按钮
    mySelf.navigationItem.leftBarButtonItem = LeftBtn;
    
}

-(void)NavLeftButtononClick{
    
    if ([NavDelegate respondsToSelector:@selector(NavLeftButtononClick)])
    {//判断方法是否实现
        [NavDelegate NavLeftButtononClick];
    }
}

@end
