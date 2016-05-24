//
//  KNCameraPickerTemplateViewController.h
//  NUS Technology
//
//  Created by NUS Technology on 6/20/14.
//
//
//  Interface of template view controller which has camera picker feature and image view for preview.

protocol CameraPickerViewControllerDelegate: NSObject {
    func didSelectedImage(image: UIImage)
}
class CameraPickerViewController: BaseViewController, UIImagePickerControllerDelegate {
    // preview image view
    @IBOutlet weak var preview: UIImageView!
    // method to get image file name to save it.

    func generateImageName() -> String {
        var formatter: NSDateFormatter = NSDateFormatter()
        formatter.dateFormat = "ddMMyyyy-HHmmss"
        var ret: String = formatter.stringFromDate(NSDate())
        return "\(ret)"
    }
    // callback when taken image

    func onImagePicked(image: UIImage) {
        //    self.currentImagePath = [self generateImagePath];
        //    [UIImageJPEGRepresentation(image, 0.5f) writeToFile:self.currentImagePath atomically:YES];
        //    
        //    UIImage *imageTmp = [UIImage imageWithContentsOfFile:self.currentImagePath];
        //    self.preview.image= imageTmp;
        self.preview.image = image
        self.delegate.didSelectedImage(image)
    }
    // path of current image.
    var currentImagePath: String
    // Set type of camera will be used, default rear camare
    var isFrontCameraUsed: Bool

    @IBAction func launchCamera(sender: AnyObject) {
        var popup: UIActionSheet = UIActionSheet(title: LOCALIZATION("Get Picture From"), delegate: self, cancelButtonTitle: LOCALIZATION("Cancel"), destructiveButtonTitle: nil, otherButtonTitles: LOCALIZATION("Camera"), LOCALIZATION("Photos"), nil)
        popup.tag = 1
        popup.showInView(UIApplication.sharedApplication().keyWindow)
        if (sender is UIViewController.self) {
            containVC = sender
        }
        else {
            containVC = self
        }
    }
    weak var delegate: protocol<NSObject, CameraPickerViewControllerDelegate>
    var containVC: UIViewController


    convenience override init(nibName nibNameOrNil: String!, bundle nibBundleOrNil: NSBundle!) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
                // Custom initialization
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onImageSent:) name:kImageSent object:nil];
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if self.currentImagePath {
            self.preview.image = UIImage.imageWithContentsOfFile(self.currentImagePath)!
        }
    }

    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        self.preview.image = nil
    }

    func generateImagePath() -> String {
        return NSHomeDirectory().stringByAppendingPathComponent("/Documents/\(self.generateImageName()).jpg")
    }

    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        var image: UIImage = info[UIImagePickerControllerEditedImage]
        //[info objectForKey:@"UIImagePickerControllerOriginalImage"];
        if picker.sourceType == .Camera {
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        }
        UIApplication.sharedApplication().statusBarStyle = .LightContent
        self.onImagePicked(image)
        containVC.dismissViewControllerAnimated(true, completion: { _ in })
    }

    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        UIApplication.sharedApplication().statusBarStyle = .LightContent
        containVC.dismissViewControllerAnimated(true, completion: { _ in })
    }

    func onImageSent(notification: NSNotification) {
        self.preview.image = nil
        self.currentImagePath = nil
    }

    func actionSheet(actionSheet: UIActionSheet, clickedButtonAtIndex buttonIndex: Int) {
        switch buttonIndex {
            case 0:
            // From Camera
                if UIImagePickerController.isSourceTypeAvailable(.Camera) {
                    camera = UIImagePickerController()
                    camera.allowsEditing = true
                    camera.sourceType = .Camera
                    if self.isFrontCameraUsed {
                        camera.cameraDevice = .Front
                    }
                    camera.delegate = (self as! protocol<UIImagePickerControllerDelegate, UINavigationControllerDelegate>)
                    camera.modalPresentationStyle = UIModalPresentationFullScreen
                    containVC.presentViewController(camera, animated: true, completion: { _ in })
                }
                else {
                    var alert: UIAlertView = UIAlertView(title: LOCALIZATION("Error"), message: LOCALIZATION("Your device doesn't have a camera"), delegate: nil, cancelButtonTitle: LOCALIZATION("Ok"), otherButtonTitles: "")
                    alert.show()
                }
            case 1:
            // From Photos
                if UIImagePickerController.isSourceTypeAvailable(.PhotoLibrary) {
                    camera = UIImagePickerController()
                    camera.allowsEditing = true
                    camera.sourceType = .PhotoLibrary
                    camera.delegate = (self as! protocol<UIImagePickerControllerDelegate, UINavigationControllerDelegate>)
                    camera.modalPresentationStyle = UIModalPresentationFullScreen
                    camera.mediaTypes = [String(kUTTypeMovie), String(kUTTypeImage)]
                    containVC.presentViewController(camera, animated: true, completion: { _ in })
                }
                else {
                    var alert: UIAlertView = UIAlertView(title: LOCALIZATION("Error"), message: LOCALIZATION("Your device doesn't have a photo library"), delegate: nil, cancelButtonTitle: LOCALIZATION("Ok"), otherButtonTitles: "")
                    alert.show()
                }
            default:
                break
        }

    }
    var camera: UIImagePickerController

}
//
//  KNCameraPickerTemplateViewController.m
//  NUS Technology
//
//  Created by NUS Technology on 6/20/14.
//
//

import MobileCoreServices
import AVFoundation