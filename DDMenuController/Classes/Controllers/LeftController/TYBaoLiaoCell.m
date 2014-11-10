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
        
        _icon = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 40, 40)];
        [self.contentView addSubview:_icon];
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(_icon.frame.size.width+_icon.frame.origin.x+10, 0, self.frame.size.width-100, 20)];
        _titleLabel.backgroundColor =[UIColor clearColor];
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.font = [UIFont systemFontOfSize:15];
        _titleLabel.numberOfLines = 0;
        _titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        [self.contentView addSubview:_titleLabel];
        
        _contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(_icon.frame.size.width+_icon.frame.origin.x+10, _titleLabel.frame.size.height+_titleLabel.frame.origin.y, self.frame.size.width-100,20)];
        _contentLabel.backgroundColor =[UIColor clearColor];
        _contentLabel.textColor = [UIColor grayColor];
        _contentLabel.textAlignment = NSTextAlignmentLeft;
        _contentLabel.font = [UIFont systemFontOfSize:12];
        _contentLabel.numberOfLines = 0;
        _contentLabel.lineBreakMode = NSLineBreakByWordWrapping;
        [self.contentView addSubview:_contentLabel];
        
        _bottomLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width-100, _contentLabel.frame.size.height+_contentLabel.frame.origin.y, 80,20)];
        _bottomLabel.backgroundColor =[UIColor clearColor];
        _bottomLabel.textColor = [UIColor grayColor];
        _bottomLabel.textAlignment = NSTextAlignmentRight;
        _bottomLabel.font = [UIFont systemFontOfSize:12];
        _bottomLabel.numberOfLines = 0;
        _bottomLabel.lineBreakMode = NSLineBreakByWordWrapping;
        [self.contentView addSubview:_bottomLabel];
        
        _type = [UIButton buttonWithType:UIButtonTypeCustom];
        _type.frame = CGRectMake(self.frame.size.width-70, 10, 40, 20);
        //        [type setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"tag.png"]]];
        [_type setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_type setBackgroundColor:RedColor];
        [_type.layer setCornerRadius:5];
        _type.titleLabel.font = [UIFont systemFontOfSize:13];
        [self.contentView addSubview:_type];

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
