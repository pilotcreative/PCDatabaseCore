//
//  DetailViewController.h
//  PCDatabaseCoreExampleApp
//
//  Created by Paweł Nużka on 24/09/14.
//  Copyright (c) 2014 Pilot. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;
@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;

@end

