//
//  ResistorColorPicker.h
//  iResist
//
//  Created by Jacob Farkas on 7/10/08.
//  Copyright 2008 Flying Monkey Enterprises. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ResistorValuePicker.h"

@class iResistViewController;

@interface ResistorColorPicker : ResistorValuePicker {
    NSArray *_colorViews;
	NSDictionary *_colors;
	UIImage *_endImg;
	
	IBOutlet iResistViewController *_viewController;
    
    BOOL _showLabels;
    
    BOOL _manualUpdate;
}

+ (NSString *) colorNameForRow:(int)row inComponent:(int)component;

- (double) getToleranceForPicker:(UIPickerView *)picker;

@end
