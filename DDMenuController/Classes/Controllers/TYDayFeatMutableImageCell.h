//
//  TYDayFeatMutableImageCell.h
//  TYDaily
//
//  Created by laoniu on 14-10-5.
//
//

#import <UIKit/UIKit.h>

@interface TYDayFeatMutableImageCell : UITableViewCell

@property (nonatomic,strong) UILabel * title;
@property (nonatomic,strong) UIButton * type;
@property (nonatomic,strong) UIImageView * image1;
@property (nonatomic,strong) UIImageView * image2;
@property (nonatomic,strong) UIImageView * image3;

-(void)setImageArray:(NSArray*)imageArray;

@end
