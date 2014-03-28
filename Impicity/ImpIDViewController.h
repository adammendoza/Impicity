
// Copyright © Tony Smith, 2014
// Your attention is drawn to the LICENSE file which accompanies this document



#import <UIKit/UIKit.h>
#import "ImpicityImp.h"


@interface ImpIDViewController : UIViewController

{
    IBOutlet UITextField *nameField;
    IBOutlet UITextField *codeField;
    
    Imp *currentImp;
    
    bool keypadFlag, sendFlag;
}


- (void)changeDetails:(NSNotification *)note;


@end