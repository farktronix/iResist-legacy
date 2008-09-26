//
//  ResistorInfoViewController.h
//  iResist
//
//  Created by Ryan Joseph on 8/19/08.
//  Copyright 2008 Flying Monkey Enterprises. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ResistorGenericViewController.h"

@interface ResistorInfoViewController : ResistorGenericViewController {
    IBOutlet UISlider *_voltSlider;
    IBOutlet UISegmentedControl *_voltSegment;
    
    IBOutlet UILabel *_ohmsLabel;
    IBOutlet UILabel *_voltLabel;
    IBOutlet UILabel *_ampLabel;
    IBOutlet UILabel *_wattLabel;
    
    double _ohms;
}

- (IBAction) voltSliderChanged:(id)sender;
- (IBAction) segmentSelected:(id)sender;
@end
