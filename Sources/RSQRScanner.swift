//
//  RSQRScanner.swift
//
//  Created by Radu Ursache on 13.05.2021.
//  v1.0
//

import AVFoundation
import UIKit

@available(iOS 10.0, macCatalyst 14.0, *)
public class RSQRScannerViewController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
	private var captureSession: AVCaptureSession!
	private var previewLayer: AVCaptureVideoPreviewLayer!
	
	public var scanResult: ((String) -> Void)?
	public var failedInit: (() -> Void)?

	public override func viewDidLoad() {
		super.viewDidLoad()

		self.view.backgroundColor = .black
		self.captureSession = AVCaptureSession()

		guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return }
		let videoInput: AVCaptureDeviceInput

		do {
			videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
		} catch {
			return
		}

		if self.captureSession.canAddInput(videoInput) {
			self.captureSession.addInput(videoInput)
		} else {
			self.failed()
			return
		}

		let metadataOutput = AVCaptureMetadataOutput()

		if self.captureSession.canAddOutput(metadataOutput) {
			self.captureSession.addOutput(metadataOutput)

			metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
			metadataOutput.metadataObjectTypes = [.qr]
		} else {
			self.failed()
			return
		}

		self.previewLayer = AVCaptureVideoPreviewLayer(session: self.captureSession)
		self.previewLayer.frame = self.view.layer.bounds
		self.previewLayer.videoGravity = .resizeAspectFill
		self.view.layer.addSublayer(self.previewLayer)

		self.captureSession.startRunning()
	}

	private func failed() {
		self.captureSession = nil
		self.failedInit?()
	}

	public override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)

		if self.captureSession?.isRunning == false {
			self.captureSession.startRunning()
		}
	}

	public override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)

		if self.captureSession?.isRunning == true {
			self.captureSession.stopRunning()
		}
	}

	public func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
		self.captureSession.stopRunning()

		if let metadataObject = metadataObjects.first {
			guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
			guard let stringValue = readableObject.stringValue else { return }
			AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
			self.found(code: stringValue)
		}

		dismiss(animated: true)
	}

	private func found(code: String) {
		self.scanResult?(code)
	}

	public override var prefersStatusBarHidden: Bool {
		return true
	}

	public override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
		return .portrait
	}
}
