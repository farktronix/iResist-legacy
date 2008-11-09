//
//  ResistorSMTPicker.m
//  iResist
//
//  Created by Jacob Farkas on 8/9/08.
//  Copyright 2008 Apple Computer. All rights reserved.
//

#import "ResistorSMTPicker.h"


@implementation ResistorSMTPicker

- (void) setOhmValue:(double)ohms forPicker:(UIPickerView *)picker
{
    
}

- (double) getOhmValueForPicker:(UIPickerView *)picker
{
    return 0.0;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return 12;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (row == 0) {
        return @"";
    } else if (row < 11) {
        return [NSString stringWithFormat:@"%d", row - 1];
    } else {
        return @"R";
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kResistorValueChangedNotification object:nil];
}

@end
