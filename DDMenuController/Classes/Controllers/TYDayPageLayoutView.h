//
//  TYDayPageLayoutViewController.h
//  TYDaily
//
//  Created by laoniu on 14-10-3.
//
//

#import <UIKit/UIKit.h>

@interface TYDayPageLayoutView : UIView<UIWebViewDelegate,UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>

- (void)viewLayout:(NSString*)requestDateString;
-(void)viewwill;
@property (nonatomic,strong) UILabel * leftInformation;
@property (nonatomic,strong) UILabel * centerInformation;
@property (nonatomic,strong) UIButton * rightButton;
@property (nonatomic,strong) UITableView * myTable;

@end
