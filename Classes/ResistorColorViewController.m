//
//  ResistorColorViewController.m
//  iResist
//
//  Created by Jacob Farkas on 7/27/08.
//  Copyright 2008 Flying Monkey Enterprises. All rights reserved.
//

#import "ResistorColorViewController.h"
#import "ResistorColorPicker.h"

@implementation ResistorColorViewController

@synthesize searchBar = _searchBar;

#pragma mark -
#pragma mark Resistor Display

- (void) _updateToleranceString:(double)tolerance
{
    _tolerance.text = [NSString stringWithFormat: @"±%.2f%%", tolerance];    
}

- (void) _drawResistorColorBarForComponent:(NSInteger)component withInfo:(NSDictionary *)info
{
    UIView *barView = nil;
    switch (component) {
        case kColorTensComponent:
            barView = _tensBar;
            break;
        case kColorOnesComponent:
            barView = _onesBar;
            break;
        case kColorMultiplierComponent:
            barView = _multiplierBar;
            break;
        case kColorToleranceComponent:
            barView = _toleranceBar;
            break;
        default:
            DebugLog(@"We were asked to update the resistor bar for an invalid component: %d", component);
            break;
    }
    
    barView.backgroundColor = [info objectForKey:kColorColorKey];
}

- (void) _resistorValueChanged:(NSNotification *)notif
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSNumber *ohmsNum = [defaults valueForKey:kOhmsKey];
    NSNumber *toleranceNum = [defaults valueForKey:kToleranceKey];
    double ohms = 0.0;
    double tolerance = 0.0;
    if (ohmsNum) ohms = [ohmsNum doubleValue];
    if (toleranceNum) tolerance = [toleranceNum doubleValue];
    _ohms.text = prettyPrintOhms(ohms);
    [self _updateToleranceString:tolerance];
    
    for (int component = kColorTensComponent; component <= kColorToleranceComponent; component++) {
        [self _drawResistorColorBarForComponent:component withInfo:[ResistorColorPicker itemInfoForRow:[_picker selectedRowInComponent:component] inComponent:component]];
    }
}

#pragma mark -
#pragma mark Search Bar

- (void) _toggleSearchBar
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationTransition:_searchBar.hidden == YES ? UIViewAnimationTransitionCurlDown : UIViewAnimationTransitionCurlUp forView:_searchBar cache:YES];
    _searchBar.hidden = !_searchBar.hidden;
    CGFloat searchBarHeight = 25.0 * (_searchBar.hidden ? -1 : 1);
    CGRect contentFrame = _contentView.frame; 
    contentFrame.origin.y += searchBarHeight;
    contentFrame.size.height -= searchBarHeight;
    _contentView.frame = contentFrame;
    
    if (_searchBar.hidden) {
        [_searchBar resignFirstResponder];
		_scrollView.pageControlEnabled = YES;
    } else {
        [_searchBar becomeFirstResponder];
		_scrollView.pageControlEnabled = NO;
    }
    
    [self _resistorValueChanged:nil];
    [UIView commitAnimations];
}

- (IBAction) _expandButtonPressed: (id) sender;
{
    [self _toggleSearchBar];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self _toggleSearchBar];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar;
{
	[self _toggleSearchBar];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar;
{
	[self _toggleSearchBar];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    static BOOL _updatingText;
    static NSCharacterSet *invalidChars = nil;
    
    if (invalidChars == nil) {
        invalidChars = [[[NSCharacterSet characterSetWithCharactersInString:@"0123456789."] invertedSet] retain];
    }
    
    if (_updatingText == NO) {
        _updatingText = YES;
        if ([_searchBar.text doubleValue] == 0.0 && [_searchBar.text length] > 3) {
            _searchBar.text = [_searchBar.text substringToIndex:[_searchBar.text length] - 1];
        }
        
        if ([_searchBar.text length]) {
            _searchBar.text = [[_searchBar.text stringByTrimmingCharactersInSet:invalidChars] stringByReplacingOccurrencesOfString:@".." withString:@"."];
        }
        if ([_searchBar.text doubleValue] > 99000000000.0) {
            _searchBar.text = [_searchBar.text substringToIndex:[_searchBar.text length] - 1];
        }
        
        DebugLog(@"Search bar updated to %@ (%f)", _searchBar.text, [_searchBar.text doubleValue]);
        [[NSUserDefaults standardUserDefaults] setValue:[NSNumber numberWithDouble:[_searchBar.text doubleValue]] forKey:kOhmsKey]; 
        [[NSNotificationCenter defaultCenter] postNotificationName:kResistorValueChangedNotification object:nil];
        
        _updatingText = NO;
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    for (UITouch *touch in touches) {
        if (_searchBar.hidden == NO && ![_searchBar hitTest:[touch locationInView:self.view] withEvent:event]) {
            [self _toggleSearchBar];
        }
    }
}

#pragma mark -
#pragma mark Color Picker

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:kShowLabelsKey]) {
        [(ResistorColorPicker*)_scrollView.currentValuePicker setShowLabels:[[NSUserDefaults standardUserDefaults] boolForKey:kShowLabelsKey]];
        for (int component = kColorTensComponent; component <= kColorToleranceComponent; component++) {
            [_picker reloadComponent:component];
        }
    }
}

#pragma mark -
#pragma mark Setup/Teardown

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	// Return YES for supported orientations
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)viewDidDisappear:(BOOL)animated
{
    if (_searchBar.hidden == NO) {
        [self _toggleSearchBar];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [self _resistorValueChanged:nil];
}

- (void) viewDidLoad
{
    _searchBar.keyboardType = UIKeyboardTypeNumberPad;
    _searchBar.delegate = self;

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_resistorValueChanged:) name:kResistorValueChangedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_resistorValueChanged:) name:kResistorPickerChangedNotification object:nil];
    
    [[NSUserDefaults standardUserDefaults] addObserver:self forKeyPath:kShowLabelsKey options:0 context:nil];
}

@end
