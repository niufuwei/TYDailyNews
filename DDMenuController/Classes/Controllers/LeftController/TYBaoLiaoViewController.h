//
//  TYBaoLiaoViewController.h
//  TYDaily
//
//  Created by laoniu on 14-10-14.
//
//

#import <UIKit/UIKit.h>

@interface TYBaoLiaoViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,NavCustomDelegate>

@property (nonatomic,strong) UITableView * table;

@end
