//
//  TYLeftMenuCell.m
//  TYDaily
//
//  Created by laoniu on 14-10-2.
//
//

#import "TYLeftMenuCell.h"

@implementation TYLeftMenuCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        _icon = [[UIImageView alloc] initWithFrame:CGRectMake(61, 20, 20, 20)];
        [self.contentView addSubview:_icon];
        
        _title = [[UILabel alloc] initWithFrame:CGRectMake(_icon.frame.size.width+_icon.frame.origin.x+10, 20, 100, 20)];
        _title.backgroundColor = [UIColor clearColor];
        _title.textColor = [UIColor colorWithRed:138.0/255.0 green:146.0/255.0 blue:152.0/255.0 alpha:1];
        _title.font = [UIFont systemFontOfSize:18];
        [self.contentView addSubview:_title];

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
