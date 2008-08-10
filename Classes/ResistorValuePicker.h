//
//  ResistorValuePicker.h
//  iResist
//
//  Created by Jacob Farkas on 8/9/08.
//  Copyright 2008 Apple Computer. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ResistorValuePicker : NSObject  <UIPickerViewDataSource, UIPickerViewDelegate> {

}

- (void) randomSpin:(UIPickerView *)picker;
- (void) setOhmValue:(double)ohms forPicker:(UIPickerView *)picker;

@end
