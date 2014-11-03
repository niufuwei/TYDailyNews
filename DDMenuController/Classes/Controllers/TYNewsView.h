//
//  TYNewsView.h
//  TYDaily
//
//  Created by laoniu on 14-10-5.
//
//

#import <UIKit/UIKit.h>
#import "TYNewsView.h"

@interface TYNewsView : UIView<UIScrollViewDelegate,UIWebViewDelegate>

@property (nonatomic) BOOL isNews;
@property (nonatomic,strong) NSString * address;

-(void)fillDataWithView:(NSDictionary*)dic;
@end
