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
	_searchBar.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
	
    [_colorPickerView selectRow:5 inComponent:0 animated:YES];
    [_colorPickerView selectRow:3 inComponent:1 animated:YES];
    [_colorPickerView selectRow:1 inComponent:2 animated:YES];
    [_colorPickerView selectRow:1 inComponent:3 animated:YES];
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


- (IBAction) _expandButtonPressed: (id) sender;
{
	_searchBar.hidden = NO;	
	_expandSearchButton.enabled = NO;
	_expandSearchButton.hidden = YES;
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
