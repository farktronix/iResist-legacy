//
//  Util.m
//  iResist
//
//

#import "Util.h"

NSString *prettyPrintOhms (double ohms, int precision)
{
	NSMutableString *prettyStr = [[NSMutableString alloc] init];
	
	int exp = (int)log10(ohms);
    int curPow = 0;
	NSString *magStr = @"";
	if (exp >= 9) {
		magStr = @"G";
        curPow = 9;
	} else if (exp >= 6) {
		magStr = @"M";
        curPow = 6;
	} else if (exp >= 3) {
		magStr = @"K";
        curPow = 3;
	}
	double sigOhms = ohms / pow(10.0, (double)curPow);
	
	int precisionNeeded = precision;
	int ii;
	for (ii = precision; ii > 0; ii--) {
		if ((int)(sigOhms * pow(10.0, (double)ii)) % 10 == 0) {
			precisionNeeded--;
		} else {
			break;
		}
	}
	
	if (precisionNeeded == 0) {
		[prettyStr appendFormat:@"%d", (int)sigOhms];
	} else {
		NSString *formatString = [NSString stringWithFormat:@"%%.\%df", precisionNeeded];
		[prettyStr appendFormat:formatString, sigOhms];
	}
        
	[prettyStr appendFormat:@" %@Ω", magStr];
	
	return [prettyStr autorelease];
}