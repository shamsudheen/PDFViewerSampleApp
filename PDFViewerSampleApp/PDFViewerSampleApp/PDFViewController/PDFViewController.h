



/*!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
 
                            * PDFViewController.h *
 
                            * PDFViewerSampleApp *
 
                     * Created by Shamsudheen on 07/04/15 *
 
             * This class represents the pdf/help documents viewer *
 
 !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!*/

#import <UIKit/UIKit.h>

@interface PDFViewController : UIViewController <UIScrollViewDelegate,UITextFieldDelegate>

@property (nonatomic, strong) NSString *fileName; //represents the file name

@end
