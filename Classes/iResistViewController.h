//
//  iResistViewController.h
//  iResist
//
//  Created by Jacob Farkas on 7/10/08.
//  Copyright Apple Computer 2008. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ResistorColorPicker.h"
#import "ResistorValueViewController.h"
#import "SettingsViewController.h"

@interface iResistViewController : UIViewController <UISearchBarDelegate, UIAccelerometerDelegate> {
    IBOutlet UIPickerView *_colorPickerView;
    IBOutlet ResistorColorPicker *_colorPicker;
    
	IBOutlet UISearchBar *_searchBar;
	IBOutlet UIButton *_expandSearchButton;
    
    IBOutlet UIButton *_toggleSettingsButton;
    IBOutlet UIView *_contentView;
    
    ResistorValueViewController *_resistorViewController;
    SettingsViewController *_settingsViewController;
}

- (IBAction) _expandButtonPressed: (id) sender;
- (IBAction) _toggleSettingsButtonPressed: (id) sender;

@end

