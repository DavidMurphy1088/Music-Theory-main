import SwiftUI
import CoreData
import MessageUI
 
struct StaffView: View {
    var score:Score
    @ObservedObject var staff:Staff
    static let lineHeight = 1
        
    init (score:Score, staff:Staff) {
        self.score = score
        self.staff = staff
    }
            
    func colr(line: Int) -> Color {
        if line < score.ledgerLineCount || line >= score.ledgerLineCount + 5 {
            return Color.white
        }
        return Color.blue
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack (alignment: .leading) {
                
                ForEach(0..<score.staffLineCount){ row in
                    Path { path in
                        path.move(to: CGPoint(x: 0, y: row * Int(geometry.size.height/CGFloat(score.staffLineCount))))
                        path.addLine(to: CGPoint(x: Int(geometry.size.width), y: row * Int(geometry.size.height/CGFloat(score.staffLineCount))))
                        path.addLine(to: CGPoint(x: Int(geometry.size.width), y: row * Int(geometry.size.height/CGFloat(score.staffLineCount))+StaffView.lineHeight))
                        path.addLine(to: CGPoint(x: 0, y: row * Int(geometry.size.height/CGFloat(score.staffLineCount))+StaffView.lineHeight))
                        path.closeSubpath()
                    }
                    .fill(colr(line: row))
                }

                HStack {
                    HStack {
                        if staff.type == StaffType.treble {
                            Text("\u{1d11e}").font(.system(size: CGFloat(score.lineSpacing * 9)))
                                .offset(y:CGFloat(0 - score.lineSpacing))
                        }
                        else {
                            Text("\u{1d122}").font(.system(size: CGFloat(score.lineSpacing * 6)))
                                .offset(y:CGFloat(0 - score.lineSpacing))
                        }
                    }
                    //.border(Color.green)
                    .frame(width: CGFloat(score.staffLineCount/3 * score.lineSpacing))
                    
                    HStack (spacing: 0) {
                        ForEach(0 ..< score.key.keySig.accidentalCount, id: \.self) { i in
                            KeySignatureAccidentalView(staff: staff, key:score.key.keySig, noteIdx: i, lineSpacing: score.lineSpacing)
                        }
                    }
                    //.border(Color.green)
                    .frame(width: CGFloat(score.staffLineCount/2 * score.lineSpacing))
                
                    ForEach(score.timeSlices, id: \.self) { timeSlice in
                        ZStack {
                            ForEach(timeSlice.note, id: \.self) { note in
                                //if the note isn't shown on both staff's the alignment between staffs is wrong
                                //so make a space on the staff where a time slice has notes only in one staff
                                if note.staff == staff.staffNum {
                                    NoteView(staff: staff, note: note, lineSpacing: score.lineSpacing, color: Color.black)
                                }
                                else {
                                    NoteView(staff: staff, note: note, lineSpacing: score.lineSpacing, color: Color.white)
                                }
                            }
                        }
                    }
                }

            }
        }
    }
}
