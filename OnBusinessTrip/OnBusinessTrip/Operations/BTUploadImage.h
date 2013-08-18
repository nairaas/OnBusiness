//
//  BTUploadImage.h
//  OnBusinessTrip
//
//  Created by Naira on 6/23/13.
//
//

#import <AtTaskConnector/AtTaskConnector.h>

@interface BTUploadImageOperation : ATAPIFileUploadOperation

- (id)initWithProfileID:(NSString *)pID successSel:(SEL)successSel failureSel:(SEL)failureSel target:(id)target;

@end
