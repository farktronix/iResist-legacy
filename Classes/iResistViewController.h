//
//  iResistViewController.h
//  iResist
//
//  Created by Jacob Farkas on 7/10/08.
//  Copyright Flying Monkey Enterprises 2008. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ResistorValuePicker, ResistorColorPicker, ResistorSMTPicker, ResistorScrollViewController, SettingsViewController;

@interface iResistViewController : UIViewController <UISearchBarDelegate, UIAccelerometerDelegate, UIScrollViewDelegate> {
    IBOutlet UIPickerView *_valuePickerView;
    ResistorColorPicker *_colorPicker;
    ResistorSMTPicker *_SMTPicker;
    ResistorValuePicker *_currentValuePicker;
    
    IBOutlet UIButton *_toggleSettingsButton;
    IBOutlet UIView *_contentView;
    
    ResistorScrollViewController *_resistorScrollViewController;
    SettingsViewController *_settingsViewController;
    
    BOOL _useAccel;
}

- (IBAction) _toggleSettingsButtonPressed: (id) sender;

@end

