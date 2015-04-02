//
//  CharacterTableViewCell.h
//  LostCharacters
//
//  Created by Leandro Pessini on 4/1/15.
//  Copyright (c) 2015 Brazuca Labs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CharacterTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *characterImage;
@property (weak, nonatomic) IBOutlet UILabel *actorLabel;
@property (weak, nonatomic) IBOutlet UILabel *seatLabel;
@property (weak, nonatomic) IBOutlet UILabel *age;

@end
