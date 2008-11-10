//
//  ResistorColorPicker.m
//  iResist
//
//  Copyright 2008 Flying Monkey Enterprises. All rights reserved.
//

#import "ResistorColorPicker.h"
#import "iResistViewController.h"

NSString * const kColorNameKey       = @"Name";
NSString * const kColorColorKey      = @"Color";
NSString * const kColorValueKey      = @"Value";
NSString * const kColorTextInvertKey = @"Invert";

#define kBlackColor  [UIColor colorWithRed:0.000 green:0.000 blue:0.000 alpha:1.0]
#define kGrayColor   [UIColor colorWithRed:0.500 green:0.500 blue:0.500 alpha:1.0]
#define kWhiteColor  [UIColor colorWithRed:1.000 green:1.000 blue:1.000 alpha:1.0]
#define kBrownColor  [UIColor colorWithRed:0.396 green:0.263 blue:0.129 alpha:1.0]
#define kRedColor    [UIColor colorWithRed:0.878 green:0.141 blue:0.063 alpha:1.0]
#define kOrangeColor [UIColor colorWithRed:1.000 green:0.500 blue:0.000 alpha:1.0]
#define kYellowColor [UIColor colorWithRed:1.000 green:1.000 blue:0.000 alpha:1.0]
#define kGreenColor  [UIColor colorWithRed:0.133 green:0.545 blue:0.133 alpha:1.0]
#define kBlueColor   [UIColor colorWithRed:0.000 green:0.000 blue:0.804 alpha:1.0]
#define kVioletColor [UIColor colorWithRed:0.580 green:0.000 blue:0.827 alpha:1.0]
#define kGoldColor   [UIColor colorWithRed:0.780 green:0.603 blue:0.235 alpha:1.0]
#define kSilverColor [UIColor colorWithRed:0.800 green:0.800 blue:0.800 alpha:1.0]
#define kEndColor    [UIColor colorWithRed:0.500 green:0.500 blue:0.500 alpha:0.8]

#define kEndImageName @"__END_IMAGE__"

#define kNumPaddingCells 3

@implementation ResistorColorPicker

@synthesize showLabels = _showLabels;

static NSArray *sComponentInfo = nil;
+ (NSArray *) componentInfo
{
    if (sComponentInfo == nil) {
        NSMutableArray *componentInfo = [[NSMutableArray alloc] initWithCapacity:kColorToleranceComponent + 1];
        
        // set up resistor number info
        NSMutableArray *numberInfo = [[NSMutableArray alloc] init];
        {
            [numberInfo addObject:[NSDictionary dictionaryWithObjectsAndKeys:
                                   LocColor(@"Black"), kColorNameKey, 
                                   kBlackColor, kColorColorKey,
                                   [NSNumber numberWithInt:0], kColorValueKey,
                                   [NSNumber numberWithBool:NO], kColorTextInvertKey,
                                   nil]];
            [numberInfo addObject:[NSDictionary dictionaryWithObjectsAndKeys:
                                   LocColor(@"Brown"), kColorNameKey, 
                                   kBrownColor, kColorColorKey,
                                   [NSNumber numberWithInt:1], kColorValueKey,
                                   [NSNumber numberWithBool:NO], kColorTextInvertKey,
                                   nil]];
            [numberInfo addObject:[NSDictionary dictionaryWithObjectsAndKeys:
                                   LocColor(@"Red"), kColorNameKey, 
                                   kRedColor, kColorColorKey,
                                   [NSNumber numberWithInt:2], kColorValueKey,
                                   [NSNumber numberWithBool:NO], kColorTextInvertKey,
                                   nil]];
            [numberInfo addObject:[NSDictionary dictionaryWithObjectsAndKeys:
                                   LocColor(@"Orange"), kColorNameKey, 
                                   kOrangeColor, kColorColorKey,
                                   [NSNumber numberWithInt:3], kColorValueKey,
                                   [NSNumber numberWithBool:NO], kColorTextInvertKey,
                                   nil]];
            [numberInfo addObject:[NSDictionary dictionaryWithObjectsAndKeys:
                                   LocColor(@"Yellow"), kColorNameKey, 
                                   kYellowColor, kColorColorKey,
                                   [NSNumber numberWithInt:4], kColorValueKey,
                                   [NSNumber numberWithBool:YES], kColorTextInvertKey,
                                   nil]];
            [numberInfo addObject:[NSDictionary dictionaryWithObjectsAndKeys:
                                   LocColor(@"Green"), kColorNameKey, 
                                   kGreenColor, kColorColorKey,
                                   [NSNumber numberWithInt:5], kColorValueKey,
                                   [NSNumber numberWithBool:NO], kColorTextInvertKey,
                                   nil]];
            [numberInfo addObject:[NSDictionary dictionaryWithObjectsAndKeys:
                                   LocColor(@"Blue"), kColorNameKey, 
                                   kBlueColor, kColorColorKey,
                                   [NSNumber numberWithInt:6], kColorValueKey,
                                   [NSNumber numberWithBool:NO], kColorTextInvertKey,
                                   nil]];
            [numberInfo addObject:[NSDictionary dictionaryWithObjectsAndKeys:
                                   LocColor(@"Violet"), kColorNameKey, 
                                   kVioletColor, kColorColorKey,
                                   [NSNumber numberWithInt:7], kColorValueKey,
                                   [NSNumber numberWithBool:NO], kColorTextInvertKey,
                                   nil]];
            [numberInfo addObject:[NSDictionary dictionaryWithObjectsAndKeys:
                                   LocColor(@"Gray"), kColorNameKey, 
                                   kGrayColor, kColorColorKey,
                                   [NSNumber numberWithInt:8], kColorValueKey,
                                   [NSNumber numberWithBool:NO], kColorTextInvertKey,
                                   nil]];
            [numberInfo addObject:[NSDictionary dictionaryWithObjectsAndKeys:
                                   LocColor(@"White"), kColorNameKey, 
                                   kWhiteColor, kColorColorKey,
                                   [NSNumber numberWithInt:9], kColorValueKey,
                                   [NSNumber numberWithBool:YES], kColorTextInvertKey,
                                   nil]];
        }
        [componentInfo addObject:numberInfo]; // kColorTensComponent
        [componentInfo addObject:numberInfo]; // kColorOnesComponent
        
        // set up multiplier info
        NSMutableArray *multiplierInfo = [numberInfo mutableCopy];
        {
            // the multiplier has two extra components for 10^-1 and 10^-2
            [multiplierInfo addObject:[NSDictionary dictionaryWithObjectsAndKeys:
                                       LocColor(@"Gold"), kColorNameKey, 
                                       kGoldColor, kColorColorKey,
                                       [NSNumber numberWithInt:-1], kColorValueKey,
                                       [NSNumber numberWithBool:NO], kColorTextInvertKey,
                                       nil]];
            [multiplierInfo addObject:[NSDictionary dictionaryWithObjectsAndKeys:
                                       LocColor(@"Silver"), kColorNameKey, 
                                       kSilverColor, kColorColorKey,
                                       [NSNumber numberWithInt:-2], kColorValueKey,
                                       [NSNumber numberWithBool:YES], kColorTextInvertKey,
                                       nil]];
        }
        [componentInfo addObject:multiplierInfo]; // kColorMultiplierComponent
        
        [numberInfo release]; // retained by componentInfo
        [multiplierInfo release]; // retained by componentInfo
        
        // set up tolerance info
        NSMutableArray *toleranceInfo = [[NSMutableArray alloc] init];
        {
            [toleranceInfo addObject:[NSDictionary dictionaryWithObjectsAndKeys:
                                      LocColor(@"Silver"), kColorNameKey, 
                                      kSilverColor, kColorColorKey,
                                      [NSNumber numberWithDouble:10.0], kColorValueKey,
                                      [NSNumber numberWithBool:YES], kColorTextInvertKey,
                                      nil]];
            [toleranceInfo addObject:[NSDictionary dictionaryWithObjectsAndKeys:
                                      LocColor(@"Gold"), kColorNameKey, 
                                      kGoldColor, kColorColorKey,
                                      [NSNumber numberWithDouble:5.0], kColorValueKey,
                                      [NSNumber numberWithBool:NO], kColorTextInvertKey,
                                      nil]];
            [toleranceInfo addObject:[NSDictionary dictionaryWithObjectsAndKeys:
                                      LocColor(@"Red"), kColorNameKey, 
                                      kRedColor, kColorColorKey,
                                      [NSNumber numberWithDouble:2.0], kColorValueKey,
                                      [NSNumber numberWithBool:NO], kColorTextInvertKey,
                                      nil]];
            [toleranceInfo addObject:[NSDictionary dictionaryWithObjectsAndKeys:
                                      LocColor(@"Brown"), kColorNameKey, 
                                      kBrownColor, kColorColorKey,
                                      [NSNumber numberWithDouble:1.0], kColorValueKey,
                                      [NSNumber numberWithBool:NO], kColorTextInvertKey,
                                      nil]];
            [toleranceInfo addObject:[NSDictionary dictionaryWithObjectsAndKeys:
                                      LocColor(@"Green"), kColorNameKey, 
                                      kGreenColor, kColorColorKey,
                                      [NSNumber numberWithDouble:0.5], kColorValueKey,
                                      [NSNumber numberWithBool:NO], kColorTextInvertKey,
                                      nil]];
            [toleranceInfo addObject:[NSDictionary dictionaryWithObjectsAndKeys:
                                      LocColor(@"Blue"), kColorNameKey, 
                                      kBlueColor, kColorColorKey,
                                      [NSNumber numberWithDouble:0.25], kColorValueKey,
                                      [NSNumber numberWithBool:NO], kColorTextInvertKey,
                                      nil]];
            [toleranceInfo addObject:[NSDictionary dictionaryWithObjectsAndKeys:
                                      LocColor(@"Violet"), kColorNameKey, 
                                      kVioletColor, kColorColorKey,
                                      [NSNumber numberWithDouble:0.1], kColorValueKey,
                                      [NSNumber numberWithBool:NO], kColorTextInvertKey,
                                      nil]];
            [toleranceInfo addObject:[NSDictionary dictionaryWithObjectsAndKeys:
                                      LocColor(@"Gray"), kColorNameKey, 
                                      kGrayColor, kColorColorKey,
                                      [NSNumber numberWithDouble:0.05], kColorValueKey,
                                      [NSNumber numberWithBool:NO], kColorTextInvertKey,
                                      nil]];
        }
        [componentInfo addObject:toleranceInfo]; // kColorToleranceComponent
        [toleranceInfo release]; // retained by componentInfo
        
        sComponentInfo = componentInfo;
    }
    return sComponentInfo;
}

- (id) init
{
    if ((self = [super init])) {
        _showLabels = [[[NSUserDefaults standardUserDefaults] valueForKey:kShowLabelsKey] boolValue];        		
		_endImg = [[UIImage imageNamed: @"checker.bmp"] retain];
    }
	
    return self;
}

- (void) dealloc
{
	[_endImg release];
    [super dealloc];
}

+ (NSDictionary *) itemInfoForRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSArray *componentInfo = [ResistorColorPicker componentInfo];
    if (component < 0 || component >= [componentInfo count]) return nil;
    
    NSArray *curComponent = [componentInfo objectAtIndex:component];
    if (row < kNumPaddingCells || row >= [curComponent count] + kNumPaddingCells) {
        // TODO: make this static or something
        return [NSDictionary dictionaryWithObjectsAndKeys:
                kEndImageName, kColorNameKey, 
                kEndColor, kColorColorKey,
                [NSNumber numberWithDouble:0], kColorValueKey,
                [NSNumber numberWithBool:NO], kColorTextInvertKey,
                nil];
    }
    
    return [curComponent objectAtIndex:row - kNumPaddingCells];
}

- (void) selectRow:(NSInteger)row inComponent:(NSInteger)component forPicker:(UIPickerView*)picker
{
    _manualUpdate = YES;
    [picker selectRow:row inComponent:component animated:NO];
    _manualUpdate = NO;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    NSArray *componentInfo = [ResistorColorPicker componentInfo];
    if (component < 0 || component >= [componentInfo count]) return 0;
    return [[componentInfo objectAtIndex:component] count] + (kNumPaddingCells * 2); // add padding items to the count
}

- (UIView*) _viewForRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSDictionary *itemInfo = [ResistorColorPicker itemInfoForRow:row inComponent:component];
    NSString *colorName = [itemInfo objectForKey:kColorNameKey];
    
    UIView *view = nil;
    if ([colorName isEqualToString:kEndImageName]) {
        view = [[UIImageView alloc] initWithImage:_endImg];
        colorName = @"";
    } else {
        view = [[UIView alloc] init];
        view.backgroundColor = [itemInfo objectForKey:kColorColorKey];
    }
    view.frame = CGRectMake(0, 0, 70, 40);
    
    if (_showLabels) {
        UILabel *label = [[UILabel alloc] init];
        label.text = colorName;
        label.frame = view.frame;
        if ([[itemInfo objectForKey:kColorTextInvertKey] boolValue] == YES) {
            label.textColor = [UIColor blackColor];
        } else {
            label.textColor = [UIColor whiteColor];
        }
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = UITextAlignmentCenter;
        [view addSubview:label];
        [label release];
    }
    
    return [view autorelease];
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view;

{ 
    // (fark): Using the cached view seems to cause all kinds of weird display problems. It's disabled for now. Hopefully this doesn't screw our memory use
//    if (view) return [[view retain] autorelease];
    return [self _viewForRow:row inComponent:component];
}

- (void) setOhmValue:(double)ohms forPicker:(UIPickerView *)picker
{
    int mult = (int)log10(ohms) - 1;
    if (ohms < 10 && ohms > 1) mult = 0; // hack :(
    int relativeOhms = ohms / pow(10, mult);
    int tens = (int)(relativeOhms / 10);
    int ones = (int)(relativeOhms % 10);
    
    // hardcode silver and gold multiplers
    if (mult < 0) {
        int numMults = [[[ResistorColorPicker componentInfo] objectAtIndex:kColorMultiplierComponent] count];
        if (ohms < 0.1) {
            mult = numMults - 1;
        } else if (ohms < 1) {
            mult = numMults - 2;
        } else {
            mult = 0;
        }
    }
    
    DebugLog(@"Setting ohms value to %f (%d %d %d)", ohms, tens, ones, mult);
    [self selectRow:tens + kNumPaddingCells inComponent:kColorTensComponent forPicker:picker];
    [self selectRow:ones + kNumPaddingCells inComponent:kColorOnesComponent forPicker:picker];
    [self selectRow:mult + kNumPaddingCells inComponent:kColorMultiplierComponent forPicker:picker];
}

- (double) getOhmValueForPicker:(UIPickerView *)picker;
{
    double ohms = 0.0;
    NSDictionary *tensInfo = [ResistorColorPicker itemInfoForRow:[picker selectedRowInComponent:kColorTensComponent] inComponent:kColorTensComponent];
    NSDictionary *onesInfo = [ResistorColorPicker itemInfoForRow:[picker selectedRowInComponent:kColorOnesComponent] inComponent:kColorOnesComponent];
    NSDictionary *multInfo = [ResistorColorPicker itemInfoForRow:[picker selectedRowInComponent:kColorMultiplierComponent] inComponent:kColorMultiplierComponent];
    
    ohms = ([[tensInfo objectForKey:kColorValueKey] intValue] * 10) + [[onesInfo objectForKey:kColorValueKey] intValue];
    ohms *= pow(10, [[multInfo objectForKey:kColorValueKey] intValue]);
    
    return ohms;
}

- (void) setTolerance:(double)tolerance forPicker:(UIPickerView *)picker
{
    NSArray *tolComponent = [[ResistorColorPicker componentInfo] objectAtIndex:kColorToleranceComponent];
    // Searching isn't exactly efficient, but it's more flexible. 
    // Not like we're going to add new tolerances, but whatever.
    int component = 0;
    for (component = 0; component < [tolComponent count]; component++) {
        NSDictionary *curInfo = [tolComponent objectAtIndex:component];
        if ([[curInfo objectForKey:kColorValueKey] doubleValue] == tolerance) {
            break;
        }
    }
    if (component == [tolComponent count]) component = 0; // we didn't find it. aww crap.
    [self selectRow:component + kNumPaddingCells inComponent:kColorToleranceComponent forPicker:picker];
}

- (double) getToleranceForPicker:(UIPickerView *)picker
{
    NSDictionary *tolInfo = [ResistorColorPicker itemInfoForRow:[picker selectedRowInComponent:kColorToleranceComponent] inComponent:kColorToleranceComponent];
    return [[tolInfo objectForKey:kColorValueKey] doubleValue];
}

- (NSInteger) _fixRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSArray *componentInfo = [ResistorColorPicker componentInfo];
    if (component < 0 || component >= [componentInfo count]) return row;
    
    // Don't allow selection of the padding item
    if (row < kNumPaddingCells) return kNumPaddingCells;
    
    // Figure out if we're selecting the padding item for this component
    int componentCount = [[componentInfo objectAtIndex:component] count];
    if (row >= componentCount + kNumPaddingCells) return componentCount + kNumPaddingCells - 1;
    return row;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    DebugLog(@"Row %d selected in component %d", row, component);
    if (_manualUpdate) return;
    
    NSInteger fixedRow = [self _fixRow:row inComponent:component];
	if (fixedRow != row) {
		// if the user selects one of the end-component sentinel images, just slide them to the one they really wanted
        DebugLog(@"Fixing up row %d to %d", row, fixedRow);
		[self selectRow:fixedRow inComponent:component forPicker:pickerView];
        // call ourself recursively with the fixed up value
        [self pickerView:pickerView didSelectRow:fixedRow inComponent:component];
	}
	else {
        NSNumber *ohms = [NSNumber numberWithDouble:[self getOhmValueForPicker:pickerView]];
        NSNumber *tolerance = [NSNumber numberWithDouble:[self getToleranceForPicker:pickerView]];
        DebugLog(@"Setting ohmage from pickerView: %@ +/- %@", ohms, tolerance);
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        if (component < kColorToleranceComponent) {
            [defaults setValue:ohms forKey:kOhmsKey];
        } else {
            [defaults setValue:tolerance forKey:kToleranceKey];
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:kResistorPickerChangedNotification object:nil];
	}
}
@end
