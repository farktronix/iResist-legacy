//
//  ResistorColorViewController.h
//  iResist
//
//  Created by Jacob Farkas on 7/27/08.
//  Copyright 2008 Flying Monkey Enterprises. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ResistorColorViewController : UIViewController <UISearchBarDelegate> {
    IBOutlet UILabel *_ohms;
	IBOutlet UILabel *_tolerance;
	IBOutlet UIImageView *_resistor;

	IBOutlet UISearchBar *_searchBar;
	IBOutlet UIButton *_expandSearchButton;
    
    UIPickerView *_picker;

	NSMutableArray *_colorBars;
	NSDictionary *_barImages;
}

@property (nonatomic, retain) UIPickerView *picker;
@property (readonly) UISearchBar *searchBar;

- (IBAction) _expandButtonPressed: (id) sender;

@end
