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

- (void) _resistorValueChanged:(NSNotification *)notif
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSNumber *ohmsNum = [defaults valueForKey:kOhmsKey];
    double ohms = 0.0;
    if (ohmsNum) ohms = [ohmsNum doubleValue];
    _ohms.text = prettyPrintOhms(ohms);
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
