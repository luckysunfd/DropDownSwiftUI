//
//  ContentView.swift
//  dropdown_list1
//
//  Created by sun on 20/1/23.
//

import SwiftUI

struct ContentView: View {
    @State private var selection: String = "🍎"
    
    var body: some View {
        VStack {
            DropDown(
                content: ["🍎", "🍌", "🍊", "🍉"],
                selection: $selection,
                activeTint: .primary.opacity(0.1),
                inActiveTint: .white.opacity(0.05),
                dynamic: false
            )
            .frame(width:120)
            
            // Spacer()
            
            Text("\(selection)")
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background {
            Color("BG")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

/*
   1. [string]类型的数组 -》 表示dropdown option
   2. string 类型的@state装饰的变量 -〉 表示当前的选择项
   3. Color 类型的变量, 表示选中的option的color
   4. Color 类型的变量, 表示未选中的option的color
   5. bool 类型的变量, 表示
 */
struct DropDown: View {
    // drop down properties
    var content: [String]
    @Binding var selection: String
    var activeTint: Color
    var inActiveTint: Color
    
    var dynamic: Bool
    
    // view properties
    @State private var expandView: Bool = false
    
    var body: some View {
        GeometryReader {
            let size = $0.size
            
            VStack(alignment: .leading, spacing: 0) {
                if !dynamic {
                    RowView(selection, size)
                }
                ForEach(content.filter {
                    dynamic ? true : $0 != selection
                }, id: \.self) { title in
                    RowView(title, size)
                }
            }
            .background {
                Rectangle()
                    .fill(inActiveTint)
            }
            /// - Moving view on the selection
            .offset(y: dynamic ? (CGFloat(content.firstIndex(of: selection) ?? 0) * -55) : 0)
        } // geometryreader
        .frame(height: 55)
        .overlay(alignment: .trailing) {
            Image(systemName: "chevron.up.chevron.down")
                .padding(.trailing, 10)
        }
        .mask(alignment: .top) {
            Rectangle()
                .frame(height: expandView ? CGFloat(content.count) * 55 : 55)
                .offset(y: dynamic && expandView ? (CGFloat(content.firstIndex(of: selection) ?? 0) * 55) : 0)
        }
    } //body
    
    @ViewBuilder
    func RowView(_ title: String, _ size: CGSize) -> some View {
        Text(title)
            .font(.title3)
            .fontWeight(.semibold)
            .padding(.horizontal)
            .frame(width: size.width, height: size.height, alignment: .leading)
            .background {
                if selection == title {
                    Rectangle()
                        .fill(activeTint)
                        .transition(.identity)
                }
            }
            .contentShape((Rectangle()))
            .onTapGesture {
                withAnimation( .interactiveSpring(response: 0.6, dampingFraction: 0.7, blendDuration: 0.7)) {
                    if expandView {
                        expandView = false
                        
                        if dynamic {
                            selection = title
                        }else{
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                                selection = title
                            }
                        }
                    }else{
                        /// disabling outside taps
                        if selection == title {
                            expandView = true
                        }
                    }
                }
            }
    }
}
