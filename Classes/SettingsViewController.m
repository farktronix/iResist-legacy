//
//  SettingsViewController.m
//  iResist
//
//  Created by Jacob Farkas on 7/27/08.
//  Copyright 2008 Flying Monkey Enterprises. All rights reserved.
//

#import "SettingsViewController.h"


@implementation SettingsViewController

- (IBAction) showLabelsValueChanged
{
    [[NSUserDefaults standardUserDefaults] setValue:[NSNumber numberWithBool:_showLabelsSwitch.on] forKey:kShowLabelsKey];
}

- (IBAction) useAccelerometerSwitchChanged
{
    [[NSUserDefaults standardUserDefaults] setValue:[NSNumber numberWithBool:_useAccelerometerSwitch.on] forKey:kUseAccelerometerKey];
}

- (void)viewDidLoad 
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    BOOL showLabels = [[defaults valueForKey:kShowLabelsKey] boolValue];
    _showLabelsSwitch.on = showLabels;
    
    BOOL accel = NO;
    NSNumber *useAccel = [defaults valueForKey:kUseAccelerometerKey];
    if (useAccel) accel = [useAccel boolValue];
    _useAccelerometerSwitch.on = accel;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	// Return YES for supported orientations
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
