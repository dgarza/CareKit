//
//  SwiftUIView.swift
//  SwiftUIView
//
//  Created by Daniela Garza on 10/4/21.
//
import Foundation
import SwiftUI

public struct GridTaskView<Header: View, DetailDisclosure:View, Footer: View>: View {
    
    @Environment(\.careKitStyle) private var style
    @Environment(\.isCardEnabled) private var isCardEnabled
    
    private let isHeaderPadded: Bool
    private let isFooterPadded: Bool
    private let isDetailDisclosurePadded: Bool
    private let header: Header
    private let footer: Footer
    private let instructions: Text?
    private let detailDisclosure: DetailDisclosure
    private let action: () -> Void
    
    public var body: some View {
        CardView {
            VStack(alignment: .leading, spacing: style.dimension.directionalInsets1.top) {
                VStack { header }
                    .if(isCardEnabled && isHeaderPadded) { $0.padding([.vertical, .leading]) }
            
                Button {
                    self.action()
                } label: {
                    HStack { header }
                    .if(isCardEnabled && isHeaderPadded) { $0.padding([.vertical, .leading]) }
                    Spacer()
                    VStack { detailDisclosure }
                        .if(isCardEnabled && isDetailDisclosurePadded) { $0.padding([.vertical, .trailing]) }
                }
                .buttonStyle(NoHighlightStyle())
                
                instructions?
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .lineLimit(nil)
                    .if(isCardEnabled && isFooterPadded) { $0.padding([.horizontal, .bottom]) }
                }
        }
    }
    
    public init(instructions: Text? = nil,
                action: @escaping () -> Void = { },
                @ViewBuilder header: () -> Header,
                @ViewBuilder footer: () -> Footer,
                @ViewBuilder detailDisclosure: () -> DetailDisclosure
                ) {
        
        self.init(isHeaderPadded: false,
                  isFooterPadded: false,
                  isDetailDisclosurePadded: false,
                  instructions: instructions,
                  action: action,
                  header: header,
                  footer: footer,
                  detailDisclosure: detailDisclosure
                )
    }
    
    init(isHeaderPadded: Bool,
         isFooterPadded: Bool,
         isDetailDisclosurePadded: Bool,
         instructions: Text? = nil,
         action: @escaping () -> Void = {},
         @ViewBuilder header: () -> Header,
         @ViewBuilder footer: () -> Footer,
         @ViewBuilder detailDisclosure: () -> DetailDisclosure
        ) {
        self.isHeaderPadded = isHeaderPadded
        self.isFooterPadded = isFooterPadded
        self.isDetailDisclosurePadded = isDetailDisclosurePadded
        self.instructions = instructions
        self.header = header()
        self.footer = footer()
        self.detailDisclosure = detailDisclosure()
        self.action = action
    }
        
}

//struct SwiftUIView: View {
//    var body: some View {
//        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
//    }
//}
//
//struct SwiftUIView_Previews: PreviewProvider {
//    static var previews: some View {
//       GridTaskView()
//    }
//}
