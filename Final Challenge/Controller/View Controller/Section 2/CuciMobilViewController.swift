//
//  Case1ViewController.swift
//  Final Challenge
//
//  Created by Jesse Joseph on 10/11/19.
//  Copyright © 2019 Jesse Joseph. All rights reserved.
//

import UIKit

class StepCaseViewController: UIViewController {

    @IBOutlet var bendaTersedia: [UIView]!
    @IBOutlet var indikatorAngka: [UIImageView]!
    @IBOutlet weak var caseBackground: UIImageView!
    
    var posisiAwalBenda: [CGPoint] = []
    var urutanBenda: [Int] = []
    var counterBenda = 1
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for benda in bendaTersedia{
            addPanView(view: benda)
            let frame:CGRect = benda.frame
            posisiAwalBenda.append(frame.origin)
        }
        // Do any additional setup after loading the view.
    }
    
    func addPanView(view:UIView) {
//        let pan = UIPanGestureRecognizer(target: self, action: #selector(Case1ViewController.handlePan(sender:)))
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.selectedObject(sender:)))
        view.addGestureRecognizer(tap)
    }
    
    @objc func selectedObject(sender: UITapGestureRecognizer) {
        let fileView = sender.view
        if let editIndikatorIndex = fileView?.tag {
            if !urutanBenda.contains(editIndikatorIndex) {
                indikatorAngka[editIndikatorIndex].image = UIImage(named: "urutan\(counterBenda)")
                indikatorAngka[editIndikatorIndex].isHidden = false
                urutanBenda.append(editIndikatorIndex)
                counterBenda+=1
            }
        }
    }
    
    @objc func handlePan(sender:UIPanGestureRecognizer) {
        let fileView = sender.view
        
        switch sender.state {
        case .began,.changed:
            moveViewWithPan(view: fileView!, sender: sender)
            
        case .ended:
            if (fileView?.frame.intersects(caseBackground.frame))! {
                if let editIndikatorIndex = fileView?.tag{
                    if !urutanBenda.contains(editIndikatorIndex){
                        indikatorAngka[editIndikatorIndex].image = UIImage(named: "urutan\(counterBenda)")
                        indikatorAngka[editIndikatorIndex].isHidden = false
                        urutanBenda.append(editIndikatorIndex)
                        counterBenda+=1
                    }
                }
                returnViewToOrigin(view: fileView!)
                
            }else{
                returnViewToOrigin(view: fileView!)
            }
            
        default:
            return
        }
    }
    
    func moveViewWithPan(view:UIView,sender:UIPanGestureRecognizer) {
        let translation = sender.translation(in:view)
        view.center = CGPoint(x: view.center.x+translation.x, y: view.center.y+translation.y)
        sender.setTranslation(CGPoint.zero, in: view)
    }
    
    func deleteView(view:UIView) {
        UIView.animate(withDuration: 0.3) {
            view.alpha = 0
        }
    }
    
    func returnViewToOrigin(view:UIView) {
        UIView.animate(withDuration: 0.3) {
            view.frame.origin = self.posisiAwalBenda[view.tag]
        }
    }
    @IBAction func finishButtonTapped(_ sender: UIButton) {
        print(urutanBenda)
        var score = 0
        var plusScore = 0
        var kunciJawaban:[Int] = []
        var kunciJawaban2:[Int] = []

        if self.title == "caseBanKempes"{
            kunciJawaban = [4,1,2,3,0]
            plusScore = 20
        }else if self.title == "caseCuciMobil"{
            kunciJawaban = [1,0,3,2]
            kunciJawaban2 = [3,0,1,2]
            plusScore = 25
        }
   
        for index in urutanBenda.indices {
            if urutanBenda[index] == kunciJawaban[index]{
                score += plusScore
            }
        }
        
        var score2 = 0
        
        if self.title == "caseCuciMobil" {
            for index in urutanBenda.indices{
                if urutanBenda[index] == kunciJawaban2[index]{
                    score2 += plusScore
                }
            }
        }
        
        print(score)
        print(score2)
        
        if score2>score {
            score = score2
        }
        
        print(score)
//         let currentScore = UserDefaults.standard.integer(forKey: "scoreSection2")
        
        if self.title == "caseBanKempes"{
            UserDefaults.standard.set(score, forKey: "scoreSection2Question1")
            self.performSegue(withIdentifier: "nextContainer", sender: self)
        }else if self.title == "caseCuciMobil"{
            UserDefaults.standard.set(score, forKey: "scoreSection2Question3")
            self.performSegue(withIdentifier: "testSegue3", sender: self)
        }
       
    }
    
    @IBAction func resetButtonTapped(_ sender: UIButton) {
        for indikator in indikatorAngka {
            indikator.isHidden = true
        }
        
        urutanBenda.removeAll()
        counterBenda = 1
    }
    
    @IBAction func toCaseCuciMobil(_ unwindSegue: UIStoryboardSegue) {
    }
}
