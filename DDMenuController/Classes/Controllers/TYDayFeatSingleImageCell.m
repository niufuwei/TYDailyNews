//
//  TYDayFeatSingleImageCell.m
//  TYDaily
//
//  Created by laoniu on 14-10-5.
//
//

#import "TYDayFeatSingleImageCell.h"

@implementation TYDayFeatSingleImageCell

@synthesize type;
@synthesize image;
@synthesize content;
@synthesize title;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        image = [[UIImageView alloc] initWithFrame:CGRectMake(10, 15, 50, 50)];
        [self.contentView addSubview:image];
        
        title = [[UILabel alloc] initWithFrame:CGRectMake(image.frame.size.width+image.frame.origin.x+10, 10, self.frame.size.width-150, 30)];
        title.backgroundColor =[ UIColor clearColor];
        title.font = [UIFont systemFontOfSize:15];
        title.numberOfLines = 0;
        title.lineBreakMode = NSLineBreakByWordWrapping;
        title.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:title];
        
        content = [[UILabel alloc] initWithFrame:CGRectMake(image.frame.size.width+image.frame.origin.x+10, title.frame.size.height+title.frame.origin.y, self.frame.size.width-80, 40)];
        content.backgroundColor =[ UIColor clearColor];
        content.font = [UIFont systemFontOfSize:13];
        content.numberOfLines = 0;//表示label可以多行显示
        content.lineBreakMode = NSLineBreakByWordWrapping;
        [self.contentView addSubview:content];
        
        type = [UIButton buttonWithType:UIButtonTypeCustom];
        type.frame = CGRectMake(self.frame.size.width-50, 10, 40, 20);
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
