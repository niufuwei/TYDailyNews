//
//  TYNewsView.h
//  TYDaily
//
//  Created by laoniu on 14-10-17.
//
//

#import <UIKit/UIKit.h>

@interface TYNews : UIView<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) UITableView * table;
@property (nonatomic,strong) NSString * newsRequest;

- (void)viewLayout:(NSString*)requestDateString;


@end
