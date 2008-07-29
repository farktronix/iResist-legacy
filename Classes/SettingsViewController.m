//
//  SettingsViewController.m
//  iResist
//
//  Created by Jacob Farkas on 7/27/08.
//  Copyright 2008 Apple Computer. All rights reserved.
//

#import "SettingsViewController.h"


@implementation SettingsViewController

- (IBAction) showLabelsValueChanged
{
    [[NSUserDefaults standardUserDefaults] setValue:[NSNumber numberWithBool:_showLabelsSwitch.on] forKey:@"ShowLabels"];
}

- (IBAction) useAccelerometerSwitchChanged
{
    [[NSUserDefaults standardUserDefaults] setValue:[NSNumber numberWithBool:_useAccelerometerSwitch.on] forKey:@"UseAccelerometer"];
}

- (void)viewDidLoad 
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    BOOL showLabels = [[defaults valueForKey:@"ShowLabels"] boolValue];
    _showLabelsSwitch.on = showLabels;
    
    BOOL accel = YES;
    NSNumber *useAccel = [defaults valueForKey:@"UseAccelerometer"];
    if (useAccel) accel = [useAccel boolValue];
    _useAccelerometerSwitch.on = accel;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	// Return YES for supported orientations
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
