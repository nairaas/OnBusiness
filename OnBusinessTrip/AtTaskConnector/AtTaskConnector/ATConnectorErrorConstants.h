//
//  ATConnectorErrorConstants.h
//  AtTaskConnector
//
//  Created by Mikayel Aghasyan on 2/29/12.
//  Copyright (c) 2012 AtTask. All rights reserved.
//

static NSString *const kATConnectorErrorDomain = @"AtTaskConnector";

static NSInteger const kATConnectorConnectionErrorCode = -1009;
static NSInteger const kATConnectorParseErrorCode = 2;
static NSInteger const kATConnectorBadJSONErrorCode = 3;
static NSInteger const kATConnectorAPIErrorCode = 4;
static NSInteger const kATConnectorHostNotFoundErrorCode = 5;
static NSInteger const kATConnectorInvalidLoginErrorCode = 6;
static NSInteger const kATConnectorNonStreamErrorCode = 7;
static NSInteger const kATConnectorNoAccessLevelErrorCode = 8;
static NSInteger const kATConnectorPasswordExpirationErrorCode = 9;
static NSInteger const kATConnectorLoginTimeoutErrorCode = 10;
static NSInteger const kATConnectorLicenseKeyExceededErrorCode = 11;