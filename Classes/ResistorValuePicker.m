//
//  ResistorValuePicker.m
//  iResist
//
//  Created by Jacob Farkas on 8/9/08.
//  Copyright 2008 Flying Monkey Enterprises. All rights reserved.
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
//		[self pickerView: pView didSelectRow: r inComponent: c];
	}
}

- (void) selectRow:(NSInteger)row inComponent:(NSInteger)component forPicker:(UIPickerView*)picker
{
    _manualUpdate = YES;
    [picker selectRow:row inComponent:component animated:NO];
    _manualUpdate = NO;
}

- (void) setOhmValue:(double)ohms forPicker:(UIPickerView *)picker
{
    return;
}

- (double) getOhmValueForPicker:(UIPickerView *)picker
{
    return 0.0;
}

- (void) setTolerance:(double)tolerance forPicker:(UIPickerView *)picker
{
    return;
}

- (double) getToleranceForPicker:(UIPickerView *)picker
{
    return 0.0;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return 1;
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
