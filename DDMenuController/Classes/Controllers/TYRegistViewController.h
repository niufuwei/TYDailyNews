//
//  TYRegistViewController.h
//  TYDaily
//
//  Created by laoniu on 14-10-3.
//
//

#import <UIKit/UIKit.h>

@interface TYRegistViewController : UIViewController<UIScrollViewDelegate,UITextFieldDelegate>

//type 1 手机， 2 邮箱
//@property (nonatomic,strong) NSString * strType;

@property (nonatomic,strong) UITextField * Textfield;
@property (nonatomic,strong) UITextField * code;
@property (nonatomic,strong) UITextField * usename;
@property (nonatomic,strong) UITextField * password;
@property (nonatomic,strong) UIButton * usePhone;

@property (nonatomic,strong) UIButton * getCode;
@property (nonatomic,strong) UIButton * regist;

@end
