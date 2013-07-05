//
//  ATDataDownloadingOperation.h
//  AtTaskConnector
//
//  Created by Naira on 11/30/12.
//
//

#import <Foundation/Foundation.h>
#import "ATNetworkOperation.h"

@interface ATDataDownloadingOperation : ATNetworkOperation

- (id)initWithURL:(NSString *)url HTTPMethod:(NSString *)method completionHandler:(ATOperationHandler)completionHandler failureHandler:(ATOperationHandler)failureHandler;

@end
