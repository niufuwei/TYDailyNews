//
//  TYZongLan.m
//  TYDaily
//
//  Created by laoniu on 14/11/9.
//
//

#import "TYZongLan.h"

@implementation TYZongLan

-(id)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        [self setBackgroundColor:[UIColor whiteColor]];
        
        _button= [UIButton buttonWithType:UIButtonTypeCustom];
        _button.frame = CGRectMake(0, 0, 80, 80);
        [self addSubview:_button];
        
        _titleLabel =[[UILabel alloc] initWithFrame:CGRectMake(0, _button.frame.size.height+_button.frame.origin.y, self.frame.size.width, 20)];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.font = [UIFont systemFontOfSize:16];
        [self addSubview:_titleLabel];
        
    }
    return self;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
