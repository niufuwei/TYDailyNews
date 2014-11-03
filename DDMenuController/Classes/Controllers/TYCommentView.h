//
//  TYCommentView.h
//  TYDaily
//
//  Created by laoniu on 14-10-8.
//
//

#import <UIKit/UIKit.h>

@interface TYCommentView : UIView<UITextFieldDelegate,UIAlertViewDelegate>

@property (nonatomic,strong) NSString * newsID;
@property (nonatomic,strong) UITextField * textField;
@property (nonatomic) BOOL isNesCenter;
@property (nonatomic,strong) NSString * address;

-(id)initWithFrame:(CGRect)frame ID:(NSString*)ID;
@end
