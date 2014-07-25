//
//  YTOSetariParolaViewController.h
//  i-asigurare
//
//  Created by Stern Edi on 07/02/14.
//
//

#import <UIKit/UIKit.h>


@interface YTOSetariParolaViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, NSXMLParserDelegate>
{
    IBOutlet UITableView        * tableView;
    IBOutlet UITableViewCell    * cellHead;
    IBOutlet UILabel            * lbl11;
    IBOutlet UIView             * vwLoading;
    IBOutlet UIView             * vwPopup;
    IBOutlet UIButton           * btnOkPop;
    IBOutlet UILabel            * lblPopDesc;
    IBOutlet UILabel            * lblTitlu1;
    IBOutlet UILabel            * lblTitlu2;
    UITableViewCell             * cellCont;
    UITableViewCell             * cellParolaActuala;
    UITableViewCell             * cellParolaNoua;
    UITableViewCell             * cellParolaConf;
    UITableViewCell             * cellSalveaza;
    UITextField                 * txtParolaActuala;
    UITextField                 * txtParolaNoua;
    UITextField                 * txtParolaConf;
    
  //  IBOutlet UIView             * vwPopup;
    BOOL keyboardFirstTimeActive;
    UITextField * activeTextField;
    NSMutableData * capturedCharactes;
	NSMutableString * currentElementValue;
    NSString * raspuns;
}

- (IBAction)hidePopUp:(id)sender;
@property (nonatomic, retain) NSMutableArray * fieldArray;
@property (nonatomic, retain) NSMutableData * responseData;


@end
