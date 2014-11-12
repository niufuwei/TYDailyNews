//
//  TYDayFeatMutableImageCell.m
//  TYDaily
//
//  Created by laoniu on 14-10-5.
//
//

#import "TYDayFeatMutableImageCell.h"

@implementation TYDayFeatMutableImageCell

@synthesize image1;
@synthesize image2;
@synthesize image3;
@synthesize title;
@synthesize type;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        title = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, self.frame.size.width-60, 30)];
        title.backgroundColor =[ UIColor clearColor];
        title.font = [UIFont systemFontOfSize:15];
        [self.contentView addSubview:title];
        
        type = [UIButton buttonWithType:UIButtonTypeCustom];
        type.frame = CGRectMake(self.frame.size.width-50, 10, 40, 20);
        [type setBackgroundColor:RedColor];
        [type.layer setCornerRadius:5];
        type.titleLabel.font = [UIFont systemFontOfSize:13];
        [self.contentView addSubview:type];
        
        image1 = [[UIImageView alloc] initWithFrame:CGRectMake(20, title.frame.size.height+title.frame.origin.y+5, (self.frame.size.width-80)/3, 50)];
        [self.contentView addSubview:image1];
        
        image2 = [[UIImageView alloc] initWithFrame:CGRectMake(image1.frame.origin.x+image1.frame.size.width+20, title.frame.size.height+title.frame.origin.y+5, (self.frame.size.width-80)/3, 50)];
        [self.contentView addSubview:image2];
        
        image3 = [[UIImageView alloc] initWithFrame:CGRectMake(image2.frame.origin.x+image2.frame.size.width+20, title.frame.size.height+title.frame.origin.y+5, (self.frame.size.width-80)/3, 50)];
        [self.contentView addSubview:image3];
        
    }
    return self;
}

-(void)setImageArray:(NSArray*)ImageArray
{
    if([ImageArray count] ==2)
    {
        image3.hidden = YES;
        [image1 setImageWithURL:[NSURL URLWithString:[[ImageArray objectAtIndex:0] objectForKey:@"url"]] placeholderImage:[UIImage imageNamed:@"noImage"]];
        
        [image2 setImageWithURL:[NSURL URLWithString:[[ImageArray objectAtIndex:1] objectForKey:@"url"]] placeholderImage:[UIImage imageNamed:@"noImage"]];
    }
    else
    {
        image3.hidden = NO;
        [image1 setImageWithURL:[NSURL URLWithString:[[ImageArray objectAtIndex:0] objectForKey:@"url"]] placeholderImage:[UIImage imageNamed:@"noImage"]];
        
        [image2 setImageWithURL:[NSURL URLWithString:[[ImageArray objectAtIndex:1] objectForKey:@"url"]] placeholderImage:[UIImage imageNamed:@"noImage"]];

        
        [image3 setImageWithURL:[NSURL URLWithString:[[ImageArray objectAtIndex:2] objectForKey:@"url"]] placeholderImage:[UIImage imageNamed:@"noImage"]];


    }
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
