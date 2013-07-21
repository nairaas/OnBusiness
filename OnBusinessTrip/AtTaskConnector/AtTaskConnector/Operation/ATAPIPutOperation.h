//
//  ATAPIUpdateObjectOperation.h
//  AtTaskConnector
//
//  Created by Naira Sahakyan on 8/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ATAPIOperation.h"

@interface ATAPIPutOperation : ATAPIOperation

- (id)initWithURIPath:(NSString *)path inputData:(NSDictionary *)inputData;
- (id)initWithURIPath:(NSString *)path inputData:(NSDictionary *)inputData
	completionHandler:(ATOperationHandler)completionHandler;
- (id)initWithURIPath:(NSString *)path inputData:(NSDictionary *)inputData
	completionHandler:(ATOperationHandler)completionHandler
	   failureHandler:(ATOperationHandler)failureHandler;

@end
