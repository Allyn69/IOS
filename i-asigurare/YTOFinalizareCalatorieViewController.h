//
//  YTOFinalizareCalatorieViewController.h
//  i-asigurare
//
//  Created by Andi Aparaschivei on 10/12/12.
//
//

#import <UIKit/UIKit.h>
#import "PickerVCSearch.h"
#import "YTOOferta.h"
#import "YTOPersoana.h"

@interface YTOFinalizareCalatorieViewController : UIViewController<NSXMLParserDelegate, UIAlertViewDelegate,UITableViewDelegate, UITableViewDataSource, PickerVCSearchDelegate>
{
    IBOutlet UITableView * tableView;

    IBOutlet UIView      *      vwLoading;
    UITextField *               activeTextField;
    
    UITableViewCell *           cellJudetLocalitate;
    UITableViewCell *           cellAdresa;
    UITableViewCell *           cellTelefon;
    UITableViewCell *           cellEmail;
    IBOutlet UITableViewCell *  cellPlata;
    UITableViewCell *           cellCalculeaza;
    
    BOOL goingBack;
    
    NSMutableArray * listCells;
    NSString * telefonLivrare;
    NSString * emailLivrare;
    int modPlata;
    
   	NSMutableData   * capturedCharactes;
	NSMutableString * currentElementValue;
	NSString        * responseMessage;
	NSString        * idOferta;
	NSString        * mesajFinal;
    
    IBOutlet UIImageView * imgError;
    IBOutlet UIView      * vwCustomAlert;
    IBOutlet UILabel     * lblCustomAlertTitle;
    IBOutlet UILabel     * lblCustomAlertMessage;
    IBOutlet UIButton    * btnCustomAlertOK;
    IBOutlet UILabel     * lblCustomAlertOK;
    IBOutlet UIButton    * btnCustomAlertNO;
    IBOutlet UILabel     * lblCustomAlertNO;
    
    UITextField * txtEmailLivrare;
    UITextField * txtTelefonLivrare;
}

@property (nonatomic, retain) YTOOferta         * oferta;
@property (nonatomic, retain) NSMutableArray    * listAsigurati;
@property (nonatomic, retain) NSMutableData     * responseData;

- (void) initCells;
- (void) addBarButton;
- (void) deleteBarButton;

- (void) setSerieAct:(NSString *)serie forIndex:(int)index;
- (void) setEmail:(NSString *)email;
- (void) setTelefon:(NSString *)telefon;
- (void) showListaJudete:(NSIndexPath *)index;
- (IBAction)btnTipPlata_Clicked:(id)sender;
- (void) setTipPlata:(NSString *)p;

- (void) showCustomLoading;
- (IBAction) hideCustomLoading;
- (void) showCustomAlert:(NSString*) title withDescription:(NSString *)description withError:(BOOL) error withButtonIndex:(int) index;
- (void) showCustomConfirm:(NSString *) title withDescription:(NSString *) description withButtonIndex:(int) index;
- (IBAction) hideCustomAlert:(id)sender;

@end
