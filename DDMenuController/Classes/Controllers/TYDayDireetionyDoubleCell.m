//
//  TYDayDireetionyDoubleCell.m
//  TYDaily
//
//  Created by laoniu on 14-10-8.
//
//

#import "TYDayDireetionyDoubleCell.h"

@implementation TYDayDireetionyDoubleCell

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
        
        
        UIButton * leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [leftButton setBackgroundColor:[UIColor clearColor]];
        leftButton.frame = CGRectMake(0, 0, self.frame.size.width/2, 90);
        [self.contentView addSubview:leftButton];
        
        UIButton * rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [rightButton setBackgroundColor:[UIColor clearColor]];
        rightButton.frame = CGRectMake(self.frame.size.width/2, 0, self.frame.size.width/2, 90);
        [self.contentView addSubview:rightButton];
        
        UIImageView * uiimageShu = [[UIImageView alloc] initWithFrame:CGRectMake(leftButton.frame.size.width-1, 10, 1, 70)];
        [uiimageShu setBackgroundColor:[UIColor grayColor]];
        [leftButton addSubview:uiimageShu];
        
        _myTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width/2-5, 60)];
        _myTitle.backgroundColor =[ UIColor clearColor];
        _myTitle.font = [UIFont systemFontOfSize:14];
        _myTitle.textAlignment = NSTextAlignmentCenter;
        _myTitle.numberOfLines = 0;//表示label可以多行显示
        _myTitle.lineBreakMode = NSLineBreakByCharWrapping;
        [leftButton addSubview:_myTitle];
        
        UIImageView * message = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width/2-70, _myTitle.frame.size.height+_myTitle.frame.origin.y+5, 20, 15)];
        [message setImage:[UIImage imageNamed:@"message.png"]];
        [leftButton addSubview:message];
        
        _num = [[UILabel alloc] initWithFrame:CGRectMake(message.frame.size.width+message.frame.origin.x+5, _myTitle.frame.size.height+_myTitle.frame.origin.y+5, 40, 15)];
        _num.backgroundColor =[ UIColor clearColor];
               _num.font = [UIFont systemFontOfSize:12];
        _num.textAlignment = NSTextAlignmentLeft;
        [leftButton addSubview:_num];
        
        
        
      
        
        _myTitle2 = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width/2+5, 0, self.frame.size.width/2-5, 60)];
        _myTitle2.backgroundColor =[ UIColor clearColor];
        _myTitle2.font = [UIFont systemFontOfSize:14];
        _myTitle2.textAlignment = NSTextAlignmentCenter;
        _myTitle2.numberOfLines = 0;//表示label可以多行显示
        _myTitle2.lineBreakMode = NSLineBreakByCharWrapping;
        [rightButton addSubview:_myTitle2];
        
        UIImageView * message2 = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width-70, _myTitle2.frame.size.height+_myTitle2.frame.origin.y+5, 20, 15)];
        [message2 setImage:[UIImage imageNamed:@"message.png"]];
        [rightButton addSubview:message2];
        
        _num2 = [[UILabel alloc] initWithFrame:CGRectMake(message2.frame.size.width+message2.frame.origin.x+5, 0, 40, 15)];
        _num2.backgroundColor =[ UIColor clearColor];
       
        _num2.font = [UIFont systemFontOfSize:12];
        _num2.textAlignment = NSTextAlignmentLeft;
        [rightButton addSubview:_num2];
        
        

    }
    return self;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
@end
