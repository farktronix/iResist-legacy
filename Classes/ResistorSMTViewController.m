//
//  ResistorSMTViewController.m
//  iResist
//
//  Created by Jacob Farkas on 8/9/08.
//  Copyright 2008 Flying Monkey Enterprises All rights reserved.
//

#import "ResistorSMTViewController.h"


@implementation ResistorSMTViewController

@synthesize picker = _picker;

- (void) _updateOhmsString:(double)ohms
{
    int exp = (int)log10(ohms);
    double displayOhms = ohms;
    
    if (ohms < 1.0) {
        displayOhms = ((int)(ohms * 1000) / 1000.0);
    }
    else if (ohms < 10) {
        displayOhms = ((int)(ohms * 100) / 100.0);
    } 
    else if (ohms < 100) {
        displayOhms = ((int)(ohms * 10) / 10.0);
    }
    else {
        double power = pow(10, exp - 3);
        displayOhms = ((int)(ohms / power) * power);  
    }
    
    if (ohms < 1) {
        _ohms.text = [NSString stringWithFormat:@"%.3f Ω", displayOhms];
    }
    else if (ohms < 10) {
        _ohms.text = [NSString stringWithFormat:@"%.2f Ω", displayOhms];
    }
    else if (ohms < 1000) {
        _ohms.text = [NSString stringWithFormat:@"%.0f Ω", displayOhms];
    }
    else if (ohms < 1000000) {
        _ohms.text = [NSString stringWithFormat:@"%.2f KΩ", displayOhms/1000.0];
    }
    else if (ohms < 1000000000) {
        _ohms.text = [NSString stringWithFormat:@"%.2f MΩ", displayOhms/1000000.0];
    }
    else {
        _ohms.text = [NSString stringWithFormat:@"%.2f GΩ", displayOhms/1000000000.0];
    }
}

- (void) _resistorValueChanged:(NSNotification *)notif
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSNumber *ohmsNum = [defaults valueForKey:kOhmsKey];
    double ohms = 0.0;
    if (ohmsNum) ohms = [ohmsNum doubleValue];
    [self _updateOhmsString:ohms];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
    
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_resistorValueChanged:) name:kResistorValueChangedNotification object:nil];
    }
    return self;
}

- (void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super dealloc];
}

@end
