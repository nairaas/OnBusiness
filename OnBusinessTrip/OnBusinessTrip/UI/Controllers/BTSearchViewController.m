//
//  BTSearchViewController.m
//  OnBusinessTrip
//
//  Created by Naira on 6/9/13.
//
//

#import "BTSearchViewController.h"
#import "BTSwitch.h"
#import "UIView+Additions.h"

#import <QuartzCore/QuartzCore.h>

@interface BTSearchViewController ()

@property (nonatomic, strong) IBOutlet UITableViewCell *datingCell;
@property (nonatomic, strong) IBOutlet UITableViewCell *socialCell;
@property (nonatomic, strong) IBOutlet UITableViewCell *genderCell;
@property (nonatomic, strong) IBOutlet UITableViewCell *ageCell;
@property (nonatomic, strong) IBOutlet UITableViewCell *buttonCell;

@property (nonatomic, weak) IBOutlet BTSwitch *datingSwitch;
@property (nonatomic, weak) IBOutlet BTSwitch *socialSwitch;
@property (nonatomic, weak) IBOutlet UISegmentedControl *genderSegmentedControl;

@property (nonatomic, weak) IBOutlet UITextField *agefromTextField;
@property (nonatomic, weak) IBOutlet UITextField *ageToTextField;

@property (nonatomic, strong) IBOutlet UITableViewCell *searchButtonCell;
@property (nonatomic, strong) IBOutlet UITableViewCell *emptyCell;
@property (nonatomic, weak) IBOutlet UIButton *searchButton;

@property (nonatomic, weak) IBOutlet UINavigationBar *navBar;

@end

@implementation BTSearchViewController

@synthesize datingSwitch = _datingSwitch;
@synthesize socialSwitch = _socialSwitch;
@synthesize searchButtonCell = _searchButtonCell;
@synthesize navBar = _navBar;
@synthesize searchButton = _searchButton;

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
    [self.datingSwitch setBackgroundImage:[UIImage imageNamed:@"switch_bg.png"]];
    [self.datingSwitch setThumbnailImage:[UIImage imageNamed:@"search_dating_but.png"]];
    [self.socialSwitch setBackgroundImage:[UIImage imageNamed:@"switch_bg.png"]];
    [self.socialSwitch setThumbnailImage:[UIImage imageNamed:@"search_social_but.png"]];
	[self.genderSegmentedControl setBackgroundImage:[UIImage imageNamed:@"gender_bg.png"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
	[self.genderSegmentedControl setDividerImage:[UIImage imageNamed:@"transparent.png"] forLeftSegmentState:UIControlStateSelected rightSegmentState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
	[self.genderSegmentedControl setDividerImage:[UIImage imageNamed:@"transparent.png"] forLeftSegmentState:UIControlStateNormal rightSegmentState:UIControlStateSelected barMetrics:UIBarMetricsDefault];
//	[self.genderSegmentedControl setDividerImage:[UIImage imageNamed:@"search_man_selected.png"] forLeftSegmentState:UIControlStateNormal rightSegmentState:UIControlStateSelected barMetrics:UIBarMetricsDefault];
	[self.genderSegmentedControl setHeight:29];
//	[self.genderSegmentedControl setImage:[UIImage imageNamed:@"search_woman_selected.png"] forSegmentAtIndex:0];
//	[self.genderSegmentedControl setTitle:@"WoMen" forSegmentAtIndex:0];
//	[self.genderSegmentedControl setTitle:@"Men" forSegmentAtIndex:1];
//	[self.genderSegmentedControl setImage:[UIImage imageNamed:@"search_man_selected.png"] forSegmentAtIndex:1];
//    UIImage *img = [UIImage imageNamed:@"search_top_bar_gb.png"];
    [self.searchButton.titleLabel setOrigin:CGPointMake((self.searchButton.titleLabel.frame.origin.x -1),
                                                        (self.searchButton.titleLabel.frame.origin.y - 5))];
    [self.agefromTextField.layer setBorderWidth:1.0];
    [self.agefromTextField.layer setBorderColor:[[UIColor darkGrayColor] CGColor]];
    [self.agefromTextField.layer setCornerRadius:10];
    [self.ageToTextField.layer setBorderWidth:1.0];
    [self.ageToTextField.layer setBorderColor:[[UIColor darkGrayColor] CGColor]];
    [self.ageToTextField.layer setCornerRadius:10];
    [self.socialSwitch setOn:YES];
    [self.datingSwitch setOn:YES];
//     setX:(self.searchButton.titleLabel.frame.origin.x - 7)];
//    [self.navBar setBackgroundImage:[img resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)] forBarMetrics:UIBarMetricsDefault];
	// Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    UIImage *img = [[UINavigationBar appearance] backgroundImageForBarMetrics:UIBarMetricsDefault];
    NSLog(@"222: %@", img);
//    [self.searchButton.titleLabel setY:(self.searchButton.titleLabel.frame.origin.y - 7)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 7;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 4) {
        return 120;
    }
    return 60;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
//    return self.tableFooterView.frame.size.height;
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    switch (indexPath.row) {
        case 0:
            cell = self.datingCell;
            break;
        case 1:
            cell = self.socialCell;
            break;
        case 2:
            cell = self.genderCell;
            break;
        case 3:
            cell = self.ageCell;
            break;
        case 4:
            cell = self.searchButtonCell;
            break;
        case 5:
        case 6:
            cell = self.emptyCell;
            break;
        default:
            break;
    }
    return cell;
}

//- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
//    return self.tableFooterView;
//}
//
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.agefromTextField resignFirstResponder];
    [self.ageToTextField resignFirstResponder];
}

- (IBAction)genderSelected:(UISegmentedControl *)sender {
	if (sender.selectedSegmentIndex == 0) {
		[self.genderSegmentedControl setImage:[UIImage imageNamed:@"search_women_selected.png"] forSegmentAtIndex:0];
		[self.genderSegmentedControl setImage:nil forSegmentAtIndex:1];
//		[self.genderSegmentedControl insertSegmentWithTitle:@"Women" atIndex:0 animated:YES];
	} else {
		[self.genderSegmentedControl setImage:[UIImage imageNamed:@"search_men_selected.png"] forSegmentAtIndex:1];
		[self.genderSegmentedControl setImage:nil forSegmentAtIndex:0];
	}
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
//    [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0] animated:YES scrollPosition:UITableViewScrollPositionTop];
//    [self.tableView scrollToNearestSelectedRowAtScrollPosition:UITableViewScrollPositionTop animated:YES];
//    self.tableView scro
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0] atScrollPosition:UITableViewScrollPositionNone animated:NO];
    [self.tableView reloadData];

    return NO;
    
}

@end
