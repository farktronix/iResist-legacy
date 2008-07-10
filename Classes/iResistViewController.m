//
//  iResistAppDelegate.m
//  iResist
//
//  Created by Jacob Farkas on 7/10/08.
//  Copyright Apple Computer 2008. All rights reserved.
//

#import "iResistViewController.h"

@implementation iResistViewController

- (void) viewDidLoad
{
    [_colorPickerView selectRow:4 inComponent:0 animated:NO];
    [_colorPickerView selectRow:2 inComponent:1 animated:NO];
    [_colorPickerView selectRow:0 inComponent:2 animated:NO];
    [_colorPickerView selectRow:4 inComponent:3 animated:NO];
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

@end
