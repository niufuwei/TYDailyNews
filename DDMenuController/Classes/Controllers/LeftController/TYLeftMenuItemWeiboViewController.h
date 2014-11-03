//
//  TYLeftMenuItemWeiboViewController.h
//  TYDaily
//
//  Created by laoniu on 14-10-2.
//
//

#import <UIKit/UIKit.h>
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"

@interface TYLeftMenuItemWeiboViewController : UIViewController<NavCustomDelegate,ASIHTTPRequestDelegate,UIWebViewDelegate,UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) UITableView * table;
@end
