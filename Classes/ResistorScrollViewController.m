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
	ResistorValuePicker *picker = nil;
	
	if (_page <= [_pickers count] && (picker = [_pickers objectAtIndex:_page])) {
		_currentValuePicker = picker;
		_picker.dataSource = picker;
		_picker.delegate = picker;
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
				
				[_scrollView addSubview:vCtrl.view];
				[_pageViews addObject:vCtrl];
				
				if ((cls = [[NSBundle mainBundle] classNamed:[NSString stringWithFormat:@"%@Picker", prefix]])) {
					ResistorValuePicker *vPicker = [[cls alloc] init];
					[_pickers addObject:vPicker];
				}
			}
		}
        
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
		
        [self setupPickerDelegate];
		_pageControl.numberOfPages = [_pageViews count];
        
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
	// thinking that .picker is going to have to be in a protocol...
	
//	if (_page <= [_pickers count] && (picker = [_pickers objectAtIndex:_page])) {
		if (picker != _picker) {
			_picker = picker;
			/*
			 [_picker release];
			 _picker = [picker retain];
			 if (_page == 0) {
			 _resistorSMTController.picker = nil;
			 _resisto_pickersrColorController.picker = _picker;
			 } else {
			 _resistorColorController.picker = nil;
			 _resistorSMTController.picker = _picker;
			 }
			 */
		}
//	}
	
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
	UIViewController *newCtrl = nil;
	UIViewController *oldCtrl = nil;
	
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
		_oldOffset = scrollView.contentOffset;
		
		//	??? if (_resistorColorController.searchBar.hidden == NO) _scrollBug = YES;
		
		[newCtrl viewDidAppear:YES];
		[oldCtrl viewDidDisappear:YES];
		
		//oldCtrl.picker = nil;
		//newCtrl.picker = _picker;
		_lastPage = _page;
		_pageControl.currentPage = _page;
		
		[self setupPickerDelegate];
    }
}


- (IBAction) pageControlChanged:(id)sender;
{
	// I have absolutely no idea how to get this to "scroll" the scroll view... too bad you can't just
	// tell it to go to a damn page, no....
}
@end
