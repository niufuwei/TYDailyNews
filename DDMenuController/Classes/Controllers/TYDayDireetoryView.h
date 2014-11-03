//
//  TYDayDireetoryViewController.h
//  TYDaily
//
//  Created by laoniu on 14-10-3.
//
//

#import <UIKit/UIKit.h>

@interface TYDayDireetoryView : UIView<UITableViewDataSource,UITableViewDelegate>

- (void)viewLayout:(NSString*)requestDateString;
-(void)viewwill;
@end
