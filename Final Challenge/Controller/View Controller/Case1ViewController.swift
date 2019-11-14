//
//  Case1ViewController.swift
//  Final Challenge
//
//  Created by Jesse Joseph on 10/11/19.
//  Copyright © 2019 Jesse Joseph. All rights reserved.
//

import UIKit

class Case1ViewController: UIViewController {

    
    @IBOutlet var bendaTersedia: [UIView]!
    @IBOutlet var indikatorAngka: [UIImageView]!
    @IBOutlet weak var caseBackground: UIImageView!
    
    var posisiAwalBenda:[CGPoint] = []
    var urutanBenda:[Int]=[]
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
    
    func addPanView(view:UIView){
        let pan = UIPanGestureRecognizer(target: self, action: #selector(Case1ViewController.handlePan(sender:)))
        let tap = UITapGestureRecognizer(target: self, action: #selector(Case1ViewController.selectedObject(sender:)))
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
    
    @objc func handlePan(sender:UIPanGestureRecognizer){
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
    
    func moveViewWithPan(view:UIView,sender:UIPanGestureRecognizer){
        let translation = sender.translation(in:view)
        view.center = CGPoint(x: view.center.x+translation.x, y: view.center.y+translation.y)
        sender.setTranslation(CGPoint.zero, in: view)
    }
    
    func deleteView(view:UIView){
        UIView.animate(withDuration: 0.3) {
            view.alpha = 0
        }
    }
    
    func returnViewToOrigin(view:UIView){
        UIView.animate(withDuration: 0.3) {
            view.frame.origin = self.posisiAwalBenda[view.tag]
        }
    }
    @IBAction func finishButtonTapped(_ sender: UIButton) {
        print(urutanBenda)
        var score = 0
        var kunciJawaban:[Int] = []

        if self.title == "caseBanKempes"{
            kunciJawaban = [4,1,2,3,0]
        }else if self.title == "caseCuciMobil"{
            kunciJawaban = [1,0,3,2]
        }
   
        for index in urutanBenda.indices{
            if urutanBenda[index] == kunciJawaban[index]{
                score += 20
            }
        }
        
        print(score)
        
        if self.title == "caseBanKempes"{
            self.performSegue(withIdentifier: "nextContainer", sender: self)
        }else if self.title == "caseCuciMobil"{
            self.performSegue(withIdentifier: "testSegue4", sender: self)
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
