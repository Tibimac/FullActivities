//
//  FATask.h
//  FullActivities
//
//  Created by Thibault Le Cornec on 18/06/2014.
//  Copyright (c) 2014 Tibimac. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, TypeTache)
{
    TypeTachePerso,
    TypeTachePro
};

@interface FATask : NSObject

////////// Propriétés //////////

@property (assign)  BOOL isFinish;
@property (copy)    NSString *name;
@property (assign)  NSUInteger priority;
@property (assign)  TypeTache type;
//@property (nonatomic, copy)     NSDate *dueDate;

@property (readonly, getter = hasImage) BOOL hasImage;
@property (nonatomic, retain, setter = setImage:)   UIImage *image;


////////// Méthodes //////////

//  Designated Initializer
- (instancetype)initWithName:(NSString*)name
                 andPriority:(NSUInteger)priority
                     andType:(TypeTache)type;

//  Méthode appellée lors de l'affectation d'un objet UIImage à _image
//  Cette méthode affecte l'image à _image et met hasImage à YES
- (void)setImage:(UIImage *)image;

//  Méthode appellée lors de la suppression de la photo
//  Cette méthode release l'objet UIImage retenu par _image,
//      repasse le pointeur à nil et met hasImage à NO
-(void)deleteImage;

@end