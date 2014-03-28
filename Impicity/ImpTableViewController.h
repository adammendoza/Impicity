
// Copyright © Tony Smith, 2014
// Your attention is drawn to the LICENSE file which accompanies this document


#import <UIKit/UIKit.h>
#import "ImpicityImp.h"
#import "ImpList.h"
#import "ImpIDViewController.h"


@interface ImpTableViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate>

{
    ImpList *myImps;
    Imp *editingImp;
    
    bool tableEditingFlag;
    
    NSInteger impRow;
    
    IBOutlet UITableView *impTable;
}


-(IBAction)impIDreturned:(UIStoryboardSegue *)segue;

- (void)changeDetails:(NSNotification *)note;
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;


@end