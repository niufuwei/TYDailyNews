//
//  TYRightHeadCell.m
//  TYDaily
//
//  Created by laoniu on 14-10-2.
//
//

#import "TYRightHeadCell.h"

@implementation TYRightHeadCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        UIView * view = [[UIView alloc] initWithFrame:CGRectMake(137, 28, 86,86)];
        [view setBackgroundColor:[UIColor colorWithRed:39 green:42 blue:48 alpha:1]];
        [view.layer setCornerRadius:43];
        view.layer.masksToBounds = YES;
        [self.contentView addSubview:view];
        
        _Avatar = [[UIImageView alloc] initWithFrame:CGRectMake(140, 31, 80, 80)];
        _Avatar.layer.masksToBounds = YES; //没这句话它圆不起来
        _Avatar.layer.cornerRadius = 40.0; //设置图片圆角的尺度
        [self.contentView addSubview:_Avatar];
        
        _weather = [[UILabel alloc] initWithFrame:CGRectMake(95, _Avatar.frame.size.height+_Avatar.frame.origin.y+50, 45, 45)];
        _weather.font = [UIFont systemFontOfSize:40];
        _weather.textColor = [UIColor whiteColor];
        _weather.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_weather];
        
        _weatherImage = [[UIImageView alloc] initWithFrame:CGRectMake(_weather.frame.size.width+_weather.frame.origin.x, _Avatar.frame.size.height+_Avatar.frame.origin.y+20, 25, 25)];
        [self.contentView addSubview:_weatherImage];
        
        _userName = [[UILabel alloc] initWithFrame:CGRectMake(_weatherImage.frame.size.width+_weatherImage.frame.origin.x+5, _Avatar.frame.size.height+_Avatar.frame.origin.y+20, 80, 40)];
        _userName.font = [UIFont systemFontOfSize:16];
        _userName.textColor = [UIColor whiteColor];
        _userName.backgroundColor = [UIColor clearColor];
        _userName.textAlignment = NSTextAlignmentRight;
        [_userName setNumberOfLines:0];
        _userName.lineBreakMode = NSLineBreakByWordWrapping;
        [self.contentView addSubview:_userName];
        
        _money = [[UILabel alloc] initWithFrame:CGRectMake(_weatherImage.frame.size.width+_weatherImage.frame.origin.x+5, _userName.frame.size.height+_userName.frame.origin.y, 80, 35)];
        _money.font = [UIFont systemFontOfSize:14];
        _money.textColor = [UIColor whiteColor];
        _money.backgroundColor = [UIColor clearColor];
        _money.textAlignment = NSTextAlignmentRight;
        [_money setNumberOfLines:0];
        _money.lineBreakMode = NSLineBreakByWordWrapping;
        [self.contentView addSubview:_money];
        
        _loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _loginButton.frame = CGRectMake(130, _Avatar.frame.size.height+_Avatar.frame.origin.y+30, 100, 35);
        [self.contentView addSubview:_loginButton];
        
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