//
//  ViewController.m
//  menutest
//
//  Created by Vladimir Vishnyagov on 21.04.15.
//  Copyright (c) 2015 ltst. All rights reserved.
//

#import "NewMenuViewController.h"

#define menuClosedFrame CGRectMake(-[UIScreen mainScreen].bounds.size.width, 0,[UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)
#define menuOpenedFrame CGRectMake(0, 0,[UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)
#define duration 0.25f //Скорость анимации закрытия открытия
#define percentOfReaction 0.25f //Число которое влияет на открытие и закрытие меню с позиции percentOfReaction*widthScreen

@interface NewMenuViewController ()

@property UINavigationController *leftNavigationController;
@property UINavigationController *rightNavigationController;
@property UIPanGestureRecognizer *panRecognizer;
@property menuState currentMenuState;

@end

@implementation NewMenuViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initViewControllers];
    }
    return self;
}

-(void)initViewControllers
{
    _leftNavigationController = [[UINavigationController alloc]init];
    _rightNavigationController = [[UINavigationController alloc]init];
    [self addChildViewController:_leftNavigationController];
    [self addChildViewController:_rightNavigationController];
    [self.view addSubview:_rightNavigationController.view];
    [self.view addSubview:_leftNavigationController.view];
    _panRecognizer = [[UIPanGestureRecognizer alloc]init];
    [_panRecognizer setMaximumNumberOfTouches:1];
    [_panRecognizer addTarget:self action:@selector(handlePan:)];
    [_panRecognizer setDelegate:self];
    [self.view addGestureRecognizer:_panRecognizer];
    _currentMenuState = menuClose;
}

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [_leftNavigationController.view setFrame:menuClosedFrame];
    [_rightNavigationController.view setFrame:menuOpenedFrame];
    [_leftNavigationController.view setBackgroundColor:[UIColor redColor]];
    [_rightNavigationController.view setBackgroundColor:[UIColor blueColor]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)handlePan:(UIPanGestureRecognizer*)panGesture
{
    switch (panGesture.state) {
        case UIGestureRecognizerStateBegan:
        {
            break;
        }
        case UIGestureRecognizerStateChanged:
        {
            CGPoint translation = [panGesture translationInView:self.view];
            if (_leftNavigationController.view.frame.origin.x+translation.x < -[UIScreen mainScreen].bounds.size.width) {
                [_leftNavigationController.view setFrame:menuClosedFrame];
            }
            else if(_leftNavigationController.view.frame.origin.x + translation.x > 0.0f)
            {
                [_leftNavigationController.view setFrame:menuOpenedFrame];
            }
            else
            {
                _leftNavigationController.view.frame = CGRectMake(_leftNavigationController.view.frame.origin.x+translation.x,0.0,[UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
            }
            [panGesture setTranslation:CGPointMake(0.0f, 0.0f) inView:self.view];
            break;
        }
        case UIGestureRecognizerStateEnded:
        {
            CGPoint velocity = [panGesture velocityInView:self.view];
            if (velocity.x >= 0.0f && _leftNavigationController.view.frame.origin.x + _leftNavigationController.view.frame.size.width >= [UIScreen mainScreen].bounds.size.width * percentOfReaction) {
                [self menuOpen];
            }
            else if (velocity.x < 0.0f && _leftNavigationController.view.frame.origin.x + _leftNavigationController.view.frame.size.width <= [UIScreen mainScreen].bounds.size.width - [UIScreen mainScreen].bounds.size.width * percentOfReaction)
            {
                [self menuClose];
            }
            else
            {
                if (_leftNavigationController.view.frame.origin.x + _leftNavigationController.view.frame.size.width < [UIScreen mainScreen].bounds.size.width * percentOfReaction) {
                    [self menuClose];
                }
                if (_leftNavigationController.view.frame.origin.x + _leftNavigationController.view.frame.size.width > [UIScreen mainScreen].bounds.size.width - [UIScreen mainScreen].bounds.size.width * percentOfReaction) {
                    [self menuOpen];
                }
            }
            break;
        }
        default:
        {
            break;
        }
    }
}

-(void)menuOpen
{
    [UIView animateWithDuration:duration delay:0.0f options:UIViewAnimationOptionCurveEaseOut animations:^{
        [_leftNavigationController.view setFrame:menuOpenedFrame];
    } completion:^(BOOL finished) {
        _currentMenuState = menuOpened;
    }];
}

-(void)menuClose
{
    [UIView animateWithDuration:duration delay:0.0f options:UIViewAnimationOptionCurveEaseOut animations:^{
        [_leftNavigationController.view setFrame:menuClosedFrame];
    } completion:^(BOOL finished) {
        _currentMenuState = menuClose;
    }];
}

- (BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)panGestureRecognizer {
    CGPoint velocity = [panGestureRecognizer velocityInView:self.view];
    return fabs(velocity.x) > fabs(velocity.y);
}

@end
