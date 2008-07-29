//
//  iResistViewController.h
//  iResist
//
//  Created by Jacob Farkas on 7/10/08.
//  Copyright Flying Monkey Enterprises 2008. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ResistorColorPicker.h"
#import "ResistorValueViewController.h"
#import "SettingsViewController.h"

@interface iResistViewController : UIViewController <UISearchBarDelegate, UIAccelerometerDelegate> {
    IBOutlet UIPickerView *_colorPickerView;
    IBOutlet ResistorColorPicker *_colorPicker;
    
    IBOutlet UIButton *_toggleSettingsButton;
    IBOutlet UIView *_contentView;
    
    ResistorValueViewController *_resistorViewController;
    SettingsViewController *_settingsViewController;
    
    BOOL _useAccel;
}

- (IBAction) _toggleSettingsButtonPressed: (id) sender;

@end

