//
//  YTOWebViewController.m
//  i-asigurare
//
//  Created by Administrator on 10/12/12.
//
//

#import "YTOWebViewController.h"

@interface YTOWebViewController ()

@end

@implementation YTOWebViewController
@synthesize URL;
@synthesize HTMLContent;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    if (URL && ![URL isEqualToString:@""])
    {
        NSURL * url = [[NSURL alloc] initWithString:URL];
        NSURLRequest * req = [[NSURLRequest alloc] initWithURL:url];
        webView.delegate = self;
        [webView loadRequest:req];
    }
    else if (HTMLContent && ![HTMLContent isEqualToString:@""])
    {
        [webView loadHTMLString:HTMLContent baseURL:nil];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [self showLoading];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self hidePopup];
}

- (void) webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [self showPopupWithTitle:@"Conexiune esuata" andDescription:@"Pagina nu este disponibila. Verificati conexiunea la internet."];
    goBack = YES;
}

- (void) showPopupWithTitle:(NSString *)title andDescription:(NSString *)description
{
    [lblLoadingDescription setHidden:NO];
    [lblLoadingDescription setText:description];
    [vwLoadingIndicator setHidden:YES];
    [lblLoadingTitle setText:title];
    [vwLoading setHidden:NO];
    [btnOk setHidden:NO];
    [lblOk setHidden:NO];
}

- (void) showLoading
{
    [lblLoadingDescription setHidden:YES];
    [vwLoadingIndicator setHidden:NO];
    [lblLoadingTitle setText:@"Se incarca..."];
    [vwLoading setHidden:NO];
    [btnOk setHidden:YES];
    [lblOk setHidden:YES];
}

- (IBAction)hidePopup
{
    [vwLoading setHidden:YES];
    if (goBack)
        [self.navigationController popViewControllerAnimated:YES];
}

@end
