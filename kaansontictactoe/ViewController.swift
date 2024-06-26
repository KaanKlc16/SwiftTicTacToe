import UIKit

class ViewController: UIViewController {
    enum Turn { case Zero, Cross }
    
    @IBOutlet weak var turnLabel: UILabel!
    @IBOutlet weak var singlePlayerButton: UIButton!
    @IBOutlet weak var multiPlayerButton: UIButton!
    @IBOutlet weak var a1: UIButton!
    @IBOutlet weak var a2: UIButton!
    @IBOutlet weak var a3: UIButton!
    @IBOutlet weak var b1: UIButton!
    @IBOutlet weak var b2: UIButton!
    @IBOutlet weak var b3: UIButton!
    @IBOutlet weak var c1: UIButton!
    @IBOutlet weak var c2: UIButton!
    @IBOutlet weak var c3: UIButton!
    
    var firstTurn = Turn.Cross
    var currentTurn = Turn.Cross
    var isSinglePlayer = false
    var ZERO = "O"
    var CROSS = "X"
    var board = [UIButton]()
    var zeroScore = 0
    var crossScore = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setInitViews()
    }
    
    private func setInitViews() {
        board.append(a1)
        board.append(a2)
        board.append(a3)
        board.append(b1)
        board.append(b2)
        board.append(b3)
        board.append(c1)
        board.append(c2)
        board.append(c3)
    }
    
    @IBAction func singlePlayerButtonTapped(_ sender: UIButton) {
        isSinglePlayer = true
        resetBoard()
        currentTurn = Turn.Cross
        performAIMove()  
    }
    
    @IBAction func multiPlayerButtonTapped(_ sender: UIButton) {
        isSinglePlayer = false
        resetBoard()
    }
    
    @IBAction func boarTapAction(_ sender: UIButton) {
        addToBoard(sender)
        if checkForVictory(CROSS) {
            resultAlert(title: "X kazandı")
            crossScore += 1
        } else if checkForVictory(ZERO) {
            resultAlert(title: "O kazandı")
            zeroScore += 1
        } else if fullBoard() {
            resultAlert(title: "Berabere")
        }
    }
    
    func checkForVictory(_ s: String) -> Bool {
        // Horizontal
        if thisSymbol(a1, s) && thisSymbol(a2, s) && thisSymbol(a3, s) { return true }
        if thisSymbol(b1, s) && thisSymbol(b2, s) && thisSymbol(b3, s) { return true }
        if thisSymbol(c1, s) && thisSymbol(c2, s) && thisSymbol(c3, s) { return true }
        // Vertical
        if thisSymbol(a1, s) && thisSymbol(b1, s) && thisSymbol(c1, s) { return true }
        if thisSymbol(a2, s) && thisSymbol(b2, s) && thisSymbol(c2, s) { return true }
        if thisSymbol(a3, s) && thisSymbol(b3, s) && thisSymbol(c3, s) { return true }
        // Diagonal
        if thisSymbol(a1, s) && thisSymbol(b2, s) && thisSymbol(c3, s) { return true }
        if thisSymbol(a3, s) && thisSymbol(b2, s) && thisSymbol(c1, s) { return true }
        return false
    }
    
    func thisSymbol(_ button: UIButton, _ symbol: String) -> Bool {
        return button.title(for: .normal) == symbol
    }
    
    private func resultAlert(title: String) {
        let message = "\nO'lar " + String(zeroScore) + " \nX'ler " + String(crossScore)
        let ac = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        ac.addAction(UIAlertAction(title: "Reset", style: .default, handler: { _ in
            self.resetBoard()
        }))
        self.present(ac, animated: true)
    }
    
    private func resetBoard() {
        for button in board {
            button.setTitle(nil, for: .normal)
            button.isEnabled = true
        }
        if firstTurn == Turn.Zero {
            firstTurn = Turn.Cross
            turnLabel.text = CROSS
        } else if firstTurn == Turn.Cross {
            firstTurn = Turn.Zero
            turnLabel.text = ZERO
        }
        currentTurn = firstTurn
    }
    
    private func fullBoard() -> Bool {
        for button in board {
            if button.title(for: .normal) == nil {
                return false
            }
        }
        return true
    }
    
    func addToBoard(_ sender: UIButton) {
        if sender.title(for: .normal) == nil {
            if currentTurn == Turn.Zero {
                sender.setTitle(ZERO, for: .normal)
                currentTurn = Turn.Cross
                turnLabel.text = CROSS
            } else if currentTurn == Turn.Cross {
                sender.setTitle(CROSS, for: .normal)
                currentTurn = Turn.Zero
                turnLabel.text = ZERO
            }
            sender.isEnabled = false
            
            if isSinglePlayer && currentTurn == Turn.Cross {
                performAIMove()
            }
        }
    }
    
    func performAIMove() {
        var availableButtons = [UIButton]()
        for button in board {
            if button.title(for: .normal) == nil {
                availableButtons.append(button)
            }
        }
        if let randomButton = availableButtons.randomElement() {
            addToBoard(randomButton)
        }
    }
}
