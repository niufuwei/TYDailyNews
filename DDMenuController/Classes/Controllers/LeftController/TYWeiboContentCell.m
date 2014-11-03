//
//  TYWeiboContentCell.m
//  TYDaily
//
//  Created by laoniu on 14-10-17.
//
//

#import "TYWeiboContentCell.h"

@implementation TYWeiboContentCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, self.frame.size.width-40, 100)];
        _titleLabel.font = [UIFont systemFontOfSize:13];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.textColor = [UIColor blackColor];
        _titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _titleLabel.numberOfLines = 0;
        [self.contentView addSubview:_titleLabel];
        
        _imageContent = [[UIImageView alloc] initWithFrame:CGRectMake(32, _titleLabel.frame.size.height+_titleLabel.frame.origin.y+10, 20, 50)];
        [self.contentView addSubview:_imageContent];
        
        UIImageView * timeIcon = [[UIImageView alloc] initWithFrame:CGRectMake(15, _imageContent.frame.size.height+_imageContent.frame.origin.y+10, 10, 10)];
        [timeIcon setImage:[UIImage imageNamed:@"TIME"]];
        [self.contentView addSubview:timeIcon];
        
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(timeIcon.frame.size.width+timeIcon.frame.origin.x+3, _imageContent.frame.size.height+_imageContent.frame.origin.y+5 , 150, 20)];
        _timeLabel.font = [UIFont systemFontOfSize:12];
        _timeLabel.backgroundColor = [UIColor clearColor];
        _timeLabel.textColor = [UIColor redColor];
        [self.contentView addSubview:_timeLabel];
        
        UIImageView * pinglunIcon = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width-130, _imageContent.frame.size.height+_imageContent.frame.origin.y+10, 12, 10)];
        [pinglunIcon setImage:[UIImage imageNamed:@"pinglun"]];
        [self.contentView addSubview:pinglunIcon];
    
        _pinglun = [[UILabel alloc] initWithFrame:CGRectMake(pinglunIcon.frame.size.width+pinglunIcon.frame.origin.x+3, _imageContent.frame.size.height+_imageContent.frame.origin.y+5 , 50, 20)];
        _pinglun.font = [UIFont systemFontOfSize:12];
        _pinglun.backgroundColor = [UIColor clearColor];
        _pinglun.textColor = [UIColor redColor];
        [self.contentView addSubview:_pinglun];
        
        UIImageView * zhuanfaIcon = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width-70, _imageContent.frame.size.height+_imageContent.frame.origin.y+10, 12, 10)];
        [zhuanfaIcon setImage:[UIImage imageNamed:@"zhuanfa"]];
        [self.contentView addSubview:zhuanfaIcon];
        
        _zhuanfa = [[UILabel alloc] initWithFrame:CGRectMake(zhuanfaIcon.frame.size.width+zhuanfaIcon.frame.origin.x+3, _imageContent.frame.size.height+_imageContent.frame.origin.y+5 , 50, 20)];
        _zhuanfa.font = [UIFont systemFontOfSize:12];
        _zhuanfa.backgroundColor = [UIColor clearColor];
        _zhuanfa.textColor = [UIColor redColor];
        [self.contentView addSubview:_zhuanfa];
    }
    return self;
}
@end
