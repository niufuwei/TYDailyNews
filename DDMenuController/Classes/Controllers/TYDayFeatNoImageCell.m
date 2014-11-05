//
//  TYDayFeatNoImageCell.m
//  TYDaily
//
//  Created by laoniu on 14-10-5.
//
//

#import "TYDayFeatNoImageCell.h"

@implementation TYDayFeatNoImageCell
{
    UIColor * myBlackColor;
    UIColor * myWhiteColor;
}
@synthesize type;
@synthesize content;
@synthesize mytitle;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        
        if(_isDayShow)
        {
            myBlackColor = [UIColor whiteColor];
            myWhiteColor = [UIColor blackColor];
        }
        else
        {
            myWhiteColor = [UIColor whiteColor];
            myBlackColor = [UIColor blackColor];
        }

        
        mytitle = [[UILabel alloc] initWithFrame:CGRectMake(10, 20, self.frame.size.width-80, 60)];
        mytitle.backgroundColor =[ UIColor clearColor];
        mytitle.textColor = myBlackColor;
        mytitle.font = [UIFont systemFontOfSize:14];
        mytitle.textAlignment = NSTextAlignmentLeft;
        mytitle.numberOfLines = 0;//表示label可以多行显示
        mytitle.lineBreakMode = NSLineBreakByCharWrapping;
        mytitle.textAlignment = NSTextAlignmentCenter;

        [self.contentView addSubview:mytitle];
        
//        content = [[UILabel alloc] initWithFrame:CGRectMake(10, mytitle.frame.size.height+mytitle.frame.origin.y, self.frame.size.width-80, 40)];
//        content.backgroundColor =[ UIColor clearColor];
//        if(_isDayShow)
//        {
//            content.textColor = [UIColor whiteColor];
//            
//        }
//        else
//        {
//            content.textColor = [UIColor grayColor];
//            
//        }//        content.font = [UIFont systemFontOfSize:13];
////        content.numberOfLines = 0;//表示label可以多行显示
//        content.lineBreakMode = NSLineBreakByCharWrapping;
//        [self.contentView addSubview:content];
        
        type = [UIButton buttonWithType:UIButtonTypeCustom];
        type.frame = CGRectMake(self.frame.size.width-50, 10, 40, 20);
//        [type setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"tag.png"]]];
        [type setTitleColor:myWhiteColor forState:UIControlStateNormal];
        [type setBackgroundColor:RedColor];
        [type.layer setCornerRadius:5];
        type.titleLabel.font = [UIFont systemFontOfSize:13];
        [self.contentView addSubview:type];
    }
    return self;
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
