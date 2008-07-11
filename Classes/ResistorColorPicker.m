//
//  ResistorColorPicker.m
//  iResist
//
//  Created by Jacob Farkas on 7/10/08.
//  Copyright 2008 Apple Computer. All rights reserved.
//

#import "ResistorColorPicker.h"


@implementation ResistorColorPicker

- (UIView *) _colorViewWithRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue
{
    UIView *view = [[UIView alloc] init];
    UIColor *color = [[UIColor alloc] initWithRed:red green:green blue:blue alpha:1.0];
    view.backgroundColor = color;
    [color release];
    view.frame = CGRectMake(0, 0, 70, 40);
    return [view autorelease];
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
    [colors addObject:[self _colorViewWithRed:0.000 green:0.000 blue:0.000]]; //black
    [colors addObject:[self _colorViewWithRed:0.396 green:0.263 blue:0.129]]; //brown
    [colors addObject:[self _colorViewWithRed:0.878 green:0.141 blue:0.063]]; //red
    [colors addObject:[self _colorViewWithRed:1.000 green:0.500 blue:0.000]]; //orange
    [colors addObject:[self _colorViewWithRed:1.000 green:1.000 blue:0.000]]; //yellow
    [colors addObject:[self _colorViewWithRed:0.133 green:0.545 blue:0.133]]; //green
    [colors addObject:[self _colorViewWithRed:0.000 green:0.000 blue:0.804]]; //blue
    [colors addObject:[self _colorViewWithRed:0.580 green:0.000 blue:0.827]]; //violet
    [colors addObject:[self _colorViewWithRed:0.500 green:0.500 blue:0.500]]; //gray
    [colors addObject:[self _colorViewWithRed:1.000 green:1.000 blue:1.000]]; //white
	[colors addObject: [self _endPickerImageView]];
    return [colors autorelease];
}

- (NSArray *) _colorViewsForToleranceComponent
{
    NSMutableArray *colors = [[NSMutableArray alloc] init];
	[colors addObject: [self _endPickerImageView]];
    [colors addObject:[self _colorViewWithRed:0.000 green:0.000 blue:0.000]]; //black
    [colors addObject:[self _colorViewWithRed:0.396 green:0.263 blue:0.129]]; //brown
    [colors addObject:[self _colorViewWithRed:0.878 green:0.141 blue:0.063]]; //red
    [colors addObject:[self _colorViewWithRed:0.133 green:0.545 blue:0.133]]; //green
    [colors addObject:[self _colorViewWithRed:0.000 green:0.000 blue:0.804]]; //blue
    [colors addObject:[self _colorViewWithRed:0.580 green:0.000 blue:0.827]]; //violet
    [colors addObject:[self _colorViewWithRed:0.500 green:0.500 blue:0.500]]; //gray
    [colors addObject:[self _colorViewWithRed:0.780 green:0.603 blue:0.235]]; //gold
    [colors addObject:[self _colorViewWithRed:0.750 green:0.750 blue:0.750]]; //silver
	[colors addObject: [self _endPickerImageView]];
    return [colors autorelease];
}

- (NSArray *) _colorViewsForMultiplierComponent
{
    NSMutableArray *colors = [[NSMutableArray alloc] init];
	[colors addObject: [self _endPickerImageView]];
    [colors addObject:[self _colorViewWithRed:0.000 green:0.000 blue:0.000]]; //black
    [colors addObject:[self _colorViewWithRed:0.396 green:0.263 blue:0.129]]; //brown
    [colors addObject:[self _colorViewWithRed:0.878 green:0.141 blue:0.063]]; //red
    [colors addObject:[self _colorViewWithRed:1.000 green:0.500 blue:0.000]]; //orange
    [colors addObject:[self _colorViewWithRed:1.000 green:1.000 blue:0.000]]; //yellow
    [colors addObject:[self _colorViewWithRed:0.133 green:0.545 blue:0.133]]; //green
    [colors addObject:[self _colorViewWithRed:0.000 green:0.000 blue:0.804]]; //blue
    [colors addObject:[self _colorViewWithRed:0.780 green:0.603 blue:0.235]]; //gold
    [colors addObject:[self _colorViewWithRed:0.750 green:0.750 blue:0.750]]; //silver
	[colors addObject: [self _endPickerImageView]];
    return [colors autorelease];
}

- (id) init
{
    if ((self = [super init])) {
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
		NSInteger nRow = row + (!row ? 1 : -1);
		
		[pickerView selectRow: nRow inComponent: component animated: NO];
		[self pickerView: pickerView didSelectRow: nRow inComponent: component];
	}
	else {
		// be ye warned: there be rounding errors ahead. there be pirate booty awarded to he
		// who can write a better prettyprinter
		double ohms = (([pickerView selectedRowInComponent:0] - 1) * 10) + ([pickerView selectedRowInComponent:1] - 1);
		NSUInteger mult = ([pickerView selectedRowInComponent:2] - 1);
		
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
	}
}
@end
