//
//  Character.h
//  LostCharacters
//
//  Created by Leandro Pessini on 3/31/15.
//  Copyright (c) 2015 Brazuca Labs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Character : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * actor;
@property (nonatomic, retain) NSNumber * age;
@property (nonatomic, retain) NSNumber * gender;
@property (nonatomic, retain) NSString * hair_color;
@property (nonatomic, retain) NSString * plane_seat;
@property (nonatomic, retain) NSString * occupation;
@property (nonatomic, retain) NSData *photoData;

@end
