//
//  ResistorScrollViewController.m
//  iResist
//
//  Created by Jacob Farkas on 8/9/08.
//  Copyright 2008 Flying Monkey Enterprises. All rights reserved.
//

#import "ResistorScrollViewController.h"

#import "ResistorColorViewController.h"
#import "ResistorSMTViewController.h"
#import "ResistorValuePicker.h"
#import "ResistorColorPicker.h"
#import "ResistorSMTPicker.h"

NSString * const kResistorViewChanged = @"ResistorViewChanged";

@implementation ResistorScrollViewController

@synthesize page = _page;

- (void) resistorValueChanged:(NSNotification *)notif
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSNumber *ohmsNum = [defaults valueForKey:kOhmsKey];
    double ohms = 0.0;
    if (ohmsNum) ohms = [ohmsNum doubleValue];
    [_currentValuePicker setOhmValue:ohms forPicker:_picker];
    
    NSNumber *toleranceNum = [defaults valueForKey:kToleranceKey];
    double tolerance = 0.0;
    if (toleranceNum) tolerance = [toleranceNum doubleValue];
    [_currentValuePicker setTolerance:tolerance forPicker:_picker];
}

- (void) setupPickerDelegate
{
    if (_page == 0) {
        _currentValuePicker = _colorPicker;
        _picker.dataSource = _colorPicker;
        _picker.delegate = _colorPicker;
    } else {    
        _currentValuePicker = _SMTPicker;
        _picker.dataSource = _SMTPicker;
        _picker.delegate = _SMTPicker;
    }
    [self resistorValueChanged:nil];
    [_picker reloadAllComponents];
} 

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        _scrollView.contentSize = CGSizeMake(self.view.frame.size.width * 2, self.view.frame.size.height);
        _scrollView.alwaysBounceHorizontal = YES;
        _scrollView.pagingEnabled = YES;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        
        CGRect frame = self.view.frame;
        frame.origin.y = 0;
        
        _resistorColorController = [[ResistorColorViewController alloc] initWithNibName:@"ResistorColorView" bundle:nil];
        frame.origin.x = 0;
        _resistorColorController.view.frame = frame;
        [_scrollView addSubview:_resistorColorController.view];

        _resistorSMTController = [[ResistorSMTViewController alloc] initWithNibName:@"ResistorSMTView" bundle:nil];
        frame.origin.x = 0 + _scrollView.frame.size.width;
        _resistorSMTController.view.frame = frame;
        [_scrollView addSubview:_resistorSMTController.view];
        
        NSNumber *pageNum = [[NSUserDefaults standardUserDefaults] valueForKey:kCurrentPageKey];
        if (pageNum) {
            _page = [pageNum intValue];
        } else {
            _page = 0;
        }
        _lastPage = _page;
        
        if (_page == 1) {
            [_scrollView scrollRectToVisible:CGRectMake( _scrollView.frame.size.width, 0,  _scrollView.frame.size.width,  _scrollView.frame.size.height) animated:NO];
        }
        
        _colorPicker = [[ResistorColorPicker alloc] init];
        _SMTPicker = [[ResistorSMTPicker alloc] init];
        [self setupPickerDelegate];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resistorValueChanged:) name:kResistorValueChangedNotification object:nil];
    }
    return self;
}

- (void) dealloc {
    [_resistorColorController release];
    [_resistorSMTController release];
    [_colorPicker release];
    [_SMTPicker release];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super dealloc];
}

- (void) setPicker:(UIPickerView *)picker
{
    if (picker != _picker) {
        [_picker release];
        _picker = [picker retain];
        if (_page == 0) {
            _resistorSMTController.picker = nil;
            _resistorColorController.picker = _picker;
        } else {
            _resistorColorController.picker = nil;
            _resistorSMTController.picker = _picker;
        }
    }
    [self setupPickerDelegate];
}

- (UIPickerView *)picker { return _picker; }

- (void) randomSpin
{
    [_currentValuePicker randomSpin:_picker];
}

- (void) scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    // This is a terrible hack for what appears to be a bug with the scroll view or the keyboard.
    // If a view in the scroll view resigns being first responder, the scroll view animates to the position
    // of that view. We don't want that, so we stash away the old offset before telling the controller that it 
    // disappeared, and we set it here when the scroll view 
    scrollView.contentOffset = _oldOffset;
    _scrollBug = NO;
}

- (void) scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (_scrollBug) scrollView.contentOffset = _oldOffset;
    
    // Switch the picker when more than 50% of the previous/next page is visible
    CGFloat pageWidth = _scrollView.frame.size.width;
    int newPage = floor((_scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    if (newPage != _page) {
        if (newPage == 0) {
            [_resistorColorController viewWillAppear:YES];
            [_resistorSMTController viewWillDisappear:YES];
        } else {
            [_resistorColorController viewWillDisappear:YES];
            [_resistorSMTController viewWillAppear:YES];
        }
        _page = newPage;
        [[NSUserDefaults standardUserDefaults] setValue:[NSNumber numberWithInt:_page] forKey:kCurrentPageKey];
        [[NSNotificationCenter defaultCenter] postNotificationName:kResistorViewChanged object:nil];
    }
    
    // full page transition complete
    if (_page != _lastPage) {
        if (_scrollView.contentOffset.x == 0) {
            _oldOffset = scrollView.contentOffset;
            [_resistorColorController viewDidAppear:YES];
            [_resistorSMTController viewDidDisappear:YES];
            
            _resistorSMTController.picker = nil;
            _resistorColorController.picker = _picker;
            _lastPage = _page;
            
            [self setupPickerDelegate];
        } else if (_scrollView.contentOffset.x == pageWidth) {
            _oldOffset = scrollView.contentOffset;
            if (_resistorColorController.searchBar.hidden == NO) _scrollBug = YES;
            
            [_resistorColorController viewDidDisappear:YES];
            [_resistorSMTController viewDidAppear:YES];
            
            _resistorSMTController.picker = _picker;
            _resistorColorController.picker = nil;
            _lastPage = _page;
            
            [self setupPickerDelegate];
        }
    }
}

@end
