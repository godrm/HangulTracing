//
//  GameVC.swift
//  HangulTracing
//
//  Created by junwoo on 2017. 11. 11..
//  Copyright © 2017년 samchon. All rights reserved.
//

import UIKit
import CoreMotion
import AVFoundation
import AVKit
import Photos

class GameVC: UIViewController, orientationIsOnlyLandScapeRight {
  
  private(set) var didSetupConstraints = false
  private(set) var playerVC: PlayerVC?
  private(set) var audioPlayer = SoundPlayer()
  private let session = AVCaptureSession()
  private let sessionQueue = DispatchQueue(label: "session queue")
  enum SessionSetupResult {
    case success
    case notAuthorized
    case configurationFailed
  }
  private(set) var setupResult: SessionSetupResult = .success
  private(set) var videoDeviceInput: AVCaptureDeviceInput!
  private(set) var movieFileOutput: AVCaptureMovieFileOutput?
  private(set) var backgroundRecordingID: UIBackgroundTaskIdentifier?
  private(set) var timerLabel: UILabel = {
    let label = UILabel()
    label.textColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
    label.textAlignment = .center
    label.font = label.font.withSize(30)
    return label
  }()
  private(set) var timer: Timer!
  private(set) var seconds = 60
  private(set) var speechSynthesizer: AVSpeechSynthesizer!
  private(set) var blurEffectView: UIVisualEffectView!
  private(set) var motionManager: CMMotionManager!
  private(set) var cardManager: CardManager?
  private(set) var scrollView: UIScrollView = {
    let scrollView = UIScrollView()
    scrollView.showsHorizontalScrollIndicator = false
    scrollView.showsVerticalScrollIndicator = false
    scrollView.isPagingEnabled = true
    scrollView.isScrollEnabled = false
    scrollView.bounces = false
    return scrollView
  }()
  private(set) var startView: GameView!
  private(set) var greatCount: Int!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    UIApplication.shared.isIdleTimerDisabled = true
    requestAVAuth()
    sessionQueue.async {
      self.configureSession()
    }
    setupView()
    setupMotionManager()
    
    view.setNeedsUpdateConstraints()
  }
  
  func setCardManager(manager: CardManager) {
    self.cardManager = manager
  }
  
  func requestAVAuth() {
    switch AVCaptureDevice.authorizationStatus(for: .video) {
    case .authorized:
      break
    case .notDetermined:
      sessionQueue.suspend()
      AVCaptureDevice.requestAccess(for: .video, completionHandler: { granted in
        if !granted {
          self.setupResult = .notAuthorized
        }
        self.sessionQueue.resume()
      })
    default:
      setupResult = .notAuthorized
    }
  }
  
  func setupView() {
    timer = Timer()
    greatCount = 0
    speechSynthesizer = AVSpeechSynthesizer()
    view.backgroundColor = UIColor.white
    view.addSubview(scrollView)
    
    let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
    blurEffectView = UIVisualEffectView(effect: blurEffect)
    blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    view.addSubview(blurEffectView)
    blurEffectView.isHidden = true
    
    startView = GameView(frame: CGRect(), word: "핸드폰을 세워보세요")
    startView.exitBtnDelegate = self
    view.addSubview(startView)
    view.addSubview(timerLabel)
  }
  
  func setupMotionManager() {
    motionManager = CMMotionManager()
    motionManager.deviceMotionUpdateInterval = 1.0 / 60
    if motionManager.isDeviceMotionAvailable {
      motionManager.startDeviceMotionUpdates(to: .main, withHandler: { (motion, error) in
        if error == nil {
          self.handleDeviceMotionUpdate(deviceMotion: motion!)
        }
      })
    }
  }
  
  func degrees(radians:Double) -> Double {
    return -180 / .pi * radians
  }
  
  func handleDeviceMotionUpdate(deviceMotion:CMDeviceMotion) {
    
    let roll = degrees(radians: deviceMotion.attitude.roll)
    if roll <= 95 && roll >= 85 && blurEffectView.isHidden && !startView.isHidden {
      
      startMovieRecording()
      startView.isHidden = true
      audioPlayer.playSoundEffect(name: "whistle", extender: "wav")
      startTimer()
    }
    if roll <= 5.0 && roll >= -5 && blurEffectView.isHidden && startView.isHidden {
      blurEffectView.isHidden = false
      synthesizeSpeech(fromString: "통과")
    }
    if roll <= 95 && roll >= 85 && !blurEffectView.isHidden && startView.isHidden {
      blurEffectView.isHidden = true
      goToNextWords()
    }
    if roll <= 185 && roll >= 175 && blurEffectView.isHidden && startView.isHidden {
      blurEffectView.isHidden = false
      synthesizeSpeech(fromString: "정답")
      greatCount = greatCount + 1
    }
    
  }
  
  func goToNextWords() {
    guard let cardManager = cardManager else { return }
    let page = Int(scrollView.contentOffset.x / scrollView.bounds.size.width)
    if page < cardManager.toDoCount - 1 {
      UIView.animate(withDuration: 0.5, delay: 0, options: UIViewAnimationOptions.curveLinear, animations: {
        self.scrollView.contentOffset.x = self.scrollView.bounds.size.width * CGFloat(page + 1)}, completion: nil)
    } else if page == cardManager.toDoCount - 1 {
      timer.invalidate()
      let scoreView = GameView(frame: CGRect(x: UIScreen.main.bounds.width * CGFloat(cardManager.toDoCount), y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height), word: "\(greatCount!) 점 / \(cardManager.toDoCount) 점")
      scoreView.exitBtnDelegate = self
      scrollView.addSubview(scoreView)
      audioPlayer.playSoundEffect(name: "cheering", extender: "wav")
      UIView.animate(withDuration: 0.5, delay: 0, options: UIViewAnimationOptions.curveLinear, animations: {
        self.scrollView.contentOffset.x = self.scrollView.bounds.size.width * CGFloat(page + 1)}, completion: nil)
      motionManager.stopDeviceMotionUpdates()
      stopMovieRecording()
    }
    
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    inputCardToScrollView()
    
    sessionQueue.async {
      switch self.setupResult {
      case .success:
        self.session.startRunning()
        
      case .notAuthorized:
        DispatchQueue.main.async {
          let changePrivacySetting = "AVCam doesn't have permission to use the camera, please change privacy settings"
          let message = NSLocalizedString(changePrivacySetting, comment: "Alert message when the user has denied access to the camera")
          let alertController = UIAlertController(title: "AVCam", message: message, preferredStyle: .alert)
          
          alertController.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Alert OK button"),
                                                  style: .cancel,
                                                  handler: nil))
          
          alertController.addAction(UIAlertAction(title: NSLocalizedString("Settings", comment: "Alert button to open Settings"),
                                                  style: .`default`,
                                                  handler: { _ in
                                                    UIApplication.shared.open(URL(string: UIApplicationOpenSettingsURLString)!, options: [:], completionHandler: nil)
          }))
          
          self.present(alertController, animated: true, completion: nil)
        }
        
      case .configurationFailed:
        DispatchQueue.main.async {
          let alertMsg = "Alert message when something goes wrong during capture session configuration"
          let message = NSLocalizedString("Unable to capture media", comment: alertMsg)
          let alertController = UIAlertController(title: "AVCam", message: message, preferredStyle: .alert)
          
          alertController.addAction(UIAlertAction(title: NSLocalizedString("OK", comment: "Alert OK button"),
                                                  style: .cancel,
                                                  handler: nil))
          
          self.present(alertController, animated: true, completion: nil)
        }
      }
    }
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    sessionQueue.async {
      if self.setupResult == .success {
        self.session.stopRunning()
      }
    }
    motionManager.stopDeviceMotionUpdates()
    super.viewWillDisappear(animated)
  }
  
  override func updateViewConstraints() {
    if !didSetupConstraints {
      
      guard let cardManager = cardManager else { return }
      
      scrollView.snp.makeConstraints({ (make) in
        make.edges.equalTo(self.view)
      })
      scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width * CGFloat(cardManager.toDoCount), height: UIScreen.main.bounds.height)
      
      blurEffectView.snp.makeConstraints({ (make) in
        make.edges.equalTo(self.view)
      })
      startView.snp.makeConstraints({ (make) in
        make.edges.equalTo(self.view)
      })
      timerLabel.snp.makeConstraints({ (make) in
        make.top.equalTo(self.view).offset(25)
        make.right.equalTo(self.view).offset(-25)
        make.height.equalTo(50)
        make.width.equalTo(100)
      })
      didSetupConstraints = true
    }
    super.updateViewConstraints()
  }
  
  func inputCardToScrollView() {
    guard let cardManager = cardManager else { return }
    let wordsArr: [String] = cardManager.toDoCards.map({ $0.word })
    let shuffledWordsArr = wordsArr.getShuffledArr() as! [String]
    for i in 0..<cardManager.toDoCount {
      let view = GameView(frame: CGRect(x: UIScreen.main.bounds.width * CGFloat(i), y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height), word: shuffledWordsArr[i])
      view.exitBtnDelegate = self
      scrollView.addSubview(view)
    }
  }
  
  func synthesizeSpeech(fromString string:String) {
    let speechUtterence = AVSpeechUtterance(string: string)
    speechSynthesizer.speak(speechUtterence)
  }
  
  func startTimer() {
    timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(GameVC.updateTimer), userInfo: nil, repeats: true)
  }
  
  @objc func updateTimer() {
    seconds -= 1
    timerLabel.text = "\(seconds) 초"
    if seconds <= 3 && seconds > 0 {
      synthesizeSpeech(fromString: "\(seconds)초")
    }
    if seconds == 0 {
      timer.invalidate()
      motionManager.stopDeviceMotionUpdates()
      guard let cardManager = cardManager else { return }
      let scoreView = GameView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height), word: "\(greatCount!) 점 / \(cardManager.toDoCount) 점")
      scoreView.exitBtnDelegate = self
      self.view.addSubview(scoreView)
      audioPlayer.playSoundEffect(name: "cheering", extender: "wav")
      stopMovieRecording()
    }
  }
  
  func configureSession() {
    if setupResult != .success {
      return
    }
    
    sessionQueue.async {
      //카메라 input
      do {
        var defaultVideoDevice: AVCaptureDevice?
        if let frontCameraDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front) {
          defaultVideoDevice = frontCameraDevice
        }
        let videoDeviceInput = try AVCaptureDeviceInput(device: defaultVideoDevice!)
        if self.session.canAddInput(videoDeviceInput) {
          self.session.addInput(videoDeviceInput)
          self.videoDeviceInput = videoDeviceInput
        } else {
          print("Could not add video device input to the session")
          self.setupResult = .configurationFailed
          self.session.commitConfiguration()
          return
        }
      } catch {
        print("Could not create video device input: \(error)")
        self.setupResult = .configurationFailed
        self.session.commitConfiguration()
        return
      }
      
      //오디오 input
      do {
        let audioDevice = AVCaptureDevice.default(for: .audio)
        let audioDeviceInput = try AVCaptureDeviceInput(device: audioDevice!)
        
        if self.session.canAddInput(audioDeviceInput) {
          self.session.addInput(audioDeviceInput)
        } else {
          print("Could not add audio device input to the session")
        }
      } catch {
        print("Could not create audio device input: \(error)")
      }
      
      //output
      let movieFileOutput = AVCaptureMovieFileOutput()
      if self.session.canAddOutput(movieFileOutput) {
        self.session.beginConfiguration()
        self.session.addOutput(movieFileOutput)
        self.session.sessionPreset = .high
        
        if let connection = movieFileOutput.connection(with: .video) {
          if connection.isVideoStabilizationSupported {
            connection.preferredVideoStabilizationMode = .auto
          }
        }
        
        self.session.commitConfiguration()
        self.movieFileOutput = movieFileOutput
      }
    }
  }
  
  func startMovieRecording() {
    guard let movieFileOutput = self.movieFileOutput else {
      return
    }
    
    sessionQueue.async {
      if !movieFileOutput.isRecording {
        if UIDevice.current.isMultitaskingSupported {
          self.backgroundRecordingID = UIApplication.shared.beginBackgroundTask(expirationHandler: nil)
        }
        
        let movieFileOutputConnection = movieFileOutput.connection(with: .video)
        movieFileOutputConnection?.videoOrientation = .landscapeRight
        let availableVideoCodecTypes = movieFileOutput.availableVideoCodecTypes
        if availableVideoCodecTypes.contains(.hevc) {
          movieFileOutput.setOutputSettings([AVVideoCodecKey: AVVideoCodecType.hevc], for: movieFileOutputConnection!)
        }
        
        let outputFileName = NSUUID().uuidString
        let outputFilePath = (NSTemporaryDirectory() as NSString).appendingPathComponent((outputFileName as NSString).appendingPathExtension("mov")!)
        movieFileOutput.startRecording(to: URL(fileURLWithPath: outputFilePath), recordingDelegate: self)
      }
    }
  }
  
  func stopMovieRecording() {
    guard let movieFileOutput = self.movieFileOutput else {
      return
    }
    sessionQueue.async {
      if movieFileOutput.isRecording {
        movieFileOutput.stopRecording()
      }
    }
  }
}

extension GameVC: ExitBtnDelegate {
  func exitBtnTapped(sender: UIButton) {
    if timer != nil {
      timer.invalidate()
    }
    motionManager.stopDeviceMotionUpdates()
    UIApplication.shared.isIdleTimerDisabled = false
    dismiss(animated: true, completion: nil)
  }
}

extension GameVC: AVCaptureFileOutputRecordingDelegate {
  
  func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
    
    func cleanUp() {
      let path = outputFileURL.path
      if FileManager.default.fileExists(atPath: path) {
        do {
          try FileManager.default.removeItem(atPath: path)
        } catch {
          print("Could not remove file at url: \(outputFileURL)")
        }
      }
      
      if let currentBackgroundRecordingID = backgroundRecordingID {
        backgroundRecordingID = UIBackgroundTaskInvalid
        if currentBackgroundRecordingID != UIBackgroundTaskInvalid {
          UIApplication.shared.endBackgroundTask(currentBackgroundRecordingID)
        }
      }
    }
    
    var success = true
    if error != nil {
      print("Movie file finishing error: \(String(describing: error))")
      success = (((error! as NSError).userInfo[AVErrorRecordingSuccessfullyFinishedKey] as AnyObject).boolValue)!
    }
    
    if success {
      PHPhotoLibrary.requestAuthorization { status in
        if status == .authorized {
          PHPhotoLibrary.shared().performChanges({
            let options = PHAssetResourceCreationOptions()
            options.shouldMoveFile = true
            let creationRequest = PHAssetCreationRequest.forAsset()
            creationRequest.addResource(with: .video, fileURL: outputFileURL, options: options)
          }, completionHandler: { success, error in
            if success {
              
              let alertController = UIAlertController(title: "알림", message: "영상이 성공적으로 저장되었습니다", preferredStyle: .alert)
              alertController
                .addAction(UIAlertAction(
                  title: NSLocalizedString("닫기", comment: "Alert OK button"),
                  style: .cancel,
                  handler: nil))
              alertController
                .addAction(UIAlertAction(
                  title: NSLocalizedString("영상보기", comment: "Alert button to open video"),
                  style: .`default`,
                  handler: { _ in
                    
                    self.playVideo()
                    
                }))
              self.present(alertController, animated: true, completion: nil)
            }
            if !success {
              print("Could not save movie to photo library: \(String(describing: error))")
            }
            cleanUp()
          })
        } else {
          cleanUp()
        }
      }
    } else {
      cleanUp()
    }
    
  }
  
  func playVideo() {
    
    let sortOptions = PHFetchOptions()
    let imageManager = PHCachingImageManager()
    
    sortOptions.fetchLimit = 1
    sortOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
    guard let lastVideoAsset = PHAsset.fetchAssets(with: sortOptions).lastObject else { fatalError() }
    imageManager.requestAVAsset(forVideo: lastVideoAsset, options: nil, resultHandler: {(asset: AVAsset?, _: AVAudioMix?, _: [AnyHashable : Any]?) -> Void in
      if let urlAsset = asset as? AVURLAsset {
        DispatchQueue.main.async {
          let localVideoUrl: URL = urlAsset.url as URL
          let player = AVPlayer(url: localVideoUrl)
          self.playerVC = PlayerVC()
          guard let playerVC = self.playerVC else { return }
          playerVC.player = player
          self.present(playerVC, animated: true, completion: {
            playerVC.player?.play()
          })
        }
      }
    })
    
  }
}


