//
//  ViewController.m
//  LostCharacters
//
//  Created by Leandro Pessini on 3/31/15.
//  Copyright (c) 2015 Brazuca Labs. All rights reserved.
//

#import "CharacterListViewController.h"
#import "Character.h"
#import "Character+CoreData.h"

@interface CharacterListViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *charactersTableView;
@property NSArray *charactersArray;

@end

@implementation CharacterListViewController

@synthesize managedObjectContext;

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Table View Delegate
    self.charactersTableView.delegate = self;
    self.charactersTableView.dataSource = self;

    self.charactersArray = [NSArray new];

//    NSManagedObject *character = [NSEntityDescription insertNewObjectForEntityForName:@"Character" inManagedObjectContext:managedObjectContext];
//    [character setValue:@"Leandro Pessini" forKey:@"name"];
//    [character setValue:@"Euuu" forKey:@"actor"];
//    [managedObjectContext save:nil];

    [self load];


}

-(void)load
{
    self.charactersArray = [Character_CoreData loadCharacters];

    [self.charactersTableView reloadData];

    NSLog(@"Array: %@", self.charactersArray);
    NSLog(@"Count: %lu", (unsigned long)self.charactersArray.count);
}

#pragma mark -UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.charactersArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.charactersTableView dequeueReusableCellWithIdentifier:@"CharacterCell"];
//    Character *character = [self.charactersArray objectAtIndex:indexPath.row];

    cell.textLabel.text = @"Oi";

    return cell;
}

@end
