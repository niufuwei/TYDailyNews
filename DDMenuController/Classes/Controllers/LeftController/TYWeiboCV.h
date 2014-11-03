//
//  TYWeiboCV.h
//  TYDaily
//
//  Created by laoniu on 14/10/19.
//
//

#import <UIKit/UIKit.h>

@interface TYWeiboCV : UIView<UITextFieldDelegate,UIAlertViewDelegate>

@property (nonatomic,strong) UITextField * textField;

-(id)initWithFrame:(CGRect)frame ID:(NSString*)ID;

@end
