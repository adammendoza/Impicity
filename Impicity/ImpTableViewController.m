
// Copyright © Tony Smith, 2014
// Your attention is drawn to the LICENSE file which accompanies this document



#import "ImpTableViewController.h"

@interface ImpTableViewController ()

@end

@implementation ImpTableViewController




- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    return self;
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Set up the table's selection persistence
    
    self.clearsSelectionOnViewWillAppear = NO;
    
    // Set up the Navigation Bar with an Edit button
    
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.navigationItem.rightBarButtonItem.action = @selector(editTouched:);
    
    // Initialise object properties
    
    tableEditingFlag = NO;
    if (!editingImp) editingImp = [[Imp alloc] init];
    
    // Access the imps list singleton
    
    myImps = [ImpList sharedImps];
    
    // Register object's interest in the 'imp details have changed' notification
    // This is sent by the ImpIDViewController
    
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    
    [nc addObserver:self
           selector:@selector(changeDetails:)
               name:@"impicity.imp.details.changed"
             object:nil];
}



- (void)changeDetails:(NSNotification *)note
{
    // Get the selected imp's new details (send by ImpIDViewController) from
    // the notificaton and apply then to the imp
    
    NSDictionary *dict = note.userInfo;
    editingImp.impName = [dict objectForKey:@"imp.name"];
    editingImp.impCode = [dict objectForKey:@"imp.code"];
}



- (IBAction)editTouched:(id)sender
{
    // The Nav Bar's Edit button has been tapped, so select or cancel editing mode
    
    [impTable setEditing:!impTable.editing animated:YES];
    
    // According to the current mode, set the title of the Edit button:
    // Editing mode: Done
    // Viewing mode: Edit
    
    if (impTable.editing)
    {
        tableEditingFlag = YES;
        [impTable reloadData];
        self.navigationItem.rightBarButtonItem.title = @"Done";
    }
    else
    {
        tableEditingFlag = NO;
        [impTable reloadData];
        self.navigationItem.rightBarButtonItem.title = @"Edit";
    }
}



#pragma mark - Table View Data Source Methods


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableEditingFlag)
    {
        // If the table is in editing mode, add an extra row top hold the 'New imp' button
        
        return ([myImps.listOfImps count] + 1);
    }
    else
    {
         // Otherwise provide one row per recorded imp
        
        return [myImps.listOfImps count];
    }
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Get a new table cell from the queue of existing cells, or create one if none are available
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"imp_table_cell"];
    if (cell == nil) cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"imp_table_cell"];
    
    if (indexPath.row == [myImps.listOfImps count])
    {
        // Append the extra row required by entering the table's editing mode
        
        cell.textLabel.text = @"Add new imp";
        cell.detailTextLabel.text = @"";
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.editingAccessoryType = UITableViewCellAccessoryNone;
    }
    else
    {
        Imp *imp = myImps.listOfImps[indexPath.row];
        cell.textLabel.text = imp.impName;
        cell.detailTextLabel.text = imp.impCode;
        cell.editingAccessoryType = UITableViewCellAccessoryDetailDisclosureButton;
        if (indexPath.row == myImps.currentImpIndex) cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }
    
    return cell;
}



- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    return indexPath;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Is the currently selected row *already* the currentImp? If so, bail
    
    if (myImps.currentImpIndex == indexPath.row) return;
    
    // Remove checkmark from previous selection...
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    NSIndexPath *oldIndexPath = [NSIndexPath indexPathForRow:myImps.currentImpIndex inSection:0];
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:oldIndexPath];
    cell.accessoryType = UITableViewCellAccessoryNone;
    
    // ... and add it to the new one
    
    cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    
    // Record the index of the now-selected imp
    
    myImps.currentImpIndex = indexPath.row;
}



- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == [myImps.listOfImps count])
    {
        // If the table is in editing mode and so has a temporary 'Add new imp' row, give it an Insert symbol
        
        return UITableViewCellEditingStyleInsert;
    }
    else
    {
        // Give all other editing mode rows a Delete symbol
        
        return UITableViewCellEditingStyleDelete;
    }
}



- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        // Remove the deleted row's imp from the data source FIRST
        
        if (indexPath.row == myImps.currentImpIndex) myImps.currentImpIndex = 0;
        [myImps.listOfImps removeObjectAtIndex:indexPath.row];
        
        // Now delete the table row itself then update the table
        
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [tableView reloadData];
    }
    else if (editingStyle == UITableViewCellEditingStyleInsert)
    {
        // Create a new imp with default name and code values FOR DISPLAY ONLY
        
        Imp *imp = [[Imp alloc] init];
        
        // Use compiler commands to branch on 64-bit or 32-bit builds to avoid compiler warnings on %lu or %u in format string
        
#if __LP64__
        imp.impName = [NSString stringWithFormat:@"Imp %lu", ([myImps.listOfImps count] + 1)];
        imp.impCode = [NSString stringWithFormat:@"Imp %lu server code", ([myImps.listOfImps count] + 1)];
#else
        imp.impName = [NSString stringWithFormat:@"Imp %u", ([myImps.listOfImps count] + 1)];
        imp.impCode = [NSString stringWithFormat:@"Imp %u server code", ([myImps.listOfImps count] + 1)];
#endif
        // Add new imp to the list
        
        [myImps.listOfImps addObject:imp];
        
        // And add it to the table
        
        [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
        [impTable reloadData];
    }
}



- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // All table rows are editable, including the 'Add new imp' row
    
    return YES;
}



- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    // Note: this is called AFTER prepareForSegue:
    
    // When the disclosure button is tapped, copy the imp'd details for passing on to ImpIDViewController
    
    Imp *imp = [myImps.listOfImps objectAtIndex:indexPath.row];
    editingImp.impName = imp.impName;
    editingImp.impCode = imp.impCode;
    impRow = indexPath.row;
    
    // Send a notification to ImpIDViewController containg the selected imp's current details
    
    NSDictionary *dict = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:editingImp.impName, editingImp.impCode, nil] forKeys:[NSArray arrayWithObjects:@"imp.name", @"imp.code", nil]];
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc postNotificationName:@"impicity.imp.details.tochange" object:self userInfo:dict];
}




#pragma mark Segue Methods


-(IBAction)impIDreturned:(UIStoryboardSegue *)segue
{
    // When the segue that goes to ImpIDViewController unwinds, update the displayed imp's details
    // with those passed by ImpIDViewController
    
    Imp *imp = [myImps.listOfImps objectAtIndex:impRow];
    imp.impName = editingImp.impName;
    imp.impCode = editingImp.impCode;
    [impTable reloadData];
}



@end