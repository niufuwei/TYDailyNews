//
//  TYNewsCommentCell.m
//  TYDaily
//
//  Created by laoniu on 14-10-8.
//
//

#import "TYNewsCommentCell.h"

@implementation TYNewsCommentCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        _addr = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 70, 20)];
        _addr.textAlignment = NSTextAlignmentLeft;
        _addr.textColor = [UIColor grayColor];
        _addr.font = [UIFont systemFontOfSize:13];
        [self.contentView addSubview:_addr];
        
        _time = [[UILabel alloc] initWithFrame:CGRectMake(_addr.frame.size.width+_addr.frame.origin.x+10, 10, 150, 20)];
        _time.textAlignment = NSTextAlignmentLeft;
        _time.textColor = [UIColor grayColor];
        _time.font = [UIFont systemFontOfSize:13];
        [self.contentView addSubview:_time];
        
        //        UIButton * zan = [UIButton buttonWithType:UIButtonTypeCustom];
        //        zan.frame = CGRectMake(self.frame.size.width-50, my_yyyyy, 20, 20);
        //        zan.tag = i+1;
        //        [zan addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
        //        [zan setImage:[UIImage imageNamed:@"zan.png"] forState:UIControlStateNormal];
        //        [backScrollview addSubview:zan];
        
        _TTcontent = [[UILabel alloc] initWithFrame:CGRectMake(30, _addr.frame.size.height+_addr.frame.origin.y+10, self.frame.size.width-60, 45)];
        _TTcontent.textAlignment = NSTextAlignmentLeft;
        _TTcontent.textColor = [UIColor grayColor];
        _TTcontent.font = [UIFont systemFontOfSize:14];
        _TTcontent.lineBreakMode = NSLineBreakByCharWrapping;
        _TTcontent.numberOfLines = 0;
        [self.contentView addSubview:_TTcontent];
        
//        UIImageView * imageH = [[UIImageView alloc] initWithFrame:CGRectMake(5, TTcontent.frame.size.height+TTcontent.frame.origin.y+5, self.frame.size.width-10, 1)];
//        [imageH setBackgroundColor:[UIColor grayColor]];
//        [self.contentView addSubview:imageH];
        
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
