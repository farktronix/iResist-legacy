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

- (void) viewDidLoad
{    
    _resistorViewController = [[ResistorValueViewController alloc] initWithNibName:@"ResistorValueView" bundle:nil];
    _settingsViewController = [[SettingsViewController alloc] initWithNibName:@"SettingsView" bundle:nil];
	
	UIAccelerometer* sAccel = [UIAccelerometer sharedAccelerometer];
	sAccel.updateInterval = 0.5;
	sAccel.delegate = self;
	
	_searchBar.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    
    NSArray *components = [[NSUserDefaults standardUserDefaults] objectForKey:@"components"];
    if (components == nil) components = [NSArray arrayWithObjects:[NSNumber numberWithInt:5], [NSNumber numberWithInt:3], [NSNumber numberWithInt:1], [NSNumber numberWithInt:1], nil];
    int component = 0;
    for (NSNumber *row in components) {
        [_colorPickerView selectRow:[row intValue] inComponent:component animated:YES];
        component++;
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:kResistorValueChangedNotification object:nil];
    
    [self _toggleSettingsButtonPressed:self];
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

- (IBAction) _toggleSettingsButtonPressed: (id) sender
{
    UIView *resistorView = _resistorViewController.view;
    UIView *settingsView = _settingsViewController.view;

    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:1];
    [UIView setAnimationTransition:([resistorView superview] ? UIViewAnimationTransitionFlipFromRight : UIViewAnimationTransitionFlipFromLeft) forView:_contentView cache:YES];

    if ([resistorView superview] != nil) {
        [_settingsViewController viewWillAppear:YES];
        [_resistorViewController viewWillDisappear:YES];
        [resistorView removeFromSuperview];
        [_contentView insertSubview:settingsView belowSubview:_toggleSettingsButton];
        [_resistorViewController viewDidDisappear:YES];
        [_settingsViewController viewDidAppear:YES];
        
    } else {
        [_resistorViewController viewWillAppear:YES];
        [_settingsViewController viewWillDisappear:YES];
        [settingsView removeFromSuperview];
        [_contentView insertSubview:resistorView belowSubview:_toggleSettingsButton];
        [_settingsViewController viewDidDisappear:YES];
        [_resistorViewController viewDidAppear:YES];
    }
    [UIView commitAnimations];

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
