//
//  YTOTermeniViewController.h
//  i-asigurare
//
//  Created by Andi Aparaschivei on 11/6/12.
//
//

#import <UIKit/UIKit.h>

@interface YTOTermeniViewController : UIViewController<NSXMLParserDelegate, UIWebViewDelegate>
{
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
    
    IBOutlet UIWebView * webView;
}

@property (nonatomic, retain) NSMutableData *  responseData;

- (void) showLoading;
- (IBAction) hideLoading;
- (void) showPopup:(NSString *)title withDescription:(NSString *)description;

@end
