//
//  iResistAppDelegate.m
//  iResist
//
//  Created by Jacob Farkas on 7/10/08.
//  Copyright Flying Monkey Enterprises 2008. All rights reserved.
//

#import "iResistViewController.h"

@implementation iResistViewController

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([keyPath isEqualToString:@"ShowLabels"]) {
        [_colorPickerView reloadAllComponents];
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

    _resistorViewController = [[ResistorValueViewController alloc] initWithNibName:@"ResistorValueView" bundle:nil];
    _settingsViewController = [[SettingsViewController alloc] initWithNibName:@"SettingsView" bundle:nil];
	
    _useAccel = YES;
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
        [_colorPickerView selectRow:[row intValue] inComponent:component animated:YES];
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
    [_resistorViewController release];
    [_settingsViewController release];
	[super dealloc];
}


- (void) _doRandomSpin;
{
	for (int i = 0; i < 3; i++)
	{
		[_colorPicker _randomSpin: _colorPickerView];
	}
}

- (void) searchTextChanged:(NSNotification *)notif
{
    NSString *searchText = [[notif userInfo] objectForKey:@"SearchText"];
    if (searchText == nil || [searchText length] == 0) return;
    int firstNum = 0;
    int secondNum = 0;
    int multiplier = 0;
    
    int idx = 0;
    
    NSString *firstChar = nil;
    
    // Warning: here be skank. I'm too lazy to write this in an elegant way.
    
    do {
        firstChar = [searchText substringWithRange:NSMakeRange(idx, 1)];
        if ([firstChar isEqualToString:@"."] || [firstChar isEqualToString:@"0"]) {
            idx++;
        } else {
            break;
        }
    } while (idx < [searchText length]);
    if ([searchText length] == idx) {
        return;
    } else {
        firstNum = [[searchText substringWithRange:NSMakeRange(idx++, 1)] intValue];
        if ([searchText length] > idx) {
            NSString *secondChar = [searchText substringWithRange:NSMakeRange(idx++, 1)];
            if ([secondChar isEqualToString:@"."]) { 
                if ([searchText length] > idx) {
                    secondNum = [[searchText substringWithRange:NSMakeRange(idx, 1)] intValue];
                } else {
                    secondNum = firstNum;
                    firstNum = 0;
                }
            } else {
                secondNum = [secondChar intValue];
            }
        } else {
            secondNum = firstNum;
            firstNum = 0;
        }
    }
    
    double ohms = [searchText doubleValue];
    // yeah, i could do Math here, but this is probably faster anyway
    if (ohms < 1.0) {
        multiplier = 8;
    } else if (ohms < 10.0) {
        multiplier = 7;
    } else if (ohms < 100.0) {
        multiplier = 0;
    } else if (ohms < 1000.0) {
        multiplier = 1;
    } else if (ohms < 10000.0) {
        multiplier = 2;
    } else if (ohms < 100000.0) {
        multiplier = 3;
    } else if (ohms < 1000000.0) {
        multiplier = 4;
    } else if (ohms < 10000000.0) {
        multiplier = 5;
    } else {
        multiplier = 6;
    }
    
    [_colorPickerView selectRow:firstNum + 1 inComponent:0 animated:YES];
    [_colorPickerView selectRow:secondNum + 1 inComponent:1 animated:YES];
    [_colorPickerView selectRow:multiplier + 1 inComponent:2 animated:YES];
}

- (IBAction) _toggleSettingsButtonPressed: (id) sender
{
    UIView *resistorView = _resistorViewController.view;
    UIView *settingsView = _settingsViewController.view;

    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:1];
    [UIView setAnimationTransition:([resistorView superview] ? UIViewAnimationTransitionFlipFromRight : UIViewAnimationTransitionFlipFromLeft) forView:_contentView cache:YES];

    if ([resistorView superview] != nil) {
        // switch to settings view
        [_settingsViewController viewWillAppear:YES];
        [_resistorViewController viewWillDisappear:YES];
        [resistorView removeFromSuperview];
        [_contentView insertSubview:settingsView belowSubview:_toggleSettingsButton];
        [_resistorViewController viewDidDisappear:YES];
        [_settingsViewController viewDidAppear:YES];
        
    } else {
        // switch to resistor view
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
    if (_useAccel) {
        float add = (acc.y < 0 ? -acc.y : acc.y) + (acc.x < 0 ? -acc.x : acc.x) + (acc.z < 0 ? -acc.z : acc.z);
        
        if (add > 5.0)
        {
            [self _doRandomSpin];
        }
    }
}
@end
