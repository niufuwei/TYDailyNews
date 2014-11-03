//
//  TYBaoLiaoCell.m
//  TYDaily
//
//  Created by laoniu on 14-10-14.
//
//

#import "TYBaoLiaoCell.h"

@implementation TYBaoLiaoCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, self.frame.size.width-30, 50)];
        _titleLabel.backgroundColor =[UIColor clearColor];
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.font = [UIFont systemFontOfSize:14];
        _titleLabel.numberOfLines = 0;
        _titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        [self.contentView addSubview:_titleLabel];
        
        _nameWithTimer = [[UILabel alloc] initWithFrame:CGRectMake(0, _titleLabel.frame.size.height+_titleLabel.frame.origin.y, self.frame.size.width-20,20)];
        _nameWithTimer.backgroundColor =[UIColor clearColor];
        _nameWithTimer.textColor = [UIColor grayColor];
        _nameWithTimer.textAlignment = NSTextAlignmentRight;
        _nameWithTimer.font = [UIFont systemFontOfSize:12];
        _nameWithTimer.numberOfLines = 0;
        _nameWithTimer.lineBreakMode = NSLineBreakByWordWrapping;
        [self.contentView addSubview:_nameWithTimer];
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
