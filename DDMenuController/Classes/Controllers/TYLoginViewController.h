//
//  TYLoginViewController.h
//  TYDaily
//
//  Created by laoniu on 14-10-3.
//
//

#import <UIKit/UIKit.h>
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"

@interface TYLoginViewController : UIViewController<NavCustomDelegate,ASIHTTPRequestDelegate, UIImagePickerControllerDelegate,UIScrollViewDelegate>

@property (nonatomic,strong) UITextField * userName;
@property (nonatomic,strong) UITextField * passWord;
@property (nonatomic,strong) UIButton * forgetPassword;
@property (nonatomic,strong) UIButton * login;
@property (nonatomic,strong) UIButton * usePhoneRegist;
@property (nonatomic,strong) UIButton * useEmailRegist;

@property (nonatomic,strong) UIButton * qq;
@property (nonatomic,strong) UIButton * weibo;
@end
