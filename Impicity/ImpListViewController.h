

#import <UIKit/UIKit.h>
#import "ImpicityImp.h"


@interface ImpListViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

{
    NSMutableArray *myImps;
    ImpicityImp *currentImp;
    
    IBOutlet UITableView *theTable;
}

- (IBAction)newImp:(id)sender;


@property (nonatomic, retain) ImpicityImp *currentImp;

@end
