//
//  ResistorColorPicker.m
//  iResist
//
//  Created by Jacob Farkas on 7/10/08.
//  Copyright 2008 Apple Computer. All rights reserved.
//

#import "ResistorColorPicker.h"
#import "iResistViewController.h"

extern CFStringRef g_AppIDString;

@implementation ResistorColorPicker
- (UIView*) _colorViewWithRect:(CGRect)rect andColor: (UIColor*)color;
{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = color;
    view.frame = rect;
    return [view autorelease];
}

// This method is only tasked with calculating the correct CGRect for a color bar;
// currently it's obviously done "by hand," but the idea was that since this class has
// the ref to _resistor (the UIImageView), it should calculate rects programmatically. Should.
- (void) _drawResistorBarWithColorName: (NSString*)cName andComponent: (int)component;
{	
	CGFloat xCoord = 125.0, yCoord = 23.0, height = 48.0, width = 10;
	
	xCoord += (20 * component);
	
	if (component == 0 || component == 3) {
		xCoord += (component == 0 ? -5.0 : 5.0);
		width += 3;
	}
	
	[_viewController _drawResistorBarWithColor: cName 
										atRect: CGRectMake(xCoord, yCoord, width, height)
									   withTag: component];
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
	
	[tDict setValue: [UIColor colorWithRed:0.000 green:0.000 blue:0.000 alpha:1.0] forKey:@"black"];
	[tDict setValue: [UIColor colorWithRed:0.500 green:0.500 blue:0.500 alpha:1.0] forKey:@"gray"];
	[tDict setValue: [UIColor colorWithRed:1.000 green:1.000 blue:1.000 alpha:1.0] forKey:@"white"];
	[tDict setValue: [UIColor colorWithRed:0.396 green:0.263 blue:0.129 alpha:1.0] forKey:@"brown"];
	[tDict setValue: [UIColor colorWithRed:0.878 green:0.141 blue:0.063 alpha:1.0] forKey:@"red"];
	[tDict setValue: [UIColor colorWithRed:1.000 green:0.500 blue:0.000 alpha:1.0] forKey:@"orange"];
	[tDict setValue: [UIColor colorWithRed:1.000 green:1.000 blue:0.000 alpha:1.0] forKey:@"yellow"];
	[tDict setValue: [UIColor colorWithRed:0.133 green:0.545 blue:0.133 alpha:1.0] forKey:@"green"];
	[tDict setValue: [UIColor colorWithRed:0.000 green:0.000 blue:0.804 alpha:1.0] forKey:@"blue"];
	[tDict setValue: [UIColor colorWithRed:0.580 green:0.000 blue:0.827 alpha:1.0] forKey:@"violet"];
	[tDict setValue: [UIColor colorWithRed:0.780 green:0.603 blue:0.235 alpha:1.0] forKey:@"gold"];
	[tDict setValue: [UIColor colorWithRed:0.800 green:0.800 blue:0.800 alpha:1.0] forKey:@"silver"];
	
	_colors = tDict;
}

- (UIView *) _colorViewWithColor: (UIColor*)color;
{
	return [self _colorViewWithRect: CGRectMake(0, 0, 70, 40) andColor: color];
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
    [colors addObject: [self _colorViewWithColor: [_colors objectForKey: @"black"]]];
    [colors addObject: [self _colorViewWithColor: [_colors objectForKey: @"brown"]]];
    [colors addObject: [self _colorViewWithColor: [_colors objectForKey: @"red"]]];
    [colors addObject: [self _colorViewWithColor: [_colors objectForKey: @"orange"]]];
    [colors addObject: [self _colorViewWithColor: [_colors objectForKey: @"yellow"]]];
    [colors addObject: [self _colorViewWithColor: [_colors objectForKey: @"green"]]];
    [colors addObject: [self _colorViewWithColor: [_colors objectForKey: @"blue"]]];
    [colors addObject: [self _colorViewWithColor: [_colors objectForKey: @"violet"]]];
    [colors addObject: [self _colorViewWithColor: [_colors objectForKey: @"gray"]]];
    [colors addObject: [self _colorViewWithColor: [_colors objectForKey: @"white"]]];
	[colors addObject: [self _endPickerImageView]];
    return [colors autorelease];
}

- (NSArray *) _colorViewsForToleranceComponent
{
    NSMutableArray *colors = [[NSMutableArray alloc] init];
	[colors addObject: [self _endPickerImageView]];
    [colors addObject: [self _colorViewWithColor: [_colors objectForKey: @"black"]]];
    [colors addObject: [self _colorViewWithColor: [_colors objectForKey: @"brown"]]];
    [colors addObject: [self _colorViewWithColor: [_colors objectForKey: @"red"]]];
    [colors addObject: [self _colorViewWithColor: [_colors objectForKey: @"green"]]];
    [colors addObject: [self _colorViewWithColor: [_colors objectForKey: @"blue"]]];
    [colors addObject: [self _colorViewWithColor: [_colors objectForKey: @"violet"]]];
    [colors addObject: [self _colorViewWithColor: [_colors objectForKey: @"gray"]]];
    [colors addObject: [self _colorViewWithColor: [_colors objectForKey: @"gold"]]];
    [colors addObject: [self _colorViewWithColor: [_colors objectForKey: @"silver"]]];
	[colors addObject: [self _endPickerImageView]];
    return [colors autorelease];
}

- (NSArray *) _colorViewsForMultiplierComponent
{
    NSMutableArray *colors = [[NSMutableArray alloc] init];
	[colors addObject: [self _endPickerImageView]];
    [colors addObject: [self _colorViewWithColor: [_colors objectForKey: @"black"]]];
    [colors addObject: [self _colorViewWithColor: [_colors objectForKey: @"brown"]]];
    [colors addObject: [self _colorViewWithColor: [_colors objectForKey: @"red"]]];
    [colors addObject: [self _colorViewWithColor: [_colors objectForKey: @"orange"]]];
    [colors addObject: [self _colorViewWithColor: [_colors objectForKey: @"yellow"]]];
    [colors addObject: [self _colorViewWithColor: [_colors objectForKey: @"green"]]];
    [colors addObject: [self _colorViewWithColor: [_colors objectForKey: @"blue"]]];
    [colors addObject: [self _colorViewWithColor: [_colors objectForKey: @"gold"]]];
    [colors addObject: [self _colorViewWithColor: [_colors objectForKey: @"silver"]]];
	[colors addObject: [self _endPickerImageView]];
    return [colors autorelease];
}

- (id) init
{
    if ((self = [super init])) {
		[self _setupColorDictionary];
		
        NSMutableArray *colors = [[NSMutableArray alloc] init];
		
		_endImg = [[UIImage imageNamed: @"checker.bmp"] retain];
		
        [colors addObject:[self _colorViewsForComponent]];
        [colors addObject:[self _colorViewsForComponent]];
        [colors addObject:[self _colorViewsForMultiplierComponent]];
        [colors addObject:[self _colorViewsForToleranceComponent]];
        
        _colorViews = colors;
    }
	
    return self;
}

- (void) dealloc
{
    [_colorViews release];
	[_endImg release];
	[_colors release];
	
    [super dealloc];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
	NSArray* firstTwo = [NSArray arrayWithObjects: @"black", @"brown", @"red", @"orange", @"yellow", 
							@"green", @"blue", @"violet", @"gray", @"white", nil];
	NSArray* tol = [NSArray arrayWithObjects: @"black", @"brown", @"red", @"green", @"blue", @"violet", @"gray",
						@"gold", @"silver", nil];
	NSArray* mult = [NSArray arrayWithObjects: @"black", @"brown", @"red", @"orange", @"yellow", 
						@"green", @"blue", @"gold", @"silver", nil];
	
	row -= 1;
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
		// be ye warned: there be rounding errors ahead. there be pirate booty awarded to he
		// who can write a better prettyprinter
		double ohms = (([pickerView selectedRowInComponent:0] - 1) * 10) + ([pickerView selectedRowInComponent:1] - 1);
		NSUInteger mult = ([pickerView selectedRowInComponent:2] - 1);
		
		NSString* rowTitle = [self pickerView: pickerView titleForRow: row forComponent: component];
		[self _drawResistorBarWithColorName: rowTitle andComponent: component];
		
		if (mult < 7) {
			ohms *= pow(10, mult);
		} 
		else if (mult == 7) {
			ohms *= 0.1;
		} 
		else if (mult == 8) {
			ohms *= 0.01;
		}
		
		if (ohms < 1000) {
			_ohms.text = [NSString stringWithFormat:(ohms < 1 ? @"%.2f Ω" : (ohms < 10 ? @"%.1f Ω" : @"%.0f Ω")), ohms];
		}
		else if (ohms < 1000000) {
			_ohms.text = [NSString stringWithFormat:@"%.1f KΩ", ohms/1000.0];
		}
		else if (ohms < 1000000000) {
			_ohms.text = [NSString stringWithFormat:@"%.1f MΩ", ohms/1000000.0];
		}
		else {
			_ohms.text = [NSString stringWithFormat:@"%.1f GΩ", ohms/1000000000.0];
		}
		
		NSUInteger tol = ([pickerView selectedRowInComponent: 3] - 1);
		float tolPercent = 0.0f;
		
		switch (tol) {
			case 1:		// brown, 1%
			case 2:		// red, 2%
				tolPercent = (float)tol;
				break;
				
			case 3:		// green, 0.5%
				tolPercent = 0.5f;
				break;
				
			case 4:		// blue, 0.25%
				tolPercent = 0.25f;
				break;
				
			case 5:		// violet, 0.10%
				tolPercent = 0.10f;
				break;
				
			case 6:		// grey, 0.05%
				tolPercent = 0.05f;
				break;
				
			case 7:		// gold
				tolPercent = 5;
				break;
				
			case 8:		// silver
				tolPercent = 10;
				break;
		}
		
		if (tolPercent)
		{
			_tolerance.text = [NSString stringWithFormat: @"±%.2f%%", tolPercent];
		}
		
		CFPreferencesSetAppValue((CFStringRef)[NSString stringWithFormat:@"%d", component],
								 (CFStringRef)[NSString stringWithFormat:@"%d", row], g_AppIDString);
		CFPreferencesSetAppValue((CFStringRef)@"ohms", (CFStringRef)_ohms.text, g_AppIDString);
		CFPreferencesSetAppValue((CFStringRef)@"tolerance", (CFStringRef)_tolerance.text, g_AppIDString);
		CFPreferencesAppSynchronize(g_AppIDString);
	}
}

- (void)setOhmsText:(NSString*)text;
{
	_ohms.text = text;
}

- (void)setToleranceText:(NSString*)text;
{
	_tolerance.text = text;
}
@end
