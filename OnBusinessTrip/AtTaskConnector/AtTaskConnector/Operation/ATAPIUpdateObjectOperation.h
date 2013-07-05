//
//  ATAPIUpdateObjectOperation.h
//  AtTaskConnector
//
//  Created by Naira Sahakyan on 8/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ATAPIObjectOperation.h"

@interface ATAPIUpdateObjectOperation : ATAPIObjectOperation

@property (nonatomic, strong) NSDictionary *updateData;

- (id)initWithObjectCode:(NSString *)objectCode updateData:(NSDictionary *)updateData fields:(NSArray *)fields;
- (id)initWithObjectCode:(NSString *)objectCode updateData:(NSDictionary *)updateData fields:(NSArray *)fields
	   completionHandler:(ATOperationHandler)completionHandler;
- (id)initWithObjectCode:(NSString *)objectCode updateData:(NSDictionary *)updateData fields:(NSArray *)fields
	   completionHandler:(ATOperationHandler)completionHandler
		  failureHandler:(ATOperationHandler)failureHandler;

@end
