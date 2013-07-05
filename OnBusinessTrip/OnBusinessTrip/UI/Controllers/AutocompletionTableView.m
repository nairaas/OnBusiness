//
//  AutocompletionTableView.m
//
//  Created by Gushin Arseniy on 11.03.12.
//  Copyright (c) 2012 Arseniy Gushin. All rights reserved.
//

#import "AutocompletionTableView.h"

@interface AutocompletionTableView () 
@property (nonatomic, strong) NSArray *suggestionOptions; // of selected NSStrings 
@property (nonatomic, strong) UITextField *textField; // will set automatically as user enters text
@property (nonatomic, strong) UIFont *cellLabelFont; // will copy style from assigned textfield

@property (nonatomic, strong) BTGooglePlacesConnector *googleConnector;

@end

@implementation AutocompletionTableView

@synthesize suggestionsDictionary = _suggestionsDictionary;
@synthesize suggestionOptions = _suggestionOptions;
@synthesize textField = _textField;
@synthesize cellLabelFont = _cellLabelFont;
@synthesize options = _options;
@synthesize googleConnector = _googleConnector;

#pragma mark - Initialization
- (UITableView *)initWithTextField:(UITextField *)textField inViewController:(UIViewController *) parentViewController withOptions:(NSDictionary *)options
{
    //set the options first
    self.options = options;
    
    // frame must align to the textfield 
    CGRect frame = CGRectMake(textField.frame.origin.x, textField.frame.origin.y+textField.frame.size.height, textField.frame.size.width, 120);
    
    // save the font info to reuse in cells
    self.cellLabelFont = textField.font;
    
    self = [super initWithFrame:frame
             style:UITableViewStylePlain];
    _textField = textField;
    self.delegate = self;
    self.dataSource = self;
    self.scrollEnabled = YES;
    
    // turn off standard correction
    textField.autocorrectionType = UITextAutocorrectionTypeNo;
    
    // to get rid of "extra empty cell" on the bottom
    // when there's only one cell in the table
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, textField.frame.size.width, 1)]; 
    v.backgroundColor = [UIColor clearColor];
    [self setTableFooterView:v];
    self.hidden = YES;  
    [textField.superview addSubview:self];

    return self;
}

#pragma mark - Logic staff
- (BOOL) substringIsInDictionary:(NSString *)subString
{
    NSMutableArray *tmpArray = [NSMutableArray array];
    NSRange range;
    
//    if (_autoCompleteDelegate && [_autoCompleteDelegate respondsToSelector:@selector(autoCompletion:suggestionsFor:)]) {
//        self.suggestionsDictionary = [_autoCompleteDelegate autoCompletion:self suggestionsFor:subString];
//    }
    [self getLocationsFor:subString];
    return NO;
}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.suggestionOptions.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *AutoCompleteRowIdentifier = @"AutoCompleteRowIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:AutoCompleteRowIdentifier];
    if (cell == nil) 
    {
        cell = [[UITableViewCell alloc] 
                 initWithStyle:UITableViewCellStyleDefault reuseIdentifier:AutoCompleteRowIdentifier];
    }
    
    if ([self.options valueForKey:ACOUseSourceFont]) 
    {
        cell.textLabel.font = [self.options valueForKey:ACOUseSourceFont];
    } else 
    {
        cell.textLabel.font = self.cellLabelFont;
    }
    cell.textLabel.adjustsFontSizeToFitWidth = NO;
    NSDictionary *d = [self.suggestionOptions objectAtIndex:indexPath.row];
    cell.textLabel.text = [d objectForKey:@"description"];

    return cell;
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 30;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *d = [self.suggestionOptions objectAtIndex:indexPath.row];
    [self.textField setText:[d objectForKey:@"description"]];
    NSLog(@"Selected: %@", d);
    if (_autoCompleteDelegate && [_autoCompleteDelegate respondsToSelector:@selector(autoCompletion:didSelectAutoCompleteSuggestionWithIndex:)]) {
        [_autoCompleteDelegate autoCompletion:self didSelectAutoCompleteSuggestionWithIndex:indexPath.row];
    }

    [self hideOptionsView];
}

#pragma mark - UITextField delegate
- (void)textFieldValueChanged:(UITextField *)textField
{
//    self.textField = textField;
    NSString *curString = textField.text;
    
    if (![curString length])
    {
        [self hideOptionsView];
        return;
    } else if ([self substringIsInDictionary:curString])
        {
            [self showOptionsView];
            [self reloadData];
        } else [self hideOptionsView];
}

#pragma mark - Options view control
- (void)showOptionsView
{
    self.hidden = NO;
}

- (void) hideOptionsView
{
    self.hidden = YES;
}

- (void)getLocationsFor:(NSString *)str {
    [self.googleConnector loadPlacesWithName:str];
}

- (BTGooglePlacesConnector *)googleConnector {
    if (!_googleConnector) {
        _googleConnector = [[BTGooglePlacesConnector alloc] init];
        _googleConnector.delegate = self;
    }
    return _googleConnector;
}

- (void)connector:(BTGooglePlacesConnector *)connector didRecieveData:(NSArray *)data {
//    NSLog(@"ddd: %@", data);
    self.suggestionOptions = data;
    [self reloadData];
    if ([data count] > 0) {
        [self showOptionsView];
    } else {
        [self hideOptionsView];
    }
    NSLog(@"2222: %@", self);
    NSLog(@"ppp: %@", self.superview);
    
//    for (NSDictionary *d in data) {
//        range = ([[self.options valueForKey:ACOCaseSensitive] isEqualToNumber:[NSNumber numberWithInt:1]]) ?
//                    [tmpString rangeOfString:subString] :
//                    [tmpString rangeOfString:subString options:NSCaseInsensitiveSearch];
//        if (range.location != NSNotFound) [tmpArray addObject:tmpString];
//    }
//    if ([tmpArray count]>0)
//    {
//        self.suggestionOptions = tmpArray;
//        return YES;
//    }
//
//    }
//    for (NSString *tmpString in self.suggestionsDictionary)
//    {
//        range = ([[self.options valueForKey:ACOCaseSensitive] isEqualToNumber:[NSNumber numberWithInt:1]]) ? [tmpString rangeOfString:subString] : [tmpString rangeOfString:subString options:NSCaseInsensitiveSearch];
//        if (range.location != NSNotFound) [tmpArray addObject:tmpString];
//    }
//    if ([tmpArray count]>0)
//    {
//        self.suggestionOptions = tmpArray;
//        return YES;
//    }
}

@end
