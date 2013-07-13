//
//  BTFindMatchesViewController.m
//  OnBusinessTrip
//
//  Created by Naira on 4/18/13.
//
//

#import "BTFindMatchesViewController.h"

#import <QuartzCore/QuartzCore.h>
#import <AtTaskConnector/AtTaskConnector.h>

#import "UIColor+Addition.h"
#import "UIView+Additions.h"

#import "BTAppDelegate.h"
#import "BTApplicationContext.h"
#import "BTLocationTextField.h"
#import "AutocompletionTableView.h"
#import "BTGooglePlacesConnector.h"

#import "BTSignInOperation.h"
#import "BTGuestMatchesOperation.h"

static NSInteger kBaseYear = 2000;
static NSArray *kShortMonths;

@interface BTFindMatchesViewController() <AutocompletionTableViewDelegate>

@property (nonatomic, strong) AutocompletionTableView *autoCompleter;
@property (nonatomic, weak) IBOutlet UIScrollView *scrollView;
@property (nonatomic, weak) IBOutlet UIPickerView *datePickerView;

@property (nonatomic, strong) NSDate *fromDate;
@property (nonatomic, strong) NSDate *ToDate;

@end

@implementation BTFindMatchesViewController

@synthesize findButton = _findButton;
@synthesize locationTextField = _locationTextField;
@synthesize durationTextField = _durationTextField;
@synthesize scrollView = _scrollView;
@synthesize datePickerView = _datePickerView;

@synthesize autoCompleter = _autoCompleter;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self.findButton setBackgroundColor:[UIColor colorWithRed:64 withGreen:128 withBlue:0]];
//    [self.findButton.layer setCornerRadius:8.0f];
    kShortMonths = [NSArray arrayWithObjects:@"Jan", @"Feb", @"Mar", @"Apr", @"May", @"Jun", @"Jul", @"Aug", @"Sep", @"Oct", @"Nov", @"Dec", nil];

    [self.locationTextField addTarget:self.autoCompleter action:@selector(textFieldValueChanged:) forControlEvents:UIControlEventEditingChanged];

    [self.locationTextField.layer setBorderWidth:1.0];
    [self.locationTextField.layer setBorderColor:[[UIColor darkGrayColor] CGColor]];
    [self.locationTextField.layer setCornerRadius:10];
    [self.durationTextField.layer setBorderWidth:1.0];
    [self.durationTextField.layer setBorderColor:[[UIColor darkGrayColor] CGColor]];
    [self.durationTextField.layer setCornerRadius:10];
    [self.findButton.titleLabel setOrigin:CGPointMake((self.findButton.titleLabel.frame.origin.x -1),
                                                        (self.findButton.titleLabel.frame.origin.y - 5))];
    [self.scrollView setContentSize:CGSizeMake(320, 500)];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)signInPressed:(id)sender {
    BTAppDelegate *del = (BTAppDelegate *)[[UIApplication sharedApplication] delegate];
    UIViewController *v = [self.storyboard instantiateViewControllerWithIdentifier:@"SignInViewController"];
    [del.window setRootViewController:v];
}


- (IBAction)findMatchesPressed:(id)sender {
	NSLog(@"222: %@", [[BTApplicationContext sharedInstance] guestUsername]);
	NSLog(@"333: %@", [[ATNetworkOperationManager sharedInstance] serviceHost]);
	BTSignInOperation *op = [[BTSignInOperation alloc] initWithUserName:[[BTApplicationContext sharedInstance] guestUsername]
                                                               password:[[BTApplicationContext sharedInstance] guestPassword]
                                                             successSel:@selector(guestSignInSucceeded)
                                                             failureSel:@selector(guestSignInFailedWithError:) target:self];
	//    BTAppDelegate *del = (BTAppDelegate *)[[UIApplication sharedApplication] delegate];
//    [[ATNetworkOperationManager sharedInstance] submitNetworkOperation:op];
	[self guestSignInSucceeded];
}

- (void)guestSignInSucceeded {
	NSLog(@"login");
	NSDictionary *location = [NSDictionary dictionaryWithObjectsAndKeys:@"The Netherlands", @"country", @"Amsterdam", @"city", nil];
	NSDictionary *trip = [NSDictionary dictionaryWithObjectsAndKeys:@"2013-06-20T00:00:00", @"startDate", @"2013-06-25T00:00:00", @"endDate", location, @"location", nil];

	BTGuestMatchesOperation *op = [[BTGuestMatchesOperation alloc] initWithTrip:trip successSel:@selector(searchSucceeded:) failureSel:@selector(searchFailedWithError:) target:self];
	//    BTAppDelegate *del = (BTAppDelegate *)[[UIApplication sharedApplication] delegate];
    [[ATNetworkOperationManager sharedInstance] submitNetworkOperation:op];
    [self.findButton.titleLabel setOrigin:CGPointMake((self.findButton.titleLabel.frame.origin.x -1),
                                                      (self.findButton.titleLabel.frame.origin.y - 5))];
}

- (void)guestSignInFailedWithError:(NSError *)error {
	NSLog(@"guestSignInFailedWithError: %@", error);
}

- (void)searchSucceeded:(id)result {
    NSLog(@"Result: %@", result);
    NSLog(@"111: %@", self.navigationController);
    BTAppDelegate *del = (BTAppDelegate *)[[UIApplication sharedApplication] delegate];
    UIViewController *v = [self.storyboard instantiateViewControllerWithIdentifier:@"TabBarViewController"];
	[del.window setRootViewController:v];
}

- (void)searchFailedWithError:(NSError *)error {
    NSLog(@"Errorrrrr: %@", error);
    UIViewController *v = [self.storyboard instantiateViewControllerWithIdentifier:@"TabBarViewController"];
    BTAppDelegate *del = (BTAppDelegate *)[[UIApplication sharedApplication] delegate];
    [del.window setRootViewController:v];
}

- (AutocompletionTableView *)autoCompleter {
    if (!_autoCompleter) {
        NSMutableDictionary *options = [NSMutableDictionary dictionaryWithCapacity:2];
        [options setValue:[NSNumber numberWithBool:NO] forKey:ACOCaseSensitive];
        [options setValue:nil forKey:ACOUseSourceFont];
        
        _autoCompleter = [[AutocompletionTableView alloc] initWithTextField:self.locationTextField inViewController:self withOptions:options];
        _autoCompleter.autoCompleteDelegate = self;
        _autoCompleter.options = options;

        //_autoCompleter.suggestionsDictionary = [NSArray arrayWithObjects:@"hostel",@"caret",@"carrot",@"house",@"horse", nil];
    }
    return _autoCompleter;
}

- (void)autoCompletion:(AutocompletionTableView *)completer didSelectAutoCompleteSuggestionWithIndex:(NSInteger)index {
    id xx = [completer.suggestionOptions objectAtIndex:index];
	NSLog(@"XXX: %@",xx);
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (textField == self.durationTextField) {
        [self.datePickerView setHidden:NO];
        [self.scrollView setContentOffset:CGPointMake(0, 150) animated:YES];
        NSDate *d = [NSDate date];
        NSCalendar *cal = [NSCalendar currentCalendar];
        NSDateComponents *comp = [cal components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:d];
        [self.datePickerView selectRow:[comp month] - 1 inComponent:0 animated:NO];
        [self.datePickerView selectRow:[comp month] - 1 inComponent:3 animated:NO];
        [self.datePickerView selectRow:[comp day] - 1 inComponent:1 animated:NO];
        [self.datePickerView selectRow:[comp day] inComponent:4 animated:NO];
        [self.datePickerView selectRow:[comp year] - kBaseYear - 1 inComponent:2 animated:NO];
        [self.datePickerView selectRow:[comp year] - kBaseYear - 1 inComponent:5 animated:NO];
		[self.locationTextField resignFirstResponder];
    } else {
        [self.datePickerView setHidden:YES];
        [self.scrollView setContentOffset:CGPointMake(0, 120) animated:YES];
		return YES;
    }
//    [self.scrollView scrollRectToVisible:CGRectMake(0, 200, 320, 100) animated:YES];
	return NO;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
	[self.datePickerView setHidden:YES];
	[self.scrollView setContentOffset:CGPointMake(0, 120) animated:YES];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 6;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    switch (component) {
        case 0:
        case 3:
            return 12;
        case 1:
        case 4:
            return 31;
        case 2:
        case 5:
            return 50;
    }
    return 0;
}


// returns width of column and height of row for each component.
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component; {
    switch (component) {
        case 0:
        case 3:
            return 52;
        case 1:
        case 4:
            return 38;
        case 2:
        case 5:
            return 60;
    }
    return 0;
}

//- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component;

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    switch (component) {
        case 0:
        case 3:
            return [kShortMonths objectAtIndex:row];
        case 1:
        case 4:
            return [NSString stringWithFormat:@"%d", row + 1];
        case 2:
        case 5:
            return [NSString stringWithFormat:@"%d", kBaseYear + row];
    }
    return @"";
}

//- (NSAttributedString *)pickerView:(UIPickerView *)pickerView attributedTitleForRow:(NSInteger)row forComponent:(NSInteger)component NS_AVAILABLE_IOS(6_0); // attributed title is favored if both methods are implemented
//- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view;

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    NSDateComponents *fromComps = [[NSDateComponents alloc] init];
	[fromComps setMonth:[pickerView selectedRowInComponent:0] + 1];
	[fromComps setDay:[pickerView selectedRowInComponent:1] + 1];
	[fromComps setYear:[pickerView selectedRowInComponent:2] + 1];
	NSCalendar *cal = [NSCalendar currentCalendar];
	self.fromDate = [cal dateFromComponents:fromComps];
    NSDateComponents *toComps = [[NSDateComponents alloc] init];
	[toComps setMonth:[pickerView selectedRowInComponent:3] + 1];
	[toComps setDay:[pickerView selectedRowInComponent:4] + 1];
	[toComps setYear:[pickerView selectedRowInComponent:5] + 1];
	self.ToDate = [cal dateFromComponents:toComps];
	[self updateDurationTextField];
}

- (void)updateDurationTextField {
	NSDateFormatter *df = [[NSDateFormatter alloc] init];
	[df setDateStyle:NSDateFormatterShortStyle];
	self.durationTextField.text = [NSString stringWithFormat:@"From %@ To %@", [df stringFromDate:self.fromDate], [df stringFromDate:self.ToDate]];
}

@end
