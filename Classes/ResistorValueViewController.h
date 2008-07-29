//
//  ResistorValueViewController.h
//  iResist
//
//  Created by Jacob Farkas on 7/27/08.
//  Copyright 2008 Apple Computer. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ResistorValueViewController : UIViewController <UISearchBarDelegate> {
    IBOutlet UILabel *_ohms;
	IBOutlet UILabel *_tolerance;
	IBOutlet UIImageView *_resistor;

	IBOutlet UISearchBar *_searchBar;
	IBOutlet UIButton *_expandSearchButton;

	NSMutableArray *_colorBars;
	NSDictionary *_barImages;
}

- (IBAction) _expandButtonPressed: (id) sender;

@end
