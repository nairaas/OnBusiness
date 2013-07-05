//
//  BTCreateTripOperation.h
//  OnBusinessTrip
//
//  Created by Naira on 6/2/13.
//
//

#import <AtTaskConnector/AtTaskConnector.h>

@interface BTCreateTripOperation : ATAPICreateObjectOperation

- (id)initWithProfileID:(NSString *)uID location:(NSString *)lID startDate:(NSDate *)startDate endDate:(NSDate *)endDate successSel:(SEL)successSel failureSel:(SEL)failureSel target:(id)target;

@end
