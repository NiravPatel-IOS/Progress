//
//  CircularProgressBar.swift
//  Progress
//
//  Created by NiravPatel on 12/06/19.
//  Copyright © 2019 NiravPatel. All rights reserved.
//

import UIKit


class CircularProgressBar: UIView {
    
    var currentTime:Double = 0
    var previousProgress:Double = 0
    
    //MARK: awakeFromNib
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
        label.text = "0"
        labelPercent.text = "%"
        labelComplete.text = "complete"
    }
    
    
    //MARK: Public
    
    public var lineWidth:CGFloat = 15 {
        didSet{
            foregroundLayer.lineWidth = lineWidth
            backgroundLayer.lineWidth = lineWidth - (0.20 * lineWidth)
        }
    }
    
    public var labelSize: CGFloat = 30 {
        didSet {
            label.font = UIFont.systemFont(ofSize: labelSize)
            label.sizeToFit()
            configLabel()
        }
    }
    
    public var labelPercentSize: CGFloat = 10 {
        didSet {
            labelPercent.font = UIFont.systemFont(ofSize: labelPercentSize)
            labelPercent.sizeToFit()
            configLabelPercent()
        }
    }
    
    public var labelCompleteSize: CGFloat = 10 {
        didSet {
            labelComplete.font = UIFont.systemFont(ofSize: labelCompleteSize)
            labelComplete.sizeToFit()
            configLabelComplete()
        }
    }
    
    public var safePercent: Int = 100 {
        didSet{
            setForegroundLayerColorForSafePercent()
        }
    }
    
    public func setProgress(to progressConstant: Double, withAnimation: Bool) {
        
        var progress: Double {
            get {
                if progressConstant > 1 { return 1 }
                else if progressConstant < 0 { return 0 }
                else { return progressConstant }
            }
        }
        
        foregroundLayer.strokeEnd = CGFloat(progress)
        
        if withAnimation {
            let animation = CABasicAnimation(keyPath: "strokeEnd")
            animation.fromValue = previousProgress
            animation.toValue = progress
            animation.duration = 2
            foregroundLayer.add(animation, forKey: "foregroundAnimation")
            
        }
        
        
        previousProgress = progress
        currentTime = 0
        
        DispatchQueue.main.async {
            self.label.text = "\(Int(progress * 100))"
            self.setForegroundLayerColorForSafePercent()
            self.configLabel()
            self.configLabelPercent()
            self.configLabelComplete()
        }
        
        /*let context = ["progress" : progress]
        let timer = Timer.scheduledTimer(timeInterval: 0.05, target: self, selector: #selector(updateProgress), userInfo: context, repeats: true)
        //timer.fire()
        RunLoop.main.add(timer, forMode: .common)*/
    }
    
    /*@objc func updateProgress(timer: Timer) {
        guard let context = timer.userInfo as? [String: Double] else { return }
        let progress : Double = context["progress"]!
        
        DispatchQueue.main.async {
            print(self.currentTime)
            if self.currentTime >= 2{
                timer.invalidate()
            } else {
                self.currentTime += 0.05
                let percent = self.currentTime/2 * 100
                
                self.label.text = "\(Int(progress * percent))"
                self.setForegroundLayerColorForSafePercent()
                self.configLabel()
                self.configLabelPercent()
                self.configLabelComplete()
            }
        }
    }*/    
    
    
    //MARK: Private
    private var label = UILabel()
    private var labelPercent = UILabel()
    private var labelComplete = UILabel()
    private let foregroundLayer = CAShapeLayer()
    private let backgroundLayer = CAShapeLayer()
    private let pulsatingLayer = CAShapeLayer()
    private var radius: CGFloat {
        get{
            if self.frame.width < self.frame.height { return (self.frame.width - lineWidth)/2 }
            else { return (self.frame.height - lineWidth)/2 }
        }
    }
    
    private var pathCenter: CGPoint{ get{ return self.convert(self.center, from:self.superview) } }
    private func makeBar(){
        self.layer.sublayers = nil
        drawPulsatingLayer()
        self.animatePulsatingLayer()
        drawBackgroundLayer()
        drawForegroundLayer()
    }
    
    private func drawBackgroundLayer(){
        let path = UIBezierPath(arcCenter: pathCenter, radius: self.radius, startAngle: 0, endAngle: 2*CGFloat.pi, clockwise: true)
        self.backgroundLayer.path = path.cgPath
        self.backgroundLayer.strokeColor = UIColor(red: 155.0/255.0, green: 134.0/255.0, blue: 223.0/255.0, alpha: 1.0).cgColor
        self.backgroundLayer.lineWidth = lineWidth
        self.backgroundLayer.fillColor = UIColor.white.cgColor
        self.layer.addSublayer(backgroundLayer)
        
    }
    
    private func drawForegroundLayer(){
        
        let startAngle = (-CGFloat.pi/2)
        let endAngle = 2 * CGFloat.pi + startAngle
        
        let path = UIBezierPath(arcCenter: pathCenter, radius: self.radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
        
        foregroundLayer.lineCap = CAShapeLayerLineCap.round
        foregroundLayer.path = path.cgPath
        foregroundLayer.lineWidth = lineWidth
        foregroundLayer.fillColor = UIColor.clear.cgColor
        foregroundLayer.strokeColor = UIColor(red: 36.0/255.0, green: 22.0/255.0, blue: 84.0/255.0, alpha: 1.0).cgColor
        foregroundLayer.strokeEnd = 0
        
        self.layer.addSublayer(foregroundLayer)
        
    }
    
    private func drawPulsatingLayer() {
        let circularPath = UIBezierPath(arcCenter: .zero, radius: self.radius, startAngle: 0, endAngle: 2*CGFloat.pi, clockwise: true)
        pulsatingLayer.path = circularPath.cgPath
        pulsatingLayer.strokeColor = UIColor.clear.cgColor
        pulsatingLayer.lineWidth = lineWidth
        pulsatingLayer.fillColor = UIColor(red: 155.0/255.0, green: 134.0/255.0, blue: 223.0/255.0, alpha: 0.6).cgColor
        pulsatingLayer.lineCap = CAShapeLayerLineCap.round
        pulsatingLayer.position = pathCenter
        self.layer.addSublayer(pulsatingLayer)
    }
    
    private func animatePulsatingLayer() {
        let animation = CABasicAnimation(keyPath: "transform.scale")
        
        animation.toValue = 1.3
        animation.duration = 0.8
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeOut)
        animation.autoreverses = true
        animation.repeatCount = Float.infinity
        
        pulsatingLayer.add(animation, forKey: "pulsing")
    }
    
    private func makeLabel(withText text: String) -> UILabel {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        label.text = text
        label.font = UIFont.systemFont(ofSize: labelSize)
        label.sizeToFit()
        label.center = CGPoint(x: pathCenter.x, y: pathCenter.y - 10)
        return label
    }
    
    private func makeLabelPercent(withText text: String) -> UILabel {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        label.text = text
        label.font = UIFont.systemFont(ofSize: labelPercentSize)
        label.sizeToFit()
        label.textColor = UIColor.lightGray
        label.center = CGPoint(x: pathCenter.x + (label.frame.size.width/2) + 10, y: pathCenter.y - 15)
        return label
    }
    
    private func makeLabelComplete(withText text: String) -> UILabel {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        label.text = text
        label.font = UIFont.systemFont(ofSize: labelCompleteSize)
        label.sizeToFit()
        label.textColor = UIColor.lightGray
        label.center = CGPoint(x: pathCenter.x, y: pathCenter.y + (label.frame.size.height/2))
        return label
    }
    
    private func configLabel(){
        label.textColor = UIColor(red: 36.0/255.0, green: 22.0/255.0, blue: 84.0/255.0, alpha: 1.0)
        label.sizeToFit()
        label.center = CGPoint(x: pathCenter.x, y: pathCenter.y - 10)
    }
    
    private func configLabelPercent(){
        labelPercent.textColor = UIColor(red: 36.0/255.0, green: 22.0/255.0, blue: 84.0/255.0, alpha: 0.4)
        labelPercent.sizeToFit()
        labelPercent.center = CGPoint(x: pathCenter.x + (label.frame.size.width/2) + 10, y: pathCenter.y - 15)
    }
    
    private func configLabelComplete(){
        labelComplete.textColor = UIColor(red: 36.0/255.0, green: 22.0/255.0, blue: 84.0/255.0, alpha: 1.0)
        labelComplete.sizeToFit()
        labelComplete.center = CGPoint(x: pathCenter.x, y: pathCenter.y + (label.frame.size.height/2))
    }
    
    private func setForegroundLayerColorForSafePercent(){
        
        self.foregroundLayer.strokeColor = UIColor(red: 36.0/255.0, green: 22.0/255.0, blue: 84.0/255.0, alpha: 1.0).cgColor
    }
    
    private func setupView() {
        makeBar()
        self.addSubview(label)
        self.addSubview(labelPercent)
        self.addSubview(labelComplete)
    }
    
    
    
    //Layout Sublayers

    private var layoutDone = false
    override func layoutSublayers(of layer: CALayer) {
        if !layoutDone {
            let tempText = label.text
            setupView()
            label.text = tempText
            layoutDone = true
        }
    }
}
