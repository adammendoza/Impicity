

#import "ImpListViewController.h"

@interface ImpListViewController ()

@end

@implementation ImpListViewController

@synthesize currentImp;


- (void)viewDidLoad
{
    ImpicityImp *oneImp = [[ImpicityImp alloc] init];
    oneImp.impCode = @"xGcjKeL7udzg";
    oneImp.impName = @"Fewie";
    myImps = [[NSMutableArray alloc] initWithObjects:oneImp, nil];
    
    [super viewDidLoad];
}



- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults synchronize];
    
    //myImps = nil;
    //myImps = [NSMutableArray arrayWithArray:[defaults arrayForKey:@"impicity_saved_imps"]];
    
    
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}



- (IBAction)newImp:(id)sender

{
    [theTable setEditing:YES];
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


#pragma mark TableView Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"%lu", (unsigned long)[myImps count]);
    return [myImps count];
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"imp_table_cell"];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"imp_table_cell"];
        ImpicityImp *theImp = myImps[indexPath.row];
        cell.textLabel.text = theImp.impName;
        cell.detailTextLabel.text = theImp.impCode;
    }
    
    return cell;
}


- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    return indexPath;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    currentImp = myImps[indexPath.row];
}


- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath

{
    if (indexPath.row == [myImps count])
    {
        return UITableViewCellEditingStyleInsert;
    }
    else
    {
        return UITableViewCellEditingStyleDelete;
    }
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath

{
    
}


- (void)insertRowsAtIndexPaths:(NSArray *)indexPaths withRowAnimation:(UITableViewRowAnimation)animation

{
    
}

@end
