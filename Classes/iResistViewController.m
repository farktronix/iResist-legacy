//
//  iResistAppDelegate.m
//  iResist
//
//  Created by Jacob Farkas on 7/10/08.
//  Copyright Flying Monkey Enterprises 2008. All rights reserved.
//

#import "iResistViewController.h"
#import "ResistorValuePicker.h"
#import "ResistorColorPicker.h"
#import "ResistorSMTPicker.h"
#import "ResistorScrollViewController.h"
#import "SettingsViewController.h"

@implementation iResistViewController

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([keyPath isEqualToString:@"ShowLabels"]) {
        [_valuePickerView reloadAllComponents];
    } else if ([keyPath isEqualToString:@"UseAccelerometer"]) {
        _useAccel = [[defaults valueForKey:@"UseAccelerometer"] boolValue];
        if (_useAccel) {
            [UIAccelerometer sharedAccelerometer].delegate = self;
        } else {
            [UIAccelerometer sharedAccelerometer].delegate = nil;
        }
    }
}

- (void) viewDidLoad
{    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    _settingsViewController = [[SettingsViewController alloc] initWithNibName:@"SettingsView" bundle:nil];
    _resistorScrollViewController = [[ResistorScrollViewController alloc] initWithNibName:@"ResistorScrollView" bundle:nil];
    
    _colorPicker = [[ResistorColorPicker alloc] init];
    _SMTPicker = [[ResistorSMTPicker alloc] init];
    
    _currentValuePicker = _colorPicker;
    _valuePickerView.dataSource = _colorPicker;
    _valuePickerView.delegate = _colorPicker;
	
    _useAccel = NO;
    NSNumber *useAccel = [defaults valueForKey:@"UseAccelerometer"];
    if (useAccel != nil) {
        _useAccel = [useAccel boolValue];
    }
    
	UIAccelerometer* sAccel = [UIAccelerometer sharedAccelerometer];
	sAccel.updateInterval = 0.5;
    if (_useAccel) sAccel.delegate = self;
	    
    NSArray *components = [defaults objectForKey:@"components"];
    if (components == nil) components = [NSArray arrayWithObjects:[NSNumber numberWithInt:5], [NSNumber numberWithInt:3], [NSNumber numberWithInt:1], [NSNumber numberWithInt:1], nil];
    int component = 0;
    for (NSNumber *row in components) {
        [_valuePickerView selectRow:[row intValue] inComponent:component animated:YES];
        component++;
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:kResistorValueChangedNotification object:nil];    
    
    [self _toggleSettingsButtonPressed:self];
    
    [defaults addObserver:self forKeyPath:@"ShowLabels" options:0 context:nil];
    [defaults addObserver:self forKeyPath:@"UseAccelerometer" options:0 context:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(searchTextChanged:) name:@"SearchTextChanged" object:nil];
}
 
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	// Return YES for supported orientations
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc {
    [_resistorScrollViewController release];
    [_settingsViewController release];
    [_colorPicker release];
    [_SMTPicker release];
	[super dealloc];
}

- (void) _doRandomSpin;
{
    [_currentValuePicker randomSpin: _valuePickerView];
}

- (void) searchTextChanged:(NSNotification *)notif
{
    NSString *searchText = [[notif userInfo] objectForKey:@"SearchText"];
    if (searchText == nil || [searchText length] == 0) return;
    [_currentValuePicker setOhmValue:[searchText doubleValue] forPicker:_valuePickerView];
}

- (IBAction) _toggleSettingsButtonPressed: (id) sender
{
    UIView *resistorView = _resistorScrollViewController.view;
    UIView *settingsView = _settingsViewController.view;

    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:1];
    [UIView setAnimationTransition:([resistorView superview] ? UIViewAnimationTransitionFlipFromRight : UIViewAnimationTransitionFlipFromLeft) forView:_contentView cache:YES];

    if ([resistorView superview] != nil) {
        // switch to settings view
        [_settingsViewController viewWillAppear:YES];
        [_resistorScrollViewController viewWillDisappear:YES];
        [resistorView removeFromSuperview];
        [_contentView insertSubview:settingsView belowSubview:_toggleSettingsButton];
        [_resistorScrollViewController viewDidDisappear:YES];
        [_settingsViewController viewDidAppear:YES];
        
    } else {
        // switch to resistor view
        [_resistorScrollViewController viewWillAppear:YES];
        [_settingsViewController viewWillDisappear:YES];
        [settingsView removeFromSuperview];
        [_contentView insertSubview:resistorView belowSubview:_toggleSettingsButton];
        [_settingsViewController viewDidDisappear:YES];
        [_resistorScrollViewController viewDidAppear:YES];
    }
    [UIView commitAnimations];

}


//// accel delegate
- (void)accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acc
{
    if (_useAccel) {
        float add = (acc.y < 0 ? -acc.y : acc.y) + (acc.x < 0 ? -acc.x : acc.x) + (acc.z < 0 ? -acc.z : acc.z);
        
        if (add > 4.0)
        {
            [self _doRandomSpin];
        }
    }
}
@end
