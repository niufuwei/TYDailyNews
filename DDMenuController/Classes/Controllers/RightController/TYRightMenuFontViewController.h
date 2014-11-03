//
//  TYRightMenuFontViewController.h
//  TYDaily
//
//  Created by laoniu on 14/10/19.
//
//

#import <UIKit/UIKit.h>

typedef void (^block)(NSString *);
@interface TYRightMenuFontViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) block myBack;
@property (nonatomic,strong) UITableView * table;
-(void)getModifyData:(void(^)(NSString*data))data;
@end
