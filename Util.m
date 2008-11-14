//
//  Util.m
//  iResist
//
//

#import "Util.h"

NSString *prettyPrintOhms (double ohms, int precision)
{
	NSMutableString *prettyStr = [[NSMutableString alloc] init];
	
	int exp = 0;
	if (ohms >= 1000) exp = (int)log10(ohms);
	double sigOhms = ohms / pow(10.0, (double)exp);
	
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
	
	NSString *magStr = @"";
	if (exp >= 9) {
		magStr = @"G";
	} else if (exp >= 6) {
		magStr = @"M";
	} else if (exp >= 3) {
		magStr = @"K";
	}
	[prettyStr appendFormat:@" %@Ω", magStr];
	
	return [prettyStr autorelease];
}