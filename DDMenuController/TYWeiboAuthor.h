//
//  TYWeiboAuthor.h
//  TYDaily
//
//  Created by laoniu on 14-10-15.
//
//

#import <Foundation/Foundation.h>

typedef void (^blockaccess)(id);
typedef void (^blockerror)(id);

@interface TYWeiboAuthor : NSObject<WBHttpRequestDelegate>

@property (nonatomic,strong) blockaccess backBlock;
@property (nonatomic,strong) blockerror backBlockError;


-(void)sendWeiBoAuthorRequest:(void(^)(id result))BackResult error:(void(^)(id error))error;

@end
