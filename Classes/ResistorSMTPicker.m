//
//  ResistorSMTPicker.m
//  iResist
//
//  Created by Jacob Farkas on 8/9/08.
//  Copyright 2008 Flying Monkey Enterprises. All rights reserved.
//

#import "ResistorSMTPicker.h"


@implementation ResistorSMTPicker

- (NSString *) _stringForRow:(int)row
{
    if (row == 0) {
        return @"";
    } else if (row < 11) {
        return [NSString stringWithFormat:@"%d", row - 1];
    } else {
        return @"R";
    }
}

- (void) setOhmValue:(double)ohms forPicker:(UIPickerView *)picker
{
    
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
