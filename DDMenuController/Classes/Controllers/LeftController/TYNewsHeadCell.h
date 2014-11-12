//
//  TYNewsHeadCell.h
//  TYDaily
//
//  Created by laoniu on 14/11/12.
//
//

#import <UIKit/UIKit.h>
#import "BMAdScrollView.h"

@interface TYNewsHeadCell : UITableViewCell<ValueClickDelegate>

//@property (nonatomic,strong) NSString * requestDateString;
//@property (nonatomic,strong) NSString * newsRequest;

-(void)sendRequestWithAppImgSlider:(NSString*)requestString;
@end
