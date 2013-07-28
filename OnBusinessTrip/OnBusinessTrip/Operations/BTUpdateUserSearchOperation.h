//
//  BTUpdateUserSearchOperation.h
//  OnBusinessTrip
//
//  Created by Naira on 7/26/13.
//
//

#import <AtTaskConnector/AtTaskConnector.h>

@interface BTUpdateUserSearchOperation : ATAPIPostOperation

- (id)initWithProfileID:(NSString *)profileID search:(NSDictionary *)d successSel:(SEL)successSel failureSel:(SEL)failureSel target:(id)target;

@end
