/*
 Description: This allows the application to access the camera & image picker to select photos
 Author: Michael Marc
 Date: 2018-12-09
 */

import MobileCoreServices
import UIKit

class CameraHandler: NSObject {
    // Properties
    private let imagePicker = UIImagePickerController()                                                       // Use to select images on device
    private let isPhotoLibraryAvailable = UIImagePickerController.isSourceTypeAvailable(.photoLibrary)        // Check if photo library is available on device
    private let isSavedPhotoAlbumAvailable = UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum) // Check if saved photos is available on device
    private let isCameraAvailable = UIImagePickerController.isSourceTypeAvailable(.camera)                    // Check to see if camera is available on device
    private let isRearCameraAvailable = UIImagePickerController.isCameraDeviceAvailable(.rear)                // Check if the rear camera is available
    private let isFrontCameraAvailable = UIImagePickerController.isCameraDeviceAvailable(.front)              // Check if the front camera is available
    private let sourceTypeCamera = UIImagePickerController.SourceType.camera                                  // Use to switch to camera view
    private let rearCamera = UIImagePickerController.CameraDevice.rear                                        // Use to switch to the rear camera
    private let frontCamera = UIImagePickerController.CameraDevice.front                                      // User to switch to the front camera
    private var delegate: UINavigationControllerDelegate & UIImagePickerControllerDelegate                            // Delegate
    
    // Initializes the delegate
    init(delegate: UINavigationControllerDelegate & UIImagePickerControllerDelegate) {
        self.delegate = delegate
    }
    
    // Enables device to go to the photo galery view and select a photo to be used
    func getPhotoLibraryOn(_ onVC: UIViewController, canEdit: Bool) {
        
        // Returns (exits) when photo library and saved photos album is not working
        if isPhotoLibraryAvailable || isSavedPhotoAlbumAvailable {
            
            // Type identifier for image data
            let type = kUTTypeImage as String
            
            if isPhotoLibraryAvailable {
                // Specifies the device’s photo library as the source for the image picker controller
                imagePicker.sourceType = .photoLibrary
                let availableTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)
                if availableTypes?.contains(type) ?? false {
                    imagePicker.mediaTypes = [type]
                }
            }
            else if isSavedPhotoAlbumAvailable {
                // Specifies the device’s Camera Roll album as the source for the image picker controller
                imagePicker.sourceType = .savedPhotosAlbum
                let availableTypes = UIImagePickerController.availableMediaTypes(for: .savedPhotosAlbum)
                if availableTypes?.contains(type) ?? false {
                    imagePicker.mediaTypes = [type]
                }
            }
            
            // Allow user to edit image after it has been taken from the camera
            imagePicker.allowsEditing = canEdit
            
            // Connects delegate to the image picker controller
            imagePicker.delegate = delegate
            
            // Shows the image picker
            onVC.present(imagePicker, animated: true, completion: nil)
        } else {
            // Displays an alert if the device does not support the photo library
            let alert = UIAlertController(title: "Error", message: "This device is incompatible to access the photo library", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
            alert.addAction(okAction)
            onVC.present(alert, animated: true)
        }
    }
    
    // Enables device to access the camera and take an image and return the image
    func getCameraOn(_ onVC: UIViewController, canEdit: Bool) {
        
        // Check if camera is available to use
        if isCameraAvailable {
            // Type identifier for image data
            let type = kUTTypeImage as String
            
            //  Checks the media types for the camera (ex. video recording, etc.)
            let availableTypes = UIImagePickerController.availableMediaTypes(for: .camera)
            if availableTypes?.contains(type) ?? false {
                imagePicker.mediaTypes = [type]
                imagePicker.sourceType = sourceTypeCamera
            }
                
            // If the rear camera is available, use it, else use the front camera
            if isRearCameraAvailable {
                imagePicker.cameraDevice = rearCamera
            } else if isFrontCameraAvailable {
                imagePicker.cameraDevice = frontCamera
            }
    
            // Allow user to edit image after it has been taken fomr the camera
            imagePicker.allowsEditing = canEdit
            
            // Show controls of the camera
            imagePicker.showsCameraControls = true
            
            // Connects delegate to the image picker controller
            imagePicker.delegate = delegate
            
            // Shows the image picker
            onVC.present(imagePicker, animated: true, completion: nil)
        } else {
            // Displays an alert if the device does not support taking pictures
            let alert = UIAlertController(title: "Error", message: "This device is incompatible to take pictures", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
            alert.addAction(okAction)
            onVC.present(alert, animated: true)
        }
    }
}
