//
//  TYBaoLiaoViewController.h
//  TYDaily
//
//  Created by laoniu on 14-10-14.
//
//

#import <UIKit/UIKit.h>

@interface TYBaoLiaoViewController : UIViewController<UIScrollViewDelegate,NavCustomDelegate>

@property (nonatomic,strong) UIScrollView * bgScrollview;
@property (nonatomic,strong) UIButton * leftButton;
@property (nonatomic,strong) UIButton * rightButton;
@end
