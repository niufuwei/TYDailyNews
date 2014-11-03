//
//  TYLongCell.m
//  TYDaily
//
//  Created by laoniu on 14-10-12.
//
//

#import "TYLongCell.h"

@implementation TYLongCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        _image = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 90)];
        [self.contentView addSubview:_image];
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
