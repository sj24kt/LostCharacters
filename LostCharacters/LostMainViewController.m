//
//  LostMainViewController.m
//  LostCharacters
//
//  Created by Sherrie Jones on 4/6/15.
//  Copyright (c) 2015 Sherrie Jones. All rights reserved.
//

#import "LostMainViewController.h"
#import "AppDelegate.h"
#import "LostTableViewCell.h"
#import "EditViewController.h"

@interface LostMainViewController () <UITableViewDataSource, UITableViewDelegate, UIActionSheetDelegate>
@property (strong, nonatomic) IBOutlet UITableView *lostTableView;
@property (strong, nonatomic) IBOutlet UITextField *nameTextField;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *editBarButton;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *addButton;
@property NSManagedObjectContext *moc;
@property NSArray *plistCharacters;
@property NSMutableArray *lostCharacters;
@property BOOL isToggled;
@property BOOL allRowsSelected;
@end

@implementation LostMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    AppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    self.moc = appDelegate.managedObjectContext;

    [self loadPlist];
}

#pragma mark - UITableView Datasource and Delegates

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.lostCharacters.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSManagedObject *character = self.lostCharacters[indexPath.row];
    LostTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LostCell"];
    cell.nameLabel.text = [character valueForKey:@"name"];
    cell.actorNameLabel.text = [character valueForKey:@"actor"];
    cell.seatNumberLabel.text = [NSString stringWithFormat:@"Seat No: %@", [character valueForKey:@"seat"]];
    cell.genderLabel.text = [character valueForKey:@"gender"];

    if (cell.imageLabel.image == nil) {
        cell.imageLabel.image = [UIImage imageNamed:@"silhouette"];
    } else {
        NSData *imageData = [character valueForKey:@"image"];
        cell.imageLabel.image = [UIImage imageWithData:imageData];
    }
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSManagedObject *character = self.lostCharacters[indexPath.row];
        [self.moc deleteObject:character];
        [self.moc save:nil];

        [self fetchNewData:nil];
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
    return @"SMOKE MONSTER";
}

#pragma mark - CoreData

- (void)loadPlist {
    [self fetchNewData:nil];

    if (self.lostCharacters.count == 0) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"lost" ofType:@"plist"];
        self.plistCharacters = [[NSArray alloc] initWithContentsOfFile:path];

        for (NSDictionary *lost in self.plistCharacters) {
            NSManagedObject *character = [NSEntityDescription insertNewObjectForEntityForName:@"Character" inManagedObjectContext:self.moc];
            [character setValue:lost[@"passenger"] forKey:@"name"];
            [character setValue:lost[@"actor"] forKey:@"actor"];
            [character setValue:lost[@"gender"] forKey:@"gender"];
            [character setValue:lost[@"seat"] forKey:@"seat"];
            [self.moc save:nil];
        }
    }
    [self.lostTableView reloadData];
}

- (void)fetchNewData:(NSString *)predicate {
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Character"];
    self.lostCharacters = [[self.moc executeFetchRequest:request error:nil] mutableCopy];

    NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    NSSortDescriptor *sortTwo = [[NSSortDescriptor alloc] initWithKey:@"gender" ascending:YES];

    if (predicate) {
        request.predicate = [NSPredicate predicateWithFormat:predicate];
    }

    request.sortDescriptors = @[sort, sortTwo];
    //self.lostCharacters = [[self.moc executeFetchRequest:request error:nil] mutableCopy];
    [self.lostTableView reloadData];
}

#pragma mark - IBActions

-(IBAction)prepareForUnwind:(UIStoryboardSegue *)segue {
}

- (IBAction)lostToggle:(UISegmentedControl *)sender {
    self.isToggled = !self.isToggled;
    [self fetchNewData:nil];
}

- (IBAction)editAction:(id)sender {
    self.lostTableView.allowsMultipleSelectionDuringEditing = YES;
    [self.lostTableView setEditing:YES animated:YES];
    [self updateButtonsToMatchTableState];
}

- (IBAction)cancelAction:(id)sender {
    [self.lostTableView setEditing:NO animated:YES];
    [self updateButtonsToMatchTableState];
}

- (void)updateButtonsToMatchTableState {
    if (self.lostTableView.editing) {
        // Show the option to cancel the edit.
//        self.navigationItem.leftBarButtonItem = self.cancelButton;

//        [self updateDeleteButtonTitle];

//        self.navigationItem.rightBarButtonItem = self.deleteButton;
    } else {
        self.navigationItem.rightBarButtonItem = self.addButton;
        // Show the edit button, but disable the edit button if there's nothing to edit.
        if (self.lostCharacters.count > 0) {
//            self.editButton.enabled = YES;
        } else {
//            self.editButton.enabled = NO;
        }
//        self.navigationItem.leftBarButtonItem = self.editButton;
    }
}

- (IBAction)deleteAction:(id)sender {
    // Open a dialog with just an OK button.
    NSString *actionTitle;
    if (([[self.lostTableView indexPathsForSelectedRows] count] == 1)) {
        actionTitle = NSLocalizedString(@"Are you sure you want to remove this item?", @"");
    } else {
        actionTitle = NSLocalizedString(@"Are you sure you want to remove these items?", @"");
    }

    NSString *cancelTitle = NSLocalizedString(@"Cancel", @"Cancel title for item removal action");
    NSString *okTitle = NSLocalizedString(@"OK", @"OK title for item removal action");
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:actionTitle
                                                             delegate:self
                                                    cancelButtonTitle:cancelTitle
                                               destructiveButtonTitle:okTitle
                                                    otherButtonTitles:nil];

    actionSheet.actionSheetStyle = UIActionSheetStyleDefault;

    // Show from our table view (pops up in the middle of the table).
    [actionSheet showInView:self.view];
}

#pragma mark - UIStoryboardSegue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(UITableViewCell *)sender {
    if ([segue.identifier isEqualToString:@"edit"]) {
        EditViewController *vc = segue.destinationViewController;
        vc.moc = self.moc;

        NSIndexPath *indexPath = [self.lostTableView indexPathForCell:sender];
        NSManagedObject *selected = self.lostCharacters[indexPath.row];
        vc.selectedCharacter = selected;
    }
}
@end


























