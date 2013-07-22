//
//  BTMatchesViewController.m
//  OnBusinessTrip
//
//  Created by Naira on 4/27/13.
//
//

#import "BTMatchesViewController.h"
#import "BTProfileViewController.h"
#import "BTUserView.h"
#import "BTGuestMatchesOperation.h"

@interface BTMatchesViewController ()

@property (nonatomic, weak) IBOutlet UICollectionView *matchesCollectionView;

@end

@implementation BTMatchesViewController

@synthesize matchesCollectionView = _matchesCollectionView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    UIImage *navBarBg = [UIImage imageNamed:@"nav_bar_bg.png"];
	[self.navigationController.navigationBar setBackgroundImage:navBarBg forBarMetrics:UIBarMetricsDefault];
//	NSDictionary *location = [NSDictionary dictionaryWithObjectsAndKeys:@"The Netherlands", @"country", @"Amsterdam", @"city", nil];
	NSDictionary *trip = [NSDictionary dictionaryWithObjectsAndKeys:@"2013-06-20T00:00:00", @"startDate", @"2013-06-25T00:00:00", @"endDate", nil]; //]location, @"location", nil];

	BTGuestMatchesOperation *op = [[BTGuestMatchesOperation alloc] initWithTrip:trip successSel:@selector(searchSucceeded:) failureSel:@selector(searchFailedWithError:) target:self];
	//    BTAppDelegate *del = (BTAppDelegate *)[[UIApplication sharedApplication] delegate];
	[[ATNetworkOperationManager sharedInstance] submitNetworkOperation:op];
}

- (void)viewWillAppear:(BOOL)animated {
    UIImage *navBarBg = [UIImage imageNamed:@"nav_bar_bg.png"];
	[self.navigationController.navigationBar setBackgroundImage:navBarBg forBarMetrics:UIBarMetricsDefault];
}

- (void)changeView  {
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)switchView:(id)sender {
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:1.0];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.navigationController.view cache:YES];
    [UIView commitAnimations];
//    [self performSelector:@selector(startAnimateLoadingView) withObject:nil afterDelay:1.0];
//    TeamBean * teamToShow = ([self team] == nil ? [[teamRequestCounts allKeys] objectAtIndex:0] : nil);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Make sure your segue name in storyboard is the same as this line
    if ([[segue identifier] isEqualToString:@"YOUR_SEGUE_NAME_HERE"])
    {
        // Get reference to the destination view controller
        BTProfileViewController *vc = [segue destinationViewController];
        
        // Pass any objects to the view controller here, like...
//        [vc setMyObjectHere:object];
    }
}

/*
*/

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 2;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    BTUserView *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"mmm" forIndexPath:indexPath];

//    BTUserView *uv = [[BTUserView alloc] init];
    NSDictionary *user = [NSDictionary dictionaryWithObjectsAndKeys:@"1", @"social", @"1", @"dating",nil];
    [cell setUser:user];
    return cell;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
}

//- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath;

- (void)searchSucceeded:(id)result {
    NSLog(@"Result: %@", result);
    NSLog(@"111: %@", self.navigationController);
}

- (void)searchFailedWithError:(NSError *)error {
    NSLog(@"Errorrrrr: %@", error);
}

@end