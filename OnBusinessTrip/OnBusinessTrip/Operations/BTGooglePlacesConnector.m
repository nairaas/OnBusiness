//
//  BTGooglePlacesConnector.m
//  OnBusinessTrip
//
//  Created by Naira on 6/7/13.
//
//

#import "BTGooglePlacesConnector.h"

static const NSString *kAppKey = @"AIzaSyABitYd5ZA-HDpxLzfC17dGCEB5F18hPao";

@interface BTGooglePlacesConnector ()

@property (nonatomic, strong) NSMutableData *data;

@end

@implementation BTGooglePlacesConnector

@synthesize delegate = _delegate;
@synthesize data = _data;

- (void)loadPlacesWithName:(NSString *)str {
    NSString *urlString = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/autocomplete/json?input=%@&sensor=false&key=%@&types=(cities)", str, kAppKey];
    NSURLRequest *r = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:urlString]];
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:r delegate:self];
    self.data = [NSMutableData data];
    NSLog(@"111: %@", conn);
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [self.data appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSError *e = nil;
    NSDictionary *a = [NSJSONSerialization JSONObjectWithData:self.data options:NSJSONReadingMutableContainers error:&e];
    if ([self.delegate respondsToSelector:@selector(connector:didRecieveData:)]) {
        [self.delegate connector:self didRecieveData:[a objectForKey:@"predictions"]];
    }
}

@end
