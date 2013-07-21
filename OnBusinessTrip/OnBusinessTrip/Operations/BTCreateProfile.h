//
//  BTCreateProfile.h
//  OnBusinessTrip
//
//  Created by Naira on 6/2/13.
//
//

#import <AtTaskConnector/AtTaskConnector.h>

@interface BTCreateProfile : ATAPIPostOperation

- (id)initWithUserID:(NSString *)uID name:(NSString *)name date:(NSString *)dateOfBirth gender:(NSInteger)gender successSel:(SEL)successSel failureSel:(SEL)failureSel target:(id)target;

@end
