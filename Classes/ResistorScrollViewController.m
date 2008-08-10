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

@implementation ResistorScrollViewController
 
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
}

@end
