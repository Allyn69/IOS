//
//  YTOAsigurariViewController.h
//  i-asigurare
//
//  Created by Andi Aparaschivei on 7/12/12.
//  Copyright (c) Created by i-Tom Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YTOCalculatorViewController.h"
#import "YTOCalatorieViewController.h"
#import "YTOLocuintaViewController.h"
#import "YTOCASCOViewController.h"

@interface YTOAsigurariViewController : UIViewController<UITableViewDataSource, UITableViewDelegate,UITabBarControllerDelegate>
{
    IBOutlet UITableView * tableView;

    UITableViewCell * cellHeader;
    
    UITableViewCell * cellAsigurareRca;
    UITableViewCell * cellAsigurareCalatorie;
    UITableViewCell * cellAsigurareLocuinta;
    UITableViewCell * cellAsigurareCasco;
    
    UITableViewCell * cellRow1;
    UITableViewCell * cellRow2;
    UITableViewCell * cellRow3;
    UITableViewCell * cellRow4;
    UITableViewCell * cellRow5;
    UITableViewCell * cellFooter;
    
    IBOutlet UITableViewCell *cellButoane;
    IBOutlet UIView * vwNotification;
    IBOutlet UIView * vwNotification7;
    IBOutlet UIView * vwDeCeInfo;
    IBOutlet UIButton *okNotification;
    IBOutlet UIButton *okNotification7;
    IBOutlet UIButton *btnDeCeInfo;
    IBOutlet UITableView *tableNotificari;
    IBOutlet UITableView *tableNotificari7;
    IBOutlet UIWebView *webView;
    IBOutlet UIView *wvPopup;
    IBOutlet UIView *vwBtnDeCeInfo;
    IBOutlet UILabel *lbl1;
    IBOutlet UILabel *lbl2;
    IBOutlet UILabel *lbl3;
    IBOutlet UILabel *lbl1OS7;
    IBOutlet UILabel *lbl2OS7;
    IBOutlet UILabel *lbl3OS7;
    IBOutlet UILabel *lblLoading;
    IBOutlet UIView *vwOperator;
    IBOutlet UIActivityIndicatorView *loading;
    IBOutlet UIActivityIndicatorView *loading7;
    //IBOutlet UILabel *lblPopupTitle;
    NSMutableString * currentElementValue;
    NSString * jsonResponse;
    
    BOOL isNotificationShowing;
    BOOL isPopUpOperatorShowing;
    int numberOfNewNotifications;
    UIView * vw;
    UIButton *a1;
    
    
    IBOutlet UILabel * lbl1Info;
    IBOutlet UILabel * lbl2Info;
    
    int paramForRequest;
    NSString * isRedus;
    NSString * isGothaer;
    NSString * raspuns;
    
    UIImageView * btnRca;
    UIButton * btnCalatorie;
    UIButton * btnLocuinta;
    UIButton * btnCasco;
    UIButton * btnDeCeInfoTable;
    
    IBOutlet UILabel *lblNoInternet;
    IBOutlet UILabel *lblOperator1;
    IBOutlet UILabel *lblOperator2;
    IBOutlet UILabel *lblOperator3;
    IBOutlet UILabel *lblNotificari;
    IBOutlet UILabel *lblNotificari7;
    
    IBOutlet UITableViewCell * cellHead;
    IBOutlet UILabel * lblEroare;
    
}
//notificari
@property (nonatomic, retain) NSMutableData *  responseData;
@property (nonatomic, retain) NSMutableArray * notificari;
@property BOOL openNotification;
- (IBAction) hideNotificari;
- (IBAction) hidePopup;
- (IBAction)choseOperator:(id)sender;
- (IBAction)hidePopupOperator:(id)sender;
- (IBAction)hideDeCeInfo:(id)sender;
- (IBAction)showDeCeInfo:(id)sender;
- (IBAction)showDeCeCont:(id)sender;
- (void)showRCAView;
- (void)showCalatorieView;
- (void)showLocuintaView;
- (void)showCascoView;
- (void)setButtonNotificariBackground;





@end
