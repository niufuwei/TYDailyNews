//
//  TYShareManager.h
//  TYDaily
//
//  Created by laoniu on 14/11/3.
//
//

#import <Foundation/Foundation.h>
#import "WeiboSDK.h"
#import "WXApi.h"
#import "WXApiObject.h"
@class TYShareManager;
@protocol TYShareManagerDelegate <NSObject>

-(void)shareWithContentString:(NSString *)contentStr andImage:(UIImage *)image;

@end


@interface TYShareManager : NSObject

@property (nonatomic, assign) id<TYShareManagerDelegate>delegate;
+(TYShareManager *)currentShare;
-(void)shareContentString:(NSString *)str title:(NSString *)title image:(UIImage *)image url:(NSString *)url;



//新浪微博的相关方法
-(BOOL)hasWeiBoAppInstalled;
-(BOOL)isAuthorizeAvailable;
-(void)shareWithWeiBo;


//微信分享
-(void)shareWithWeiXin:(int)way;

//qq分享
-(void)shareWithQQZone:(int)way;

-(void)shareWithQQ:(int)way;

@end
