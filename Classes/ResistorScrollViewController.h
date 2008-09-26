//
//  ResistorScrollViewController.h
//  iResist
//
//  Created by Jacob Farkas on 8/9/08.
//  Copyright 2008 Flying Monkey Enterprises All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString * const kResistorViewChanged;

@class ResistorValuePicker;

@interface ResistorScrollViewController : UIViewController <UIScrollViewDelegate> {
    IBOutlet UIScrollView *_scrollView;
    IBOutlet UIPageControl *_pageControl;
	
    UIPickerView *_picker;
    ResistorValuePicker *_currentValuePicker;
	UIViewController *_currentViewController;
	
	NSMutableArray *_pageViews;
	NSMutableArray *_pickers;
    
    int _page;
    int _lastPage;

    BOOL _scrollBug;
}

@property (nonatomic, retain) UIPickerView *picker;
@property (readonly) int page;

@property BOOL pageControlEnabled;

- (void) randomSpin;

- (IBAction) pageControlChanged:(id)sender;

@end
