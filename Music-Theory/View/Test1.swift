import SwiftUI
import CoreData

struct Test1: View {
    @State var score:Score
    @ObservedObject var staff:Staff
    @State var note = 52

    init() {
        let score = Score()
        score.tempo = 8
        let staff = Staff(score: score, type: .treble, staffNum: 0)
        score.setStaff(num: 0, staff: staff)
        self.score = score
        self.staff = staff
    }

    func setKey(key:Key) {
        score.setKey(key: key)
        //system.setStaff(num: 1, staff: Staff(system: system, type: .bass))
    }

    var body: some View {
        HStack {
            VStack {
                ScoreView(score: score)
                .padding()
                Spacer()
                VStack {
                    Button("Make Note") {
                        let ts = score.addTimeSlice()
                        ts.addNote(n: Note(num: note))
                        ts.addNote(n: Note(num: note-4))
                        note = note - 1
                    }
                    Spacer()
                    Button("Make Chord") {
                        //let ch = Chord(key: key)
                        //let ts = TimeSlice(score: score)
                        //ts.addChord(c: ch)
                        //system.addTimeSlice(ts: ts)
                    }
                    Spacer()
                    Button("Clear") {
                        score.clear()
                    }
                    Spacer()
                    Button("Play") {
                        score.playScore()
                    }
                }
            }
        }
        .onAppear {
            let keySig:KeySignature = KeySignature(type: AccidentalType.flat, count: 0)
            let key = Key(type: Key.KeyType.major, keySig: keySig)
            setKey(key: key)
        }
    }

}

