//
//  TYMoreViewController.h
//  temp
//
//  Created by laoniu on 14-10-10.
//  Copyright (c) 2014年 xiaoma. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^block) (NSMutableArray*itemArray,NSMutableArray *urlArray);

@interface TYMoreViewController : UIViewController
@property (nonatomic,strong) block moreBlock;

-(void)getMoreData:(void(^)(NSMutableArray*itemArray,NSMutableArray *urlArray))more itemArray:(NSMutableArray*)itemArray urlArray:(NSMutableArray*)urlArray;

@end
