//
//  TYSuggestViewController.h
//  TYDaily
//
//  Created by laoniu on 14/10/19.
//
//

#import <UIKit/UIKit.h>

@interface TYSuggestViewController : UIViewController<UITextViewDelegate,UITextFieldDelegate,UIScrollViewDelegate,NavCustomDelegate>

@property (nonatomic,strong) UITextField * titleField;
@property (nonatomic,strong) UITextView * textView;
@end
