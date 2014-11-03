//
//  TYRightCenterTableViewCell.m
//  TYDaily
//
//  Created by laoniu on 14-10-2.
//
//

#import "TYRightCenterTableViewCell.h"

@implementation TYRightCenterTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        UIImageView * image = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height-5)];
        [image setImage:[UIImage imageNamed:@"bg.png"]];
        [self.contentView addSubview:image];
        
        _date = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width-60, self.frame.size.height)];
        _date.font = [UIFont systemFontOfSize:12];
        _date.textColor = [UIColor whiteColor];
        _date.backgroundColor = [UIColor clearColor];
        _date.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:_date];
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
