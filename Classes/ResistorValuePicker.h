//
//  ResistorValuePicker.h
//  iResist
//
//  Created by Jacob Farkas on 8/9/08.
//  Copyright 2008 Flying Monkey Enterprises. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ResistorValuePicker : NSObject  <UIPickerViewDataSource, UIPickerViewDelegate> {
    BOOL _manualUpdate;
}

- (void) randomSpin:(UIPickerView *)picker;

- (void) selectRow:(NSInteger)row inComponent:(NSInteger)component forPicker:(UIPickerView*)picker;

- (void) setOhmValue:(double)ohms forPicker:(UIPickerView *)picker;
- (double) getOhmValueForPicker:(UIPickerView *)picker;

- (void) setTolerance:(double)tolerance forPicker:(UIPickerView *)picker;
- (double) getToleranceForPicker:(UIPickerView *)picker;

@end
