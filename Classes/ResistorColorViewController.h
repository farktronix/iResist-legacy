//
//  ResistorColorViewController.h
//  iResist
//
//  Created by Jacob Farkas on 7/27/08.
//  Copyright 2008 Flying Monkey Enterprises. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ResistorGenericViewController.h"

@interface ResistorColorViewController : ResistorGenericViewController <UISearchBarDelegate> {
    IBOutlet UIView *_contentView;
    IBOutlet UILabel *_ohms;
	IBOutlet UILabel *_tolerance;
	IBOutlet UIImageView *_resistor;

	IBOutlet UISearchBar *_searchBar;
	IBOutlet UIButton *_expandSearchButton;

	NSMutableArray *_colorBars;
	NSDictionary *_barImages;
}

@property (readonly) UISearchBar *searchBar;

- (IBAction) _expandButtonPressed: (id) sender;

@end
