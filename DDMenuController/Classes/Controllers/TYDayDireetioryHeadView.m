//
//  TYDayDireetioryHeadView.m
//  TYDaily
//
//  Created by laoniu on 14-10-8.
//
//

#import "TYDayDireetioryHeadView.h"

@implementation TYDayDireetioryHeadView
@synthesize type;
@synthesize value;

-(void)HeadViewLoad
{
    value = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 30, 20)];
    value.textColor = RedColor;
    value.font = [UIFont systemFontOfSize:16];
    value.backgroundColor = [UIColor clearColor];
    value.textAlignment = NSTextAlignmentCenter;

    [self addSubview:value];
    
    UILabel * name = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, 30, 10)];
    name.textColor = RedColor;
    name.text = @"版";
    name.font = [UIFont systemFontOfSize:9];
    name.backgroundColor = [UIColor clearColor];
    name.textAlignment = NSTextAlignmentCenter;
    [self addSubview:name];
    
    UIImageView * image = [[UIImageView alloc] initWithFrame:CGRectMake(40, 0, self.frame.size.width-40, 30)];
    [image setImage:[UIImage imageNamed:@"bgR.png"]];
    [self addSubview:image];
    
    type = [[UILabel alloc] initWithFrame:CGRectMake(60, 0, 200, 30)];
    type.textColor = RedColor;
    type.font = [UIFont systemFontOfSize:14];
    type.backgroundColor = [UIColor clearColor];
    [self addSubview:type];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
