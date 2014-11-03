//
//  TYDayFeaturedViewController.h
//  TYDaily
//
//  Created by laoniu on 14-10-3.
//
//

#import <UIKit/UIKit.h>

@interface TYDayFeaturedView : UIView<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) UITableView * table;
@property (nonatomic,strong) NSString * oldDate;

- (void)viewLayout:(NSString*)requestDateString;
-(void)viewwill;
@end
