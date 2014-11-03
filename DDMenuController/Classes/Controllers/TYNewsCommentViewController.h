//
//  TYNewsCommentViewController.h
//  TYDaily
//
//  Created by laoniu on 14-10-8.
//
//

#import <UIKit/UIKit.h>

@interface TYNewsCommentViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>

@property (nonatomic,strong) UITableView * table;
@property (nonatomic,strong) NSString * newsID;
@property (nonatomic,strong) NSString * requestURL;

@end
