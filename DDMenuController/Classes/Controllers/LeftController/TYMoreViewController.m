//
//  TYMoreViewController.m
//  temp
//
//  Created by laoniu on 14-10-10.
//  Copyright (c) 2014年 xiaoma. All rights reserved.
//

#import "TYMoreViewController.h"

@interface TYMoreViewController ()
{
    UIScrollView * bgScrollview;
    NSInteger tishiYY;
    __block NSMutableArray * dataArrayHead;
    NSMutableArray * dataArrayButtom;
    NSMutableArray * HeadUrlArr;
    NSMutableArray * bottomUrlArr;
    UIView * headView;
    
    NSMutableDictionary * tagDic;
    
    NavCustom * custom;
}
@end

@implementation TYMoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    custom = [[NavCustom alloc] init];
    [custom setNavWithText:@"分类" mySelf:self];

    [self setLeftItem];
    
    dataArrayButtom = [[NSMutableArray alloc] init];
//    dataArrayHead = [[NSMutableArray alloc] init];
    tagDic = [[NSMutableDictionary alloc] init];
    
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
    bgScrollview = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    bgScrollview.tag = 2000;
    [bgScrollview setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:bgScrollview];
    
    headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 150)];
    [headView setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bgborderbg.png"]]];
    [bgScrollview addSubview:headView];
    headView.tag = 3000;
    
//    dataArrayHead = [NSMutableArray arrayWithObjects:@"陈真",@"成龙",@"国际",@"小明",@"毛毛",@"校长", nil];
    [self loadHead:dataArrayHead];
    
    
    UIButton * delbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    delbutton.backgroundColor = [UIColor clearColor];
    [delbutton setTitle:@"                      点选删除" forState:UIControlStateNormal];
    delbutton.titleLabel.font = [UIFont systemFontOfSize:12];
    [delbutton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    delbutton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    delbutton.adjustsImageWhenHighlighted = NO;
    [delbutton setBackgroundImage:[UIImage imageNamed:@"bgborderdel.png"] forState:UIControlStateNormal];
    delbutton.frame = CGRectMake(0, headView.frame.size.height+headView.frame.origin.y , self.view.frame.size.width, 20);
    
    
    delbutton.tag =1000;
    //        [button addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
    [bgScrollview addSubview:delbutton];
    
    
    UILabel * tishi = [[UILabel alloc] initWithFrame:CGRectMake(30, delbutton.frame.size.height+delbutton.frame.origin.y+20, 100, 20)];
    tishi.backgroundColor = [UIColor clearColor];
    tishi.textColor = [UIColor grayColor];
    tishi.text = @"点击添加";
    tishi.font =[ UIFont systemFontOfSize:12];
    tishi.tag = 4000;
    [bgScrollview addSubview:tishi];
    
    tishiYY = tishi.frame.size.height+tishi.frame.origin.y;
  
    bottomUrlArr = [[NSMutableArray alloc] initWithObjects:@"yw/list",@"jj/list",@"sh/list",@"sy/list",@"gj/list",@"wt/list", @"jk/list",@"tp/list",@"yd/list",@"jy/list",nil];

    dataArrayButtom = [NSMutableArray arrayWithObjects:@"要闻",@"经济",@"社会",@"声音",@"国际",@"文体",@"健康",@"图片",@"悦读",@"教育",nil];
    
    NSLog(@"%@",dataArrayHead);
    for(int i=0;i<[dataArrayHead count];i++)
    {
        NSString * strD = [dataArrayHead objectAtIndex:i];
        NSString * strU = [HeadUrlArr objectAtIndex:i];
        if([dataArrayButtom indexOfObject:[dataArrayHead objectAtIndex:i]] != NSNotFound)
        {
            [bottomUrlArr removeObject:strU];
            [dataArrayButtom removeObject:strD];
        }
    }
    
    
    [self loadButtom:dataArrayButtom];
    // Do any additional setup after loading the view.
}

-(void) setLeftItem{
    
    UIButton* backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *image = [UIImage imageNamed:@"back.png"];
    
    backButton.backgroundColor=[UIColor clearColor];
    backButton.frame = CGRectMake(-20, 0, 12, 20);
    [backButton setBackgroundImage:image forState:UIControlStateNormal];
    [backButton setBackgroundImage: [UIImage imageNamed:@"back.png"] forState:UIControlStateHighlighted];
    
    [backButton addTarget:self action:@selector(popself) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem* leftButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    if([UIDevice currentDevice].systemVersion.floatValue >= 7.0f){
        UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]
                                           initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                           target:nil action:nil];
        negativeSpacer.width = -7.5;
        self.navigationItem.leftBarButtonItems = @[negativeSpacer, leftButtonItem];
    }
    else{
        self.navigationItem.leftBarButtonItem = leftButtonItem;
    }
}

-(void)popself
{
    _moreBlock(dataArrayHead,HeadUrlArr);
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)getMoreData:(void (^)(NSMutableArray *, NSMutableArray *))more itemArray:(NSMutableArray *)itemArray urlArray:(NSMutableArray *)urlArray
{
    _moreBlock = more;
    dataArrayHead = [[NSMutableArray alloc] initWithArray:itemArray];
    HeadUrlArr = [[NSMutableArray alloc] initWithArray:urlArray];

}

-(void)loadHead:(NSArray*)arr
{
    NSInteger myXX = 30;
    NSInteger myYY = 20;
    for(int i = 0 ;i<[arr count];i++)
    {
        
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.backgroundColor = [UIColor clearColor];
        [button setTitle:[arr objectAtIndex:i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"bgborder.png"] forState:UIControlStateNormal];
        button.frame = CGRectMake(myXX, myYY, (self.view.frame.size.width-90)/4, 30);
        [button addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
        myXX = button.frame.size.width+button.frame.origin.x+10;
        
        button.tag = i+1;
        if(button.frame.origin.x > self.view.frame.size.width - 60 -(self.view.frame.size.width-90)/4-1)
        {
            myXX = 30;
            myYY = button.frame.size.height+button.frame.origin.y+10;
            
        }
        [headView addSubview:button];
    }
}

-(void)loadButtom:(NSArray*)arr2
{
    
    NSInteger myXX2 = 30;
    NSInteger myYY2 = tishiYY+10;
    for(int i = 0 ;i<[arr2 count];i++)
    {
        
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.backgroundColor = [UIColor clearColor];
        [button setTitle:[arr2 objectAtIndex:i] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"bgborder.png"] forState:UIControlStateNormal];
        button.frame = CGRectMake(myXX2, myYY2, (self.view.frame.size.width-90)/4, 30);
        [button addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
        myXX2 = button.frame.size.width+button.frame.origin.x+10;
        
        button.tag = 100+i;
        if(button.frame.origin.x > self.view.frame.size.width - 60 -(self.view.frame.size.width-90)/4-1)
        {
            myXX2 = 30;
            myYY2 = button.frame.size.height+button.frame.origin.y+10;
            
        }
        [bgScrollview addSubview:button];
    }
    
    bgScrollview.contentSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height+1);
    
}

-(void)onClick:(id)sender
{
    UIButton * btn = (UIButton*)sender;
  
    if(btn.tag <100)
    {
        for(UIView * view in headView.subviews)
        {
            if(view.tag ==1000||view.tag ==2000||view.tag ==3000||view.tag ==4000)
            {
                
            }
            else
            {
                [view removeFromSuperview];
            }
        }
        
        [dataArrayButtom addObject:btn.titleLabel.text];
        [bottomUrlArr addObject:[HeadUrlArr objectAtIndex:btn.tag-1]];
        
        [dataArrayHead removeObject:btn.titleLabel.text];
        [HeadUrlArr removeObject:[HeadUrlArr objectAtIndex:btn.tag-1]];
        
        
        NSLog(@"%@--->%@",dataArrayButtom,dataArrayHead);
        [self loadHead:dataArrayHead];
        [self loadButtom:dataArrayButtom];
        
    }
    else
    {
        for(UIView * view in bgScrollview.subviews)
        {
            if(view.tag ==1000||view.tag ==2000||view.tag ==3000||view.tag ==4000)
            {
                
            }
            else
            {
                [view removeFromSuperview];
            }
        }
        
        [dataArrayButtom removeObject:btn.titleLabel.text];
        [dataArrayHead addObject:btn.titleLabel.text];
  
        [HeadUrlArr addObject:[bottomUrlArr objectAtIndex:btn.tag -100 ]];
        [bottomUrlArr removeObject:[bottomUrlArr objectAtIndex:btn.tag-100]];
        [self loadHead:dataArrayHead];
        [self loadButtom:dataArrayButtom];
    }
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
