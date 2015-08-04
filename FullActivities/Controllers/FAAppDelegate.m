//
//  FAAppDelegate.m
//  FullActivities
//
//  Created by Thibault Le Cornec on 18/06/2014.
//  Copyright (c) 2014 Tibimac. All rights reserved.
//

#import "FAAppDelegate.h"

@implementation FAAppDelegate

/* ************************************************** */
/* ----------------- Initialisation ----------------- */
/* ************************************************** */
#pragma mark - Initialisation

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    
    // Alloc/init du TableViewController qui sera contenu dans la NavigationController
    _tableViewController = [[FATableViewController alloc] initWithStyle:UITableViewStyleGrouped];
    
    // Alloc/init du NavigationController qui sera le rootViewController de la window de l'application.
    rootViewController = [[UINavigationController alloc] initWithRootViewController:_tableViewController];
    [rootViewController setDelegate:self];
    
    [[self window] setRootViewController:rootViewController];
    
    [_tableViewController release];
    [rootViewController release];
    
    [[self window] makeKeyAndVisible];
    
    return YES;
}





/* ************************************************** */
/* ---------------- Gestion Affichage --------------- */
/* ************************************************** */
#pragma mark - Gestion Affichage 

#pragma mark |--> Changement de statusBarFrame (UIApplicationDelegate)
// Permet de redimensionner la vue lorsque la frame de la statusBar change
- (void)application:(UIApplication *)application willChangeStatusBarFrame:(CGRect)newStatusBarFrame
{
    //  Lorsque cette méthode est appellée elle donne les nouvelles dimensions de la statusBar
    //      mais si on passe en paramètre d'orientation l'orientation actuelle de l'application
    //      celle-ci ayant pas encore fait sa rotation on passe alors l' "ANCIENNE" orientation.
    //  On ne peut pas non plus passer directement la valeur de l'orientation du iDevice car
    //      car ça ne correspond pas exactement aux valeurs d'orientation de l'interface.
    //      On passe donc une valeur 1 pour l'orientation portrait et 3 pour le paysage en fonction
    //      de l'orientation du iDevice (0 ou 1 pour le portrait, 3 ou 4 pour le paysage).
    //  On peut se baser sur l'orientation du iDevice car l'appel de cette méthode se fait justement
    //      parce-que le iDevice a déjà changé d'orientation ou que la frame de la statusBar change
    //      donc l'orientation du iDevice au moment où la demande (ci-dessus) est bien la "nouvelle"
    //      orientation.
    if (([[UIDevice currentDevice] orientation] == 0) || ([[UIDevice currentDevice] orientation] == 1) || ([[UIDevice currentDevice] orientation] == 2))
    {
        [[_taskEditionViewController taskEditionView] setViewForOrientation:1
                                                         withStatusBarFrame:newStatusBarFrame];
    }
    else if (([[UIDevice currentDevice] orientation] == 3) || ([[UIDevice currentDevice] orientation] == 4))
    {
        [[_taskEditionViewController taskEditionView] setViewForOrientation:3
                                                         withStatusBarFrame:newStatusBarFrame];
    }
}


#pragma mark |--> Retour de vue Édition à TableView (UINavigationControllerDelegate)
//  Méthode appellée par le NavigationController
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    //  Si le viewcontroller qui va être affiché = tableViewController
    //      alors nous étions sur la TaskEditionViewController et l'utilisateur revient
    //      à la liste des tâches
    if (viewController == _tableViewController)
    {
        //            NSLog(@"On retourne a la liste");
        //        //  Si le clavier est affiché alors le UITextField de saisi du nom est le firstResponder
        //        if ([[[_taskEditionViewController taskEditionView] taskNameField] isFirstResponder])
        //        {
        //                NSLog(@"Le clavier est affiché :O !");
        //            // Dans ce cas on fait disparaitre le clavier
        [[[_taskEditionViewController taskEditionView] taskNameField] resignFirstResponder];
        // }
    }
}





/* ************************************************** */
/* --------------- Gestion multi-tâche -------------- */
/* ************************************************** */
#pragma mark - Gestion multi-tâches

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    FADataSource *dataSource = [[_tableViewController tableView] dataSource];
    
    NSInteger nbTaskNotFinished = 0;
    
    for (NSMutableArray *category in [dataSource tasks]) // Parcours des catégories
    {
        for (FATask *task in category) // Parcours des taches dans chaque catégorie
        {
            if ([task isFinish] == NO)
            {
                nbTaskNotFinished++;
            }
        }
    }
    
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:nbTaskNotFinished];
}


- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
