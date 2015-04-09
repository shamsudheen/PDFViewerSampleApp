



/*!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
 
                             * ViewController.m *
 
                            * PDFViewerSampleApp *
 
                     * Created by Shamsudheen on 07/04/15 *
 
             * This class represents the initial view controller *
 
 !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!*/

#import "ViewController.h"
#import "PDFViewController.h"

@interface ViewController ()

@property (nonatomic, strong) PDFViewController *pdfViewController; //pdf viewer class property.

@end

@implementation ViewController

/*!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
 
 Method will call after the view has been loaded.
 For view controllers created in code, this is after -loadView.
 For view controllers unarchived from a nib, this is after the view is set.
 
 !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!*/
- (void)viewDidLoad
{
    [super viewDidLoad];
}

/*!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
 
 Calling when the view is about to made visible. Default does nothing
 
 !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!*/
- (void)viewWillAppear:(BOOL)animated
{
    //subscribe all the relevant notofications.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pdfViewerDismissed) name:@"pdfViewerDismissed" object:nil];
}

/*!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
 
 This delegate method triggers when the view is going to be disappeared
 
 !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!*/
- (void)viewWillDisappear:(BOOL)animated
{
    //remove all the notofications.
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

/*!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
 
 Method will call when the parent application receives a memory warning.
 On iOS 6.0 it will no longer clear the view by default.
 
 !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!*/
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

/*!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
 
 Method to present/display the pdf file.
 
 !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!*/
- (IBAction)presentPDFViewer:(id)sender
{
    @try
    {
        if (nil == self.pdfViewController)
        {
            self.pdfViewController = [[PDFViewController alloc] init];
            [self.pdfViewController setFileName:@"Resume"];
            [self presentViewController:self.pdfViewController animated:YES completion:nil];
        }
    }
    @catch (NSException *exception)
    {
        NSLog(@"%s\n exception: Name- %@ Reason->%@", __PRETTY_FUNCTION__,[exception name],[exception reason]);
    }
}

/*!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
 
 Method to destroy the psf viewer instance.
 
 !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!*/
- (void)pdfViewerDismissed
{
    self.pdfViewController = nil;
}

@end
