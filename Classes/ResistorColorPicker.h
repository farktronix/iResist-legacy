//
//  ResistorColorPicker.h
//  iResist
//
//  Created by Jacob Farkas on 7/10/08.
//  Copyright 2008 Apple Computer. All rights reserved.
//

#import <UIKit/UIKit.h>

@class iResistViewController;

@interface ResistorColorPicker : NSObject <UIPickerViewDataSource, UIPickerViewDelegate> {
    NSArray *_colorViews;
	NSDictionary *_colors;
	UIImage *_endImg;
	
	IBOutlet iResistViewController *_viewController;
    
    BOOL _showLabels;
}

+ (NSString *) colorNameForRow:(int)row inComponent:(int)component;

- (void) _randomSpin:(UIPickerView*)pView;

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component;
@end
