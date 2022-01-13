//
//  ViewController.swift
//  SystemViewControllers
//
//  Created by Lyubomir Lazarov on 8/26/21.
//

import UIKit
import SafariServices
import MessageUI

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, MFMailComposeViewControllerDelegate, MFMessageComposeViewControllerDelegate {

    @IBOutlet var imageView: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func shareButtonTapped(_ sender: UIButton) {
        guard let image = imageView.image else {return}
        
        let activityController = UIActivityViewController(activityItems: [image], applicationActivities: nil)
        activityController.popoverPresentationController?.sourceView = sender
        present(activityController, animated: true, completion: nil)
    }
    @IBAction func safariButtonTapped(_ sender: Any) {
        if let url = URL(string: "http://www.apple.com") {
            let safariViewController = SFSafariViewController(url: url)
            present(safariViewController, animated: true, completion: nil)
        }
    }
    @IBAction func cameraButtonTapped(_ sender: UIButton) {
        
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        
        let alertController = UIAlertController(title: "Choose Image Source", message: nil, preferredStyle: .actionSheet)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(cancelAction)
        
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            let cameraAction = UIAlertAction(title: "Camera", style: .default) { action in
                print("User selected Camera action")
                imagePicker.sourceType = .camera
                self.present(imagePicker, animated: true, completion: nil)
            }
            alertController.addAction(cameraAction)
        }
        
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let photoLibraryAction = UIAlertAction(title: "Photo Library", style: .default) { action in
                print("User selected Photo Library action")
                imagePicker.sourceType = .photoLibrary
                self.present(imagePicker, animated: true, completion: nil)
            }
            alertController.addAction(photoLibraryAction)
        }
        
        alertController.popoverPresentationController?.sourceView = sender
        
        present(alertController, animated: true, completion: nil)
        
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard  let selectedImage = info[.originalImage] as? UIImage else { return }
        
        imageView.image = selectedImage
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func emailButtonTapped(_ sender: UIButton) {
        guard MFMailComposeViewController.canSendMail() else {
            print("Can not send mail")
            return
        }
        let mailComposer = MFMailComposeViewController()
        mailComposer.delegate = self
        
        mailComposer.setToRecipients(["lyubomir.lazarov@icloud.com", "s.lazarova@live.uni-vt.bg"])
        mailComposer.setSubject("Look at this")
        mailComposer.setMessageBody("This e-mail was sent from an app I made!", isHTML: false)
        
        if let image = imageView.image, let jpegData = image.jpegData(compressionQuality: 0.9) {
            mailComposer.addAttachmentData(jpegData, mimeType: "image/jpeg", fileName: "photo.jpg")
        }
        
        present(mailComposer, animated: true, completion: nil)
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        //print(result)
        controller.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func iMessageButtonTapped(_ sender: UIButton) {
        guard MFMessageComposeViewController.canSendText() else {
            print("Message services are not available")
            return
        }
        guard MFMessageComposeViewController.canSendAttachments() else {
            print("Your device is not configured to send attachments")
            return
        }
        
        let messageComoser = MFMessageComposeViewController()
        messageComoser.messageComposeDelegate = self
        
        messageComoser.recipients = ["0889742768"]
        messageComoser.body = "This message was sent from an app I made!"
        
        present(messageComoser, animated: true, completion: nil)
    }
    
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        print(result)
        controller.dismiss(animated: true, completion: nil)
    }
    
}

