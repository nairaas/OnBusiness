//
//  BTSignUpViewController.m
//  OnBusinessTrip
//
//  Created by Naira on 5/27/13.
//
//

#import "BTSignUpViewController.h"
#import "BTSignUpOperation.h"
#import "BTCreateProfile.h"
#import "BTCreateTripOperation.h"
#import "BTGetSearchOperation.h"
//#import "BTAppDelegate.h"
#import "BTUploadImage.h"
#import "BTGetUserProfileOperation.h"

#import <AtTaskConnector/AtTaskConnector.h>

@interface BTSignUpViewController ()

@end

@implementation BTSignUpViewController

@synthesize signUp = _signUp;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)signUp:(id)sender {
    BTSignUpOperation *op = [[BTSignUpOperation alloc] initWithUserName:self.emailTextField.text
                                       password:self.passwordTextField.text
                                           date:self.dateTextField.text gender:0
                                     successSel:@selector(successfulSignUpHandler:)
                                     failureSel:@selector(failedSignUpHandler:) target:self];
//    BTAppDelegate *del = (BTAppDelegate *)[[UIApplication sharedApplication] delegate];
//    [del.networkOperationManager submitNetworkOperation:op];
    [[ATNetworkOperationManager sharedInstance] submitNetworkOperation:op];
}

- (void)successfulSignUpHandler:(NSDictionary *)userInfo {
    NSLog(@"USER: %@", userInfo);
    BTCreateProfile *op = [[BTCreateProfile alloc] initWithUserID:[userInfo objectForKey:@"id"] name:@"Hello" date:nil gender:1 successSel:@selector(profileCreated:) failureSel:@selector(profileCreationFailed:) target:self];
//    BTAppDelegate *del = (BTAppDelegate *)[[UIApplication sharedApplication] delegate];
//    [del.networkOperationManager submitNetworkOperation:op];
    [[ATNetworkOperationManager sharedInstance] submitNetworkOperation:op];
}

- (void)failedSignUpHandler:(NSError *)error {
    NSLog(@"Error: %@", error);
}

- (void)profileCreated:(NSDictionary *)profile {
    NSLog(@"Profile: %@", profile);
/*    BTCreateTripOperation *op = [[BTCreateTripOperation alloc] initWithProfileID:[profile objectForKey:@"id"] location:<#(NSString *)#> startDate:<#(NSDate *)#> endDate:<#(NSDate *)#> successSel:<#(SEL)#> failureSel:<#(SEL)#> target:<#(id)#>];
    BTAppDelegate *del = (BTAppDelegate *)[[UIApplication sharedApplication] delegate];
    [del.networkOperationManager submitNetworkOperation:op];
 */
//    BTAppDelegate *del = (BTAppDelegate *)[[UIApplication sharedApplication] delegate];
	BTGetUserProfileOperation *opp = [[BTGetUserProfileOperation alloc] initWithProfileID:[profile objectForKey:@"id"] successSel:@selector(profileRetrieved:) failureSel:@selector(profileRetrievalFailed:) target:self];
//	[del.networkOperationManager submitNetworkOperation:opp];
	[[ATNetworkOperationManager sharedInstance] submitNetworkOperation:opp];
	
	BTGetSearchOperation *op = [[BTGetSearchOperation alloc] initWithProfileID:[profile objectForKey:@"id"] successSel:@selector(searchSucceeded:) failureSel:@selector(searchFailedWithError:) target:self];
//    [del.networkOperationManager submitNetworkOperation:op];
	[[ATNetworkOperationManager sharedInstance] submitNetworkOperation:op];
    
    BTUploadImageOperation *upload = [[BTUploadImageOperation alloc] initWithProfileID:@"11" successSel:@selector(imageUploaded:) failureSel:@selector(imageUploadingFailed:) target:self];
//    [del.networkOperationManager submitNetworkOperation:upload];
	[[ATNetworkOperationManager sharedInstance] submitNetworkOperation:upload];
}

- (void)profileCreationFailed:(NSError *)error {
    NSLog(@"Profile failure: %@", error);
}

- (void)profileRetrieved:(NSDictionary *)profile {
    NSLog(@"xxx: %@", profile);
}

- (void)profileRetrievalFailed:(NSError *)error {
    NSLog(@"Error: %@", error);
}

- (void)searchSucceeded:(NSDictionary *)dictionary {
    NSLog(@"Search: %@", dictionary);
}

- (void)searchFailedWithError:(NSError *)error {
    NSLog(@"Error: %@", error);
}

- (void)imageUploaded:(NSDictionary *)dictionary {
    NSLog(@"Image: %@", dictionary);
}

- (void)imageUploadingFailed:(NSError *)error {
    NSLog(@"Image Error: %@", error);
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (self.emailTextField == textField) {
        [self.passwordTextField becomeFirstResponder];
    } else if (self.passwordTextField == textField) {
        [self.passwordTextField resignFirstResponder];
    } else if (self.dateTextField == textField) {
        [self.dateTextField resignFirstResponder];
    }
    return YES;
}

@end
