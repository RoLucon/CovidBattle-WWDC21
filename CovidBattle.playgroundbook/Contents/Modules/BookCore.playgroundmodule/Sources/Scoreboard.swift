import Foundation

public class Scoreboard {
    weak var delegate: ScoreboardDelegate?
    
    private var maxTime: Double
    
    private var initialDate: Date
    private var infectionNumber: Double  = 1
    private var infectionRate: Double  = 0
    
    init(maxTime: Int) {
        self.maxTime = Double(maxTime)
        initialDate = Date()
    }
    
    //Contar cada tipo de estado para alterar o rating
    func update(persons: [Person]) {
        let masked = persons.filter{ $0.state == .masked }.count
        let infected = persons.filter{ $0.state == .infected }.count
        let vaccined = persons.filter{ $0.state == .vaccined }.count
        let unMasked = persons.count - masked - infected - vaccined
            
        let aux: Double = Double(infected + unMasked/2) 
        
        infectionRate = aux / 2000.0
        
        if masked == persons.count {
            let value = Double.random(in: 0..<1)
            if value < 0.25 {
                persons.randomElement()?.turnOffMask()
            }
            if value < 0.1 {
                persons.randomElement()?.turnOffMask()
            }
            if value < 0.05 {
                persons.randomElement()?.turnOffMask()
            }
        }
        
    }
    
    //MARK: - Timer
    private func timeInterval() -> Double {
        return abs(initialDate.timeIntervalSinceNow)
    }
    
    public func updateTimer() -> String {
        let time = maxTime - timeInterval()
        
        if time < 0 {
            winGame()
            return String(format: "Time: %.2f", 00.00)
        }
        
        return String(format: "Time: %.2f", time)
    }
    
    //MARK: - Infection
    func infectionPercent() -> Double {
        infectionNumber += infectionNumber * infectionRate
        
        if infectionNumber >= 100 {
            gameOver()
            infectionNumber = 100
        }
        
        return infectionNumber / 100
    }
    
    func startCount(){
        initialDate = Date()
    }
    //MARK: - Vaccine
}

extension Scoreboard: ScoreboardDelegate {
    
    func stopGame() {
        guard let delegate = delegate else { return }
        delegate.stopGame()
    }
    
    func gameOver() {
        guard let delegate = delegate else { return }
        delegate.gameOver()
    }
    
    func winGame() {
        guard let delegate = delegate else { return }
        delegate.winGame()
    }
}
