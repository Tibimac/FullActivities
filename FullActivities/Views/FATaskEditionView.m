//
//  FATaskEditionView.m
//  FullActivities
//
//  Created by Thibault Le Cornec on 18/06/2014.
//  Copyright (c) 2014 Tibimac. All rights reserved.
//

#import "FATaskEditionView.h"
#import "FATaskEditionViewController.h"

@implementation FATaskEditionView

/* ************************************************** */
/* ----------------- Initialisation ----------------- */
/* ************************************************** */
#pragma mark - Initialisation

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
        {
            _isiPhone = YES;;
        }
        else
        {
            _isiPhone = NO;
        }
        
        //  Il faut définir une couleur de fond pour éviter ce qui ressemble à un bug
        //      graphique ou un lag lorsque la TableView fait le pushViewController pour
        //      afficher la vue d'édition
        [self setBackgroundColor:[UIColor colorWithRed:0.94 green:0.94 blue:0.96 alpha:1]];
        
        
        /* ************************************************** */
        /* ----------------------- Nom ---------------------- */
        _taskNameField = [[UITextField alloc] init];
        [_taskNameField setPlaceholder:@"Je dois..."];
        [_taskNameField setTextColor:[UIColor colorWithRed:0 green:0.48 blue:1 alpha:1]];
        UIFont *fontNameField = [UIFont boldSystemFontOfSize:20];
        [_taskNameField setFont:fontNameField];
        [_taskNameField setTextAlignment:NSTextAlignmentCenter];
        [_taskNameField setBackgroundColor:[UIColor whiteColor]];
        [_taskNameField setTintColor:[UIColor redColor]];
        
        // Définition du padding
        UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 0)];
        [paddingView setBackgroundColor:[UIColor clearColor]];
        // Padding entre le bord du UITextField et le texte à gauche
        [_taskNameField setLeftView:paddingView];
        [_taskNameField setLeftViewMode:UITextFieldViewModeAlways];
        // Padding entre le bord du UITextField et le texte à droite
        [_taskNameField setRightView:paddingView];
        [_taskNameField setRightViewMode:UITextFieldViewModeUnlessEditing];
        
        [paddingView release];
        
        [_taskNameField setClearButtonMode:UITextFieldViewModeWhileEditing];
        [_taskNameField setReturnKeyType:UIReturnKeyDone];
        [_taskNameField setKeyboardAppearance:UIKeyboardAppearanceDefault];
        [_taskNameField setKeyboardType:UIKeyboardTypeAlphabet];
        
        [self addSubview:_taskNameField];
        [_taskNameField release];
        
        
        /* ************************************************** */
        /* --------------------- Priorité ------------------- */
        taskPriorityLabel = [[UILabel alloc] init];
        [taskPriorityLabel setText:@"Priorité"];
        [taskPriorityLabel setTextAlignment:NSTextAlignmentCenter];
        [self addSubview:taskPriorityLabel];
        [taskPriorityLabel release];
        
        NSArray *priorityItems = [NSArray arrayWithObjects:@"Faible", @"Moyenne", @"Importante", nil];
        _taskPrioritySegments = [[UISegmentedControl alloc] initWithItems:priorityItems];
        [_taskPrioritySegments addTarget:_taskEditionViewController action:@selector(prioritySegmentDidChange) forControlEvents:UIControlEventValueChanged];
        [_taskPrioritySegments setBackgroundColor:[UIColor whiteColor]];
        [self addSubview:_taskPrioritySegments];
        [_taskPrioritySegments release];
        
        
        /* ************************************************** */
        /* ----------------------- Type --------------------- */
        taskTypeLabel = [[UILabel alloc] init];
        [taskTypeLabel setText:@"Type"];
        [taskTypeLabel setTextAlignment:NSTextAlignmentCenter];
        [self addSubview:taskTypeLabel];
        [taskTypeLabel release];
        
        NSArray *typeItems = [NSArray arrayWithObjects:@"Personnel", @"Professionnel", nil];
        _taskTypeSegments = [[UISegmentedControl alloc] initWithItems:typeItems];
        [_taskTypeSegments addTarget:_taskEditionViewController action:@selector(typeSegmentDidChange) forControlEvents:UIControlEventValueChanged];
        [_taskTypeSegments setBackgroundColor:[UIColor whiteColor]];
        [self addSubview:_taskTypeSegments];
        [_taskTypeSegments release];
        
        
        /* ************************************************** */
        /* ---------------------- Image --------------------- */
        _taskImageView = [[UIImageView alloc] init];
        [_taskImageView setBackgroundColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:0.5]];
        [_taskImageView setUserInteractionEnabled:YES]; // Permet d'autoriser les gestures recognizer
        [_taskImageView setContentMode:UIViewContentModeScaleAspectFit]; // Conserve le ratio de l'image lors de son affichage
        [self addSubview:_taskImageView];
        [_taskImageView release];
        
        
        
        [self setViewForOrientation:[[UIApplication sharedApplication] statusBarOrientation]
                 withStatusBarFrame:[[UIApplication sharedApplication] statusBarFrame]];
    }
    
    return self;
}





/* ************************************************** */
/* ---------------- Placement objets ---------------- */
/* ************************************************** */
#pragma mark - Placement objets

- (void)setViewForOrientation:(UIInterfaceOrientation)orientation
           withStatusBarFrame:(CGRect)statusBarFrame
{
    #pragma mark Positioning Objects
    
    #define MARGE_X 10
    CGFloat TOP = 0.0; // Stocke le décalage lié à la barre de navigation
    CGFloat STATUSBAR_EXTRA = 0.0; // Stocke le décalage lié à la statusBar si frame > 20
    
    if(UIInterfaceOrientationIsPortrait(orientation))
    {
        if (statusBarFrame.size.height > 20)
        {
            STATUSBAR_EXTRA = statusBarFrame.size.height-20;
        }
        
        TOP = 64.0;
        
        [self setFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height-(STATUSBAR_EXTRA))];
    }
    else if (UIInterfaceOrientationIsLandscape(orientation))
    {
        if (statusBarFrame.size.width > 20)
        {
            STATUSBAR_EXTRA = statusBarFrame.size.width-20;
        }
        
        if (_isiPhone)
        {
            TOP = 52.0;
        }
        else
        {
            TOP = 64.0;
        }
        
        [self setFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.height, [[UIScreen mainScreen] bounds].size.width-(STATUSBAR_EXTRA))];
    }
    
    CGFloat viewWidth   = [self bounds].size.width;
    CGFloat viewHeight  = [self bounds].size.height;
    
    if(UIInterfaceOrientationIsPortrait(orientation))
    {
        [_taskNameField         setFrame:CGRectMake(0      , TOP+10, viewWidth, 40)];
        
        [taskPriorityLabel setText:@"Priorité"];
        [taskPriorityLabel      setFrame:CGRectMake(MARGE_X, TOP+60, viewWidth-(MARGE_X*2), 25)];
        [_taskPrioritySegments  setFrame:CGRectMake(MARGE_X, TOP+85, viewWidth-(MARGE_X*2), 30)];
        
        [taskTypeLabel setText:@"Type"];
        [taskTypeLabel          setFrame:CGRectMake(MARGE_X, TOP+125, viewWidth-(MARGE_X*2), 25)];
        [_taskTypeSegments      setFrame:CGRectMake(MARGE_X, TOP+150, viewWidth-(MARGE_X*2), 30)];
        
        [_taskImageView         setFrame:CGRectMake(MARGE_X, TOP+190, viewWidth-(MARGE_X*2), viewHeight-(TOP+190+10))];
    }
    else if (UIInterfaceOrientationIsLandscape(orientation))
    {
        [_taskNameField         setFrame:CGRectMake(0            , TOP+10, viewWidth, 40)];
        
        [taskPriorityLabel setText:@"Priorité :"];
        [taskPriorityLabel      setFrame:CGRectMake(MARGE_X      , TOP+60, 70                         , 30)];
        [_taskPrioritySegments  setFrame:CGRectMake(MARGE_X+70+10, TOP+60, viewWidth-(MARGE_X*2+70+10), 30)];
        
        [taskTypeLabel setText:@"Type :"];
        [taskTypeLabel          setFrame:CGRectMake(MARGE_X      , TOP+100, 70                         , 30)];
        [_taskTypeSegments      setFrame:CGRectMake(MARGE_X+70+10, TOP+100, viewWidth-(MARGE_X*2+70+10), 30)];
        
        [_taskImageView         setFrame:CGRectMake(MARGE_X, TOP+140, viewWidth-(MARGE_X*2), viewHeight-(TOP+140+10))];
    }
}

@end
