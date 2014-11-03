//
//  TYHttpRequest.h
//  TYDaily
//
//  Created by laoniu on 14-10-4.
//
//

#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"

typedef void (^Success)(id);
typedef void (^Failure)(NSError*);
@interface TYHttpRequest : NSObject<ASIHTTPRequestDelegate>

@property (nonatomic,strong) Success mySuccess;
@property (nonatomic,strong) Failure myFailure;
-(void)httpRequest:(NSString*)service parameter:(id)parameter Success:(void(^)(id result))Success Failure:(void(^)(NSError*error))Failure view:(UIView*)view isPost:(BOOL)isPost;

-(void)httpRequestWeiBo:(NSString*)service parameter:(id)parameter Success:(void(^)(id result))Success Failure:(void(^)(NSError*error))Failure view:(UIView*)view isPost:(BOOL)isPost;
@end
