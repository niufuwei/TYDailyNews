//
//  TYCollectCell.m
//  TYDaily
//
//  Created by laoniu on 14/10/19.
//
//

#import "TYCollectCell.h"

@implementation TYCollectCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self= [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        _ICON = [[UIImageView alloc] initWithFrame:CGRectMake(10, 20, 80, 60)];
        [self.contentView addSubview:_ICON];
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(_ICON.frame.size.width+_ICON.frame.origin.x+10, 10, self.frame.size.width-_ICON.frame.size.width+_ICON.frame.origin.x+5-10-70, 20)];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.font = [UIFont systemFontOfSize:14];
        _titleLabel.textColor = [UIColor blackColor];
        [self.contentView addSubview:_titleLabel];
        
        _contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(_ICON.frame.size.width+_ICON.frame.origin.x+10, _titleLabel.frame.size.height+_titleLabel.frame.origin.y, self.frame.size.width-_ICON.frame.size.width+_ICON.frame.origin.x+5-10-70,50)];
        _contentLabel.backgroundColor = [UIColor clearColor];
        _contentLabel.font = [UIFont systemFontOfSize:12];
        _contentLabel.textColor = [UIColor grayColor];
        _contentLabel.numberOfLines = 0;
        _contentLabel.lineBreakMode = NSLineBreakByWordWrapping;
        [self.contentView addSubview:_contentLabel];
        
        _selectButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _selectButton.frame = CGRectMake(self.frame.size.width-45, 20, 28, 28);
        [self.contentView addSubview:_selectButton];
        
        _buttomLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width-120, _contentLabel.frame.size.height+_contentLabel.frame.origin.y, 100,20)];
        _buttomLabel.backgroundColor = [UIColor clearColor];
        _buttomLabel.font = [UIFont systemFontOfSize:12];
        _buttomLabel.textColor = [UIColor grayColor];
        [self.contentView addSubview:_buttomLabel];
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
