//
//  ResistorSMTPicker.m
//  iResist
//
//  Created by Jacob Farkas on 8/9/08.
//  Copyright 2008 Flying Monkey Enterprises. All rights reserved.
//

#import "ResistorSMTPicker.h"

static int kRStringIndex = 11;

@implementation ResistorSMTPicker

- (NSString *) _stringForRow:(int)row
{
    if (row == 0) {
        return @"";
    } else if (row < kRStringIndex) {
        return [NSString stringWithFormat:@"%d", row - 1];
    } else {
        return @"R";
    }
}

- (NSArray *)getOhmPickersForValue:(double)ohms
{
    NSMutableArray *pickers = [[NSMutableArray alloc] initWithCapacity:4];
    [pickers addObject:@""];
    [pickers addObject:@""];
    [pickers addObject:@""];
    [pickers addObject:@""];
    
    if (ohms < 100 && ohms != (int)ohms) {
        // this value has a 'R' in it
        int sig = (int)ohms;
        if (ohms >= 10) {
            [pickers replaceObjectAtIndex:0 withObject:[NSString stringWithFormat:@"%d", sig / 10]];
            [pickers replaceObjectAtIndex:1 withObject:[NSString stringWithFormat:@"%d", sig % 10]];
            [pickers replaceObjectAtIndex:2 withObject:@"R"];
            [pickers replaceObjectAtIndex:3 withObject:[NSString stringWithFormat:@"%d", (int)(ohms * 10) % 10]];
        } else if (ohms < 10) {
            [pickers replaceObjectAtIndex:0 withObject:[NSString stringWithFormat:@"%d", sig % 10]];
            [pickers replaceObjectAtIndex:1 withObject:@"R"];
            [pickers replaceObjectAtIndex:2 withObject:[NSString stringWithFormat:@"%d", (int)(ohms * 10) % 10]];
            [pickers replaceObjectAtIndex:3 withObject:[NSString stringWithFormat:@"%d", (int)(ohms * 100) % 10]];
        }
    }
    else {
        int multiplier = MAX((int)log10(ohms) - 2, 0);
        int sigs = ohms / pow(10.0, multiplier);
        
        if (sigs >= 100) {
            [pickers replaceObjectAtIndex:0 withObject:[NSString stringWithFormat:@"%d", (int)(sigs/100)]];
        }
        if (sigs >= 10) {
            [pickers replaceObjectAtIndex:1 withObject:[NSString stringWithFormat:@"%d", (int)((sigs % 100) / 10)]];
        }
        [pickers replaceObjectAtIndex:2 withObject:[NSString stringWithFormat:@"%d", (int)(sigs % 10)]];
        
        if (multiplier == 0) {
            [pickers replaceObjectAtIndex:3 withObject:@"R"];
        } else {
            [pickers replaceObjectAtIndex:3 withObject:[NSString stringWithFormat:@"%d", multiplier]];
        }
    }
    
    return [pickers autorelease];
}

- (void) setOhmValue:(double)ohms forPicker:(UIPickerView *)picker
{
    // reset all values
    int ii = 0;
    for (ii = 0; ii < 4; ii++)
        [self selectRow:0 inComponent:0 forPicker:picker];
    
    if (ohms < 100 && ohms != (int)ohms) {
        // this value has a 'R' in it
        int sigs = (int)ohms;
        if (ohms >= 10) {
            [self selectRow:1 + (sigs / 10) inComponent:0 forPicker:picker];
            [self selectRow:1 + (sigs % 10) inComponent:1 forPicker:picker];
            [self selectRow:kRStringIndex inComponent:2 forPicker:picker];
            [self selectRow:1 + ((int)(ohms * 10) % 10) inComponent:3 forPicker:picker];
        } else if (ohms < 10) {
            [self selectRow:1 + (sigs % 10) inComponent:0 forPicker:picker];
            [self selectRow:kRStringIndex inComponent:1 forPicker:picker];
            [self selectRow:1 + ((int)(ohms * 10) % 10) inComponent:2 forPicker:picker];
            [self selectRow:1 + ((int)(ohms * 100) % 10) inComponent:3 forPicker:picker];
        }
    }
    else {
        int multiplier = MAX((int)log10(ohms) - 2, 0);
        int sigs = ohms / pow(10.0, multiplier);
        
        if (sigs >= 100) {
            [self selectRow:1 + (sigs / 100) inComponent:0 forPicker:picker];
        }
        if (sigs >= 10) {
            [self selectRow:1 + (int)((sigs % 100) / 10) inComponent:1 forPicker:picker];
        }
        [self selectRow:1 + (sigs % 10) inComponent:2 forPicker:picker];
        
        if (multiplier == 0) {
            [self selectRow:kRStringIndex inComponent:3 forPicker:picker];
        } else {
            [self selectRow:1 + multiplier inComponent:3 forPicker:picker];
        }
    }
}

- (double) _ohmsForSMTString:(NSString *)smt
{
    double ohms = 0.0;
    int len = [smt length];
    int ii;
    int magnitude = 0;
    int sigDigits = 0; // digits before the decimal point (>=1)
    int decDigits = 0; // digits after the decimal point (<1)
    
    if (len == 0 || len > 4) return 0.0;
    
    const char *smtChars = [smt cStringUsingEncoding:NSASCIIStringEncoding];
    
    // figure out if there is a 'R' in this string
    int radixPos = -1;
    for (ii = 0; ii < len; ii++) {
        if (smtChars[ii] == 'R') {
            // if this isn't the first 'R' we've come across, this string is no good
            if (radixPos != -1) return 0.0;
            radixPos = ii;
        }
    }
    
    if (radixPos > -1) {
        // this string has a radix in it
        sigDigits = atoi(smtChars);
        
        if (radixPos + 1 < len) {
            decDigits = atoi(smtChars + radixPos + 1);
        }
        
    } else {
        // no radix in this string
        char sigChars[4] = {'0'};
        if (len == 2) {
            strncpy(sigChars, smtChars, len);
        } else {
            strncpy(sigChars, smtChars, len - 1);
            magnitude = smtChars[len - 1] - '0';
        }
        sigDigits = atoi(sigChars);
    }
    
    double decValue = 0.0;
    if (decDigits) decValue = (double)decDigits / pow(10.0, 1.0 + (int)log10((double)decDigits));
    
    ohms = (double)(sigDigits * pow(10.0, (double)magnitude)) + decValue;
    
    return ohms;
}

- (double) getOhmValueForPicker:(UIPickerView *)picker
{
    
    NSMutableString *smtString = [NSMutableString stringWithCapacity:4];
    int ii;
    for (ii = 0; ii < 4; ii++) {
        int rowVal = [picker selectedRowInComponent:ii];
        if (rowVal != 0)
            [smtString appendString:[self _stringForRow:rowVal]];
    }
    
    return [self _ohmsForSMTString:smtString];
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return 12;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [self _stringForRow:row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSNumber *ohms = [NSNumber numberWithDouble:[self getOhmValueForPicker:pickerView]];
    [[NSUserDefaults standardUserDefaults] setValue:ohms forKey:kOhmsKey];
    [[NSNotificationCenter defaultCenter] postNotificationName:kResistorPickerChangedNotification object:nil];
}

@end
