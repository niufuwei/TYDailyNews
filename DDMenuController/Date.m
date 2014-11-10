//
//  Date.m
//  KbWireless
//
//  Created by niufuwei on 14-3-6.
//  Copyright (c) 2014年 niufuwei. All rights reserved.
//

#import "Date.h"

@implementation Date

-(NSString*)getYMDInfor:(NSDate*)date
{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    
    NSInteger unitFlags = NSYearCalendarUnit |
    
    NSMonthCalendarUnit |
    
    NSDayCalendarUnit |
    
    NSWeekdayCalendarUnit |
    
    NSHourCalendarUnit |
    
    NSMinuteCalendarUnit |
    
    NSSecondCalendarUnit;
    
    comps = [calendar components:unitFlags fromDate:date];
    
//    int week = [comps weekday];
    
    int year=[comps year];
    
    int month = [comps month];
    
    int day = [comps day];
    return [NSString stringWithFormat:@"%d年%d月%d日",year,month,day];
}

-(NSString*)getYear:(NSDate*)date
{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    
    NSInteger unitFlags = NSYearCalendarUnit |
    
    NSMonthCalendarUnit |
    
    NSDayCalendarUnit |
    
    NSWeekdayCalendarUnit |
    
    NSHourCalendarUnit |
    
    NSMinuteCalendarUnit |
    
    NSSecondCalendarUnit;
    
    comps = [calendar components:unitFlags fromDate:date];
    
    //    int week = [comps weekday];
    
    int year=[comps year];
    return [NSString stringWithFormat:@"%d",year];
}

-(NSString*)getMon:(NSDate*)date
{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    
    NSInteger unitFlags = NSYearCalendarUnit |
    
    NSMonthCalendarUnit |
    
    NSDayCalendarUnit |
    
    NSWeekdayCalendarUnit |
    
    NSHourCalendarUnit |
    
    NSMinuteCalendarUnit |
    
    NSSecondCalendarUnit;
    
    comps = [calendar components:unitFlags fromDate:date];
    
    //    int week = [comps weekday];
    
    int month=[comps month];
    return [NSString stringWithFormat:@"%d",month];
}
-(NSString*)getDay:(NSDate*)date
{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    
    NSInteger unitFlags = NSYearCalendarUnit |
    
    NSMonthCalendarUnit |
    
    NSDayCalendarUnit |
    
    NSWeekdayCalendarUnit |
    
    NSHourCalendarUnit |
    
    NSMinuteCalendarUnit |
    
    NSSecondCalendarUnit;
    
    comps = [calendar components:unitFlags fromDate:date];
    
    //    int week = [comps weekday];
    
    int day=[comps day];
    return [NSString stringWithFormat:@"%d",day];
}

-(NSString *)stringFormDate:(NSDate *)date isHorLine:(BOOL)isHorLine
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    if(isHorLine)
    {
        [dateFormatter  setDateFormat:@"yyyy-MM-dd"];

    }
    else
    {
        [dateFormatter  setDateFormat:@"yyyyMMdd"];

    }
    
    
    NSString * currentDateStr = [dateFormatter stringFromDate:date];
    return currentDateStr;
}

-(NSString*)getWeakInfor:(NSDate*)date
{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit |
    
    NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    comps = [calendar components:unitFlags fromDate:date];
    
    
    NSString * weekString = nil;
    
    switch ([comps weekday]) {
        case 1:
        {
            weekString = @"星期日";
        }
            break;
        case 2:
        {
            weekString = @"星期一";

        }
            break;
        case 3:
        {
            weekString = @"星期二";

        }
            break;
        case 4:
        {
            weekString = @"星期三";

        }
            break;
        case 5:
        {
            weekString = @"星期四";

        }
            break;
        case 6:
        {
            weekString = @"星期五";

        }
            break;
        case 7:
        {
            weekString = @"星期六";

        }
            break;
            
        default:
            break;
    }
    
    return weekString;

}
-(NSDate *)DateFormString:(NSString *)string
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
    [dateFormatter  setDateFormat:@"yyyy-MM-dd"];
    
    NSDate * currentDateStr = [dateFormatter dateFromString:string];
    return currentDateStr;
}

@end
