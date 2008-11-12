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
    }
}

int main (int argc, const char * argv[]) {
    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
    
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
    
    [pool drain];
    
    return 0;
}
