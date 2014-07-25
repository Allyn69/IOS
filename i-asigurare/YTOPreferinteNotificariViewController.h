//
//  YTOPreferinteNotificariViewController.h
//  i-asigurare
//
//  Created by Stern Edi on 07/02/14.
//
//

#import <UIKit/UIKit.h>


@interface YTOPreferinteNotificariViewController : UIViewController<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, NSXMLParserDelegate>
{
    IBOutlet UITableView        * tableView;
    IBOutlet UITableViewCell    * cellHead;
    IBOutlet UILabel            * lbl11;
    IBOutlet UITableViewCell    * cellDetalii;
    IBOutlet UITableViewCell    * cellExpirare;
    IBOutlet UITableViewCell    * cellAlteInfo;
    IBOutlet UITableViewCell    * cellDetalii2;
    IBOutlet UISwitch           * switchAlerte;
    IBOutlet UISwitch           * switchInfo;

    IBOutlet UILabel            * lblUser;
    IBOutlet UILabel            * lblDetalii;
    IBOutlet UISwitch           * swExpirare;
    IBOutlet UISwitch           * swAlteInfo;
    
    NSString                    * checkAlerte;
    NSString                    * checkInfo;
    
	NSMutableData * capturedCharactes;
	NSMutableString * currentElementValue;
    NSString * raspuns;
}

@property (nonatomic, retain) NSMutableData * responseData;

@end
