//
//  ViewController.h
//  menutest
//
//  Created by Vladimir Vishnyagov on 21.04.15.
//  Copyright (c) 2015 ltst. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    menuOpened,
    menuClose,
    menuAnimation
} menuState;

@interface NewMenuViewController : UIViewController <UIGestureRecognizerDelegate>

@end

