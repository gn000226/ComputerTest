//
//  ViewController.swift
//  ComputerTest
//
//  Created by 陳暘璿 on 2020/12/24.
//

import UIKit

/* 加減乘除等號 **/
enum OperationType {
    case add
    case subtract
    case multiply
    case divide
    // none > 沒進行計算時預設的狀態
    case none
    case percent    // 百分比符號
}

class ViewController: UIViewController {
    
    @IBOutlet weak var numberLabel: UILabel!    //數字
    @IBOutlet weak var signLabel: UILabel!      //運算符
    @IBOutlet weak var cutButton: UIButton!
    
    @IBOutlet weak var percentButton: UIButton!
    
    // 放目前畫面上的數字，計算用，初始值為０
    var numberOnScreen:Double = 0
    
    // 放被覆蓋之前的數字，計算用，初始值為０
    var previousNumber:Double = 0
    
    // 紀錄狀態，判斷目前是否於計算的狀態，初始值為false
    var isCalculation = false
    
    // 建立物件(操作)，遵從enum > 判斷是否有點擊過計算的button，預設為 .none
    var operation: OperationType = .none
    
    //確認是否已點擊小數點
    var isPoint = false
    
    var signClick = false
    
    // Bool變數，是否重啟新的計算，避免上一次計算結果影響新的計算
    var newStart = true
    
    var numberArray :[Any] = []      //保存數字
    var string: String? = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    /* 數字鍵按鈕設定 **/
    @IBAction func numbers(_ sender: UIButton) {
        // 取得tag的值 ( tag當初設定為按鈕數字減1 )
        let inputNumber = sender.tag - 1
        if numberLabel.text != nil {
            // 重啟計算(計算完畢) 為 true時，下次輸入數字時重啟計算
            if newStart == true {
                numberArray.removeAll()
                numberLabel.text = "\(inputNumber)"
                numberArray.append(inputNumber)
                newStart = false
            } else {
                // 否則繼續當前的計算
                /// label顯示的字串為0，則輸入數字時覆蓋掉，避免計算時會計算到運算符導致錯誤
                if numberLabel.text == "0" {
                    numberLabel.text = "\(inputNumber)"
                    numberArray.append(inputNumber)
                } else {
                    // 已有數字，取得該數字顯示再加上點擊的數字
                    numberLabel.text = numberLabel.text! + "\(inputNumber)"
                    numberArray.append(inputNumber)
                }
            }
            print("\(numberArray)")
            /// 將數字字串轉為Double，顯示在畫面上 > 用來計算
//            let doubleStr = String(format: "%.8f", Double(numberLabel.text!) ?? 0)
//            numberOnScreen = Double(doubleStr) ?? 0
            numberOnScreen = Double(numberLabel.text!) ?? 0
        }
    }
    
    /* 小數點 **/
    @IBAction func point(_ sender: UIButton) {
        if numberLabel.text?.contains(".") == false {
            isPoint = true
            let point = "."
            newStart = false
            if numberLabel.text == "0" && numberArray.count == 0 {
                numberArray.append("0")
                numberArray.append(".")
                numberLabel.text = numberLabel.text?.appending(".")
            } else {
                numberLabel.text = "\(Int(numberOnScreen))\(point)"
                //                let pointStr = numberLabel.text
                numberArray.append(point)
            }
            print(numberArray)
            numberOnScreen = Double(numberLabel.text!) ?? 0
        }
    }
    
    /* 除法動作 **/
    @IBAction func divide(_ sender: UIButton) {
        /// 按下計算符號，呼叫enum
        /// 狀態改為計算中
        /// 先前顯示的數字 存到計算數字中，等等要計算用
        signLabel.text = "/"
        operation = .divide
        isCalculation = true
        previousNumber = numberOnScreen
        numberLabel.text = "0"
        numberArray.removeAll()
        print("第一位數：\(previousNumber)")
    }
    
    /* 乘法動作 **/
    @IBAction func multiply(_ sender: UIButton) {
        /// 按下計算符號，呼叫enum
        /// 狀態改為計算中
        /// 先前顯示的數字 存到計算數字中，等等要計算用
        signLabel.text = "x"
        operation = .multiply
        isCalculation = true
        previousNumber = numberOnScreen
        numberLabel.text = "0"
        numberArray.removeAll()
        print("第一位數：\(previousNumber)")
    }
    
    /* 減法動作 **/
    @IBAction func subtract(_ sender: UIButton) {
        signLabel.text = "-"
        numberLabel.text = "0"
        /// 按下計算符號，呼叫enum
        operation = .subtract
        /// 狀態改為計算中
        isCalculation = true
        /// 先前顯示的數字 存到計算數字中，等等要計算用
        previousNumber = numberOnScreen
        numberArray.removeAll()
        print("第一位數：\(previousNumber)")
    }
    
    /* 加法動作 **/
    @IBAction func add(_ sender: UIButton) {
        /// 按下計算符號，呼叫enum
        /// 狀態改為計算中
        /// 先前顯示的數字 存到計算數字中，等等要計算用
        signLabel.text = "+"
        numberLabel.text = "0"
        operation = .add
        isCalculation = true
        previousNumber = numberOnScreen
        numberArray.removeAll()
        print("第一位數：\(previousNumber)")
    }
    
    /* 等號動作 **/
    @IBAction func getAnswer(_ sender: UIButton){
        // 當運算的狀態是正在運算時，switch判斷
        if isCalculation == true {
            print("第二位數：\(numberOnScreen)")
            switch operation {
            case .add:
                /// 將計算後的數字存回 numberOnScreen
                numberOnScreen = NSDecimalNumber(decimal: Decimal(previousNumber) + Decimal(numberOnScreen)).doubleValue
                /// 再呼叫 makeOkNumberString方法，畫面上顯示正確的數值字串
                makeOkNumberString(from: numberOnScreen)
            case .subtract:
                /// 將計算後的數字存回 numberOnScreen
                numberOnScreen = NSDecimalNumber(decimal: Decimal(previousNumber) - Decimal(numberOnScreen)).doubleValue
                /// 再呼叫 makeOkNumberString方法，畫面上顯示正確的數值字串
                makeOkNumberString(from: numberOnScreen)
            case .multiply:
                /// 將計算後的數字存回 numberOnScreen
                numberOnScreen = NSDecimalNumber(decimal: Decimal(previousNumber) * Decimal(numberOnScreen)).doubleValue
                /// 再呼叫 makeOkNumberString方法，畫面上顯示正確的數值字串
                makeOkNumberString(from: numberOnScreen)
            case .divide:
                /// 將計算後的數字存回 numberOnScreen
                numberOnScreen = NSDecimalNumber(decimal: Decimal(previousNumber) / Decimal(numberOnScreen)).doubleValue
                /// 再呼叫 makeOkNumberString方法，畫面上顯示正確的數值字串
                makeOkNumberString(from: numberOnScreen)
            case .none:
                numberLabel.text = "0"
            case .percent:
                numberOnScreen = NSDecimalNumber(decimal: Decimal(previousNumber) * Decimal(0.01) ).doubleValue
              
                makeOkNumberString(from: numberOnScreen)
            }
            print("結果數：\(numberOnScreen)")
            /// 最後再將運算狀態改為false
            isCalculation = false
            /// 重啟新的計算，避免相沖
            newStart = true
        }
    }
    
    /* 顯示正確的數字字串 > 等號的方法內會呼叫 **/
    /// 例如：整入的話去除小數點等等
    // from > 要從外部傳入參數
    func makeOkNumberString(from number: Double) {
        // 最後要呈現的字串
        var finalText: String
        /// 假如無條件進位後的數值大小等於 原本的數值
        if floor(number) == number {
            /// 則轉為Int 去小數點
            finalText = "\(Int(number))"
        } else {
            /// 否則不去除小數點
            finalText = String(format: "%.7f", number)
            // 只顯示小數點後7位數
            if finalText.count >= 8 {
                finalText = String(finalText.prefix(9))
//                numberLabel.adjustsFontSizeToFitWidth = true
            }
        }
        numberLabel.text = finalText
        signLabel.text = ""
    }
    
    /* 按c 清除label > 狀態改為初始值 **/
    @IBAction func clear(_ sender: UIButton) {
        numberLabel.text = "0"
        signLabel.text = ""
        numberOnScreen = 0
        previousNumber = 0
        numberArray.removeAll()
        isCalculation = false
        isPoint = false
        operation = .none
        newStart = true
    }
    
    /* 狀態列底色 > 設為深色模式 **/
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }
    
    /** 去位數 */
    @IBAction func cutNumber(_ sender: Any) {
        if !newStart {
            if numberLabel.text != "0" && numberArray.count != 0 {
                var numString : String? = ""
                if numberArray.count >= 2 {
                    numberArray.remove(at: numberArray.count-1)
                    for i in 0...numberArray.count-1 {
                        numString!.append("\(numberArray[i])")
                    }
                } else {
                    numberArray.removeAll()
                    //                    numberArray.append(0)
                    numberOnScreen = 0
                    numString = "\((Int(numberOnScreen)))"
                }
                numberLabel.text = numString
                print(numberArray)
            }
        }
    }
    
    /** 百分比 */
    @IBAction func percentSet(_ sender: Any) {
        /// 按下計算符號，呼叫enum
        /// 狀態改為計算中
        /// 先前顯示的數字 存到計算數字中，等等要計算用
        signLabel.text = "%"
        operation = .percent
        isCalculation = true
        previousNumber = numberOnScreen
    }
}

