//
//  iResistViewController.h
//  iResist
//
//  Created by Jacob Farkas on 7/10/08.
//  Copyright Flying Monkey Enterprises 2008. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ResistorColorPicker.h"
#import "ResistorScrollViewController.h"
#import "SettingsViewController.h"

@interface iResistViewController : UIViewController <UISearchBarDelegate, UIAccelerometerDelegate, UIScrollViewDelegate> {
    IBOutlet UIPickerView *_valuePickerView;
    IBOutlet ResistorValuePicker *_valuePicker;
    
    IBOutlet UIButton *_toggleSettingsButton;
    IBOutlet UIView *_contentView;
    
    ResistorScrollViewController *_resistorScrollViewController;
    SettingsViewController *_settingsViewController;
    
    BOOL _useAccel;
}

- (IBAction) _toggleSettingsButtonPressed: (id) sender;

@end

