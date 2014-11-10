//
//  TYJDViewController.h
//  TYDaily
//
//  Created by laoniu on 14/11/8.
//
//

#import <UIKit/UIKit.h>

@interface TYJDViewController : UIViewController<UITextViewDelegate,UIImagePickerControllerDelegate,UITextViewDelegate,UIScrollViewDelegate,UIActionSheetDelegate>

@property (nonatomic,strong) UIDatePicker * datePick;
@end
