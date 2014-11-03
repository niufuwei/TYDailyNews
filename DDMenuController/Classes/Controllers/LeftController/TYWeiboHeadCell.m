//
//  TYWeiboHeadCell.m
//  TYDaily
//
//  Created by laoniu on 14-10-17.
//
//

#import "TYWeiboHeadCell.h"

@implementation TYWeiboHeadCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        _IconView = [[UIImageView alloc] initWithFrame:CGRectMake(23, 10, 130, 130)];
        [self.contentView addSubview:_IconView];
        
        _ButtomLabel = [[UILabel alloc] initWithFrame:CGRectMake(23, _IconView.frame.size.height+_IconView.frame.origin.y+30, self.frame.size.width-64, 20)];
        _ButtomLabel.textColor = [UIColor blackColor];
        _ButtomLabel.font = [UIFont systemFontOfSize:13];
        _ButtomLabel.backgroundColor =[ UIColor clearColor];
        [self.contentView addSubview:_ButtomLabel];
        
        _btnAttention = [UIButton buttonWithType:UIButtonTypeCustom];
        _btnAttention.frame = CGRectMake(_IconView.frame.size.width+_IconView.frame.origin.x+15, 23, 70, 35);
        [_btnAttention setBackgroundImage:[UIImage imageNamed:@"guanzhu.png"] forState:UIControlStateNormal];
        [_btnAttention setTitle:@"关注" forState:UIControlStateNormal];
        [_btnAttention setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.contentView addSubview:_btnAttention];
        
        _URL = [[UILabel alloc] initWithFrame:CGRectMake(_IconView.frame.size.width+_IconView.frame.origin.x+15, _btnAttention.frame.size.height+_btnAttention.frame.origin.y+10, 150, 20)];
        _URL.font = [UIFont systemFontOfSize:12];
        _URL.backgroundColor = [UIColor clearColor];
        _URL.textColor = [UIColor blackColor];
        [self.contentView addSubview:_URL];
        
        _Content = [[UILabel alloc] initWithFrame:CGRectMake(_IconView.frame.size.width+_IconView.frame.origin.x+15, _btnAttention.frame.size.height+_btnAttention.frame.origin.y+10, 150, 100)];
        _Content.font = [UIFont systemFontOfSize:12];
        _Content.backgroundColor = [UIColor clearColor];
        _Content.textColor = [UIColor blackColor];
        _Content.lineBreakMode = NSLineBreakByWordWrapping;
        _Content.numberOfLines = 0;
        [self.contentView addSubview:_Content];
        
    }
    
    return self;
}

@end
