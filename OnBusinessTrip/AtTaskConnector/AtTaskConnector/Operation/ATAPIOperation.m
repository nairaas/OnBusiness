
//
//  ATAPIOperation.m
//  AtTaskConnector
//
//  Created by Mikayel Aghasyan on 2/26/12.
//  Copyright (c) 2012 AtTask. All rights reserved.
//

#import "ATAPIOperation.h"
#import "ATConnectorErrorConstants.h"
#import "ATDataParser.h"

NSString *const kOutputData = @"data";
NSString *const kInputFields = @"inputFields";

static NSString *const kJSONError = @"error";
static NSString *const kJSONData = @"data";


@implementation ATAPIOperation

@synthesize output = _output;
@synthesize inputData = _inputData;

#pragma mark - Custom accessors

- (id)inputData {
	return [self operationInputValueForKey:kInputFields];
}

- (void)setInputData:(id)inputData {
	[self setOperationInputValue:inputData forKey:kInputFields];
}

#pragma mark - Provide info for request creation

- (NSString *)URIPath {
	return @"";
}

- (void)propagateOutput {
	id output = self.output;
	if (output) {
		[self setOperationOutputValue:output forKey:kOutputData];
	}
}

- (BOOL)parseData:(Class)parser {
	NSError * __autoreleasing error = nil;
	id jsonObject = [NSJSONSerialization JSONObjectWithData:self.data options:0 error:&error];
	if (error) {
		if (!self.error && [self.data length] > 0) {
			self.error = error;
		}
	} else {
		if ([jsonObject isKindOfClass:[NSDictionary class]]) {
			id jsonError = [(NSDictionary *)jsonObject objectForKey:kJSONError];
			if (jsonError) {
				NSDictionary *errorUserInfo = nil;
				if ([jsonError isKindOfClass:[NSDictionary class]]) {
					errorUserInfo = (NSDictionary *)jsonError;
				}
				NSNumber *jsonErrorCode = [errorUserInfo valueForKey:@"code"];
				NSString *jsonErrorMsg = [errorUserInfo valueForKey:@"message"];
				NSDictionary *userInfo = nil;
				NSInteger errorCode = 0;
				if (jsonErrorCode) {
					userInfo = [[NSDictionary alloc] initWithObjectsAndKeys:jsonErrorMsg, @"message", nil];
				} else {
					NSString *jsonErrorClass = [errorUserInfo valueForKey:@"class"];
					if (([jsonErrorClass rangeOfString:@"NoAccessLevelException"]).location != NSNotFound) {
						errorCode = kATConnectorNoAccessLevelErrorCode;
						userInfo = [[NSDictionary alloc] initWithObjectsAndKeys:jsonErrorMsg, @"message", nil];
					} else if (([jsonErrorClass rangeOfString:@"LicenseKeyExceededException"]).location != NSNotFound) {
						errorCode = kATConnectorLicenseKeyExceededErrorCode;
					} else if (([jsonErrorClass rangeOfString:@"PasswordExpiredException"]).location != NSNotFound) {
						errorCode = kATConnectorPasswordExpirationErrorCode;
					} else if (([jsonErrorClass rangeOfString:@"FailedLoginTimeoutException"]).location != NSNotFound) {
						errorCode = kATConnectorLoginTimeoutErrorCode;
					}
				}
				if (errorCode != 0 || self.error == nil) {
					self.error = [[NSError alloc] initWithDomain:kATConnectorErrorDomain code:(errorCode != 0 ? errorCode : [jsonErrorCode integerValue])
														userInfo:userInfo];
				}
			}// else {
//				id jsonData = [(NSDictionary *)jsonObject objectForKey:kJSONData];
//				if (jsonData) {
//					self.output = jsonObject;
//				}
//			}
//		} else {
//			if (!self.error) {
//				self.error = [[NSError alloc] initWithDomain:kATConnectorErrorDomain code:kATConnectorBadJSONErrorCode userInfo:nil];
        }
		}
//	}
    if (nil == self.error) {
        self.output = jsonObject;
    }
	return (self.error == nil);
}

@end
