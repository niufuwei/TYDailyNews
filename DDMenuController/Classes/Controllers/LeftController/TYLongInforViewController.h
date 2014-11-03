//
//  TYLongInforViewController.h
//  TYDaily
//
//  Created by laoniu on 14-10-12.
//
//

#import <UIKit/UIKit.h>

@interface TYLongInforViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView * table;
@property (nonatomic,strong) NSString * titleStr;
@property (nonatomic,strong) NSString * requestUrl;

@end
