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

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
		// Initialization code
	}
	return self;
}

- (void)viewDidLoad 
{
    BOOL showLabels = [[[NSUserDefaults standardUserDefaults] valueForKey:@"ShowLabels"] boolValue];
    _showLabelsSwitch.on = showLabels;
    BOOL accel = YES;
    NSNumber *useAccel = [[NSUserDefaults standardUserDefaults] valueForKey:@"UseAccelerometer"];
    if (useAccel) accel = [useAccel boolValue];
    _useAccelerometerSwitch.on = accel;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	// Return YES for supported orientations
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc {
	[super dealloc];
}


@end
