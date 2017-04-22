//: Playground - noun: a place where people can play

import GameplayKit
import UIKit
/*
 * Task 1, Define a base class named Transformer, and its child class Autobot and Decepticon.
 *
 * Task 2: Generate Groups (Autobots,Deceptions) randomly and sort by rank in each group.
 *
 * Task 3: Run battle then try to find a winner in each fight
 *
 * Task 4: output
 * 
 * Click the play button to excuate playground
 */

let logMode: Bool = false        // Change it to true, will show more running details
let maxNumberInGroup:UInt32 = 5  // The max numbers is 12 (limited by lines in resources file)
var numbersInGroup:Int = 1       // Setting default number of fighter in each group
let numbersOfTechSpec = 8
let defaultValueOfSpec:Int8 = 0  // Setting tech spec default value

let groupD = "Decepticons"
let groupA = "Autobots"
let leaderOfGroupD = "PREDAKING"
let leaderOfGroupA = "OPTIMUS PRIME"
let opponentWin = "opponent"

var groupDFinalScore:Int8 = 0
var groupAFinalScroe:Int8 = 0
var groupDSurvivors = ""
var groupASurvivors = ""
var round: Int!
var groupAScore: Int = 0
var groupDScore: Int = 0
var battleTerminated: Bool! = false

class Transformer: NSObject {
    let name: String
    let strength:Int8
    let intelligence: Int8
    let speed: Int8
    let endurance: Int8
    let rank: Int8
    let courage: Int8
    let firepower: Int8
    let skill: Int8
    var eliminated: Bool
    
    init(name: String, attrTechSpec:[Int8]) {
        self.name = name
        self.strength = attrTechSpec[0]
        self.intelligence = attrTechSpec[1]
        self.speed = attrTechSpec[2]
        self.endurance = attrTechSpec[3]
        self.rank = attrTechSpec[4]
        self.courage = attrTechSpec[5]
        self.firepower = attrTechSpec[6]
        self.skill = attrTechSpec[7]
        self.eliminated = false
        
    }
    var overoll: Int8 {
        get {
            return self.strength + self.intelligence + self.speed + self.endurance + self.firepower
        }
    }
    
    func winOnCourageStrength(against courage: Int8, strength:Int8) -> String?{
        let diffCourage = self.courage - courage
        let diffStrength = self.strength - strength
        if (diffCourage >= 4) && (diffCourage >= 3 ){
            return (self.name)
        }
        if (diffCourage <= -4) && (diffStrength <= -3 ){
            return (opponentWin)
        }
        return (nil)
    }
    
    func winOnSkill(against skill:Int8)->String?{
        let diffSkill = self.skill - skill
        if diffSkill >= 3 {
            return self.name
        }else if diffSkill <= -3 {
            return opponentWin
        }else{
            return nil
        }
    }
    
    func eliminate(){
        self.eliminated = true
    }
}

class Autobot: Transformer {
    let group = "A"
}

class Decepticon: Transformer {
    let group = "D"
}

var autobots = [Autobot]()
var decepticons = [Decepticon]()

/*
 * Generate a random number of fighters in group
 */
func setNumberInGroup()->Int{
    var needNumber =  true
    var random: UInt32 = 0
    while needNumber {
        random = arc4random_uniform(maxNumberInGroup + 1) // 0 ~ maxNumberInGroup
        if (random >= 1) && (random <= maxNumberInGroup){
            needNumber = false
        }
    }
    return Int(random)
}

/*
 *  Assemble Group for fighting
 */
func assembleGroup(groupType:String?){
    if groupType == nil {return}
    let groupName:String!

    if groupType! == groupA{
            groupName = groupA
        }else if groupType! == groupD {
            groupName = groupD
    }else{
        return
    }
    
    do{ // Load the data from files
        let fileURL = Bundle.main.url(forResource: groupName, withExtension: "txt")
        let data = try String(contentsOf: fileURL!, encoding: String.Encoding.utf8)
        var lines = data.components(separatedBy: .newlines)
        lines = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: lines) as! [String]
        numbersInGroup = setNumberInGroup() // this number in each group could be same or different
        
        for i in 0..<numbersInGroup{
            var attrTechSpec = [Int8](repeating: 0, count: numbersOfTechSpec)
            let line = lines[i]
            let attrs = line.components(separatedBy:",")
  
            for l in 0..<attrTechSpec.count{
                attrTechSpec[l] = Int8(attrs[l+2])!
            }
            if groupType! == groupA {
                let fighter = Autobot(name: attrs[0], attrTechSpec: attrTechSpec)
                autobots.append(fighter)
            }else{
                let fighter = Decepticon(name: attrs[0], attrTechSpec: attrTechSpec)
                decepticons.append(fighter)
            }
        }
    } catch let err as NSError {
        print("Error info: \(err)")}
    
    // Sort fighters by rank
    if groupType! == groupA{
        autobots.sort { (first:Autobot, second:Autobot) -> Bool in
            first.rank > second.rank}
    }else{
        decepticons.sort { (first:Decepticon, second:Decepticon) -> Bool in
            first.rank > second.rank}
    }
}

assembleGroup(groupType: groupA) // generate group Autobots
assembleGroup(groupType: groupD) // generate group Decepticons
if logMode {print("GroupA has: \(autobots.count) fighters, GroupD has: \(decepticons.count) fighters")}

func setVictor(round x:Int, victor groupName:String){
    if groupName == groupA {
            decepticons[x].eliminate()
            groupAScore = groupAScore + 1
    }else if groupName == groupD {
            autobots[x].eliminate()
            groupDScore = groupDScore + 1
    }
}

func onReporing(){  // Output
    if battleTerminated! {
        terminationOutput()
        return
    }else{
        battleOutput()
    }
    autobots.removeAll()
    decepticons.removeAll()
}

func terminationOutput(){
    print("\(leaderOfGroupD) VS \(leaderOfGroupA), the battle is terminated!")
}

func onFighting(round x:Int!){
    // The leader always wins the fight
    if decepticons[x].name == leaderOfGroupD && autobots[x].name != leaderOfGroupA{
        setVictor(round: x, victor: groupD)
        if logMode {print("🏁 end round:\(x!) Victor: D, Leader win")}
        return
    }
    if decepticons[x].name != leaderOfGroupD && autobots[x].name == leaderOfGroupA{
        setVictor(round:x, victor:groupA)
        if logMode {print("🏁 end round:\(x!) Victor: A, Leader win")}
        return
    }
    // The fight wins with courage and strength
    let res = autobots[x].winOnCourageStrength(against: decepticons[x].courage,
                                               strength:decepticons[x].strength)
    if let victor = res {
        if victor == autobots[x].name {
            setVictor(round:x, victor:groupA)  // autobots win
            if logMode {print("🏁end round:\(x!) Victor: A, with courage and strength \(autobots[x].courage)|\(autobots[x].strength)")}
        }else if victor == opponentWin {
            setVictor(round: x, victor: groupD) // decepticons win
            if logMode {print("🏁end round:\(x!) Victor: D, with courage and strength \(decepticons[x].courage)|\(decepticons[x].strength)")}
        }
        return
    }
    // The fighter wins with skill
    let resu = autobots[x].winOnSkill(against: decepticons[x].skill)
    if let victor = resu {
        if(victor == autobots[x].name){  // autobots win
            setVictor(round:x, victor:groupA)
            if logMode {print("🏁end round:\(x!) Victor: A, with skill, \(autobots[x].skill)")}
        }else if victor == opponentWin{  // decepticons win
            setVictor(round: x, victor: groupD)
            if logMode {print("🏁end round:\(x!) Victor: D, with skill, \(decepticons[x].skill)")}
        }
        return
    }
    // The fighter wins with overcall rating
    let autobotOveroll = autobots[x].overoll
    let decepticonOveroll = decepticons[x].overoll
    if autobotOveroll > decepticonOveroll {
        setVictor(round:x, victor:groupA)
        if logMode {print("🏁end round:\(x!) Victor: A, with Overroll")}
    }
    if autobotOveroll < decepticonOveroll{
        setVictor(round:x, victor: groupD)
        if logMode {print("🏁end round:\(x!) Victor: D, with Overroll")}
    }
    if autobotOveroll == decepticonOveroll{
          // both fighters lost the fight
            autobots[x].eliminate()
            decepticons[x].eliminate()
        if logMode {print("🏁end round:\(x!) Victor: , both lose on Overroll")}
    }
}

func startBattle(){
    round = min(autobots.count, decepticons.count)
    if round < 1 {return}
    for i in 0..<round{  // all is ready, start fight
        if decepticons[i].name == leaderOfGroupD && autobots[i].name == leaderOfGroupA{
            // Predaking vs Optimus Prime
            battleTerminated = true
            break
        }
        if logMode {print("Round \(i): GroupD(\(decepticons[i].name)) vs GroupA(\(autobots[i].name)) ")}
        onFighting(round:i)
    }
    onReporing()
}

func battleOutput(){
    for decepticon in decepticons{
        if !decepticon.eliminated {
            groupDSurvivors += " \(decepticon.name),"
        }
    }
    for autobot in autobots {
        if !autobot.eliminated {
            groupASurvivors += " \(autobot.name),"
        }
    }
    if logMode {print("GroupD Score:\(groupDScore) vs GroupA Score:\(groupAScore)")}
    
    groupAFinalScroe = Int8(groupAScore)  // calculate final scroe , our rule just check one score
    groupDFinalScore = Int8(groupDScore)
    print("")
    if(round! == 1){
        print("\(round!) battle")
    }else{
        print("\(round!) battles")
    }
    if groupAFinalScroe > groupDFinalScore {
        print("Winning team (\(groupA)): \(groupASurvivors)")
        print("Survivors from the losing team (\(groupD)): \(groupDSurvivors)")
    }else if groupAFinalScroe < groupDFinalScore {
        print("Winning team (\(groupD)): \(groupDSurvivors)")
        print("Survivors from the losing team (\(groupA)): \(groupASurvivors)")
    }else{
        print("Winning team (): ")
        print("Survivors from the losing team ():")
        print( "* The both groups have the same score \(groupAFinalScroe):\(groupDFinalScore), number of elimination is equal." )
    }
}
startBattle()








