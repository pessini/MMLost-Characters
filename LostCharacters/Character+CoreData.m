//
//  Character+CoreData.m
//  LostCharacters
//
//  Created by Leandro Pessini on 3/31/15.
//  Copyright (c) 2015 Brazuca Labs. All rights reserved.
//

#import "Character+CoreData.h"
#import "AppDelegate.h"

@implementation Character_CoreData

//+ (Character *)newInstance
//{
//    AppDelegate *appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
//    NSManagedObjectContext *context = [appDelegate managedObjectContext];
//    Character *character = [NSEntityDescription insertNewObjectForEntityForName:@"Character"
//                                             inManagedObjectContext:context];
//    return character;
//}

+ (NSArray *)loadCharacters
{
    AppDelegate *appDelegate = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    NSManagedObjectContext *context = [appDelegate managedObjectContext];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Character"
                                              inManagedObjectContext:context];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entity];
    NSError *error;
    NSArray *array = [context executeFetchRequest:request error:&error];

    if (!array)
    {
        NSLog(@"Error %@", error);
        return nil;
    }
    return array;
}

@end
