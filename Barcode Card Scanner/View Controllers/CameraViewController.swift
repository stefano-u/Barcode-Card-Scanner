/*
 Description: This allows the user to scan a barcode using their camera
 Author: Stefano Gregor Unlayao
 Date: 2018-12-09
 */

import UIKit
import AVFoundation

class CameraViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    // Properties
    @IBOutlet weak var imgView: UIImageView!       // Shows the barcode overlay on the scanner
    var session: AVCaptureSession!                 // Manages data from the camera (manages capture activity)
    var previewLayer: AVCaptureVideoPreviewLayer?  // Displays video as it is being captured by an input device
    var soundEffects = SoundEffect(0)              // Used for playing sound effects
    var newCard = Card()
    
    // Initializes the barcode scanner and sound effects when the view loads
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Sets the capture device (the physical device + properties)
        guard let videoCaptureDevice = AVCaptureDevice.default(for: AVMediaType.video) else {
            // If the device cannot use the camera, then it will show an alert and move back to the previous view controller
            self.navigationController?.popViewController(animated: true)
            let message = "This device is not supported to use the camera."
            let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
            let closeAction = UIAlertAction(title: "Close", style: .cancel, handler: nil)
            alert.addAction(closeAction)
            present(alert, animated: true)
            return
        }
        // Initializes the capture session object
        session = AVCaptureSession()
        session.startRunning()
        
        // Sets the video input (captures data from the input device)
        let videoInput: AVCaptureDeviceInput?
    
        do {
            // Initializes the device input with the capture device
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        
            // Add input to the session
            if let videoInputUnwrapped = videoInput ?? nil {
                session.addInput(videoInputUnwrapped)
            }
            
            // Creates an output object
            let metadataOutput = AVCaptureMetadataOutput()
            
            // Adds ouptput to the session
            session.addOutput(metadataOutput)
            
            // Sends captured data to the delgate object via a serial queue
            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            
            // Sets the type of barcodes to scan (these are normally the type for cards)
            metadataOutput.metadataObjectTypes = [.code39, .code128, .code93, .ean13, .ean8]
            
            // Initializes the previewLayer and displays the video data
            previewLayer = AVCaptureVideoPreviewLayer(session: session)
            previewLayer?.frame = view.layer.bounds
            previewLayer?.videoGravity = AVLayerVideoGravity.resizeAspectFill
            
            // Adds the unwrapped previewLayer onto the screen
            if let previewLayerUnwrap = previewLayer {
                view.layer.addSublayer(previewLayerUnwrap)
                view.layer.insertSublayer(previewLayerUnwrap, below: imgView.layer)
            }
            
            // Shows the fake barcode image on the screen
            imgView.isHidden = false
            
            // Starts the capture session
            session.startRunning()
        } catch {
            // Pops this view controller and displays an alert if an error occurs
            self.navigationController?.popViewController(animated: true)
            let message = "An error has occured."
            let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
            let closeAction = UIAlertAction(title: "Close", style: .cancel, handler: nil)
            alert.addAction(closeAction)
            present(alert, animated: true)
            session.stopRunning()
        }
    }
    // Informs the delegate that the capture output object emitted new metadata objects.
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        // Get the first object from the metadataObjects array
        let barcodeData = metadataObjects.first
        
        // Turn it into machine readable code
        guard let barcodeReadable = barcodeData as? AVMetadataMachineReadableCodeObject else {
            return
        }
        
        // Sends the barcode as a string
        if let barcodeStringValue = barcodeReadable.stringValue {
            barcodeDetected(code: barcodeStringValue)
        }
    }
    
    // Shows an alert that the barcode has been detected
    func barcodeDetected(code: String){
        var alert: UIAlertController
        var continueAction: UIAlertAction
        
        // If it is a non-custom card, then it will only ask the user to confirm the results
        // For custom cards, the user is prompted for a name
        if newCard.getCardOption() != "Custom Card" {
            let message = "Code: " + code + "\n\n Do you want to submit this " + newCard.getCardOption() + " card?"
            alert = UIAlertController(title: "Barcode Found", message: message, preferredStyle: .alert)
            
            continueAction = UIAlertAction(title: "Yes", style: .default, handler: {
                (alertAction:UIAlertAction) in
                // Sets the card number
                self.newCard.setCardNum(num: code)
                
                // Unwinds to the home view
                self.navigationController?.popToRootViewController(animated: true)
                
                // Shows an alert to indicate success
                let message = "The card has been added successfully!"
                let alert = UIAlertController(title: "Success", message: message, preferredStyle: .alert)
                let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alert.addAction(okAction)
                self.present(alert, animated: true)
            })
        
        } else {
            alert = UIAlertController(title: "Barcode Found", message: "Code: " + code + "\n\n Please enter a card name:", preferredStyle: .alert)
            
            // Adds a text field for card name when the alert pops up
            alert.addTextField { (textField) in
                textField.placeholder = "Insert card name"
            }
            
            continueAction = UIAlertAction(title: "Continue", style: .default, handler: {
                (alertAction:UIAlertAction) in
                
                // Retrieves the previously added textfield (first one) in the alert and get its value
                guard let alertTextField = alert.textFields?[0], let cardNameInput = alertTextField.text else {
                    return
                }
                
                // Sets the card's number and name, then returns to the Home view
                if !cardNameInput.isEmpty {
                    self.newCard.setCardName(name: cardNameInput)
                    self.newCard.setCardNum(num: code)
                    
                    // Unwinds to the home view
                    self.navigationController?.popToRootViewController(animated: true)
                    
                    // Shows an alert to indicate success
                    let message = "The card has been added successfully!"
                    let alert = UIAlertController(title: "Success", message: message, preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alert.addAction(okAction)
                    self.present(alert, animated: true)
                } else {
                    // If the text field is empty, then the alert will be shown again
                    self.soundEffects.setSoundEffect(resourceName: "Error")
                    self.soundEffects.play()
                    self.present(alert, animated: true)
                }
            })
        }
        
        // Starts the barcode/camera again when exit is pressed
        let cancelAction = UIAlertAction(title: "Exit", style: .default, handler: {
            (alertAction:UIAlertAction) in
            self.session.startRunning()
        })
        
        // Displays the alert message
        alert.addAction(continueAction)
        alert.addAction(cancelAction)
        present(alert, animated: true)
        
        // If alert is shown, then play the sound effect and stop the camera running in the background
        if alert.isBeingPresented{
            // Initializes sound effect to play the "BarcodeFound" mp3 file
            self.soundEffects.setSoundEffect(resourceName: "BarcodeFound")
            self.soundEffects.play()
            session.stopRunning()
        }
    }
}
