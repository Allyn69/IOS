//
//  YTOValabilitateRCAViewController.h
//  i-asigurare
//
//  Created by Administrator on 10/25/12.
//
//

#import <UIKit/UIKit.h>
#import "YTOAutovehicul.h"

@interface YTOValabilitateRCAViewController : UIViewController<NSXMLParserDelegate>
{
    IBOutlet UILabel * lblMasina;
    IBOutlet UILabel * lblSerie;
    
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
    
    NSDate * dataExpirare;
}
@property (nonatomic, retain) NSMutableData * responseData;
@property (nonatomic, retain) YTOAutovehicul * masina;

- (IBAction)selecteazaMasina:(id)sender;
- (IBAction) callVerificaRca;
- (void) setAutovehicul:(YTOAutovehicul *)m;

- (void) showLoading;
- (IBAction) hideLoading;
- (void) showPopup:(NSString *)title withDescription:(NSString *)description;

@end
