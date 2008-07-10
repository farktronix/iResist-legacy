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

- (NSArray *) _colorViewsForComponent
{
    NSMutableArray *colors = [[NSMutableArray alloc] init];
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
    return [colors autorelease];
}

- (id) init
{
    if ((self = [super init])) {
        NSMutableArray *colors = [[NSMutableArray alloc] init];
        
        [colors addObject:[self _colorViewsForComponent]];
        [colors addObject:[self _colorViewsForComponent]];
        [colors addObject:[self _colorViewsForComponent]];
        [colors addObject:[self _colorViewsForComponent]];
        
        _colorViews = colors;
    }
    return self;
}

- (void) dealloc
{
    [_colorViews release];
    [super dealloc];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 4;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return 10;
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
    // be ye warned: there be rounding errors ahead. there be pirate booty awarded to he
    // who can write a better prettyprinter
    NSUInteger ohms = ([pickerView selectedRowInComponent:0] * 10) + [pickerView selectedRowInComponent:1];
    ohms *= pow(10, [pickerView selectedRowInComponent:2]);
    if (ohms < 1000) {
        _ohms.text = [NSString stringWithFormat:@"%d Ω", ohms];
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
}
@end
