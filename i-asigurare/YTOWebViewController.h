//
//  YTOWebViewController.h
//  i-asigurare
//
//  Created by Administrator on 10/12/12.
//
//

#import <UIKit/UIKit.h>

@interface YTOWebViewController : UIViewController<UIWebViewDelegate>
{
    IBOutlet UIWebView * webView;
    
    IBOutlet UIView * vwLoading;
    IBOutlet UILabel * lblLoadingTitle;
    IBOutlet UILabel * lblLoadingDescription;
    IBOutlet UIActivityIndicatorView * vwLoadingIndicator;
    IBOutlet UIButton * btnOk;
    IBOutlet UILabel  * lblOk;
    BOOL goBack;
}

@property (nonatomic, retain) NSString * URL;
@property (nonatomic, retain) NSString * HTMLContent;

- (IBAction) hidePopup;

@end
