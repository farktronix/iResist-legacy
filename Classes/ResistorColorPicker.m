//
//  ResistorColorPicker.m
//  iResist
//
//  Created by Jacob Farkas on 7/10/08.
//  Copyright 2008 Apple Computer. All rights reserved.
//

#import "ResistorColorPicker.h"
#import "iResistViewController.h"

@implementation ResistorColorPicker
+ (NSString *) colorNameForRow:(int)row inComponent:(int)component
{
    NSArray* firstTwo = [NSArray arrayWithObjects: @"black", @"brown", @"red", @"orange", @"yellow", 
                         @"green", @"blue", @"violet", @"gray", @"white", nil];
    NSArray* tol = [NSArray arrayWithObjects: @"black", @"brown", @"red", @"green", @"blue", @"violet", @"gray",
                    @"gold", @"silver", nil];
    NSArray* mult = [NSArray arrayWithObjects: @"black", @"brown", @"red", @"orange", @"yellow", 
                     @"green", @"blue", @"gold", @"silver", nil];
    
	if (component < 2) {
		return [firstTwo objectAtIndex: row];
	}
	else if (component == 2) {
		return [mult objectAtIndex: row];
	}
	else if (component == 3) {
		return [tol objectAtIndex: row];
	}
	
	return @"NotATitle";
}


- (UIView*) _colorViewWithRect:(CGRect)rect color: (UIColor*)color label:(NSString *)text;
{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = color;
    view.frame = rect;

    if (_showLabels) {
        UILabel *label = [[UILabel alloc] init];
        label.text = text;
        label.frame = view.frame;
        if ([text isEqualToString:@"White"] || [text isEqualToString:@"Silver"] || [text isEqualToString:@"Yellow"]) {
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

- (void) _randomSpin:(UIPickerView*)pView;
{
	int c;
	
	for (c = 0; c < 4; c++)
	{
		int r = (rand() % [self pickerView: pView numberOfRowsInComponent: c]);
		[pView selectRow: r inComponent: c animated: YES];
		[self pickerView: pView didSelectRow: r inComponent: c];
	}
}

- (void) _setupColorDictionary;
{
	NSMutableDictionary *tDict = [[NSMutableDictionary alloc] init];
	
	[tDict setValue: [UIColor colorWithRed:0.000 green:0.000 blue:0.000 alpha:1.0] forKey:@"Black"];
	[tDict setValue: [UIColor colorWithRed:0.500 green:0.500 blue:0.500 alpha:1.0] forKey:@"Gray"];
	[tDict setValue: [UIColor colorWithRed:1.000 green:1.000 blue:1.000 alpha:1.0] forKey:@"White"];
	[tDict setValue: [UIColor colorWithRed:0.396 green:0.263 blue:0.129 alpha:1.0] forKey:@"Brown"];
	[tDict setValue: [UIColor colorWithRed:0.878 green:0.141 blue:0.063 alpha:1.0] forKey:@"Red"];
	[tDict setValue: [UIColor colorWithRed:1.000 green:0.500 blue:0.000 alpha:1.0] forKey:@"Orange"];
	[tDict setValue: [UIColor colorWithRed:1.000 green:1.000 blue:0.000 alpha:1.0] forKey:@"Yellow"];
	[tDict setValue: [UIColor colorWithRed:0.133 green:0.545 blue:0.133 alpha:1.0] forKey:@"Green"];
	[tDict setValue: [UIColor colorWithRed:0.000 green:0.000 blue:0.804 alpha:1.0] forKey:@"Blue"];
	[tDict setValue: [UIColor colorWithRed:0.580 green:0.000 blue:0.827 alpha:1.0] forKey:@"Violet"];
	[tDict setValue: [UIColor colorWithRed:0.780 green:0.603 blue:0.235 alpha:1.0] forKey:@"Gold"];
	[tDict setValue: [UIColor colorWithRed:0.800 green:0.800 blue:0.800 alpha:1.0] forKey:@"Silver"];
	
	_colors = tDict;
}

- (UIView *) _colorViewWithColorString: (NSString*)color;
{
	return [self _colorViewWithRect: CGRectMake(0, 0, 70, 40) color: [_colors objectForKey:color] label:color];
}

- (UIImageView*) _endPickerImageView;
{
	UIImageView* _endImgView = [[UIImageView alloc] initWithImage: _endImg];
	_endImgView.frame = CGRectMake(0, 0, 70, 40);
	
	return [_endImgView autorelease];
}

- (NSArray *) _colorViewsForComponent
{
    NSMutableArray *colors = [[NSMutableArray alloc] init];
	[colors addObject: [self _endPickerImageView]];
    [colors addObject: [self _colorViewWithColorString:@"Black"]];
    [colors addObject: [self _colorViewWithColorString:@"Brown"]];
    [colors addObject: [self _colorViewWithColorString:@"Red"]];
    [colors addObject: [self _colorViewWithColorString:@"Orange"]];
    [colors addObject: [self _colorViewWithColorString:@"Yellow"]];
    [colors addObject: [self _colorViewWithColorString:@"Green"]];
    [colors addObject: [self _colorViewWithColorString:@"Blue"]];
    [colors addObject: [self _colorViewWithColorString:@"Violet"]];
    [colors addObject: [self _colorViewWithColorString:@"Gray"]];
    [colors addObject: [self _colorViewWithColorString:@"White"]];
	[colors addObject: [self _endPickerImageView]];
    return [colors autorelease];
}

- (NSArray *) _colorViewsForToleranceComponent
{
    NSMutableArray *colors = [[NSMutableArray alloc] init];
	[colors addObject: [self _endPickerImageView]];
    [colors addObject: [self _colorViewWithColorString:@"Black"]];
    [colors addObject: [self _colorViewWithColorString:@"Brown"]];
    [colors addObject: [self _colorViewWithColorString:@"Red"]];
    [colors addObject: [self _colorViewWithColorString:@"Green"]];
    [colors addObject: [self _colorViewWithColorString:@"Blue"]];
    [colors addObject: [self _colorViewWithColorString:@"Violet"]];
    [colors addObject: [self _colorViewWithColorString:@"Gray"]];
    [colors addObject: [self _colorViewWithColorString:@"Gold"]];
    [colors addObject: [self _colorViewWithColorString:@"Silver"]];
	[colors addObject: [self _endPickerImageView]];
    return [colors autorelease];
}

- (NSArray *) _colorViewsForMultiplierComponent
{
    NSMutableArray *colors = [[NSMutableArray alloc] init];
	[colors addObject: [self _endPickerImageView]];
    [colors addObject: [self _colorViewWithColorString:@"Black"]];
    [colors addObject: [self _colorViewWithColorString:@"Brown"]];
    [colors addObject: [self _colorViewWithColorString:@"Red"]];
    [colors addObject: [self _colorViewWithColorString:@"Orange"]];
    [colors addObject: [self _colorViewWithColorString:@"Yellow"]];
    [colors addObject: [self _colorViewWithColorString:@"Green"]];
    [colors addObject: [self _colorViewWithColorString:@"Blue"]];
    [colors addObject: [self _colorViewWithColorString:@"Gold"]];
    [colors addObject: [self _colorViewWithColorString:@"Silver"]];
	[colors addObject: [self _endPickerImageView]];
    return [colors autorelease];
}

- (void) _setupColorViews
{
    NSMutableArray *colors = [[NSMutableArray alloc] init];
    [colors addObject:[self _colorViewsForComponent]];
    [colors addObject:[self _colorViewsForComponent]];
    [colors addObject:[self _colorViewsForMultiplierComponent]];
    [colors addObject:[self _colorViewsForToleranceComponent]];
    [_colorViews release];
    _colorViews = colors;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    _showLabels = [[[NSUserDefaults standardUserDefaults] valueForKey:@"ShowLabels"] boolValue];
    [self _setupColorViews];
}

- (id) init
{
    if ((self = [super init])) {
        _showLabels = [[[NSUserDefaults standardUserDefaults] valueForKey:@"ShowLabels"] boolValue];
        [[NSUserDefaults standardUserDefaults] addObserver:self forKeyPath:@"ShowLabels" options:0 context:nil];
        
		[self _setupColorDictionary];
		
		_endImg = [[UIImage imageNamed: @"checker.bmp"] retain];
        
        [self _setupColorViews];
    }
	
    return self;
}

- (void) dealloc
{
    [[NSUserDefaults standardUserDefaults] removeObserver:self forKeyPath:@"ShowLabels"];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [_colorViews release];
	[_endImg release];
	[_colors release];
	
    [super dealloc];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 4;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return (component < 2 ? 12 : 11);
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    return 70;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 40;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view;

{
    return [[_colorViews objectAtIndex:component] objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
	if (row == 0 || row == (component < 2 ? 11 : 10)) {
		// if the user selects one of the end-component sentinel images, just slide them to the one they really wanted
		NSInteger nRow = row + (!row ? 1 : -1);
		
		[pickerView selectRow: nRow inComponent: component animated: NO];
		[self pickerView: pickerView didSelectRow: nRow inComponent: component];
	}
	else {        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSArray *componentValues = [NSArray arrayWithObjects:[NSNumber numberWithInt:[pickerView selectedRowInComponent:0]],
                                                             [NSNumber numberWithInt:[pickerView selectedRowInComponent:1]],
                                                             [NSNumber numberWithInt:[pickerView selectedRowInComponent:2]],
                                                             [NSNumber numberWithInt:[pickerView selectedRowInComponent:3]],
                                                             nil];
        [defaults setValue:componentValues forKey:@"components"];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kResistorValueChangedNotification object:nil];
	}
}
@end
