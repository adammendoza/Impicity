
// Copyright © Tony Smith, 2014
// Your attention is drawn to the LICENSE file which accompanies this document




#import <UIKit/UIKit.h>
#import "AboutViewController.h"
#import "ImpTableViewController.h"
#import "ImpicityImp.h"
#import "ImpList.h"

@interface ViewController : UIViewController <UITextFieldDelegate>

{
    // Messaging Outlets
    
    IBOutlet UILabel *statusLabel;
    IBOutlet UITextField *messageField;
    IBOutlet UIButton *sendButton;
    IBOutlet UISwitch *invSwitch;
    
    // Clock Outlets
    
    IBOutlet UILabel *modeLabel;
    IBOutlet UISwitch *modeSwitch;
    IBOutlet UISlider *brightSlider;
    
    // Connection Properties
    
    NSURLConnection *conn;
    NSMutableData *receivedData;
    NSArray *messages;
    
    // Misc Properties
    
    NSInteger messageType;
    BOOL keypadFlag, sendFlag, invFlag, qryFlag;
    
    // Imp Properties
    
    ImpList *myImps;
    
    IBOutlet UILabel *currentImpLabel;
}


// Actions

- (IBAction)setBrightness:(id)sender;
- (IBAction)inverseSwitcher:(id)sender;
- (IBAction)modeSwitcher:(id)sender;
- (IBAction)sendMessage:(id)sender;

// Connection Methods

- (void)makeConnection:(NSString *)urlString;
- (void)setConnection:(NSURL *)url;

// imp agent Methods

- (void)getMode;

// Data Persistence Methods

- (void)saveImps:(NSNotification *)note;


@end