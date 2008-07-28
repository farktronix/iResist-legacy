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
- (UIView*) _colorViewWithRect:(CGRect)rect andColor: (UIColor*)color;
{
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = color;
    view.frame = rect;
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
