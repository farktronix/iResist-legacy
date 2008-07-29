//
//  SettingsViewController.h
//  iResist
//
//  Created by Jacob Farkas on 7/27/08.
//  Copyright 2008 Apple Computer. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SettingsViewController : UIViewController {
    IBOutlet UISwitch *_showLabelsSwitch;
    IBOutlet UISwitch *_useAccelerometerSwitch;
    IBOutlet UISwitch *_showSearchSwitch;
}

- (IBAction) showLabelsValueChanged;
- (IBAction) useAccelerometerSwitchChanged;
- (IBAction) showSearchBarChanged;

@end
