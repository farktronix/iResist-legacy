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
@synthesize currentValuePicker = _currentValuePicker;

@dynamic pageControlEnabled;

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
	ResistorValuePicker *picker = nil;
	
	[[NSNotificationCenter defaultCenter] postNotificationName:@"rmVEqIRLabel" object:nil];
	
    picker = [_pickers objectAtIndex:_page];
	if ((NSNull*)picker != [NSNull null]) {
		_currentValuePicker = picker;
        _picker.hidden = NO;
		_picker.dataSource = picker;
		_picker.delegate = picker;
	} else {
        _currentValuePicker = nil;
        _picker.hidden = YES;
        _picker.dataSource = nil;
        _picker.delegate = nil;
		
		[[NSNotificationCenter defaultCenter] postNotificationName:@"addVEqIRLabel" object:nil];
    }
	
    [self resistorValueChanged:nil];
    [_picker reloadAllComponents];
} 

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        CGRect frame = self.view.frame;
        frame.origin.y = 0;
		
		_pageViews = [[NSMutableArray array] retain];
		_pickers = [[NSMutableArray array] retain];
		
		int widthMult = 0;
		Class cls = nil;
		NSArray *starterArr = [NSArray arrayWithObjects:@"ResistorColor", @"ResistorSMT", @"ResistorInfo", nil];
		
		for (NSString *prefix in starterArr) {
			NSString *view = [NSString stringWithFormat:@"%@View", prefix];
			
			if ((cls = [[NSBundle mainBundle] classNamed: [NSString stringWithFormat:@"%@Controller", view]])) {
				UIViewController *vCtrl = [(UIViewController*)[cls alloc] initWithNibName:view bundle:nil];
				frame.origin.x = _scrollView.frame.size.width * widthMult++;
				vCtrl.view.frame = frame;
				
				if ([vCtrl isKindOfClass:[ResistorGenericViewController class]])
					((ResistorGenericViewController*)vCtrl).scrollView = self;
				
				[_scrollView addSubview:vCtrl.view];
				[_pageViews addObject:vCtrl];
				
				if ((cls = [[NSBundle mainBundle] classNamed:[NSString stringWithFormat:@"%@Picker", prefix]])) {
					ResistorValuePicker *vPicker = [[cls alloc] init];
					[_pickers addObject:vPicker];
				} else {
                    [_pickers addObject:[NSNull null]];
                }
			}
		}
		
        _scrollView.contentSize = CGSizeMake(self.view.frame.size.width * [_pageViews count], self.view.frame.size.height);
        _scrollView.alwaysBounceHorizontal = YES;
        _scrollView.pagingEnabled = YES;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        
        NSNumber *pageNum = [[NSUserDefaults standardUserDefaults] valueForKey:kCurrentPageKey];
        if (pageNum) {
            _page = [pageNum intValue];
        } else {
            _page = 0;
        }
        _lastPage = _page;
        
        if (_page) {
            [_scrollView scrollRectToVisible:CGRectMake(_scrollView.frame.size.width * _page, 0,  _scrollView.frame.size.width,  _scrollView.frame.size.height) animated:NO];
        }
		
        [self setupPickerDelegate];
		_pageControl.numberOfPages = [_pageViews count];
		_pageControl.currentPage = _page;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resistorValueChanged:) name:kResistorValueChangedNotification object:nil];
    }
    return self;
}

- (void) dealloc {
	for (id view in _pageViews) {
		[view release];
	}
	
	for (id picker in _pickers) {
		[picker release];
	}
	
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super dealloc];
}

- (void) setPicker:(UIPickerView *)picker
{
	if (picker != _picker) {
		_picker = picker;
		
		ResistorGenericViewController *oldPage = [_pageViews objectAtIndex:_lastPage];
		ResistorGenericViewController *newPage = [_pageViews objectAtIndex:_page];
		
		if (oldPage && newPage) {
			oldPage.picker = nil;
			newPage.picker = _picker;
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
	_scrollBug = NO;
}

- (void) scrollViewDidScroll:(UIScrollView *)scrollView
{
	if (_scrollBug) scrollView.contentOffset = CGPointMake(scrollView.frame.size.width * _page, 0);
	
    // Switch the picker when more than 50% of the previous/next page is visible
    CGFloat pageWidth = _scrollView.frame.size.width;
    int newPage = floor((_scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
	ResistorGenericViewController *newCtrl = nil;
	ResistorGenericViewController *oldCtrl = nil;
	
    if (newPage != _page && newPage <= [_pageViews count]) {
		newCtrl = [_pageViews objectAtIndex:newPage];
		oldCtrl = [_pageViews objectAtIndex:_page];
		
        if (newCtrl && oldCtrl) {
			[newCtrl viewWillAppear:YES];
			[oldCtrl viewWillDisappear:YES];
		}
		
        _page = newPage;
        [[NSUserDefaults standardUserDefaults] setValue:[NSNumber numberWithInt:_page] forKey:kCurrentPageKey];
        [[NSNotificationCenter defaultCenter] postNotificationName:kResistorViewChanged object:nil];
    }
    
    // full page transition complete
    if (_page != _lastPage && newCtrl && oldCtrl) {
		_scrollBug = ([oldCtrl isKindOfClass:[ResistorColorViewController class]] && ((ResistorColorViewController*)oldCtrl).searchBar.hidden == NO);
		
		oldCtrl.picker = nil;
		newCtrl.picker = _picker;
		
		_lastPage = _page;
		_pageControl.currentPage = _page;
		
		[self setupPickerDelegate];
        
		[newCtrl viewDidAppear:YES];
		[oldCtrl viewDidDisappear:YES];
    }
}

- (IBAction) pageControlChanged:(id)sender;
{
	int newPage = _pageControl.currentPage;
	
	CGRect newFrame = _scrollView.frame;
	newFrame.origin.x = (newFrame.size.width * newPage);
	newFrame.origin.y = 0;
	[_scrollView scrollRectToVisible:newFrame animated:YES];
}

- (BOOL) pageControlEnabled;
{
	return _pageControl.enabled;
}

- (void) setPageControlEnabled:(BOOL)set;
{
	_pageControl.hidden = !(_pageControl.enabled = set);
}
@end
