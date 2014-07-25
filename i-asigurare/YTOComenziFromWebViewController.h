//
//  YTOComenziFromWebViewController.h
//  i-asigurare
//
//  Created by Stern Edi on 20/01/14.
//
//

#import <UIKit/UIKit.h>


@interface YTOComenziFromWebViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>
{
    IBOutlet UITableView * tableView;
    NSMutableString * currentElementValue;
    NSString * jsonResponse;
    IBOutlet UIView * wvLoading;
    IBOutlet UIView * wvPopup;
    IBOutlet UILabel * lblPopupTitle;
    
    IBOutlet UILabel * lblSeIncarca;
    IBOutlet UILabel * lblNoInternet;
    IBOutlet UITableViewCell * cellHead;
    IBOutlet UILabel * lblEroare;
    IBOutlet UIView      * vwEmpty;
    BOOL editingMode;
    IBOutlet UIView * noLogIn;
    IBOutlet UILabel * lblZeroComenzi;
    IBOutlet UILabel * lblChangeView;
}

@property (nonatomic, retain) NSMutableData *  responseData;
@property (nonatomic, retain) NSMutableArray * comenzi;
@property (nonatomic, retain) UIViewController * controller;

- (IBAction) hidePopup;
- (IBAction)goToLogin:(id)sender;

@end
