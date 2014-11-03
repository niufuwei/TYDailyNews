//
//  TYLeftMenuItemLongViewController.h
//  TYDaily
//
//  Created by laoniu on 14-10-2.
//
//

#import <UIKit/UIKit.h>
@interface TYLeftMenuItemLongViewController : UIViewController<NavCustomDelegate,UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) UITableView * table;
@end
