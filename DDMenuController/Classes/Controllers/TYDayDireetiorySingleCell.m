//
//  TYDayDireetiorySingleCell.m
//  TYDaily
//
//  Created by laoniu on 14-10-8.
//
//

#import "TYDayDireetiorySingleCell.h"

@implementation TYDayDireetiorySingleCell
{
    UIColor * myBlackColor;
    UIColor * myWhiteColor;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        if(_isDayShow)
        {
            myBlackColor = [UIColor whiteColor];
            myWhiteColor = [UIColor blackColor];
        }
        else
        {
            myWhiteColor = [UIColor whiteColor];
            myBlackColor = [UIColor blackColor];
        }

        
        _myTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width-70, 70)];
        _myTitle.backgroundColor =[ UIColor clearColor];
        _myTitle.textColor = myBlackColor;
        _myTitle.font = [UIFont systemFontOfSize:14];
        _myTitle.textAlignment = NSTextAlignmentLeft;
        _myTitle.textAlignment = NSTextAlignmentCenter;
        _myTitle.numberOfLines = 0;//表示label可以多行显示
        _myTitle.lineBreakMode = NSLineBreakByCharWrapping;
        [self.contentView addSubview:_myTitle];
        
        UIImageView * message = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width-60, 70-30, 20, 15)];
        [message setImage:[UIImage imageNamed:@"message.png"]];
        [self addSubview:message];
        
        _num = [[UILabel alloc] initWithFrame:CGRectMake(message.frame.size.width+message.frame.origin.x+5, 70-30, 40, 15)];
        _num.backgroundColor =[ UIColor clearColor];
        if(_isDayShow)
        {
            _num.textColor = [UIColor whiteColor];
            
        }
        else
        {
            _num.textColor = [UIColor grayColor];
            
        }        _num.font = [UIFont systemFontOfSize:12];
        _num.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:_num];


    }
    return self;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
@end
