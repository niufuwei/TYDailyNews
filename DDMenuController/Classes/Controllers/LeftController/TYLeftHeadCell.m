//
//  TYLeftHeadCell.m
//  TYDaily
//
//  Created by laoniu on 14-10-2.
//
//

#import "TYLeftHeadCell.h"

@implementation TYLeftHeadCell


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        _LogoImage = [[UIImageView alloc] initWithFrame:CGRectMake(80, 31, 50, 50)];
        [self.contentView addSubview:_LogoImage];
        
        _nameImage = [[UIImageView alloc] initWithFrame:CGRectMake(40, _LogoImage.frame.size.height+_LogoImage.frame.origin.y+10, 120, 35)];
        [self.contentView addSubview:_nameImage];
        
        UIImageView * line = [[UIImageView alloc] initWithFrame:CGRectMake(0, 144, self.frame.size.width, 1)];
        [line setBackgroundColor:[UIColor whiteColor]];
        [self.contentView addSubview:line];
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
