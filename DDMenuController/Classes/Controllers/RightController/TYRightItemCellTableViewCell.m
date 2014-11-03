//
//  TYRightItemCellTableViewCell.m
//  TYDaily
//
//  Created by laoniu on 14-10-2.
//
//

#import "TYRightItemCellTableViewCell.h"

@implementation TYRightItemCellTableViewCell


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        _icon = [[UIImageView alloc] initWithFrame:CGRectMake(100, 25, 20, 20)];
        [self.contentView addSubview:_icon];
        
        _title = [[UILabel alloc] initWithFrame:CGRectMake(_icon.frame.size.width+_icon.frame.origin.x+20, 25, 80, 20)];
        _title.backgroundColor = [UIColor clearColor];
        _title.textColor = TYDaily_color(0xffffff);
        _title.font = [UIFont systemFontOfSize:16];
        [self.contentView addSubview:_title];
        
        _number =[[UIButton alloc] initWithFrame:CGRectMake(_title.frame.size.width+_title.frame.origin.x-15, 20, 20, 20)];
        _number.backgroundColor = [UIColor redColor];
        [_number setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _number.titleLabel.font = [UIFont systemFontOfSize:10];
        _number.layer.cornerRadius = 10.0; //设置图片圆角的尺度
        [self.contentView addSubview:_number];
        
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
