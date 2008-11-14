#import <Foundation/Foundation.h>

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

void testPrettyPrint (NSString *expected, double ohms, int precision)
{
	NSString *retStr = prettyPrintOhms(ohms, precision);
	if (![retStr isEqualToString:expected]) {
		NSLog(@"%0.3f ohms (precision %d) did not pretty print correctly. Expected: \"%@\" Returned: \"%@\"", ohms, precision, expected, retStr);
	}
}

int main (int argc, const char * argv[]) {
    NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];

	testPrettyPrint(@"0.1 Ω", 0.1, 1);
	testPrettyPrint(@"0.1 Ω", 0.12, 1);
	testPrettyPrint(@"0.12 Ω", 0.12, 2);
	testPrettyPrint(@"0.12 Ω", 0.123, 2);
	testPrettyPrint(@"0.01 Ω", 0.01, 2);
	testPrettyPrint(@"0.02 Ω", 0.02, 2);
	
	testPrettyPrint(@"1 Ω", 1.0, 1);
	testPrettyPrint(@"1.2 Ω", 1.2, 1);
	testPrettyPrint(@"1.2 Ω", 1.23, 1);
	testPrettyPrint(@"1.23 Ω", 1.23, 2);
	testPrettyPrint(@"1 Ω", 1.00, 2);

	testPrettyPrint(@"1 KΩ", 1000.0, 1);
	testPrettyPrint(@"1 KΩ", 1000.0, 2);
	testPrettyPrint(@"1.2 KΩ", 1200.0, 1);
	testPrettyPrint(@"1.2 KΩ", 1230.0, 1);
	testPrettyPrint(@"1.23 KΩ", 1230.0, 2);
	
	testPrettyPrint(@"1 MΩ", 1000000.0, 1);
	testPrettyPrint(@"1 MΩ", 1000000.0, 2);
	testPrettyPrint(@"1.2 MΩ", 1200000.0, 1);
	testPrettyPrint(@"1.2 MΩ", 1230000.0, 1);
	testPrettyPrint(@"1.23 MΩ", 1230000.0, 2);
	
	testPrettyPrint(@"1 GΩ", 1000000000.0, 1);
	testPrettyPrint(@"1 GΩ", 1000000000.0, 2);
	testPrettyPrint(@"1.2 GΩ", 1200000000.0, 1);
	testPrettyPrint(@"1.2 GΩ", 1230000000.0, 1);
	testPrettyPrint(@"1.23 GΩ", 1230000000.0, 2);
	
    [pool drain];
    return 0;
}
