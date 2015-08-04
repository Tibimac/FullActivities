//
//  FADataSource.m
//  FullActivities
//
//  Created by Thibault Le Cornec on 18/06/2014.
//  Copyright (c) 2014 Tibimac. All rights reserved.
//

#import "FADataSource.h"
#import "FATableViewController.h"

@implementation FADataSource

/* ************************************************** */
/* ----------------- Initialisations ---------------- */
/* ************************************************** */
#pragma mark - Initialisation
 
- (instancetype)init
{
    self = [super init];
    
    if (self)
    {
        //====================================
        // EN CAS DE PERSISTENCE DES DONNÉES |
        //====================================
        //  Ouverture du ficier contenant les données
        //  Lecture du fichier
        //  Données lues placées dans un tableau en mémoire.
        //  Données envoyées aux cellules lorsque demandé par le TableViewController
        
        _tasks = [[NSMutableArray alloc] init];
        
        NSMutableArray *firstSection = [[NSMutableArray alloc] init];
        NSMutableArray *secondSection = [[NSMutableArray alloc] init];
        
        [_tasks addObject:firstSection];
        [_tasks addObject:secondSection];
        
        [firstSection release];
        [secondSection release];
        
        
        FATask *aTask;
        //  Personnel
        aTask = [[FATask alloc] initWithName:@"Ranger bureau" andPriority:0 andType:TypeTachePerso];
        [[_tasks objectAtIndex:TypeTachePerso] addObject:aTask];
        [aTask release];
        
        aTask = [[FATask alloc] initWithName:@"Finir Exo 7 MOOC" andPriority:2 andType:TypeTachePerso];
        [aTask setIsFinish:YES];
        [[_tasks objectAtIndex:TypeTachePerso] addObject:aTask];
        [aTask release];
        
        aTask = [[FATask alloc] initWithName:@"Finir Exo 8 MOOC" andPriority:2 andType:TypeTachePerso];
        [[_tasks objectAtIndex:TypeTachePerso] addObject:aTask];
        [aTask release];
        
        aTask = [[FATask alloc] initWithName:@"Keep Calm & Code Objective-C" andPriority:1 andType:TypeTachePerso];
        [aTask setImage:[UIImage imageNamed:@"keep-calm-and-code-objc"]];
        [[_tasks objectAtIndex:TypeTachePerso] addObject:aTask];
        [aTask release];
        
        aTask = [[FATask alloc] initWithName:@"Acheter vêtements mariage" andPriority:2 andType:TypeTachePerso];
        [aTask setIsFinish:YES];
        [[_tasks objectAtIndex:TypeTachePerso] addObject:aTask];
        [aTask release];
        
        aTask = [[FATask alloc] initWithName:@"Passer l'aspirateur" andPriority:0 andType:TypeTachePerso];
        [[_tasks objectAtIndex:TypeTachePerso] addObject:aTask];
        [aTask release];
    
        
        //  Professionnel
        aTask = [[FATask alloc] initWithName:@"Mettre à jour CV" andPriority:1 andType:TypeTachePro];
        [[_tasks objectAtIndex:TypeTachePro] addObject:aTask];
        [aTask release];
        
        aTask = [[FATask alloc] initWithName:@"Trouver une formation dev iOS" andPriority:2 andType:TypeTachePro];
        [[_tasks objectAtIndex:TypeTachePro] addObject:aTask];
        [aTask release];
        
        aTask = [[FATask alloc] initWithName:@"Obtenir financement formation" andPriority:2 andType:TypeTachePro];
        [[_tasks objectAtIndex:TypeTachePro] addObject:aTask];
        [aTask release];
        
//        for (int section = 0; section <=1 ; section++) // Boucle pour créer 2 sections
//        {
//            for (int row = 0; row < 10; row++) // Boucle pour créer 10 taches par section
//            {
//                TypeTache type;
//                
//                if (section == 0) //Type Perso stocké en 0
//                {
//                     type = TypeTachePerso;
//                }
//                else // Type Pro stocké en 1
//                {
//                    type = TypeTachePro;
//                }
//                
//                // Création d'une tâche avec une priorité aléatoire
//                FATask *newTask =[[FATask alloc] initWithName:[NSString stringWithFormat:@"Tâche %d", row+1]
//                                                  andPriority:arc4random()%3
//                                                      andType:type];
//                
//                [[_tasks objectAtIndex:section] addObject:newTask];
//                [newTask release];
//            }
//        }
    }
    
    return self;
}





/* ************************************************** */
/* ------------ Déplacement des Cellules ------------ */
/* ************************************************** */
#pragma mark - Déplacement des Cellules (UITableViewDataSource)

#pragma mark |--> Demande si la cellule est déplacable
//  Méthode appellée en mode édition pour chaque cellule afin de savoir si elle peut
//      être déplacée
//  Cette méthode peut renvoyer YEs ou NO en fonction de la cellule pour laquelle
//      c'est demandée
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}


#pragma mark |--> Déplacement d'une cellule et des données liées
//  Si la cellule est déplacable, il faut implémenter cette méthode pour avoir les "poignets" de déplacement
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
    // On récupère l'objet a déplacer et on le retient avant sa suppression du tableau
    FATask *taskToMove = [[[_tasks objectAtIndex:fromIndexPath.section] objectAtIndex:fromIndexPath.row] retain];
    
    // On suprime l'objet de là où il été
    [[_tasks objectAtIndex:fromIndexPath.section] removeObjectAtIndex:fromIndexPath.row];
    
    //  Si la section a changée -> tâche déplacée dans un autre type -> mise à jour de la tâche
    if (fromIndexPath.section != toIndexPath.section)
    {
        [taskToMove setType:toIndexPath.section];
    }
    
    // On insère l'objet à sa nouvelle position
    [[_tasks objectAtIndex:toIndexPath.section] insertObject:taskToMove atIndex:toIndexPath.row];
    
    //  Un reloadData est nécessaire pour remettre à jour les indexPath stocké par les checkbox des cellules
    [tableView reloadData];
    
    // Pas nécessaire puis le reloadData s'en charge
    //  Mise à jour de l'indexPath stocké par la checkbox de la cellule
//    #define CHECKBOX_TAG 1
//    //  Réupération de la cellule correspondant au nouvel index suite au déplacement.
//    UITableViewCell *cell = [tableView cellForRowAtIndexPath:toIndexPath];
//    //  Récupération du bouton checkbox de cette cellule
//    UICheckboxButton *checkbox = (UICheckboxButton *)[[cell contentView] viewWithTag:CHECKBOX_TAG];
//    //  Mise à jour de l'indePath qu'elle stocke
//    [checkbox setIndexPathCell:toIndexPath];
    
    [taskToMove release];
}





/* ************************************************** */
/* ---------- Suppression/Ajout de cellules --------- */
/* ************************************************** */
#pragma mark - Suppression/Ajout de cellules

#pragma mark |--> Demande si la cellule est modifiable
//  Méthode appellé en mode édition pour chaque cellule afin de savoir si elle peut
//      être modifiée
//  Cette méthode peut renvoyer YES ou NO en fonction de la cellule pour laquelle
//      c'est demandée
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}


#pragma mark |--> Édition cellule à l'index donné (ajout ou suppression)
- (void) tableView:(UITableView *)tableView
commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
 forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        [[_tasks objectAtIndex:indexPath.section] removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        //  Un reloadData est nécessaire pour remettre à jour les indexPath stocké par les checkbox des cellules
        [tableView reloadData];
    }
}





/* ************************************************** */
/* --------- Méthodes de UITableViewDataSource ------ */
/* ************************************************** */
#pragma mark - Méthodes de UITableViewDataSource

#pragma mark |--> Nombre de sections
//  Méthode appellée par le protocol UITableViewDataSource
//  Cette méthode renvoi le nombre de section dans la liste
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSUInteger numberOfSectionsInTableView = [_tasks count];
    return numberOfSectionsInTableView;
}


#pragma mark |--> Nombre de ligne dans la section
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSUInteger numberOfRowsInSection = [[_tasks objectAtIndex:section] count];
    return numberOfRowsInSection;
}


#pragma mark |--> Cellule pour indexPath
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    #define CHECKBOX_TAG 1
    #define LABEL_NAME_TAG 2
    static NSString *CellIdentifier = @"CheckBoxCell";
    
    BOOL newCell = NO;
    NSUInteger section = indexPath.section;
    NSUInteger row = indexPath.row;

    UILabel *labelName;
    UICheckboxButton *checkboxButton;
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if ((section < [_tasks count]) && (row < [[_tasks objectAtIndex:section] count]))
    {
        if (cell == nil) // Si aucune cellule récupérée -> création d'une nouvelle
        {
            newCell = YES;
            
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
            
            CGSize size = [cell contentView].frame.size;
            
            /* ************************************************** */
            /* ----------------- Bouton Checkbox ---------------- */
            checkboxButton = [[UICheckboxButton alloc] init];
            [checkboxButton setTag:CHECKBOX_TAG];
            [checkboxButton setBackgroundColor:[UIColor whiteColor]];
            [checkboxButton setFrame:CGRectMake(10, 7, 30, 30)];
            
            //  Accés à l'objet UINavigationController de l'appli
            UINavigationController *navCtrl= (UINavigationController*)[[[[UIApplication sharedApplication] delegate] window] rootViewController];
            //  Accés au rootViewController du NavigationController, qui est la TableViewController
            FATableViewController *tableViewController = [[navCtrl viewControllers] objectAtIndex:0];
            [checkboxButton addTarget:tableViewController action:@selector(checkboxDidClicked:) forControlEvents:UIControlEventTouchUpInside];
            
            [[cell contentView] addSubview:checkboxButton];
            
            
            /* ************************************************** */
            /* ------------------- Label Name ------------------- */
            labelName = [[UILabel alloc] initWithFrame:CGRectMake(50, 0, size.width-(50), size.height)];
            [labelName setTag:LABEL_NAME_TAG];
            [labelName setTextAlignment:NSTextAlignmentLeft];
            [labelName setTextColor:[UIColor blackColor]];
            [labelName setBackgroundColor:[UIColor whiteColor]];
            [labelName setAutoresizingMask:(UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight)];
            [[cell contentView] addSubview:labelName];
        }
        else
        {
            labelName       = (UILabel *)           [[cell contentView] viewWithTag:LABEL_NAME_TAG];
            checkboxButton  = (UICheckboxButton *)  [[cell contentView] viewWithTag:CHECKBOX_TAG];
        }
        
        
        //  Récupération de la tâche correspondante à l'index de la cellule
        //  Permet de remplir la cellule avec le nom de la tâche et en fonction de son statut et de sa priorité
        FATask *taskForCell = [[[_tasks objectAtIndex:section] objectAtIndex:row] retain];
        
        /* ************************************************** */
        /* --------------- Mise à jour valeurs -------------- */
        [checkboxButton configureCheckboxButtonWithPriority:[taskForCell priority]
                                               forIndexPath:indexPath
                                            inCellContainer:cell];
        
        [checkboxButton setSelected:[taskForCell isFinish]];
        [labelName setText:[taskForCell name]];
        
        if ([taskForCell isFinish])
        {
            [labelName setTextColor:[UIColor colorWithWhite:0 alpha:0.20]];
            [checkboxButton setAlpha:0.20];
        }
        else
        {
            [labelName setTextColor:[UIColor colorWithWhite:0 alpha:1.0]];
            [checkboxButton setAlpha:1.0];
        }
    }
    else
    {   /* Section ou Row demandée en dehors du tableau */ }
        
    
    if (newCell)
    {
        return [cell autorelease];
    }
    else
    {
        return cell;
    }
}


#pragma mark |--> Titre pour la section
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0)
    {
        return @"Personnel";
    }
    else
    {
        return @"Professionnel";
    }
}

@end
