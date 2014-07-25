//
//  YTOPromotiiFromWebViewController.h
//  i-asigurare
//
//  Created by Stern Edi on 6/21/13.
//
//

#import <UIKit/UIKit.h>



@interface YTOPromotiiFromWebViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>
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
}

@property (nonatomic, retain) NSMutableData *  responseData;
@property (nonatomic, retain) NSMutableArray * promotii;

- (IBAction) hidePopup;

@end
