//
//  MixingViewController.swift
//  Mandalo
//
//  Created by Robert on 07.09.19.
//  Copyright © 2019 Kevin Schaefer. All rights reserved.
//

import UIKit
import SceneKit

class MixingViewController: UIViewController {

    var requirements: Requirements?

    @IBOutlet weak var continueButton: BigButton!
    private var currentPart = Requirements.Part.allCases.first

    @IBOutlet weak var sceneView: SCNView!

    @IBOutlet weak var instructionHeadlineLabel: UILabel!
    @IBOutlet weak var instructionDetailsLabel: UILabel!

    private var waterNode: SCNNode?
    private var polymerNode: SCNNode?
    private var cementNode: SCNNode?
    private var sandNode: SCNNode?

    private let formatter: MeasurementFormatter = {
        let formatter = MeasurementFormatter()
        formatter.unitOptions = MeasurementFormatter.UnitOptions.naturalScale
        formatter.numberFormatter.maximumFractionDigits = 2
        return formatter
    }()

    private let numberFormatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.percentSymbol = "%"
        formatter.numberStyle = .percent
        return formatter
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        let rootNode = sceneView.scene?.rootNode
        waterNode = rootNode?.childNode(withName: "water", recursively: false)
        polymerNode = rootNode?.childNode(withName: "polymer", recursively: false)
        cementNode = rootNode?.childNode(withName: "cement", recursively: false)
        sandNode = rootNode?.childNode(withName: "sand", recursively: false)

        waterNode?.isHidden = true
        polymerNode?.isHidden = true
        cementNode?.isHidden = true
        sandNode?.isHidden = true

        setPivotsAndSizesToZero()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setText()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        startAnimatingAddingPart()
    }

    private func updateCurrentPart() {
        guard let currentPart = self.currentPart
            else { return }

        guard let index = Requirements.Part.allCases.firstIndex(of: currentPart), index + 1 != Requirements.Part.allCases.endIndex
            else { self.currentPart = nil; return }

        self.currentPart = Requirements.Part.allCases[index + 1]
    }

    private func updateViews(for percentageDone: Double) {
        guard let currentPart = self.currentPart
            else { return }

        let node: SCNNode?

        switch currentPart {
        case .sand:
            node = self.sandNode
        case .cement:
            node = self.cementNode
        case .polymer:
            node = self.polymerNode
        case .water:
            node = self.waterNode
        }

        node?.isHidden = false
        self.setNodeGeometry(geometry: node?.geometry, node: node, percentageDone: percentageDone, currentPart: currentPart)
    }

    private func setNodeGeometry(geometry: SCNGeometry?, node: SCNNode?, percentageDone: Double, currentPart: Requirements.Part) {
        guard let cylinder = geometry as? SCNCylinder
            else { return }

        let fullHeight: CGFloat

        switch currentPart {
        case .sand:
            fullHeight = 0.4
        case .cement:
            fullHeight = 0.6
        case .polymer:
            fullHeight = 0.1
        case .water:
            fullHeight = 0.5
        }

        SCNTransaction.begin()
        SCNTransaction.animationDuration = 0.2
        let newHeight = CGFloat(min(percentageDone, 1)) * fullHeight
        let delta = newHeight - cylinder.height
        cylinder.height = newHeight
        node?.position.y += Float(delta) / 2
        SCNTransaction.commit()
    }

    private func setPivotsAndSizesToZero() {
        func setGeometryHeightToZero(node: SCNNode?) {
            guard let cylinder = node?.geometry as? SCNCylinder
                else { return }
            let fullHeight = cylinder.height
            cylinder.height = 0
            node?.position.y -= Float(fullHeight) / 2
        }

        setGeometryHeightToZero(node: self.waterNode)
        setGeometryHeightToZero(node: self.cementNode)
        setGeometryHeightToZero(node: self.polymerNode)
        setGeometryHeightToZero(node: self.sandNode)
    }

    private func startAnimatingAddingPart() {

        guard let part = self.currentPart
            else { return }

        let node: SCNNode?

        switch part {
        case .sand:
            node = self.sandNode
        case .polymer:
            node = self.polymerNode
        case .water:
            node = self.waterNode
        case .cement:
            node = self.cementNode
        }

        node?.isHidden = false
        setNodeGeometry(geometry: node?.geometry, node: node, percentageDone: 1.0, currentPart: part)
    }
    
    @IBAction func didTapContinueButton(_ sender: UIButton) {

        self.updateCurrentPart()

        if self.currentPart == nil {
            self.performSegue(withIdentifier: "showTilingSegue", sender: nil)
        } else {
            startAnimatingAddingPart()
            setText()

            if currentPart == .water {
                sender.setTitle("Start Tiling!", for: .normal)
            }
        }
    }

    private func setText() {
        guard let currentPart = self.currentPart, let requirements = self.requirements
            else { return }

        let measurement: Measurement<UnitMass>

        switch currentPart {
        case .cement: measurement = requirements.cement
        case .polymer: measurement = requirements.polymer
        case .water: measurement = requirements.water
        case .sand: measurement = requirements.sand
        }

        self.instructionHeadlineLabel.text = "Add \(formatter.string(from: measurement)) of \(currentPart.rawValue)"
        self.instructionDetailsLabel.text = "Slowly add \(formatter.string(from: measurement)) of \(currentPart.rawValue) and stir the result for a good while to reach perfect viscosity."
        self.continueButton.setTitle(currentPart != .water ? "Continue" : "Start Tiling!", for: .normal)
    }
}
