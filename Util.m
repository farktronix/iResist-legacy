//
//  Util.m
//  iResist
//
//

#import "Util.h"

NSString * prettyPrintOhms (double ohms)
{
    int exp = (int)log10(ohms);
    double displayOhms = ohms;
    
    if (ohms < 1.0) {
        displayOhms = ((int)(ohms * 100) / 100.0);
    }
    else if (ohms < 10) {
        displayOhms = ((int)(ohms * 10) / 10.0);
    } 
    else {
        double power = pow(10, exp - 1);
        displayOhms = ((int)(ohms / power) * power);  
    }
    
    if (ohms < 1000) {
        return [NSString stringWithFormat:(ohms < 1 ? @"%.2f Ω" : (ohms < 10 ? @"%.1f Ω" : @"%.0f Ω")), displayOhms];
    }
    else if (ohms < 1000000) {
        return [NSString stringWithFormat:@"%.1f KΩ", displayOhms/1000.0];
    }
    else if (ohms < 1000000000) {
        return [NSString stringWithFormat:@"%.1f MΩ", displayOhms/1000000.0];
    }
    else {
        return [NSString stringWithFormat:@"%.1f GΩ", displayOhms/1000000000.0];
    }
}