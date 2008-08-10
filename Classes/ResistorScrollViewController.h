//
//  ResistorScrollViewController.h
//  iResist
//
//  Created by Jacob Farkas on 8/9/08.
//  Copyright 2008 Flying Monkey Enterprises All rights reserved.
//

#import <UIKit/UIKit.h>

@class ResistorColorViewController, ResistorSMTViewController;

@interface ResistorScrollViewController : UIViewController <UIScrollViewDelegate> {
    IBOutlet UIScrollView *_scrollView;
    
    ResistorColorViewController *_resistorColorController;
    ResistorSMTViewController *_resistorSMTController;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView;

@end
