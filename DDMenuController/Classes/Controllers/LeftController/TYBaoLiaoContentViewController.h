//
//  TYBaoLiaoContentViewController.h
//  TYDaily
//
//  Created by laoniu on 14/11/5.
//
//

#import <UIKit/UIKit.h>

@interface TYBaoLiaoContentViewController : UIView<UITableViewDataSource,UITableViewDelegate>
{
    NSString * url;
}
@property (nonatomic,strong) UITableView * table;

-(id)initWithFrame:(CGRect)frame withUrl:(NSString*)withUrl;

@end
