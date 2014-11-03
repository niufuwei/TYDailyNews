//
//  TYWeiboCommentCell.m
//  TYDaily
//
//  Created by laoniu on 14/10/19.
//
//

#import "TYWeiboCommentCell.h"

@implementation TYWeiboCommentCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self=  [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        _content = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, self.frame.size.width-20, 50)];
        _content.backgroundColor = [UIColor clearColor];
        _content.textColor = [UIColor blackColor];
        _content.textAlignment = NSTextAlignmentLeft;
        _content.font = [UIFont systemFontOfSize:15];
        _content.lineBreakMode = NSLineBreakByWordWrapping;
        _content.numberOfLines = 0;
        [self.contentView addSubview:_content];
        
        _buttomLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, _content.frame.size.height+_content.frame.origin.y, self.frame.size.width-20, 20)];
        _buttomLabel.backgroundColor = [UIColor clearColor];
        _buttomLabel.textColor = [UIColor grayColor];
        _buttomLabel.textAlignment = NSTextAlignmentRight;
        _buttomLabel.font = [UIFont systemFontOfSize:13];
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
