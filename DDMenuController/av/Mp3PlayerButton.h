//
//  Mp3PlayerButton.h
//  NCMusicEngine Example
//
//  Created by Aster0id on 13-5-5.
//  Copyright (c) 2013年 NC. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface Mp3PlayerButton : UIButton
{
    NSURL *_mp3URL;
    CGFloat _progress;
    CGRect _outerCircleRect;
	CGRect _innerCircleRect;
    
    CGFloat _r;
	CGFloat _g;
	CGFloat _b;
	CGFloat _a;
}

@property(nonatomic,strong) NSURL *mp3URL;
@property(nonatomic,strong) UIImage *playImage;
@property(nonatomic,strong) UIImage *pauseImage;
-(void) setProgress:(CGFloat) newProgress;

@end
