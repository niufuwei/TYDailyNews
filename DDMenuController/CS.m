//
//  NSString+CS.m
//  TYDaily
//
//  Created by laoniu on 14-10-6.
//
//

#import "CS.h"

@implementation CS

+(NSString*)DealWithString:(NSString *)string
{
    string = [string stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@"\t" withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    string = [string stringByReplacingOccurrencesOfString:@" " withString:@""];
    return string;
}
@end
