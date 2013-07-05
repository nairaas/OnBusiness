//
//  Constants.h
//  AtTask
//
//  Created by Naira on 4/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#define MAX_WORKS_COUNT 100

static NSString *const kRESTAPIPath = @"/attask/api";
static NSString *const kRESTAPIVersion = @"v3.0";

static NSString *const kProjectEntityName = @"Project";
static NSString *const kTaskEntityName = @"Task";
static NSString *const kUpdateEntityName = @"Update";
static NSString *const kDocumentEntityName = @"Document";
static NSString *const kUserEntityName = @"User";
static NSString *const kNoteEntityName = @"Note";
static NSString *const kPortfolioEntityName = @"Portfolio";
static NSString *const kPriorityEntityName = @"Priority";
static NSString *const kStatusEntityName = @"Status";

static NSString *const kObjectCodeProject = @"project";
static NSString *const kObjectCodeTask = @"task";
static NSString *const kObjectCodeIssue = @"issue";
static NSString *const kObjectCodeDocument = @"docu";
static NSString *const kObjectCodeAssignment = @"assgn";
static NSString *const kObjectCodeHour = @"hour";
static NSString *const kObjectCodeNote = @"note";
static NSString *const kObjectCodeUser = @"user";
static NSString *const kObjectCodePortfolio = @"portfolio";
static NSString *const kObjectCodeCustomEnum = @"customenum";

static NSString *const kBusinessCallStartNotification = @"BusinessCallStart";
static NSString *const kBusinessCallEndNotification = @"BusinessCallEndtNotification";
static NSString *const kBusinessMethodName = @"BusinessMethodName";

static NSString *const kDataLoadingStartNotification = @"DataLoadingStart";

static const int kMinutesPerHour = 60;
static const int kSecondsPerMinute = 60;
static const int kSecondsPerHour = 3600;

static NSString *const kDaysPerWeek = @"project.mgmt:default.timeline.daysperweek";
static NSString *const kHoursPerDay = @"project.mgmt:default.timeline.hoursperday";
static NSString *const kWeeksPerMonth = @"project.mgmt:default.timeline.weekspermonth";

static NSString *const kEmptyValue = @"N/A";

static NSString *const kLastGroupName = @"other";
static NSInteger const kLastGroupIndex = 3;

static NSString *const kNextWeek = @"nextWeek";
static NSString *const kNext2Week = @"next2Week";
static NSString *const kNextMonth = @"nextMonth";

static NSString *const kCostBasedPerformanceIndexMethod = @"C";

static NSString *const kReceivedProjectKey = @"project";
static NSString *const kReceivedErrorKey = @"error";
static NSString *const kReceivedDataKey = @"data";

static NSString *const kAddCommentAction = @"AddComment";
static NSString *const kViewCommentsAction = @"ViewComments";

static CGFloat const kAvatarBorderWidth = 1;
static NSString *const kBlankSmallAvatarName = @"blank_avatar.png";
static NSString *const kUnassignedSmallAvatarName = @"unassigned_avatar.png";
static NSString *const kBlankMediumAvatarName = @"avatar_blank_38.png";
static NSString *const kUnassignedMediumAvatarName = @"avatar_unassigned_38.png";
static NSString *const kBlankBigAvatarName = @"avatar_blank_48.png";
static NSString *const kUnassignedBigAvatarName = @"avatar_unassigned_48.png";

static NSString *const kPendingApprovalStatusIdentifier = @":A";
static NSString *const kPendingIssuesStatusIdentifier = @":I";
static NSString *const kPendingApprovalStatusLabel = @"Pending Approval";
static NSString *const kPendingIssuesStatusLabel = @"Pending Issues";

static NSString *const kValueKey = @"value";
static NSString *const kLabelKey = @"label";
static NSString *const kBelongsToBaseSetAttributeName = @"belongsToBaseSet";

static NSString *const kRegularFontName = @"HelveticaNeue";
static NSString *const kMediumFontName = @"HelveticaNeue-Medium";
static NSString *const kBoldFontName = @"HelveticaNeue-Bold";

static NSString *const kUsernameID = @"username";
static NSString *const kPasswordID = @"password";
static NSString *const kHostID = @"host";
static NSString *const kCredentialsKey = @"credentials";
static NSString *const kLoggedInKey = @"loggedIn";
