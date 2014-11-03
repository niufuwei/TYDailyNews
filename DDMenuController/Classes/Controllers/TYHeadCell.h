//
//  TYHeadCell.h
//  TYDaily
//
//  Created by laoniu on 14-10-7.
//
//

#import <UIKit/UIKit.h>
#import "BMAdScrollView.h"

@interface TYHeadCell : UITableViewCell<ValueClickDelegate>

@property (nonatomic,strong) NSString * requestDateString;
//@property (nonatomic,strong) NSString * newsRequest;

-(void)sendRequestWithAppImgSlider:(NSString*)requestString;

@end
