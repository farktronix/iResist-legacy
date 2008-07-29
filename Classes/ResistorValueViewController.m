//
//  ResistorValueViewController.m
//  iResist
//
//  Created by Jacob Farkas on 7/27/08.
//  Copyright 2008 Flying Monkey Enterprises. All rights reserved.
//

#import "ResistorValueViewController.h"
#import "ResistorColorPicker.h"

@implementation ResistorValueViewController

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

- (void) _updateOhmsStringForSelectedComponents:(NSArray *)components
{
    // be ye warned: there be rounding errors ahead. there be pirate booty awarded to he
    // who can write a better prettyprinter
    double ohms = (([[components objectAtIndex:0] intValue] - 1) * 10) + ([[components objectAtIndex:1] intValue] - 1);
    NSUInteger mult = ([[components objectAtIndex:2] intValue] - 1);
    
    if (mult < 7) {
        ohms *= pow(10, mult);
    } 
    else if (mult == 7) {
        ohms *= 0.1;
    } 
    else if (mult == 8) {
        ohms *= 0.01;
    }
    
    if (ohms < 1000) {
        _ohms.text = [NSString stringWithFormat:(ohms < 1 ? @"%.2f Ω" : (ohms < 10 ? @"%.1f Ω" : @"%.0f Ω")), ohms];
    }
    else if (ohms < 1000000) {
        _ohms.text = [NSString stringWithFormat:@"%.1f KΩ", ohms/1000.0];
    }
    else if (ohms < 1000000000) {
        _ohms.text = [NSString stringWithFormat:@"%.1f MΩ", ohms/1000000.0];
    }
    else {
        _ohms.text = [NSString stringWithFormat:@"%.1f GΩ", ohms/1000000000.0];
    }
}

- (void) _updateToleranceStringForSelectedComponents:(NSArray *)components
{
    NSUInteger tol = ([[components objectAtIndex:3] intValue] - 1);
    float tolPercent = 0.0f;
    
    switch (tol) {
        case 1:		// brown, 1%
        case 2:		// red, 2%
            tolPercent = (float)tol;
            break;
            
        case 3:		// green, 0.5%
            tolPercent = 0.5f;
            break;
            
        case 4:		// blue, 0.25%
            tolPercent = 0.25f;
            break;
            
        case 5:		// violet, 0.10%
            tolPercent = 0.10f;
            break;
            
        case 6:		// grey, 0.05%
            tolPercent = 0.05f;
            break;
            
        case 7:		// gold
            tolPercent = 5;
            break;
            
        case 8:		// silver
            tolPercent = 10;
            break;
    }
    
    if (tolPercent)
    {
        _tolerance.text = [NSString stringWithFormat: @"±%.2f%%", tolPercent];
    }    
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
	id tView = nil;
	
	if (img && component < [_colorBars count] && ![[_colorBars objectAtIndex: component] isKindOfClass: [NSNull class]])
	{
		tView = [_colorBars objectAtIndex: component];
		[_colorBars removeObjectAtIndex: component];
		[tView removeFromSuperview];
		[tView release];
	}
	
	tView = [[UIImageView alloc] initWithImage: img];
	((UIView*)tView).frame = cBarRect;
	[_colorBars insertObject:tView atIndex:component];
	[self.view addSubview: tView];
}

- (void) _resistorValueChanged:(NSNotification *)notif
{
    NSArray *components = [[NSUserDefaults standardUserDefaults] valueForKey:@"components"];
    if ([components count] < 4) {
        NSLog(@"Error: not enough components have been selected!");
        return;
    }
    [self _updateOhmsStringForSelectedComponents:components];
    [self _updateToleranceStringForSelectedComponents:components];
    
    int component = 0;
    for (NSNumber *rowNum in components) {
        [self _drawResistorBarWithColorName:[ResistorColorPicker colorNameForRow:([rowNum intValue] - 1) inComponent:component] andComponent:component];
        component++;
    }
}

- (IBAction) _expandButtonPressed: (id) sender;
{
	_searchBar.hidden = !_searchBar.hidden;
    CGFloat searchBarHeight = 25.0 * (_searchBar.hidden ? -1 : 1);
    _resistor.frame = CGRectMake(_resistor.frame.origin.x, _resistor.frame.origin.y + searchBarHeight, _resistor.frame.size.width, _resistor.frame.size.height);
    _ohms.frame = CGRectMake(_ohms.frame.origin.x, _ohms.frame.origin.y + searchBarHeight, _ohms.frame.size.width, _ohms.frame.size.height);
    _tolerance.frame = CGRectMake(_tolerance.frame.origin.x, _tolerance.frame.origin.y + searchBarHeight, _tolerance.frame.size.width, _tolerance.frame.size.height);
    
    if (_searchBar.hidden) {
        [_searchBar resignFirstResponder];
    }
    
    [self _resistorValueChanged:nil];
}

//// search bar delegate functions
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
	[searchBar resignFirstResponder];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar;
{
	_searchBar.hidden = YES;
	
	[searchBar resignFirstResponder];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar;
{
	[searchBar resignFirstResponder];
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
        if ([searchText length]) {
            _searchBar.text = [[searchText stringByTrimmingCharactersInSet:invalidChars] stringByReplacingOccurrencesOfString:@".." withString:@"."];
        }
        if ([_searchBar.text length] > 8) {
            _searchBar.text = [_searchBar.text substringToIndex:8];
        }
        _updatingText = NO;
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SearchTextChanged" object:nil userInfo:[NSDictionary dictionaryWithObject:searchText forKey:@"SearchText"]];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	// Return YES for supported orientations
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void) viewDidLoad
{
    _searchBar.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
//    _searchBar.returnKeyType = UIReturnKeyDone;
    _searchBar.delegate = self;

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_resistorValueChanged:) name:kResistorValueChangedNotification object:nil];
    [self _resistorValueChanged:nil];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    for (UITouch *touch in touches) {
        if (![_searchBar hitTest:[touch locationInView:self.view] withEvent:event]) {
            [_searchBar resignFirstResponder];
        }
    }
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
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
	[super dealloc];
}


@end
