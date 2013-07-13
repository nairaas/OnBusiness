//
//  BTSignInViewController.m
//  OnBusinessTrip
//
//  Created by Naira on 5/27/13.
//
//

#import "BTSignInViewController.h"
#import "BTSignInOperation.h"

#import <AtTaskConnector/AtTaskConnector.h>

//#import "BTAppDelegate.h"

@interface BTSignInViewController ()

@end

@implementation BTSignInViewController

@synthesize emailTextField = _emailTextField;
@synthesize passwordTextField = _passwordTextField;
@synthesize signInButton = _signInButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.emailTextField becomeFirstResponder];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)signIn:(id)sender {
    BTSignInOperation *op = [[BTSignInOperation alloc] initWithUserName:@"mobile-client" //self.emailTextField.text
                                                               password:@"0btpa$$w0rd" //self.passwordTextField.text
                                                             successSel:@selector(signInSucceeded)
                                                             failureSel:@selector(signInFailedWithError:) target:self];
//    BTAppDelegate *del = (BTAppDelegate *)[[UIApplication sharedApplication] delegate];
    [[ATNetworkOperationManager sharedInstance] submitNetworkOperation:op];
//    [del.networkOperationManager submitNetworkOperation:op];
}

- (void)signInSucceeded {
    NSLog(@"Sign in Succeeded");
}

- (void)signInFailedWithError:(NSError *)error {
    NSLog(@"Sign in Failed with error: %@", error);
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (self.emailTextField == textField) {
        [self.passwordTextField becomeFirstResponder];
    } else if (self.passwordTextField == textField) {
        [self.passwordTextField resignFirstResponder];
    }
    return YES;
}

@end
