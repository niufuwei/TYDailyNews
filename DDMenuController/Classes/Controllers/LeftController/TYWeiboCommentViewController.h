//
//  TYWeiboCommentViewController.h
//  TYDaily
//
//  Created by laoniu on 14/10/19.
//
//

#import <UIKit/UIKit.h>

@interface TYWeiboCommentViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) NSString * WeiboID;

@property (nonatomic,strong) UITableView * table;
@end
