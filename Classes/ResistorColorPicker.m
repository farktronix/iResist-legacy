//
//  ResistorColorPicker.m
//  iResist
//
//  Copyright 2008 Flying Monkey Enterprises. All rights reserved.
//

#import "ResistorColorPicker.h"
#import "iResistViewController.h"

@implementation ResistorColorPicker
+ (NSString *) colorNameForRow:(int)row inComponent:(int)component
{
	// sometimes the accel. randomizer will pick row -1 while "spinning", causing a crash
	if (row >= 0) {
		NSArray* firstTwo = [NSArray arrayWithObjects: LocColor(@"Black"), LocColor(@"Brown"), LocColor(@"Red"), LocColor(@"Orange"), LocColor(@"Yellow"), 
							 LocColor(@"Green"), LocColor(@"Blue"), LocColor(@"Violet"), LocColor(@"Gray"), LocColor(@"White"), nil];
		NSArray* tol = [NSArray arrayWithObjects: LocColor(@"Black"), LocColor(@"Brown"), LocColor(@"Red"), LocColor(@"Green"), LocColor(@"Blue"), LocColor(@"Violet"), LocColor(@"Gray"),
						LocColor(@"Gold"), LocColor(@"Silver"), nil];
		NSArray* mult = [NSArray arrayWithObjects: LocColor(@"Black"), LocColor(@"Brown"), LocColor(@"Red"), LocColor(@"Orange"), LocColor(@"Yellow"), 
						 LocColor(@"Green"), LocColor(@"Blue"), LocColor(@"Gold"), LocColor(@"Silver"), nil];
		
		if (component < 2) {
			return [firstTwo objectAtIndex: row];
		}
		else if (component == 2) {
			return [mult objectAtIndex: row];
		}
		else if (component == 3) {
			return [tol objectAtIndex: row];
		}
	}
	
	return @"";
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
        if ([text isEqualToString:LocColor(@"White")] || [text isEqualToString:LocColor(@"Silver")] || [text isEqualToString:LocColor(@"Yellow")]) {
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

- (void) _setupColorDictionary;
{
	NSMutableDictionary *tDict = [[NSMutableDictionary alloc] init];
	
	[tDict setValue: [UIColor colorWithRed:0.000 green:0.000 blue:0.000 alpha:1.0] forKey:LocColor(@"Black")];
	[tDict setValue: [UIColor colorWithRed:0.500 green:0.500 blue:0.500 alpha:1.0] forKey:LocColor(@"Gray")];
	[tDict setValue: [UIColor colorWithRed:1.000 green:1.000 blue:1.000 alpha:1.0] forKey:LocColor(@"White")];
	[tDict setValue: [UIColor colorWithRed:0.396 green:0.263 blue:0.129 alpha:1.0] forKey:LocColor(@"Brown")];
	[tDict setValue: [UIColor colorWithRed:0.878 green:0.141 blue:0.063 alpha:1.0] forKey:LocColor(@"Red")];
	[tDict setValue: [UIColor colorWithRed:1.000 green:0.500 blue:0.000 alpha:1.0] forKey:LocColor(@"Orange")];
	[tDict setValue: [UIColor colorWithRed:1.000 green:1.000 blue:0.000 alpha:1.0] forKey:LocColor(@"Yellow")];
	[tDict setValue: [UIColor colorWithRed:0.133 green:0.545 blue:0.133 alpha:1.0] forKey:LocColor(@"Green")];
	[tDict setValue: [UIColor colorWithRed:0.000 green:0.000 blue:0.804 alpha:1.0] forKey:LocColor(@"Blue")];
	[tDict setValue: [UIColor colorWithRed:0.580 green:0.000 blue:0.827 alpha:1.0] forKey:LocColor(@"Violet")];
	[tDict setValue: [UIColor colorWithRed:0.780 green:0.603 blue:0.235 alpha:1.0] forKey:LocColor(@"Gold")];
	[tDict setValue: [UIColor colorWithRed:0.800 green:0.800 blue:0.800 alpha:1.0] forKey:LocColor(@"Silver")];
	
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
    [colors addObject: [self _colorViewWithColorString:LocColor(@"Black")]];
    [colors addObject: [self _colorViewWithColorString:LocColor(@"Brown")]];
    [colors addObject: [self _colorViewWithColorString:LocColor(@"Red")]];
    [colors addObject: [self _colorViewWithColorString:LocColor(@"Orange")]];
    [colors addObject: [self _colorViewWithColorString:LocColor(@"Yellow")]];
    [colors addObject: [self _colorViewWithColorString:LocColor(@"Green")]];
    [colors addObject: [self _colorViewWithColorString:LocColor(@"Blue")]];
    [colors addObject: [self _colorViewWithColorString:LocColor(@"Violet")]];
    [colors addObject: [self _colorViewWithColorString:LocColor(@"Gray")]];
    [colors addObject: [self _colorViewWithColorString:LocColor(@"White")]];
	[colors addObject: [self _endPickerImageView]];
    return [colors autorelease];
}

- (NSArray *) _colorViewsForToleranceComponent
{
    NSMutableArray *colors = [[NSMutableArray alloc] init];
	[colors addObject: [self _endPickerImageView]];
    [colors addObject: [self _colorViewWithColorString:LocColor(@"Black")]];
    [colors addObject: [self _colorViewWithColorString:LocColor(@"Brown")]];
    [colors addObject: [self _colorViewWithColorString:LocColor(@"Red")]];
    [colors addObject: [self _colorViewWithColorString:LocColor(@"Green")]];
    [colors addObject: [self _colorViewWithColorString:LocColor(@"Blue")]];
    [colors addObject: [self _colorViewWithColorString:LocColor(@"Violet")]];
    [colors addObject: [self _colorViewWithColorString:LocColor(@"Gray")]];
    [colors addObject: [self _colorViewWithColorString:LocColor(@"Gold")]];
    [colors addObject: [self _colorViewWithColorString:LocColor(@"Silver")]];
	[colors addObject: [self _endPickerImageView]];
    return [colors autorelease];
}

- (NSArray *) _colorViewsForMultiplierComponent
{
    NSMutableArray *colors = [[NSMutableArray alloc] init];
	[colors addObject: [self _endPickerImageView]];
    [colors addObject: [self _colorViewWithColorString:LocColor(@"Black")]];
    [colors addObject: [self _colorViewWithColorString:LocColor(@"Brown")]];
    [colors addObject: [self _colorViewWithColorString:LocColor(@"Red")]];
    [colors addObject: [self _colorViewWithColorString:LocColor(@"Orange")]];
    [colors addObject: [self _colorViewWithColorString:LocColor(@"Yellow")]];
    [colors addObject: [self _colorViewWithColorString:LocColor(@"Green")]];
    [colors addObject: [self _colorViewWithColorString:LocColor(@"Blue")]];
    [colors addObject: [self _colorViewWithColorString:LocColor(@"Gold")]];
    [colors addObject: [self _colorViewWithColorString:LocColor(@"Silver")]];
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
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([keyPath isEqualToString:kShowLabelsKey]) {
        _showLabels = [[defaults valueForKey:kShowLabelsKey] boolValue];
        [self _setupColorViews];
    }
}

- (id) init
{
    if ((self = [super init])) {
        _showLabels = [[[NSUserDefaults standardUserDefaults] valueForKey:kShowLabelsKey] boolValue];
        [[NSUserDefaults standardUserDefaults] addObserver:self forKeyPath:kShowLabelsKey options:0 context:nil];
        
		[self _setupColorDictionary];
		
		_endImg = [[UIImage imageNamed: @"checker.bmp"] retain];
        
        [self _setupColorViews];
    }
	
    return self;
}

- (void) dealloc
{
    [[NSUserDefaults standardUserDefaults] removeObserver:self forKeyPath:kShowLabelsKey];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [_colorViews release];
	[_endImg release];
	[_colors release];
	
    [super dealloc];
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return (component < 2 ? 12 : 11);
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view;

{
    return [[_colorViews objectAtIndex:component] objectAtIndex:row];
}

- (void) setOhmValue:(double)ohms forPicker:(UIPickerView *)picker
{
    int exp = (int)log10(ohms);
    int firstNum = 0;
    int secondNum = 0;
    
    if (ohms == 0) {
        exp = 8;
    }
    else if (ohms < 1.0) {
        firstNum = (int)(ohms * 10);
        secondNum = (int)(ohms * 100) % (10 * (firstNum == 0 ? 1 : firstNum));
        exp = 9;
    }
    else if (ohms < 10) {
        firstNum = (int)ohms;
        secondNum = (int)(ohms * 10) % (10 * firstNum);
        if (secondNum == 0) {
            secondNum = firstNum;
            firstNum = 0;
            exp = 1;
        } else {
            exp = 8;
        }
    } 
    else {
        firstNum = (int)(ohms / pow(10, exp));
        secondNum = (int)((ohms / pow(10, exp)) * 10) % (10 * firstNum);
    }
    
    _manualUpdate = YES;
    NSLog(@"Setting ohms value to %f (%d %d %d)", ohms, firstNum, secondNum, exp);
    [picker selectRow:firstNum + 1 inComponent:0 animated:NO];
    [picker selectRow:secondNum + 1 inComponent:1 animated:NO];
    [picker selectRow:exp inComponent:2 animated:NO];
    _manualUpdate = NO;
}

- (double) getOhmValueForPicker:(UIPickerView *)picker;
{
    double ohms = (([picker selectedRowInComponent:0] - 1) * 10) + ([picker selectedRowInComponent:1] - 1);
    NSUInteger mult = ([picker selectedRowInComponent:2] - 1);
    
    if (mult < 7) {
        ohms *= pow(10, mult);
    } 
    else if (mult == 7) {
        ohms *= 0.1;
    } 
    else if (mult == 8) {
        ohms *= 0.01;
    }
    
    return ohms;
}

- (void) setTolerance:(double)tolerance forPicker:(UIPickerView *)picker
{
    _manualUpdate = YES;
    if (tolerance == 0.0) {
        [picker selectRow:1 inComponent:3 animated:YES];
    }
    else if (tolerance == 1.0) {
        [picker selectRow:2 inComponent:3 animated:YES];
    }
    else if (tolerance == 2.0) {
        [picker selectRow:3 inComponent:3 animated:YES];
    }
    else if (tolerance == 0.5) {
        [picker selectRow:4 inComponent:3 animated:YES];
    }
    else if (tolerance == 0.25) {
        [picker selectRow:5 inComponent:3 animated:YES];
    }
    else if (tolerance == 0.1) {
        [picker selectRow:6 inComponent:3 animated:YES];
    }
    else if (tolerance == 0.05) {
        [picker selectRow:7 inComponent:3 animated:YES];
    }
    else if (tolerance == 5.00) {
        [picker selectRow:8 inComponent:3 animated:YES];
    }
    else if (tolerance == 10.00) {
        [picker selectRow:9 inComponent:3 animated:YES];
    }
    _manualUpdate = NO;
}

- (double) getToleranceForPicker:(UIPickerView *)picker
{
    NSUInteger tol = ([picker selectedRowInComponent:3] - 1);
    double tolPercent = 0.0;
    
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
    return tolPercent;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSLog(@"Row %d selected in component %d", row, component);
    if (_manualUpdate) return;
	if (row == 0 || row == (component < 2 ? 11 : 10)) {
		// if the user selects one of the end-component sentinel images, just slide them to the one they really wanted
		NSInteger nRow = row + (!row ? 1 : -1);
		
        NSLog(@"Fixing up row to %d", nRow);
		[pickerView selectRow:nRow inComponent:component animated:NO];
        [self pickerView:pickerView didSelectRow:nRow inComponent:component];
	}
	else {
        NSNumber *ohms = [NSNumber numberWithDouble:[self getOhmValueForPicker:pickerView]];
        NSNumber *tolerance = [NSNumber numberWithDouble:[self getToleranceForPicker:pickerView]];
        NSLog(@"Setting ohmage from pickerView: %@ +/- %@", ohms, tolerance);
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        if (component < 3) {
            [defaults setValue:ohms forKey:kOhmsKey];
        } else {
            [defaults setValue:tolerance forKey:kToleranceKey];
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:kResistorValueChangedNotification object:nil];
	}
}
@end
