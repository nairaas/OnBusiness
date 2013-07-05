//
//  ATAPILogoutOperation.h
//  AtTaskConnector
//
//  Created by Mariam Hakobyan on 12/19/12.
//
//

#import <AtTaskConnector/AtTaskConnector.h>

@interface ATAPILogoutOperation : ATAPIOperation

@property (nonatomic, copy) NSString *sessionID;

- (id)initWithSessionID:(NSString *)sessionID;
- (id)initWithSessionID:(NSString *)sessionID completionHandler:(ATOperationHandler)completionHandler;
- (id)initWithSessionID:(NSString *)sessionID completionHandler:(ATOperationHandler)completionHandler failureHandler:(ATOperationHandler)failureHandler;

@end
