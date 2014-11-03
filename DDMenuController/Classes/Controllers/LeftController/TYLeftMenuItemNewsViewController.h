//
//  TYLeftMenuItemNewsViewController.h
//  TYDaily
//
//  Created by laoniu on 14-10-2.
//
//

#import <UIKit/UIKit.h>
@interface TYLeftMenuItemNewsViewController : UIViewController<NavCustomDelegate,UIScrollViewDelegate>

@property (nonatomic,strong) NSMutableArray * menuArray;
@property (nonatomic,strong) NSMutableArray * urlArray;
@end
