//
//  TYNewsViewController.h
//  TYDaily
//
//  Created by laoniu on 14-10-5.
//
//

#import <UIKit/UIKit.h>
#import "TYNewsView.h"


@class XMShareItem;

@protocol XMShareItemDelegate <NSObject>

-(void)shareItemDidShare:(XMShareItem *)shareImte;

@end

@interface XMShareItem : UIView
@property (nonatomic, strong) UIButton *shareButton;
@property (nonatomic, strong) UILabel *shareTitle;
@property (nonatomic, assign) id<XMShareItemDelegate>shareDelegate;
@property (nonatomic, readonly) NSString *name;

-(id)initWithFrame:(CGRect)frame image:(UIImage *)image title:(NSString *)title delegate:(id)delegate;
-(void)shareButtonClicked:(id)sender;
@end






@interface TYNewsViewController : UIViewController


@property (nonatomic,strong) NSString * tyleValue;
@property (nonatomic,strong) NSString * tyleName;
@property (nonatomic,strong) NSString * newsID;
@property (nonatomic,strong) NSURL * newsUrl;
@property (nonatomic,strong) NSString * address;
@property (nonatomic) BOOL isNewsCenter;

@end
