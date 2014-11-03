//
//  TYNewsView.m
//  TYDaily
//
//  Created by laoniu on 14-10-5.
//
//

#import "TYNewsView.h"
#import "TYCommentView.h"
#import <MediaPlayer/MediaPlayer.h>
#import "NCMusicEngine.h"
#import "Mp3PlayerButton.h"

@interface TYNewsView ()<NCMusicEngineDelegate>
{
    NCMusicEngine *_player;
    UIScrollView * backScrollview;
    TYCommentView * ButtomView;
    NSString * newsID;
    UILabel * TTcontent;
    UILabel * time;
    UILabel * addr;
    TYHttpRequest * myHttp;
    NSString * strURL;
    NSURL * videoURL;
    UIImageView * imageVdieo;
}
@end

@implementation TYNewsView


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
   
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onNotifaction:) name:@"updateComment" object:nil];
    
    newsID = [dic objectForKey:@"id"];
    
    backScrollview = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    backScrollview.contentSize = CGSizeMake(self.frame.size.width, self.frame.size.height+1);
    backScrollview.delegate = self;
    [self addSubview:backScrollview];
    
    UIImageView * leftImage =[[UIImageView alloc] initWithFrame:CGRectMake(10, 20, 5, 5)];
    [leftImage setImage:[UIImage imageNamed:@"leftImage.png"]];
    [backScrollview addSubview:leftImage];
    
    UILabel * typeValue = [[UILabel alloc] initWithFrame:CGRectMake(20, 15, 30, 15)];
    typeValue.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"PageNo"]];
    typeValue.textColor =RedColor;
    typeValue.backgroundColor = [UIColor clearColor];
    typeValue.font = [UIFont systemFontOfSize:11];
    [backScrollview addSubview:typeValue];
    
    UILabel * type2 = [[UILabel alloc] initWithFrame:CGRectMake(33, 17, 15, 15)];
    type2.text = @"版";
    type2.textColor =RedColor;
    type2.backgroundColor = [UIColor clearColor];
    type2.font = [UIFont systemFontOfSize:8];
    [backScrollview addSubview:type2];
    
    UILabel * PageName = [[UILabel alloc] initWithFrame:CGRectMake(45, 15, 30, 15)];
    PageName.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"PageName"]];
    PageName.textColor =RedColor;
    PageName.backgroundColor = [UIColor clearColor];
    PageName.font = [UIFont systemFontOfSize:11];
    [backScrollview addSubview:PageName];
    
    UIImageView * rightimage =[[UIImageView alloc] initWithFrame:CGRectMake(PageName.frame.size.width+PageName.frame.origin.x, 20, self.frame.size.width-PageName.frame.size.width+PageName.frame.origin.x-5-10, 5)];
    [rightimage setImage:[UIImage imageNamed:@"rightImage.png"]];
    [backScrollview addSubview:rightimage];
    
    NSInteger yyyy =rightimage.frame.size.height+rightimage.frame.origin.y+20;
    if(_isNews)
    {
        leftImage.hidden = YES;
        typeValue.hidden = YES;
        PageName.hidden = YES;
        type2.hidden = YES;
        rightimage.hidden = YES;
        yyyy = 20;
        
    }
    else
    {
        
    }
    
    
    UILabel * PageTitle = [[UILabel alloc] initWithFrame:CGRectMake(10, yyyy, self.frame.size.width-20, 20)];
    PageTitle.text = [CS DealWithString: [dic objectForKey:@"Title"]];
    PageTitle.textAlignment = NSTextAlignmentLeft;
    PageTitle.textColor =[UIColor blackColor];
    PageTitle.backgroundColor = [UIColor clearColor];
    PageTitle.font = [UIFont systemFontOfSize:14];
    [backScrollview addSubview:PageTitle];
    
    
    NSInteger height;
    NSInteger yy;
    if([[CS DealWithString: [dic objectForKey:@"SubTitle"]] length] == 0)
    {
        yy = 0;
        height = 0;
    }
    else
    {
        yy=0;
        height = 20;
    }
    UILabel * SubTitle = [[UILabel alloc] initWithFrame:CGRectMake(10, PageTitle.frame.size.height+PageTitle.frame.origin.y+yy, self.frame.size.width-20, height)];
    SubTitle.text = [CS DealWithString: [dic objectForKey:@"SubTitle"]];
    SubTitle.textAlignment = NSTextAlignmentLeft;
    SubTitle.textColor =[UIColor grayColor];
    SubTitle.backgroundColor = [UIColor clearColor];
    SubTitle.font = [UIFont systemFontOfSize:13];
    SubTitle.numberOfLines = 0;//表示label可以多行显
    SubTitle.lineBreakMode = NSLineBreakByCharWrapping;
    [backScrollview addSubview:SubTitle];
    
    
    UILabel * create_time = [[UILabel alloc] initWithFrame:CGRectMake(10, SubTitle.frame.size.height+SubTitle.frame.origin.y+5, self.frame.size.width-120, 20)];
    create_time.text = [CS DealWithString: [dic objectForKey:@"create_time"]];
    create_time.textAlignment = NSTextAlignmentLeft;
    create_time.textColor =[UIColor grayColor];
    create_time.backgroundColor = [UIColor clearColor];
    create_time.lineBreakMode = NSLineBreakByCharWrapping;
    create_time.font = [UIFont systemFontOfSize:12];
    [backScrollview addSubview:create_time];
    
    UILabel * type = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width-150, SubTitle.frame.size.height+SubTitle.frame.origin.y+5, 130, 20)];
    type.text = [NSString stringWithFormat:@"%@",[dic objectForKey:@"Src"]];
    type.textAlignment = NSTextAlignmentRight;
    type.textColor =[UIColor grayColor];
    type.backgroundColor = [UIColor clearColor];
    type.font = [UIFont systemFontOfSize:12];
    if(_isNews)
    {
        type.hidden = YES;
    }
    [backScrollview addSubview:type];
    
    UIImageView * imageHeng = [[UIImageView alloc] initWithFrame:CGRectMake(10, create_time.frame.size.height+create_time.frame.origin.y+5, self.frame.size.width-20, 1)];
    [imageHeng setImage:[UIImage imageNamed:@"LINE"]];
    [backScrollview addSubview:imageHeng];
    
    //加载图片
 
    NSLog(@"%@",dic);
    
    NSInteger myYY = imageHeng.frame.size.height+imageHeng.frame.origin.y+10;
    
    if([[[NSUserDefaults standardUserDefaults] objectForKey:@"showImage"] isEqualToString:@"ok"])
    {
        for(int i = 0; i < [[dic objectForKey:@"Images"] count];i++)
        {
            UIImageView * image =[[ UIImageView alloc] initWithFrame:CGRectMake(20, myYY, self.frame.size.width-40, 200)];
            [image setImageWithURL:[NSURL URLWithString:[[[dic objectForKey:@"Images"] objectAtIndex:i] objectForKey:@"url"]] placeholderImage:[UIImage imageNamed:@""]];
            [backScrollview addSubview:image];
            
            myYY = image.frame.size.height+image.frame.origin.y+10;
        }

    }
    
    if(_isNews)
    {
        if([dic objectForKey:@"Video"] && ![[dic objectForKey:@"Video"] isKindOfClass:[NSString class]])
        {
            imageVdieo =[[ UIImageView alloc] initWithFrame:CGRectMake(20, myYY, self.frame.size.width-40, 200)];
            [imageVdieo setImageWithURL:[NSURL URLWithString:[[dic objectForKey:@"Video"] objectForKey:@"img"]] placeholderImage:[UIImage imageNamed:@""]];
            videoURL = [NSURL URLWithString:[[dic objectForKey:@"Video"] objectForKey:@"url"]];
            [backScrollview addSubview:imageVdieo];
            
            UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onVideoTap:)];
            tap.numberOfTapsRequired  =1;
            imageVdieo.userInteractionEnabled = YES;
            [imageVdieo addGestureRecognizer:tap];
            
            myYY = imageVdieo.frame.size.height+imageVdieo.frame.origin.y+10;
        }
        else
        {
            
        }
        
        if([dic objectForKey:@"Audio"] && ![[dic objectForKey:@"Audio"] isKindOfClass:[NSString class]])
        {
            Mp3PlayerButton *playButton = [[Mp3PlayerButton alloc] initWithFrame:CGRectMake(self.frame.size.width/2-30, myYY+50, 60, 60)];
            playButton.mp3URL = [NSURL URLWithString:[[dic objectForKey:@"Audio"] objectForKey:@"url"]];
            [playButton addTarget:self action:@selector(playAudio:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:playButton];
            
            myYY = playButton.frame.size.height+playButton.frame.origin.y+10;

        }
        else
        {
            
        }

    }
    
    UILabel * content = [[UILabel alloc] initWithFrame:CGRectMake(10,myYY+5, self.frame.size.width-20, 100)];

    content.textAlignment = NSTextAlignmentLeft;
    content.textColor =[UIColor grayColor];
    content.backgroundColor = [UIColor clearColor];
    content.font = [UIFont systemFontOfSize:textFont];
    [backScrollview addSubview:content];

    
    content.numberOfLines =0;
    CGSize labelSize = {0, 0};
    
    
    NSString * strContent = [[dic objectForKey:@"Content"] stringByReplacingOccurrencesOfString:@"<p>" withString:@""];
    strContent =[strContent stringByReplacingOccurrencesOfString:@"</p>" withString:@"\n"];
    strContent =[strContent stringByReplacingOccurrencesOfString:@"<br />" withString:@""];
    
//    NSData* jsonData = [[dic objectForKey:@"Content"] dataUsingEncoding:NSUTF8StringEncoding];
//    content.text = [jsonData objectFromJSONData];
    
//    NSLog(@"%@",content.text);
    labelSize = [strContent sizeWithFont:[UIFont systemFontOfSize:textFont]
                 
                  constrainedToSize:CGSizeMake(self.frame.size.width-20, 5000)
                 
                      lineBreakMode:NSLineBreakByWordWrapping];
    
    content.text = strContent;
    content.frame =CGRectMake(content.frame.origin.x, content.frame.origin.y, content.frame.size.width, labelSize.height+50);

    
    
    UIImageView * leftImage2 =[[UIImageView alloc] initWithFrame:CGRectMake(10, content.frame.size.height+content.frame.origin.y+50, 5, 5)];
    [leftImage2 setImage:[UIImage imageNamed:@"leftImage.png"]];
    [backScrollview addSubview:leftImage2];

    UILabel * comment = [[UILabel alloc] initWithFrame:CGRectMake(20, content.frame.size.height+content.frame.origin.y+35, 30, 30)];
    comment.text = @"评论";
    comment.textColor =RedColor;
    comment.backgroundColor = [UIColor clearColor];
    comment.font = [UIFont systemFontOfSize:14];
    [backScrollview addSubview:comment];
    
    UIImageView * rightimage2 =[[UIImageView alloc] initWithFrame:CGRectMake(comment.frame.size.width+comment.frame.origin.x, content.frame.size.height+content.frame.origin.y+50, self.frame.size.width, 5)];
    [rightimage2 setImage:[UIImage imageNamed:@"rightImage.png"]];
    [backScrollview addSubview:rightimage2];
    
    NSInteger my_yyyyy = rightimage2.frame.size.height+rightimage2.frame.origin.y+10;
 
    addr = [[UILabel alloc] initWithFrame:CGRectMake(20, my_yyyyy, 70, 20)];
    addr.textAlignment = NSTextAlignmentLeft;
    addr.textColor = [UIColor grayColor];
    addr.font = [UIFont systemFontOfSize:13];
    addr.text = [[dic objectForKey:@"Comment"] objectForKey:@"author"];
    [backScrollview addSubview:addr];
    
    time = [[UILabel alloc] initWithFrame:CGRectMake(addr.frame.size.width+addr.frame.origin.x+10, my_yyyyy, 150, 20)];
    time.textAlignment = NSTextAlignmentLeft;
    time.textColor = [UIColor grayColor];
    time.font = [UIFont systemFontOfSize:13];
    time.text =  [[dic objectForKey:@"Comment"] objectForKey:@"create_time"];
    [backScrollview addSubview:time];
    
//        UIButton * zan = [UIButton buttonWithType:UIButtonTypeCustom];
//        zan.frame = CGRectMake(self.frame.size.width-50, my_yyyyy, 20, 20);
//        zan.tag = i+1;
//        [zan addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
//        [zan setImage:[UIImage imageNamed:@"zan.png"] forState:UIControlStateNormal];
//        [backScrollview addSubview:zan];
    
    TTcontent = [[UILabel alloc] initWithFrame:CGRectMake(30, addr.frame.size.height+addr.frame.origin.y+10, self.frame.size.width-60, 45)];
    TTcontent.textAlignment = NSTextAlignmentLeft;
    TTcontent.textColor = [UIColor grayColor];
    TTcontent.font = [UIFont systemFontOfSize:14];
    TTcontent.lineBreakMode = NSLineBreakByCharWrapping;
    TTcontent.numberOfLines = 0;
    TTcontent.text = [CS DealWithString:[[dic objectForKey:@"Comment"] objectForKey:@"content"]];
    TTcontent.userInteractionEnabled = YES;
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onTap:)];
    tap.numberOfTapsRequired = 1;
    [TTcontent addGestureRecognizer:tap];

    
    [backScrollview addSubview:TTcontent];
    
    if([[CS DealWithString:[[dic objectForKey:@"Comment"] objectForKey:@"content"]] length]==0)
    {
        TTcontent.text = @"暂无评论";
        TTcontent.textAlignment = NSTextAlignmentCenter;
        TTcontent.font = [UIFont systemFontOfSize:16];
    }
    
//    UIImageView * imageH = [[UIImageView alloc] initWithFrame:CGRectMake(5, TTcontent.frame.size.height+TTcontent.frame.origin.y, self.frame.size.width-10, 1)];
//    [imageH setBackgroundColor:[UIColor grayColor]];
//    [backScrollview addSubview:imageH];
//    
//    my_yyyyy = imageH.frame.size.height+imageH.frame.origin.y+10;
    
    
    NSInteger myHeight = TTcontent.frame.size.height+TTcontent.frame.origin.y+70;
    if(TTcontent.frame.size.height+TTcontent.frame.origin.y+50 <self.frame.size.height)
    {
        myHeight = self.frame.size.height+1;
    }
    backScrollview.contentSize = CGSizeMake(self.frame.size.width, myHeight+70);

    
    ButtomView = [[TYCommentView alloc] initWithFrame:CGRectMake(0, self.frame.size.height-64-50, self.frame.size.width, 50) ID:newsID];
    ButtomView.newsID =[dic objectForKey:@"id"];
    ButtomView.isNesCenter = _isNews;
    ButtomView.address = _address;
    [ButtomView setBackgroundColor:[UIColor whiteColor]];
    [self addSubview:ButtomView];
    [ButtomView bringSubviewToFront:self];

    
    [[NSNotificationCenter defaultCenter] addObserver:self
     
                                             selector:@selector(keyboardWillShow:)
     
                                                 name:UIKeyboardWillShowNotification
     
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
     
                                             selector:@selector(keyboardWillHide:)
     
                                                 name:UIKeyboardWillHideNotification
     
                                               object:nil];
    

}

- (void)playAudio:(Mp3PlayerButton *)button
{
    if (_player == nil) {
        _player = [[NCMusicEngine alloc] init];
        //_player.button = button;
        _player.delegate = self;
    }
    
    if ([_player.button isEqual:button]) {
        if (_player.playState == NCMusicEnginePlayStatePlaying) {
            [_player pause];
        }
        else if(_player.playState==NCMusicEnginePlayStatePaused){
            [_player resume];
        }
        else{
            [_player playUrl:button.mp3URL];
        }
    } else {
        [_player stop];
        _player.button = button;
        [_player playUrl:button.mp3URL];
    }
}


-(void)onVideoTap:(UITapGestureRecognizer*)tap
{
    if(tap.numberOfTouches ==1 )
    {
        NSLog(@"%@",videoURL);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"startVideo" object:videoURL];
    }
}

-(void)onNotifaction:(NSNotification*)noti
{
    myHttp = [[TYHttpRequest alloc] init];
    
    strURL = @"";
    if(_isNews)
    {
        strURL = [_address stringByReplacingOccurrencesOfString:@"view" withString:@"cs"];
    }
    else
    {
        strURL = @"comment/list";
    }
    
    [myHttp httpRequest:strURL parameter:[NSString stringWithFormat:@"id=%@&pageSize=%@&pageNo=%@",newsID,@"1",@"0"] Success:^(id result) {
        
        NSData* jsonData = [result dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary * dic = (NSDictionary*)[jsonData objectFromJSONData];
        
        NSLog(@"%@",dic);
        
        addr.text = [[[dic objectForKey:@"comments"] objectAtIndex:0] objectForKey:@"author"];
        time.text =  [[[dic objectForKey:@"comments"] objectAtIndex:0] objectForKey:@"create_time"];
        TTcontent.text = [CS DealWithString:[[[dic objectForKey:@"comments"] objectAtIndex:0] objectForKey:@"content"]];

        
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

    } view:self isPost:NO];
}

-(void)onTap:(NSNotification*)tap
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"pushComment" object:newsID];
}

- (void) keyboardWillShow:(NSNotification *) notif
{
    NSDictionary *info = [notif userInfo];
    
    NSValue *value = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
    
    CGSize keyboardSize = [value CGRectValue].size;
    
    [UIView animateWithDuration:0.1 delay:0 options:0 animations:^{
        ButtomView.frame = CGRectMake(0, self.frame.size.height- keyboardSize.height-64-50, 320, 50);
    } completion:^(BOOL finished) {
        
    }];
}

-(void)keyboardWillHide:(NSNotification*)noti
{
    [UIView animateWithDuration:0.1 delay:0 options:0 animations:^{
        ButtomView.frame = CGRectMake(0, self.frame.size.height+-64-50
                                      , 320, 50);
    } completion:^(BOOL finished) {
        
    }];
    
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self endEditing:YES];
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
