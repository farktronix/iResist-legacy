//
//  iResistViewController.h
//  iResist
//
//  Created by Jacob Farkas on 7/10/08.
//  Copyright Apple Computer 2008. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ResistorColorPicker.h"

@interface iResistViewController : UIViewController <UISearchBarDelegate> {
    IBOutlet UIPickerView *_colorPickerView;
	IBOutlet UISearchBar *_searchBar;
	IBOutlet UIButton *_expandSearchButton;
    IBOutlet ResistorColorPicker *_colorPicker;
}

- (IBAction) _expandButtonPressed: (id) sender;


@end

