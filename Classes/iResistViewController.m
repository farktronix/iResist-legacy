//
//  iResistAppDelegate.m
//  iResist
//
//  Created by Jacob Farkas on 7/10/08.
//  Copyright Apple Computer 2008. All rights reserved.
//

#import "iResistViewController.h"

CFStringRef g_AppIDString = (CFStringRef)@"us.seph.iResist";

@implementation iResistViewController

- (void) _loadBarImages;
{
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

// This is called from -[ResistorColorPicker _drawResistorBarWithColorName], because it calculates the correct
// CGRect... horrible way to do it, I know, but on first writing it seemed like the way to go.
- (void) _drawResistorBarWithColor: (NSString*)color atRect: (CGRect)rect withTag: (int)tag;
{
	UIImage* img = [_barImages valueForKey: color];	
	id tView = nil;
	
	if (img && tag < [_colorBars count] && ![[_colorBars objectAtIndex: tag] isKindOfClass: [NSNull class]])
	{
		tView = [_colorBars objectAtIndex: tag];
		[_colorBars removeObjectAtIndex: tag];
		[tView removeFromSuperview];
		[tView release];
	}
	
	tView = [[UIImageView alloc] initWithImage: img];
	((UIView*)tView).frame = rect;
	[_colorBars insertObject:tView atIndex:tag];
	[self.view addSubview: tView];
}

- (void) viewDidLoad
{
	[self _loadBarImages];
	
	UIAccelerometer* sAccel = [UIAccelerometer sharedAccelerometer];
	sAccel.updateInterval = 0.5;
	sAccel.delegate = self;
	
	NSNull* n = [NSNull null];
	_colorBars = [[NSMutableArray alloc] initWithObjects: n, n, n, n, nil];
	_searchBar.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
	
	int compRows[4] = {5, 3, 1, 1};
	int count = 0;
	NSString* tmpVal = nil;
	
	if (tmpVal = (NSString*)CFPreferencesCopyAppValue((CFStringRef)@"ohms", g_AppIDString))
	{
		[_colorPicker setOhmsText: tmpVal];
		CFRelease(tmpVal);
	}
	
	if (tmpVal = (NSString*)CFPreferencesCopyAppValue((CFStringRef)@"tolerance", g_AppIDString))
	{
		[_colorPicker setToleranceText: tmpVal];
		CFRelease(tmpVal);
	}
	
	for (; count < 4; count++)
	{
		if (tmpVal = (NSString*)CFPreferencesCopyAppValue((CFStringRef)[NSString stringWithFormat:@"%d", count], g_AppIDString))
		{
			compRows[count] = [(NSString*)tmpVal intValue];
			CFRelease(tmpVal);
		}
		
		[_colorPickerView selectRow:compRows[count] inComponent:count animated:YES];
		
		NSString* rowTitle = [_colorPicker pickerView: _colorPickerView titleForRow: compRows[count] forComponent: count];
		[_colorPicker _drawResistorBarWithColorName: rowTitle andComponent: count];
	}
}
 
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	// Return YES for supported orientations
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
	// Release anything that's not essential, such as cached data
}


- (void)dealloc {
	[_colorBars release];
	[_barImages release];
	[super dealloc];
}


- (void) _doRandomSpin;
{
	for (int i = 0; i < 3; i++)
	{
		[_colorPicker _randomSpin: _colorPickerView];
	}
}


- (IBAction) _expandButtonPressed: (id) sender;
{
	//_searchBar.hidden = NO;	
	//_expandSearchButton.enabled = NO;
	//_expandSearchButton.hidden = YES;
	[self _doRandomSpin];
}


//// accel delegate
- (void)accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acc
{
	float add = (acc.y < 0 ? -acc.y : acc.y) + (acc.x < 0 ? -acc.x : acc.x) + (acc.z < 0 ? -acc.z : acc.z);
	
	if (add > 5.0)
	{
		[self _doRandomSpin];
	}
}

//// search bar delegate functions
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
	[searchBar resignFirstResponder];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar;
{
	_searchBar.hidden = YES;	
	_expandSearchButton.enabled = YES;
	_expandSearchButton.hidden = NO;
	
	[searchBar resignFirstResponder];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar;
{
	[searchBar resignFirstResponder];
}
@end
