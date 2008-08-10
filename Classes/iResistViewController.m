//
//  iResistAppDelegate.m
//  iResist
//
//  Created by Jacob Farkas on 7/10/08.
//  Copyright Flying Monkey Enterprises 2008. All rights reserved.
//

#import "iResistViewController.h"
#import "ResistorScrollViewController.h"
#import "SettingsViewController.h"

@implementation iResistViewController

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([keyPath isEqualToString:kUseAccelerometerKey]) {
        _useAccel = [[defaults valueForKey:kUseAccelerometerKey] boolValue];
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
    _resistorScrollViewController.picker = _valuePickerView;
	
    _useAccel = NO;
    NSNumber *useAccel = [defaults valueForKey:kUseAccelerometerKey];
    if (useAccel != nil) {
        _useAccel = [useAccel boolValue];
    }
    
	UIAccelerometer* sAccel = [UIAccelerometer sharedAccelerometer];
	sAccel.updateInterval = 0.5;
    if (_useAccel) sAccel.delegate = self;

    [[NSNotificationCenter defaultCenter] postNotificationName:kResistorValueChangedNotification object:nil];    
        
    [self _toggleSettingsButtonPressed:self];
    
    [defaults addObserver:self forKeyPath:kUseAccelerometerKey options:0 context:nil];
}
 
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	// Return YES for supported orientations
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc {
    [_resistorScrollViewController release];
    [_settingsViewController release];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[NSUserDefaults standardUserDefaults] removeObserver:self forKeyPath:kUseAccelerometerKey];
	[super dealloc];
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
            [_resistorScrollViewController randomSpin];
        }
    }
}
@end
