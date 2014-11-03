//
//  Date.h
//  KbWireless
//
//  Created by niufuwei on 14-3-6.
//  Copyright (c) 2014年 niufuwei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Date : NSObject

-(NSString *)stringFormDate:(NSDate *)date isHorLine:(BOOL)isHorLine;
-(NSDate*)DateFormString:(NSString *)string;
-(NSString*)getWeakInfor:(NSDate*)date;
-(NSString*)getYMDInfor:(NSDate*)date;

@end
