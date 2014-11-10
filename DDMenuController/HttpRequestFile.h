//
//  HttpRequestFile.h
//  KbWireless
//
//  Created by niufuwei on 14-3-21.
//  Copyright (c) 2014年 niufuwei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HttpRequestFile : NSObject

+(id)upload:(NSString *)url widthParams:(NSDictionary *)params;

@end

@interface FileDetail : NSObject
@property(strong,nonatomic) NSString *name;
@property(strong,nonatomic) NSData *data;
+(FileDetail *)fileWithName:(NSString *)name data:(NSData *)data;
@end
