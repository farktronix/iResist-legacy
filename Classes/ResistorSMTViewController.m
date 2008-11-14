//
//  ResistorSMTViewController.m
//  iResist
//
//  Created by Jacob Farkas on 8/9/08.
//  Copyright 2008 Flying Monkey Enterprises All rights reserved.
//

#import "ResistorSMTViewController.h"


@implementation ResistorSMTViewController

- (void) _resistorValueChanged:(NSNotification *)notif
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSNumber *ohmsNum = [defaults valueForKey:kOhmsKey];
    double ohms = 0.0;
    if (ohmsNum) ohms = [ohmsNum doubleValue];
    _ohms.text = prettyPrintOhms(ohms, 2);
    
    _smtLabel1.text = [_picker.delegate pickerView:_picker titleForRow:[_picker selectedRowInComponent:0] forComponent:0];
    _smtLabel2.text = [_picker.delegate pickerView:_picker titleForRow:[_picker selectedRowInComponent:1] forComponent:1];
    _smtLabel3.text = [_picker.delegate pickerView:_picker titleForRow:[_picker selectedRowInComponent:2] forComponent:2];
    _smtLabel4.text = [_picker.delegate pickerView:_picker titleForRow:[_picker selectedRowInComponent:3] forComponent:3];
}

- (void)viewDidAppear:(BOOL)animated
{
    [self _resistorValueChanged:nil];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
    
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_resistorValueChanged:) name:kResistorValueChangedNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_resistorValueChanged:) name:kResistorPickerChangedNotification object:nil];
    }
    return self;
}

- (void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super dealloc];
}

@end
