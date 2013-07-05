//
//  ATAPIReportOperation.h
//  AtTaskConnector
//
//  Created by Mariam Hakobyan on 7/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ATAPIObjectOperation.h"

@interface ATAPIReportOperation : ATAPIObjectOperation

@property (nonatomic, strong) NSDictionary *criteria;

- (id)initWithObjectCode:(NSString *)objectCode criteria:(NSDictionary *)criteria fields:(NSArray *)fields;
- (id)initWithObjectCode:(NSString *)objectCode criteria:(NSDictionary *)criteria fields:(NSArray *)fields
	   completionHandler:(ATOperationHandler)completionHandler;
- (id)initWithObjectCode:(NSString *)objectCode criteria:(NSDictionary *)criteria fields:(NSArray *)fields
	   completionHandler:(ATOperationHandler)completionHandler
		  failureHandler:(ATOperationHandler)failureHandler;

@end
