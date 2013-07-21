//
//  ATAPIGetOperation.h
//  AtTaskConnector
//
//  Created by Naira Sahakyan on 06/21/13.
//

#import "ATAPIOperation.h"

@interface ATAPIGetOperation : ATAPIOperation

//@property (nonatomic, copy) NSString *objectCode;
//@property (nonatomic, copy) NSArray *fields;

- (id)initWithURIPath:(NSString *)path;

- (id)initWithObjectCode:(NSString *)path
	   completionHandler:(ATOperationHandler)completionHandler;

- (id)initWithObjectCode:(NSString *)path
	   completionHandler:(ATOperationHandler)completionHandler
		  failureHandler:(ATOperationHandler)failureHandler;

- (id)initWithObjectCode:(NSString *)path query:(id)query;

- (id)initWithObjectCode:(NSString *)path query:(id)query
	   completionHandler:(ATOperationHandler)completionHandler;

- (id)initWithURIPath:(NSString *)path query:(id)query
	completionHandler:(ATOperationHandler)completionHandler
	   failureHandler:(ATOperationHandler)failureHandler;

@end