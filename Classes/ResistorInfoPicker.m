//
//  ResistorInfoPicker.m
//  iResist
//
//  Created by Ryan Joseph on 8/19/08.
//  Copyright 2008 Flying Monkey Enterprises. All rights reserved.
//

#import "ResistorInfoPicker.h"


@implementation ResistorInfoPicker

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    return 285;
}
@end
