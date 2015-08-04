//
//  FAAppDelegate.h
//  FullActivities
//
//  Created by Thibault Le Cornec on 18/06/2014.
//  Copyright (c) 2014 Tibimac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FATableViewController.h"
#import "FATaskEditionViewController.h"
#import "FATaskEditionView.h"

@interface FAAppDelegate : UIResponder <UIApplicationDelegate, UINavigationControllerDelegate>
{
    UINavigationController *rootViewController;
}


////////// Propriétés //////////

@property (strong, nonatomic) UIWindow *window;

//  Permet au TaskEditionViewController d'accéder à la tableView
//      et sa source de données pour enregistrer les modifications
//      sur une tâche et pour demander à la tableView de se rafraichir (reloadData)
@property (readonly) FATableViewController *tableViewController;

//  Est définie lors du init de FATaskEditionViewController
//  Permet ainsi d'accéder à la vue d'édition (FATaskEditionView *taskEditionView)
//      lors de l'appel à setViewForOrientation:
//      (voir méthode application:willChangeStatusBarFrame:)
@property (strong) FATaskEditionViewController *taskEditionViewController;

@end
