//
//  Util.h
//  iResist
//
//

#import <Foundation/Foundation.h>

#define kResistorValueChangedNotification @"ResistorValueChanged"

// User defaults
#define kOhmsKey @"Ohms"
#define kToleranceKey @"Tolerance"
#define kVoltsKey @"Volts"
#define kCurrentPageKey @"CurrentPage"
#define kShowLabelsKey @"ShowLabels"
#define kUseAccelerometerKey @"UseAccelerometer"

#define LocColor(x) NSLocalizedStringFromTable(x, @"Colors", nil)

NSString *prettyPrintOhms (double ohms);
