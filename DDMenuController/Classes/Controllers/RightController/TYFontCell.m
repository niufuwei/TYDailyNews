//
//  TYFontCell.m
//  TYDaily
//
//  Created by laoniu on 14/10/19.
//
//

#import "TYFontCell.h"

@implementation TYFontCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        
        _font = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, 100, 50)];
        _font.backgroundColor = [UIColor clearColor];
        _font.font = [UIFont systemFontOfSize:15];
        _font.textColor =[UIColor blackColor];
        [self.contentView addSubview:_font];
        
        _selectbBtton = [UIButton buttonWithType:UIButtonTypeCustom];
        _selectbBtton.frame = CGRectMake(self.frame.size.width-70, 10, 20, 20);
        [self.contentView addSubview:_selectbBtton];
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
