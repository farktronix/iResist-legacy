//
//  ResistorColorPicker.h
//  iResist
//
//  Created by Jacob Farkas on 7/10/08.
//  Copyright 2008 Flying Monkey Enterprises. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ResistorValuePicker.h"

@class iResistViewController;

extern NSString * const kColorNameKey;          // NSString - Localized name of the color
extern NSString * const kColorColorKey;         // UIColor - The color itself
extern NSString * const kColorValueKey;         // NSNumber - The value represented by this color (ohms, magnitude, or tolerance)
extern NSString * const kColorTextInvertKey;    // NSNumber (BOOL) - YES if the text should display white to be visible on top of this color.

#define kColorTensComponent         0
#define kColorOnesComponent         1
#define kColorMultiplierComponent   2
#define kColorToleranceComponent    3

@interface ResistorColorPicker : ResistorValuePicker {
    UIImage *_endImg;
	    
    BOOL _showLabels;
}

@property (nonatomic) BOOL showLabels;

+ (NSArray *) componentInfo; // NSArray (component) of NSArray (rows) of NSDictionaries with row information
+ (NSDictionary *) itemInfoForRow:(NSInteger)row inComponent:(NSInteger)component;
@end
