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

NSString * const kResistorViewChanged = @"ResistorViewChanged";

@implementation ResistorScrollViewController
 
@synthesize page = _page;

- (void) viewDidLoad
{
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
    
    _page = 0;
    _lastPage = 0;
}

- (void) dealloc {
    [_resistorColorController release];
    [_resistorSMTController release];
    [super dealloc];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
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
        [[NSNotificationCenter defaultCenter] postNotificationName:kResistorViewChanged object:nil];
    }
    if (_page != _lastPage) {
        if (_scrollView.contentOffset.x == 0) {
            _oldOffset = scrollView.contentOffset;
            [_resistorColorController viewDidAppear:YES];
            [_resistorSMTController viewDidDisappear:YES];
            _lastPage = _page;
        } else if (_scrollView.contentOffset.x == pageWidth) {
            _oldOffset = scrollView.contentOffset;
            if (_resistorColorController.searchBar.hidden == NO) _scrollBug = YES;
            [_resistorColorController viewDidDisappear:YES];
            [_resistorSMTController viewDidAppear:YES];
            _lastPage = _page;
        }
    }
}

@end
