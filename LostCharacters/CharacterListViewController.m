//
//  ViewController.m
//  LostCharacters
//
//  Created by Leandro Pessini on 3/31/15.
//  Copyright (c) 2015 Brazuca Labs. All rights reserved.
//

#import "CharacterListViewController.h"
#import "AppDelegate.h"
#import "Character.h"
#import "CharacterTableViewCell.h"

@interface CharacterListViewController () <UITableViewDataSource, UITableViewDelegate, UITabBarDelegate>
@property (weak, nonatomic) IBOutlet UITableView *charactersTableView;
@property NSArray *charactersArray;
@property (nonatomic,strong) NSManagedObjectContext *managedObjectContext;

@end

@implementation CharacterListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Table View Delegate
    self.charactersTableView.delegate = self;
    self.charactersTableView.dataSource = self;

    self.charactersArray = [NSArray new];

    AppDelegate *delegate = [[UIApplication sharedApplication] delegate];
    self.managedObjectContext = delegate.managedObjectContext;
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self loadDataUsingPredicate:nil];
}

#pragma mark -UITableViewDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.charactersArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CharacterTableViewCell *cell = [self.charactersTableView dequeueReusableCellWithIdentifier:@"CharacterCell"];
    NSManagedObject *character = [self.charactersArray objectAtIndex:indexPath.row];

    cell.nameLabel.text = [character valueForKey:@"name"];
    cell.actorLabel.text = [character valueForKey:@"actor"];
    cell.seatLabel.text = [NSString stringWithFormat:@"Seat: %@",[character valueForKey:@"plane_seat"]];

    if ([[character valueForKey:@"age"] isEqualToValue:@0])
    {
        cell.age.text = @"";
    }
    else
    {
        cell.age.text = [NSString stringWithFormat:@"Age: %@", [character valueForKey:@"age"]];
    }

    if ([character valueForKey:@"photo"] == nil)
    {
        if (![character valueForKey:@"gender"])
        {
            cell.characterImage.image = [UIImage imageNamed:@"female_icon"];
        }
        else
        {
            cell.characterImage.image = [UIImage imageNamed:@"male_icon"];
        }

    }
    else
    {
        NSData *imageData = [character valueForKey:@"photo"];
        cell.characterImage.image = [UIImage imageWithData:imageData];
    }

    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        NSManagedObject *character = self.charactersArray[indexPath.row];
        [self.managedObjectContext deleteObject:character];
        [self.managedObjectContext save:nil];

        [self loadDataUsingPredicate:nil];
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"SMOKE MONSTER";
}

#pragma mark -UITabBarDelegate

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    if(item.tag == 0)
    {
        [self loadDataUsingPredicate:@"gender == 0"];
    }
    else if (item.tag == 2)
    {
        [self loadDataUsingPredicate:@"gender == 1"];
    }
    else
    {
        [self loadDataUsingPredicate:nil];
    }
}

- (void)loadDataUsingPredicate:(NSString *)predicate {
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Character"];


    NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    NSSortDescriptor *sortTwo = [[NSSortDescriptor alloc] initWithKey:@"gender" ascending:YES];
    if (predicate)
    {
        request.predicate = [NSPredicate predicateWithFormat:predicate];
    }

    request.sortDescriptors = @[sort, sortTwo];

    self.charactersArray = [self.managedObjectContext executeFetchRequest:request error:nil];

    [self.charactersTableView reloadData];
}
@end
