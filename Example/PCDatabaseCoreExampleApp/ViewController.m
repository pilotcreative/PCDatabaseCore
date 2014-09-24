//
//  ViewController.m
//  PCDatabaseCoreExampleApp
//
//  Created by Paweł Nużka on 05/09/14.
//  Copyright (c) 2014 Pilot. All rights reserved.
//

#import "ViewController.h"
#import "DatabaseHelper+Event.h"
#import "Event.h"

@interface ViewController () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSFetchedResultsController *fetchedController;
@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.fetchedController = [[DatabaseHelper sharedInstance] getAllEvents];
	// Do any additional setup after loading the view, typically from a nib.
}


#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.fetchedController.fetchedObjects.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EventCell" forIndexPath:indexPath];
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.parentViewController performSegueWithIdentifier:@"showEventDetails" sender:self.fetchedController.fetchedObjects[indexPath.row]];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    Event *event = self.fetchedController.fetchedObjects[indexPath.row];
    cell.textLabel.text = event.name;
}

@end
