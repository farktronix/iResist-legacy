#import <Foundation/Foundation.h>

double ohmsForSMTString (NSString *smt)
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

void checkOhms (NSString *smt, double expected)
{
    double ohms = ohmsForSMTString(smt);
    if (ohms != expected) {
        NSLog(@"The string \"%@\" failed. Expected: %0.3f, returned: %0.3f", smt, expected, ohms);
    } else {
        NSLog(@"PASS! %@ is equal to %0.3f", smt, expected);
    }
}

void testOhmStringParse (void)
{
    // zeros
    checkOhms(@"", 0);
    checkOhms(@"0000", 0);
    checkOhms(@"000", 0);
    checkOhms(@"00", 0);
    checkOhms(@"0", 0);
    
    // three digit codes
    checkOhms(@"100", 10);
    checkOhms(@"101", 100);
    checkOhms(@"102", 1000);
    checkOhms(@"103", 10000);
    checkOhms(@"104", 100000);
    checkOhms(@"105", 1000000);
    checkOhms(@"106", 10000000);
    checkOhms(@"107", 100000000);
    checkOhms(@"108", 1000000000);
    checkOhms(@"109", 10000000000);
    
    // four digit codes
    checkOhms(@"1000", 100);
    checkOhms(@"1001", 1000);
    checkOhms(@"1002", 10000);
    checkOhms(@"1003", 100000);
    checkOhms(@"1004", 1000000);
    checkOhms(@"1005", 10000000);
    checkOhms(@"1006", 100000000);
    checkOhms(@"1007", 1000000000);
    checkOhms(@"1008", 10000000000);
    checkOhms(@"1009", 100000000000);
    
    // tests with a radix
    checkOhms(@"R1", 0.1);
    checkOhms(@"0R1", 0.1);
    checkOhms(@"R11", 0.11);
    checkOhms(@"0R11", 0.11);
    checkOhms(@"1R", 1);
    checkOhms(@"10R", 10);
    checkOhms(@"100R", 100);
    checkOhms(@"1R1", 1.1);
    checkOhms(@"10R1", 10.1);
    checkOhms(@"2R22", 2.22);
    checkOhms(@"R123", 0.123);
    checkOhms(@"R120", 0.120);
    
    // assorted other numbers that we don't really need to test
    checkOhms(@"334", 330000);
    checkOhms(@"222", 2200);
    checkOhms(@"473", 47000);
    checkOhms(@"105", 1000000);
    checkOhms(@"4992", 49900);
    
    // error cases
    checkOhms(@"RR", 0);
    checkOhms(@"1RR", 0);
    checkOhms(@"12RR", 0);
}

NSArray *getOhmPickersForValue (double ohms)
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

void testOhmPickersForValue (double ohms)
{
    NSArray *pickers = getOhmPickersForValue(ohms);

    NSMutableString *smtString = [NSMutableString stringWithCapacity:4];
    int ii;
    for (ii = 0; ii < 4; ii++) {
        NSString *curVal = [pickers objectAtIndex:ii];
        if (![curVal isEqualToString:@""])
            [smtString appendString:curVal];
    }
    
    checkOhms(smtString, ohms);
}

void testOhmPickerParse (void)
{
    testOhmPickersForValue(1.0);
    testOhmPickersForValue(10.0);
    testOhmPickersForValue(12.0);
    testOhmPickersForValue(100.0);
    testOhmPickersForValue(120.0);
    testOhmPickersForValue(123.0);
    testOhmPickersForValue(102.0);
    testOhmPickersForValue(1000.0);
    testOhmPickersForValue(1200.0);
    testOhmPickersForValue(1230.0);
    testOhmPickersForValue(1200.0);
    testOhmPickersForValue(1020.0);
    testOhmPickersForValue(123e1);
    testOhmPickersForValue(1e3);
    testOhmPickersForValue(123e2);
    testOhmPickersForValue(1e4);
    testOhmPickersForValue(123e3);
    testOhmPickersForValue(1e5);
    testOhmPickersForValue(123e4);
    testOhmPickersForValue(1e6);
    testOhmPickersForValue(123e5);
    testOhmPickersForValue(1e7);
    testOhmPickersForValue(123e6);
    testOhmPickersForValue(1e8);
    testOhmPickersForValue(123e7);
    testOhmPickersForValue(1e9);
    testOhmPickersForValue(123e8);
    testOhmPickersForValue(1e10);
    testOhmPickersForValue(123e9);
    testOhmPickersForValue(1e11);
    
    testOhmPickersForValue(0.1);    
    testOhmPickersForValue(0.12);    
    testOhmPickersForValue(1.1);    
    testOhmPickersForValue(1.23);    
    testOhmPickersForValue(12.3);    
    testOhmPickersForValue(123.0);    
    testOhmPickersForValue(1.23);
}

int main (int argc, const char * argv[]) {
    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
    
    testOhmPickerParse();
    
    [pool drain];
    
    return 0;
}
