//
//  iResistAppDelegate.m
//  iResist
//
//  Created by Jacob Farkas on 7/10/08.
//  Copyright Apple Computer 2008. All rights reserved.
//

#import "iResistViewController.h"

@implementation iResistViewController

- (void) _drawResistorBarWithColor: (UIColor*)color atRect: (CGRect)rect withTag: (int)tag;
{
	id tView = nil;
	
	if (tag < [_colorBars count] && ![[_colorBars objectAtIndex: tag] isKindOfClass: [NSNull class]])
	{
		tView = [_colorBars objectAtIndex: tag];
		[_colorBars removeObjectAtIndex: tag];
		[tView removeFromSuperview];
		[tView release];
	}
	
	tView = [[_colorPicker _colorViewWithRect:rect andColor:color] retain];
	[_colorBars insertObject:tView atIndex:tag];
	[self.view addSubview: tView];
}

- (void) viewDidLoad
{
	UIAccelerometer* sAccel = [UIAccelerometer sharedAccelerometer];
	sAccel.updateInterval = 0.5;
	sAccel.delegate = self;
	
	NSNull* n = [NSNull null];
	_colorBars = [[NSMutableArray alloc] initWithObjects: n, n, n, n, nil];
	_searchBar.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
	
    [_colorPickerView selectRow:5 inComponent:0 animated:YES];
    [_colorPickerView selectRow:3 inComponent:1 animated:YES];
    [_colorPickerView selectRow:1 inComponent:2 animated:YES];
    [_colorPickerView selectRow:1 inComponent:3 animated:YES];
	[_colorPicker _drawResistorBarWithColorName: @"yellow" andComponent: 0];
	[_colorPicker _drawResistorBarWithColorName: @"red" andComponent: 1];
	[_colorPicker _drawResistorBarWithColorName: @"black" andComponent: 2];
	[_colorPicker _drawResistorBarWithColorName: @"black" andComponent: 3];
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
	[super dealloc];
}


- (IBAction) _expandButtonPressed: (id) sender;
{
	//_searchBar.hidden = NO;	
	//_expandSearchButton.enabled = NO;
	//_expandSearchButton.hidden = YES;
	[_colorPicker _randomSpin: _colorPickerView];
}

//// accel delegate
- (void)accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acc
{
	float add = (acc.y < 0 ? -acc.y : acc.y) + (acc.x < 0 ? -acc.x : acc.x) + (acc.z < 0 ? -acc.z : acc.z);
	
	if (add > 4.5)
	{
		[_colorPicker _randomSpin: _colorPickerView];
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
