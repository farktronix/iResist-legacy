//
//  ResistorScrollViewController.h
//  iResist
//
//  Created by Jacob Farkas on 8/9/08.
//  Copyright 2008 Flying Monkey Enterprises All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString * const kResistorViewChanged;

@class ResistorValuePicker, ResistorColorPicker, ResistorSMTPicker, ResistorColorViewController, ResistorSMTViewController;

@interface ResistorScrollViewController : UIViewController <UIScrollViewDelegate> {
    IBOutlet UIScrollView *_scrollView;
    
    // this is ugly, but I think it's the easiest way to keep this label up to date.
    IBOutlet UILabel *_virColorLabel;
    IBOutlet UILabel *_virSMTLabel;
    
    UIPickerView *_picker;
    ResistorColorPicker *_colorPicker;
    ResistorSMTPicker *_SMTPicker;
    ResistorValuePicker *_currentValuePicker;
    
    ResistorColorViewController *_resistorColorController;
    ResistorSMTViewController *_resistorSMTController;
    
    int _page;
    int _lastPage;
    
    CGPoint _oldOffset;
    BOOL _scrollBug;
}

@property (nonatomic, retain) UIPickerView *picker;
@property (readonly) int page;

- (void) randomSpin;

@end
