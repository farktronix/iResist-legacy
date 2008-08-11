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

@synthesize picker = _picker;
@synthesize searchBar = _searchBar;

#pragma mark -
#pragma mark Ohm Display

- (void) _updateOhmsString:(double)ohms
{
    int exp = (int)log10(ohms);
    double displayOhms = ohms;
    
    if (ohms < 1.0) {
        displayOhms = ((int)(ohms * 100) / 100.0);
    }
    else if (ohms < 10) {
        displayOhms = ((int)(ohms * 10) / 10.0);
    } 
    else {
        double power = pow(10, exp - 1);
        displayOhms = ((int)(ohms / power) * power);  
    }
    
    if (ohms < 1000) {
        _ohms.text = [NSString stringWithFormat:(ohms < 1 ? @"%.2f Ω" : (ohms < 10 ? @"%.1f Ω" : @"%.0f Ω")), displayOhms];
    }
    else if (ohms < 1000000) {
        _ohms.text = [NSString stringWithFormat:@"%.1f KΩ", displayOhms/1000.0];
    }
    else if (ohms < 1000000000) {
        _ohms.text = [NSString stringWithFormat:@"%.1f MΩ", displayOhms/1000000.0];
    }
    else {
        _ohms.text = [NSString stringWithFormat:@"%.1f GΩ", displayOhms/1000000000.0];
    }
}

- (void) _updateToleranceString:(double)tolerance
{
    _tolerance.text = [NSString stringWithFormat: @"±%.2f%%", tolerance];    
}

// This method is only tasked with calculating the correct CGRect for a color bar;
// currently it's obviously done "by hand," but the idea was that since this class has
// the ref to _resistor (the UIImageView), it should calculate rects programmatically. Should.
- (void) _drawResistorBarWithColorName: (NSString*)color andComponent: (int)component;
{	
    CGRect cBarRect = _resistor.frame;
    cBarRect.size.width = 10;
    cBarRect.size.height = 48.0;
    if ((component % 3) == 0) cBarRect.size.width += 3;
    cBarRect.origin.x += 128.0 + (20 * component);
    if (component == 0) cBarRect.origin.x -= 5.0;
    if (component == 3) cBarRect.origin.x += 5.0;
    
	UIImage* img = [_barImages valueForKey: color];	
	UIImageView *bView = nil;
	
	if (img && component < [_colorBars count])
	{
		id existingBar = [_colorBars objectAtIndex: component];
		
		// if there was a color we need to replace, remove it from the superview
		if ((NSNull *)existingBar != [NSNull null] && [((UIImageView *)existingBar).image isEqual:img]) {
            bView = existingBar;
        } else {
			if ((NSNull *)existingBar != [NSNull null]) {
                [(UIView *)existingBar removeFromSuperview];
            }
            [existingBar release];
            bView = [[UIImageView alloc] initWithImage:img];
            [_colorBars replaceObjectAtIndex:component withObject:bView];
            [self.view insertSubview:bView belowSubview:_searchBar];
		}
		
        bView.frame = cBarRect;
	}
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
    [self _updateOhmsString:ohms];
    [self _updateToleranceString:tolerance];
    
    for (int ii = 0; ii < 4; ii++) {
        [self _drawResistorBarWithColorName:[ResistorColorPicker colorNameForRow:([_picker selectedRowInComponent:ii] - 1) inComponent:ii] andComponent:ii];
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
    _resistor.frame = CGRectMake(_resistor.frame.origin.x, _resistor.frame.origin.y + searchBarHeight, _resistor.frame.size.width, _resistor.frame.size.height);
    _ohms.frame = CGRectMake(_ohms.frame.origin.x, _ohms.frame.origin.y + searchBarHeight, _ohms.frame.size.width, _ohms.frame.size.height);
    _tolerance.frame = CGRectMake(_tolerance.frame.origin.x, _tolerance.frame.origin.y + searchBarHeight, _tolerance.frame.size.width, _tolerance.frame.size.height);
    
    if (_searchBar.hidden) {
        [_searchBar resignFirstResponder];
    } else {
        [_searchBar becomeFirstResponder];
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
        if ([_searchBar.text doubleValue] > 99000000.0) {
            _searchBar.text = [_searchBar.text substringToIndex:[_searchBar.text length] - 1];
        }
        
        NSLog(@"Search bar updated to %@ (%f)", _searchBar.text, [_searchBar.text doubleValue]);
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
#pragma mark Setup/Teardown

- (void) _loadBarImages;
{
    // this could probably all be done with gradients instead of images...
	NSMutableDictionary *bi =  [[NSMutableDictionary alloc] init];
	
	[bi setObject:[UIImage imageNamed:@"black.png"]		forKey:@"black"];
	[bi setObject:[UIImage imageNamed:@"blue.png"]		forKey:@"blue"];
	[bi setObject:[UIImage imageNamed:@"brown.png"]		forKey:@"brown"];
	[bi setObject:[UIImage imageNamed:@"gold.png"]		forKey:@"gold"];
	[bi setObject:[UIImage imageNamed:@"gray.png"]		forKey:@"gray"];
	[bi setObject:[UIImage imageNamed:@"green.png"]		forKey:@"green"];
	[bi setObject:[UIImage imageNamed:@"orange.png"]	forKey:@"orange"];
	[bi setObject:[UIImage imageNamed:@"red.png"]		forKey:@"red"];
	[bi setObject:[UIImage imageNamed:@"silver.png"]	forKey:@"silver"];
	[bi setObject:[UIImage imageNamed:@"violet.png"]	forKey:@"violet"];
	[bi setObject:[UIImage imageNamed:@"white.png"]		forKey:@"white"];
	[bi setObject:[UIImage imageNamed:@"yellow.png"]	forKey:@"yellow"];
	
	_barImages = (NSDictionary*)bi;
}

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

- (void) viewDidLoad
{
    _searchBar.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
//    _searchBar.returnKeyType = UIReturnKeyDone;
    _searchBar.delegate = self;

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_resistorValueChanged:) name:kResistorValueChangedNotification object:nil];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
	if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        NSNull* n = [NSNull null];
        _colorBars = [[NSMutableArray alloc] initWithObjects: n, n, n, n, nil];
        
        [self _loadBarImages];
	}
	return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [_colorBars release];
    [_barImages release];
    [_picker release];
	[super dealloc];
}


@end
