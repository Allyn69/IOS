//
//  YTOFAQViewController.h
//  i-asigurare
//
//  Created by Administrator on 11/5/12.
//
//

#import <UIKit/UIKit.h>

@interface YTOFAQViewController : UIViewController<NSXMLParserDelegate, UITableViewDataSource, UITableViewDelegate>
{
    IBOutlet UITableView * tableView;
    
    IBOutlet UIView     * vwLoading;
    IBOutlet UILabel    * lblLoadingTitlu;
    IBOutlet UILabel    * lblLoadingDescription;
    IBOutlet UIButton   * btnLoadingOk;
    IBOutlet UILabel    * lblLoadingOk;
    IBOutlet UIActivityIndicatorView * loading;
    
    NSMutableData * capturedCharactes;
	NSMutableString * currentElementValue;
	NSString    * responseMessage;
	NSString    * jsonResponse;
}

@property (nonatomic, retain) NSMutableData *  responseData;
@property (nonatomic, retain) NSMutableArray * listFAQ;

- (void) showLoading;
- (IBAction) hideLoading;
- (void) showPopup:(NSString *)title withDescription:(NSString *)description;

@end
