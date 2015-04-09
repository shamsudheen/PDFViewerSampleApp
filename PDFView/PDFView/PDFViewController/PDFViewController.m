



/*!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
 
                            * PDFViewController.m *
 
                            * PDFViewerSampleApp *
 
                     * Created by Shamsudheen on 07/04/15 *
 
             * This class represents the pdf/help documents viewer *
 
 !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!*/

#import "PDFViewController.h"

@interface PDFViewController ()

@property (nonatomic, assign) float numberOfPages; //represents the number of pages in the pdf.
@property (nonatomic, assign) float pageHeight;    //represents the pdf page height.

@property (nonatomic, assign) int currentPageNumber;  //represents the active pdf page number.

@property (nonatomic, weak) IBOutlet UIWebView *pdfViewer; //represents the pdf viewer.

@property (nonatomic, weak) IBOutlet UITextField *txtPageNumber; //represents the page number input provider.

@end

@implementation PDFViewController


/*!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
 
 Method will call after the view has been loaded.
 For view controllers created in code, this is after -loadView.
 For view controllers unarchived from a nib, this is after the view is set.
 
 !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!*/
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.txtPageNumber setDelegate:self];
}

/*!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
 
 This delegate method triggers when the view has been fully transitioned onto the screen.
 
 !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!*/
- (void)viewDidAppear:(BOOL)animated
{
    @try
    {
        [super viewDidAppear:animated];
        
        [self displayPDFContent];
    }
    @catch (NSException *exception)
    {
        NSLog(@"%s\n exception: Name- %@ Reason->%@", __PRETTY_FUNCTION__,[exception name],[exception reason]);
    }
}

/*!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
 
 Method will call when the parent application receives a memory warning.
 On iOS 6.0 it will no longer clear the view by default.
 
 !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!*/
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark Custom methods

/*!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
 
 Method is used to display the pdf content.
 
 !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!*/
- (void)displayPDFContent
{
    @try
    {
        self.pageHeight = -1; //settings the pageHeight to -1. So it will be dynamically caliculated.
        
        NSString *filePath = [[NSBundle mainBundle] pathForResource:self.fileName ofType:@"pdf"];
        
        if (nil != filePath)
        {
            NSURL *fileURL = [NSURL fileURLWithPath:filePath];
            
            CGPDFDocumentRef pdfDocumentRef = CGPDFDocumentCreateWithURL((CFURLRef)fileURL);
            self.numberOfPages = (int) CGPDFDocumentGetNumberOfPages(pdfDocumentRef);
            
            NSURLRequest *urlRequest = [NSURLRequest requestWithURL:fileURL];
            [self.pdfViewer loadRequest:urlRequest];
            
            self.currentPageNumber = 1;
        }
    }
    @catch (NSException *exception)
    {
        NSLog(@"%s\n exception: Name- %@ Reason->%@", __PRETTY_FUNCTION__,[exception name],[exception reason]);
    }
    @finally
    {
        [self setPdfViewerProperties];
    }
}

/*!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
 
 Method is used to set the pdf viewer properties.
 
 !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!*/
- (void)setPdfViewerProperties
{
    @try
    {
        CGRect rect = [[UIScreen mainScreen] bounds];
        CGSize screenSize = rect.size;
        
        self.pdfViewer.autoresizesSubviews = YES;
        self.pdfViewer.autoresizingMask = (UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth);
        self.pdfViewer.scrollView.delegate = self;
        self.pdfViewer.contentMode = UIViewContentModeCenter;
        self.pdfViewer.frame = CGRectMake(0, 75, screenSize.width, screenSize.height - 75);
    }
    @catch (NSException *exception)
    {
        NSLog(@"%s\n exception: Name- %@ Reason->%@", __PRETTY_FUNCTION__,[exception name],[exception reason]);
    }
}

/*!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
 
 Method is used to display the pdf next page.
 
 !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!*/
- (IBAction)nextPage:(id)sender
{
    @try
    {
        //to caliculate the page number, first get how far the user has scrolled.
        float verticalContentOffset = self.pdfViewer.scrollView.contentOffset.y;
        
         float screenHight = self.pdfViewer.frame.size.height;
        
        //caliculating the current page number
        self.currentPageNumber = ceil(((verticalContentOffset + (screenHight/2)) / self.pageHeight));
        
        self.currentPageNumber = (0 >= self.currentPageNumber) ? 1: self.currentPageNumber;
        
        if (self.currentPageNumber < self.numberOfPages)
        {
            CGFloat contentHeight = self.pdfViewer.scrollView.contentSize.height;
            
            self.pageHeight = (contentHeight / self.numberOfPages);
            
            float yCord = (self.pageHeight * self.currentPageNumber++);
            
            [self.pdfViewer.scrollView setContentOffset:CGPointMake(0, yCord) animated:YES];
        }
    }
    @catch (NSException *exception)
    {
        NSLog(@"%s\n exception: Name- %@ Reason->%@", __PRETTY_FUNCTION__,[exception name],[exception reason]);
    }
}

/*!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
 
 Method is used to display the pdf previous page.
 
 !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!*/
- (IBAction)previousPage:(id)sender
{
    @try
    {
        if (self.currentPageNumber > 1)
        {
            float yCord = --self.currentPageNumber * self.pageHeight - self.pageHeight;
            [self.pdfViewer.scrollView setContentOffset:CGPointMake(0, yCord) animated:YES];
        }
    }
    @catch (NSException *exception)
    {
        NSLog(@"%s\n exception: Name- %@ Reason->%@", __PRETTY_FUNCTION__,[exception name],[exception reason]);
    }
}

/*!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
 
 Method is used to scroll to a specific page using the page number.
 
 !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!*/
- (IBAction)goToASpecificPage:(id)sender
{
    @try
    {
        //The page height is caliculated by taking the overall size of the webview scrollview content size.
        //then  deviding it by the number of pages.
        CGFloat contentHeight = self.pdfViewer.scrollView.contentSize.height;
        
        self.pageHeight = contentHeight/ self.numberOfPages;
        
        BOOL isInputTextValid = [self isInputValid];
        
        int userGivenPageNumber = [self.txtPageNumber.text intValue];
        
        if (YES == isInputTextValid)
        {
            if (self.numberOfPages < userGivenPageNumber)
            {
                self.txtPageNumber.text = @"";
                self.txtPageNumber.placeholder = @"Input exceeds the total pages";
            }
            else
            {
                int tragetPageNumber = userGivenPageNumber - 1;
                
                [self.pdfViewer.scrollView setContentOffset:CGPointMake(0, (tragetPageNumber * self.pageHeight)) animated:YES];
                
                self.currentPageNumber = userGivenPageNumber;
            }
        }
        else
        {
            self.txtPageNumber.text = @"";
            self.txtPageNumber.placeholder = @"Invalid input";
        }
    }
    @catch (NSException *exception)
    {
        NSLog(@"%s\n exception: Name- %@ Reason->%@", __PRETTY_FUNCTION__,[exception name],[exception reason]);
    }
}

/*!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
 
 Method is used to check either the provided page number is valid or not.
 
 !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!*/
- (BOOL)isInputValid
{
    BOOL isNumeric = NO;
    
    @try
    {
        if(0 < [self.txtPageNumber.text length])
        {
            NSCharacterSet *nonNumberSet = [[NSCharacterSet characterSetWithRange:NSMakeRange('0',10)] invertedSet];
            NSString *trimmed = [self.txtPageNumber.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            
            isNumeric = trimmed.length > 0 && [trimmed rangeOfCharacterFromSet:nonNumberSet].location == NSNotFound;
        }
    }
    @catch (NSException *exception)
    {
        NSLog(@"%s\n exception: Name- %@ Reason->%@", __PRETTY_FUNCTION__,[exception name],[exception reason]);
    }
    @finally
    {
        return isNumeric;
    }
}

/*!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
 
 Method is used to dismiss the displayed pdf page.
 
 !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!*/
- (IBAction)doneButtonClicked:(id)sender
{
    [self.pdfViewer loadHTMLString:@"" baseURL:nil];
    
    if (YES == self.pdfViewer.isLoading)
    {
        [self.pdfViewer stopLoading];
    }
    
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    
    self.pdfViewer.delegate = nil;
    
    [self.pdfViewer removeFromSuperview];

    [self dismissViewControllerAnimated:NO completion:^{
    
        [[NSNotificationCenter defaultCenter] postNotificationName:@"pdfViewerDismissed" object:nil];
        
    }];
}

#pragma mark Scrollview delegates

/*!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
 
 Method is used to handle the page number while scrolling.
 
 !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!*/
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    @try
    {
        //The page height is caliculated by taking the overall size of the webview scrollview content size.
        //then  deviding it by the number of pages.
        CGFloat contentHeight = self.pdfViewer.scrollView.contentSize.height;
        
        self.pageHeight = contentHeight/ self.numberOfPages;
        
        float screenHight = self.pdfViewer.frame.size.height;
        
        //to caliculate the page number, first get how far the user has scrolled.
        float verticalContentOffset = self.pdfViewer.scrollView.contentOffset.y;
        
        self.currentPageNumber = ceilf((verticalContentOffset + (screenHight/2)) / self.pageHeight);
        
        self.currentPageNumber = (0 >= self.currentPageNumber) ? 1: self.currentPageNumber;
    }
    @catch (NSException *exception)
    {
        NSLog(@"%s\n exception: Name- %@ Reason->%@", __PRETTY_FUNCTION__,[exception name],[exception reason]);
    }
}

#pragma mark TextFeild delegates

/*!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
 
 This UItextView delegate will trigger for every text change.
 
 !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!*/
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    @try
    {
        self.txtPageNumber.placeholder = @"Enter page number here";
    }
    @catch (NSException *exception)
    {
        NSLog(@"%s\n exception: Name- %@ Reason->%@", __PRETTY_FUNCTION__,[exception name],[exception reason]);
    }
}

/*!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
 
 This UItextView delegate will trigger when clear button pressed
 
 !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!*/
- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    @try
    {
        self.txtPageNumber.placeholder = @"Enter page number here";
    }
    @catch (NSException *exception)
    {
        NSLog(@"%s\n exception: Name- %@ Reason->%@", __PRETTY_FUNCTION__,[exception name],[exception reason]);
    }
    @finally
    {
        return YES;
    }
}

@end
