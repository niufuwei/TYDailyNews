//
//  TYVideoViewController.h
//  TYDaily
//
//  Created by laoniu on 14/10/21.
//
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>      //导入视频播放库

@interface TYVideoViewController : UIViewController
{
    MPMoviePlayerController *mp;
    NSURL *movieURL;                        //视频地址
    UIActivityIndicatorView *loadingAni;    //加载动画
    UILabel *label;                            //加载提醒
}

@property (nonatomic,retain) NSURL *movieURL;
//准备播放
- (void)readyPlayer;

@end
