//
//  ResistorInfoViewController.m
//  iResist
//
//  Created by Ryan Joseph on 8/19/08.
//  Copyright 2008 Flying Monkey Enterprises. All rights reserved.
//

#import "ResistorInfoViewController.h"

@implementation ResistorInfoViewController
- (void) updateOhms
{
    NSNumber *ohmsNum = [[NSUserDefaults standardUserDefaults] valueForKey:kOhmsKey];
    _ohms = [ohmsNum doubleValue];
    _ohmsLabel.text = prettyPrintOhms(_ohms);
}

- (void) setVolts:(double)volts
{
    // I = V/R
    double amps = volts/_ohms;
    double watts = amps * volts;
    _voltLabel.text = [NSString stringWithFormat:@"%0.2fV", volts];
    _ampLabel.text = [NSString stringWithFormat:@"%0.6fA", amps];
    _wattLabel.text = [NSString stringWithFormat:@"%0.6fW", watts];
}

- (void) viewDidLoad
{
    [self updateOhms];
    double volts = 5.0;
    NSNumber *voltNum = [[NSUserDefaults standardUserDefaults] valueForKey:kVoltsKey];
    if (voltNum) volts = [voltNum doubleValue];
    [self setVolts:volts];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self updateOhms];
}

- (IBAction) voltSliderChanged:(id)sender
{
    [self setVolts:_voltSlider.value];
}

- (IBAction) segmentSelected:(id)sender
{
    switch (_voltSegment.selectedSegmentIndex) {
        case 0:
            [_voltSlider setValue:3.3 animated:YES];
            [self setVolts:3.3];
            break;
        case 1:
            [_voltSlider setValue:5 animated:YES];
            [self setVolts:5];
            break;
        case 2:
            [_voltSlider setValue:12 animated:YES];
            [self setVolts:12];
            break;
    }
}

@end
