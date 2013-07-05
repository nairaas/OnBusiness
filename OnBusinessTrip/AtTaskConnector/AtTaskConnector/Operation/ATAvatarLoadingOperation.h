//
//  ATAvatarLoadingOperation.h
//  AtTaskConnector
//
//  Created by Naira Sahakyan on 5/25/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ATNetworkOperation.h"

typedef enum {
	ATAvatarTiny = 28,
	ATAvatarSmall = 31,
	ATAvatarMedium = 38,
	ATAvatarLarge = 48,
	ATAvatarFull = 123
} AvatarSizeType;

@interface ATAvatarLoadingOperation : ATNetworkOperation

@property (nonatomic, strong) NSString *userID;
@property (nonatomic, assign) AvatarSizeType avatarSizeType;

- (id)initWithUserID:(NSString *)uID avatarSize:(AvatarSizeType)size completionHandler:(ATOperationHandler)completionHandler
	  failureHandler:(ATOperationHandler)failureHandler;

@end
