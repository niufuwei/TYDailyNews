//
//  TYRightMenuCollectViewController.h
//  TYDaily
//
//  Created by laoniu on 14-10-2.
//
//

#import <UIKit/UIKit.h>

@interface TYRightMenuCollectViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,NavCustomDelegate>

@property (nonatomic,strong) UITableView * myTable;

@end
