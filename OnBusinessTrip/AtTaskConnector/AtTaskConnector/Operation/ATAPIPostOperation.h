//
//  ATAPICreateObjectOperation.h
//  AtTaskConnector
//
//  Created by Naira Sahakyan on 21/06/13.
//

#import "ATAPIOperation.h"

@interface ATAPIPostOperation : ATAPIOperation

- (id)initWithURIPath:(NSString *)path inputData:(NSDictionary *)inputData;
- (id)initWithURIPath:(NSString *)path inputData:(NSDictionary *)inputData
	   completionHandler:(ATOperationHandler)completionHandler;
- (id)initWithURIPath:(NSString *)path inputData:(id)inputData
	   completionHandler:(ATOperationHandler)completionHandler
		  failureHandler:(ATOperationHandler)failureHandler;

@end
