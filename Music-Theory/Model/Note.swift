import Foundation

enum AccidentalType {
    case sharp
    case flat
}

enum HandType {
    case left
    case right
}

class Note : Hashable, Comparable {
    var num:Int
    var staff:Int
    static let MIDDLE_C = 40
    static let noteNames:[Character] = ["A", "B", "C", "D", "E", "F", "G"]

    static func == (lhs: Note, rhs: Note) -> Bool {
        return lhs.num == rhs.num
    }
    static func < (lhs: Note, rhs: Note) -> Bool {
        return lhs.num < rhs.num
    }
    
    static func isSameNote(note1:Int, note2:Int) -> Bool {
        return (note1 % 12) == (note2 % 12)
    }
    
    init(num:Int, staff:Int = 0) {
        self.num = num
        self.staff = staff
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(num)
    }
    
    static func staffNoteName(idx:Int) -> Character {
        if idx >= 0 {
            return self.noteNames[idx % noteNames.count]
        }
        else {
            return self.noteNames[noteNames.count - (abs(idx) % noteNames.count)]
        }
    }

    static func getAllOctaves(note:Int) -> [Int] {
        var notes:[Int] = []
        for n in 0...88 {
            if note >= n {
                if (note - n) % 12 == 0 {
                    notes.append(n)
                }
            }
            else {
                if (n - note) % 12 == 0 {
                    notes.append(n)
                }
            }
        }
        return notes
    }
    
    static func getClosestOctave(note:Int, toPitch:Int) -> Int? {
        let pitches = Note.getAllOctaves(note: note)
        var closest:Int?
        var minDist:Int?
        for p in pitches {
            let dist = abs(p - toPitch)
            if minDist == nil || dist < minDist! {
                minDist = dist
                closest = p
            }
        }
        return closest
    }
}
