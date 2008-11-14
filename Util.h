//
//  Util.h
//  iResist
//
//

#import <Foundation/Foundation.h>

#define kResistorValueChangedNotification @"ResistorValueChanged"
#define kResistorPickerChangedNotification @"PickerValueChanged"

// User defaults
#define kOhmsKey @"Ohms"
#define kToleranceKey @"Tolerance"
#define kVoltsKey @"Volts"
#define kCurrentPageKey @"CurrentPage"
#define kShowLabelsKey @"ShowLabels"
#define kUseAccelerometerKey @"UseAccelerometer"

#define LocColor(x) NSLocalizedStringFromTable(x, @"Colors", nil)

#if DEBUG
    #define DebugLog(fmt, ...)  NSLog(fmt, ## __VA_ARGS__)
#else
    #define DebugLog(fmt, ...)
#endif

NSString *prettyPrintOhms (double ohms, int precision);
