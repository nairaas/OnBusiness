//
//  ATAPISearchOperation.h
//  AtTaskConnector
//
//  Created by Mikayel Aghasyan on 2/29/12.
//  Copyright (c) 2012 AtTask. All rights reserved.
//

#import "ATAPIObjectOperation.h"

@interface ATAPISearchOperation : ATAPIObjectOperation

@property (nonatomic, copy) NSString *namedQuery;
@property (nonatomic, strong) NSDictionary *criteria;

- (id)initWithObjectCode:(NSString *)objectCode namedQuery:(NSString *)namedQuery
				criteria:(NSDictionary *)criteria fields:(NSArray *)fields;
- (id)initWithObjectCode:(NSString *)objectCode namedQuery:(NSString *)namedQuery
				criteria:(NSDictionary *)criteria fields:(NSArray *)fields
	   completionHandler:(ATOperationHandler)completionHandler;
- (id)initWithObjectCode:(NSString *)objectCode namedQuery:(NSString *)namedQuery
				criteria:(NSDictionary *)criteria fields:(NSArray *)fields
	   completionHandler:(ATOperationHandler)completionHandler
		  failureHandler:(ATOperationHandler)failureHandler;

@end
