//
//  FATableViewController.m
//  FullActivities
//
//  Created by Thibault Le Cornec on 18/06/2014.
//  Copyright (c) 2014 Tibimac. All rights reserved.
//

#import "FATableViewController.h"

@interface FATableViewController ()

@end

@implementation FATableViewController

/* ************************************************** */
/* ----------------- Initialisation ----------------- */
/* ************************************************** */
#pragma mark - Initialisation

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    
    if (self)
    {
        [self setTitle:@"Mes tâches"];
        dataSource = [[FADataSource alloc] init];
        [[self tableView] setDataSource:dataSource];
        [[self tableView] setDelegate:self];
        // Nécessaire pour le style Grouped :
        [[self tableView] setSectionFooterHeight:0.0];
        [[self tableView] setContentInset:UIEdgeInsetsMake(-17.0f, 0.0f, 0.0f, 0.0f)];
        
        // Bouton Edit géré automatiquement par le TableViewController
        [[self editButtonItem] setTitle:@"Modifier"];
        [[self navigationItem] setLeftBarButtonItem:[self editButtonItem] animated:YES];
        
        
        UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd
                                                                                   target:self
                                                                                   action:@selector(addTask)];
        [[self navigationItem] setRightBarButtonItem:addButton animated:YES];
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // On instancie le controlleur de la vue d'édition
    if (taskEditionViewController == nil)
    {
        taskEditionViewController = [[FATaskEditionViewController alloc] init];
    }
    
    [taskEditionViewController setTitle:@"Édition"];
}





#pragma mark - Changement nom bouton Modifier TableView
//  Méthode appellée par le bouton de modification de la TableView (bouton en haut à gauche)
//  Par défaut le nom du bouton est Edit/Done
//  Par défaut il appelle la méthode setEditing:animated: de UIViewController
//  Il faut surcharger la méthode pour redéfinir le nom du bouton à la volée
- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    // Make sure you call super first
    [super setEditing:editing animated:animated];
    
    if (editing)
    {
        [[self editButtonItem] setTitle:@"OK"];
    }
    else
    {
        [[self editButtonItem] setTitle:@"Modifier"];
    }
}





#pragma mark - Mise à jour indexPathTaskToEdit et chargement vue édition
//  Cette méthode définie la propriété indexPathTaskToEdit de TaskEditionViewController puis
//      demande au controleur de la vue d'édition de charger la tâche à éditer dans la vue
//  Enfin on affiche le viewController passé en paranètre
- (void)setIndexPathTaskToEditTo:(NSIndexPath *)indexPath
    andLoadAndPushViewController:(UIViewController *)viewController
{
    //  Met à jour la propriété indexPathTaskToEdit de TaskEditionViewController
    //  si indexPath = nil c'est qu'il s'agit da l'ajout d'une nouvelle tâche
    [taskEditionViewController setIndexPathTaskInEdition:indexPath];
    
    //  Demande au controlleur de la vue d'édition de charger la tâche selectionnée
    [taskEditionViewController loadTaskToEdit];
    
    //  Demande au navigationController d'afficher la vue d'édition
    [[self navigationController] pushViewController:viewController animated:YES];
}





/* ************************************************** */
/* -------------- Sélection d'une tâche ------------- */
/* ************************************************** */
#pragma mark - Sélection d'une tâche (UITableViewDelegate)

//  Méthode appellée lorsqu'une cellule est sélectionnée
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self viewDidLoad]; // Vérifie sur le TaskEditionViewController est créé et le re-crée si besoin
    [self setIndexPathTaskToEditTo:indexPath andLoadAndPushViewController:taskEditionViewController];
}





/* ************************************************** */
/* ---------------- Gestion CheckBox ---------------- */
/* ************************************************** */
#pragma mark - CheckBox cliquée (Action)

//  Méthode appellée lorsque l'utilisateur clique sur la checkbox
//  Cette méthode inverse l'état du bouton et l'état "isFinish" de la tâche liée
//  Elle met à jour l'apparence du bouton et du label en fonction de l'état "isFinish"
//      de la tâche liée
- (void)checkboxDidClicked:(id)sender
{
    #define CHECKBOX_TAG 1
    #define LABEL_NAME_TAG 2
    
    //  On passe l'état du bouton à l'inverse de son état actuel
    [sender setSelected:![sender isSelected]];
    
    //  Récupération de la tâche liée au bouton qui a cliqué
    FATask *task = [[[dataSource tasks] objectAtIndex:[sender indexPathCell].section] objectAtIndex:[sender indexPathCell].row];
    
    //  On passe isFinish à l'inverse de sa valeur actuelle
    [task setIsFinish:![task isFinish]];
    
    //  Mise à jour de l'apparence selon si la tâche est finie ou non
    if ([task isFinish])
    {
        [sender setAlpha:0.20];
        
        UILabel *labelName = (UILabel *)[[[sender cellContainer] contentView] viewWithTag:LABEL_NAME_TAG];
        [labelName setTextColor:[UIColor colorWithWhite:0 alpha:0.20]];
    }
    else
    {
        [sender setAlpha:1.0];
        
        UILabel *labelName = (UILabel *)[[[sender cellContainer] contentView] viewWithTag:LABEL_NAME_TAG];
        [labelName setTextColor:[UIColor colorWithWhite:0 alpha:1.0]];
    }
}





/* ************************************************** */
/* ---------------------- Ajout --------------------- */
/* ************************************************** */
#pragma mark - Ajout (Action)

//  Méthode appellée par le bouton +
- (void)addTask
{
    [self viewDidLoad]; // Vérifie sur le TaskEditionViewController est créé et le re-crée si besoin
    [self setIndexPathTaskToEditTo:nil andLoadAndPushViewController:taskEditionViewController];
}





/* ************************************************** */
/* ----------------- Gestion Mémoire ---------------- */
/* ************************************************** */
#pragma mark - Gestion Mémoire

- (void)didReceiveMemoryWarning
{
    UINavigationController *navController = (UINavigationController *)[[[[UIApplication sharedApplication] delegate] window] rootViewController];
    
    //  Si la vue d'édition n'est pas affichée -> dealloc
    if ([[navController topViewController] isKindOfClass:[FATableViewController class]])
    {
        NSLog(@"On est sur la tableView, on vire la vue edition ! Mais comment faire ... ?!");
    }
    [super didReceiveMemoryWarning];
}

@end
