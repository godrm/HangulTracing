//
//  CameraVC.swift
//  HangulTracing
//
//  Created by junwoo on 2017. 11. 8..
//  Copyright © 2017년 samchon. All rights reserved.
//

import UIKit
import AVFoundation

class CameraVC: UIViewController {
  
  var didSetupConstraints = false
  var captureSession: AVCaptureSession!
  var cameraOutput: AVCapturePhotoOutput!
  var previewLayer: AVCaptureVideoPreviewLayer!
  var photoData: Data?
  var cameraView: UIView = {
    let view = UIView()
    return view
  }()
  var capturedImgView: UIImageView = {
    let imgView = UIImageView()
    imgView.backgroundColor = UIColor(hex: "1EC545")
    imgView.layer.cornerRadius = 15
    imgView.clipsToBounds = true
    return imgView
  }()
  var saveBtn: UIButton = {
    let btn = UIButton()
    btn.backgroundColor = #colorLiteral(red: 0.9994240403, green: 0.3548831371, blue: 0.08110601978, alpha: 1)
    btn.setTitle("SAVE", for: .normal)
    btn.layer.cornerRadius = 15
    return btn
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.addSubview(cameraView)
    view.addSubview(capturedImgView)
    view.addSubview(saveBtn)
    saveBtn.isHidden = true
    saveBtn.addTarget(self, action: #selector(CameraVC.saveBtnTapped(_:)), for: .touchUpInside)
    view.setNeedsUpdateConstraints()
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    previewLayer.frame = cameraView.bounds
  }
  
  override func updateViewConstraints() {
    if !didSetupConstraints {
      
      cameraView.snp.makeConstraints({ (make) in
        make.edges.equalTo(self.view)
      })
      capturedImgView.snp.makeConstraints({ (make) in
        make.right.bottom.equalTo(self.view).offset(-20)
        make.height.equalTo(128)
        make.width.equalTo(75)
      })
      saveBtn.snp.makeConstraints({ (make) in
        make.height.equalTo(50)
        make.width.equalTo(75)
        make.top.equalTo(self.view).offset(20)
        make.right.equalTo(self.view).offset(-20)
      })
      didSetupConstraints = true
    }
    super.updateViewConstraints()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    
    let tap = UITapGestureRecognizer(target: self, action: #selector(didTapCameraView))
    tap.numberOfTapsRequired = 1
    
    captureSession = AVCaptureSession()
    captureSession.sessionPreset = AVCaptureSession.Preset.hd1920x1080
    let backCamera = AVCaptureDevice.default(for: AVMediaType.video)
    
    do {
      //input
      let input = try AVCaptureDeviceInput(device: backCamera!)
      if captureSession.canAddInput(input) {
        captureSession.addInput(input)
      }
      
      //output
      cameraOutput = AVCapturePhotoOutput()
      if captureSession.canAddOutput(cameraOutput) {
        captureSession.addOutput(cameraOutput)
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        //aspect ratio
        previewLayer.videoGravity = AVLayerVideoGravity.resizeAspect
        previewLayer.connection?.videoOrientation = AVCaptureVideoOrientation.portrait
        cameraView.layer.addSublayer(previewLayer)
        cameraView.addGestureRecognizer(tap)
        captureSession.startRunning()
      }
    } catch {
      debugPrint("could not setup camera :", error.localizedDescription)
    }
  }
  
  @objc func didTapCameraView() {
    cameraView.isUserInteractionEnabled = false
    
    let settings = AVCapturePhotoSettings()
    settings.previewPhotoFormat = settings.embeddedThumbnailPhotoFormat
    cameraOutput.capturePhoto(with: settings, delegate: self)
  }
  
  @objc func saveBtnTapped(_ sender: UITapGestureRecognizer) {
    if capturedImgView.image != nil {
      NotificationCenter.default.post(name: Constants().NOTI_PHOTO_SELECTED, object: nil, userInfo: ["photoData":photoData])
      dismiss(animated: true, completion: nil)
    }
    
  }
}

extension CameraVC: AVCapturePhotoCaptureDelegate {
  func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
    if let error = error {
      debugPrint(error)
    } else {
      photoData = photo.fileDataRepresentation()
      let image = UIImage(data: photoData!)
      self.capturedImgView.image = image
      cameraView.isUserInteractionEnabled = true
      saveBtn.isHidden = false
    }
  }
}
