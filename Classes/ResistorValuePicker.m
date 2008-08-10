//
//  ResistorValuePicker.m
//  iResist
//
//  Created by Jacob Farkas on 8/9/08.
//  Copyright 2008 Apple Computer. All rights reserved.
//

#import "ResistorValuePicker.h"


@implementation ResistorValuePicker

- (void) randomSpin:(UIPickerView*)pView;
{
	int c;
	
	for (c = 0; c < 4; c++)
	{
		int r = (rand() % [self pickerView: pView numberOfRowsInComponent: c]);
		[pView selectRow: r inComponent: c animated: YES];
		[self pickerView: pView didSelectRow: r inComponent: c];
	}
}

- (void) setOhmValue:(double)ohms
{
    return;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 4;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    return 70;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 40;
}

@end
