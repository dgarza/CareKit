//
//  SwiftUIView.swift
//  SwiftUIView
//
//  Created by Daniela Garza on 10/4/21.
//
import Foundation
import SwiftUI


public struct GridTaskView<Header: View, DetailDisclosure: View, Footer: View>: View {
    
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
                    .if(isCardEnabled && isHeaderPadded) { $0.padding([.horizontal, .top]) }
                
                Button {
                    self.action()
                } label: {
                    HStack { header }
                    .if(isCardEnabled && isHeaderPadded) { $0.padding([.vertical, .leading]) }
                    Spacer()
                    VStack { detailDisclosure }
                        .if(isCardEnabled && isDetailDisclosurePadded) { $0.padding([.vertical, .trailing]) }
                
                .buttonStyle(NoHighlightStyle())
                }
                Divider()
                
                instructions?
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .lineLimit(nil)
                    .if(isCardEnabled && isFooterPadded) { $0.padding([.horizontal, .bottom]) }
                }
        }
    }
    
    public init(instructions: Text? = nil,
                action: @escaping () -> Void = {},
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

public extension GridTaskView where Header == _GridTaskViewHeader {
    init(title: Text,
         detail: Text? = nil,
         instructions: Text? = nil,
         @ViewBuilder footer: () -> Footer,
//         action: @escaping () -> Void = {},
         @ViewBuilder detailDisclosure: () -> DetailDisclosure
        ) {
        self.init(isHeaderPadded: true,
                  isFooterPadded: false,
                  isDetailDisclosurePadded: false,
                  instructions: instructions,
//                  action: action,
                  header: { _GridTaskViewHeader(title: title, detail: detail) },
                  footer: footer,
                  detailDisclosure: detailDisclosure)
    }
}

public struct _GridTaskViewHeader: View {
    @Environment(\.careKitStyle) private var style
    
    fileprivate let title: Text
    fileprivate let detail: Text?
    
    public var body: some View {
        VStack(alignment: .leading, spacing: style.dimension.directionalInsets1.top) {
            HeaderView(title: title, detail: detail)
            Divider()
        }
    }
}

public extension GridTaskView where DetailDisclosure == _GridTaskViewDetailDisclosure {
    init(isComplete: Bool,
         @ViewBuilder header: () -> Header,
         @ViewBuilder footer: () -> Footer,
         action: @escaping () -> Void = {}
    ) {
        self.init(isHeaderPadded: false,
                  isFooterPadded: true,
                  isDetailDisclosurePadded: true,
                  action: action,
                  header: header,
                  footer: footer,
                  detailDisclosure: { _GridTaskViewDetailDisclosure(isComplete: isComplete)
        })
    }
}

public extension GridTaskView where Footer == _GridTaskViewFooter {
    init(isComplete: Bool,
         @ViewBuilder header: () -> Header,
         @ViewBuilder footer: () -> Footer,
         action: @escaping () -> Void = {},
         instructions: Text? = nil,
         detail: Text? = nil
    ) {
        self.init(isHeaderPadded: false,
                  isFooterPadded: true,
                  isDetailDisclosurePadded: true,
                  instructions: instructions,
                  header: header,
                  footer: { _GridTaskViewFooter(instructions: instructions, detail: detail, isComplete: isComplete, action: action) },
                  detailDisclosure: { _GridTaskViewDetailDisclosure(isComplete: isComplete) as! DetailDisclosure
            })
    }
}

public struct _GridTaskViewFooter: View {
    @Environment(\.sizeCategory) private var sizeCategory
    
    fileprivate let instructions: Text?
    fileprivate let detail: Text?
    fileprivate let isComplete: Bool
    fileprivate let action: () -> Void
    
    public var body: some View {
        Button(action: action) {
            CircularCompletionView(isComplete: isComplete) {
                HStack {
                    Spacer()
                }
            }
        }.buttonStyle(NoHighlightStyle())
    }
}

public struct _GridTaskViewDetailDisclosure: View {
    @Environment(\.careKitStyle) private var style
    @Environment(\.sizeCategory) private var sizeCategory
    
    @OSValue<CGFloat>(values: [.watchOS: 6], defaultValue: 16) private var padding
    
    fileprivate let isComplete: Bool
    
    public var body: some View {
        CircularCompletionView(isComplete: isComplete) {
            Image(systemName: "checkmark")
                .resizable()
                .padding(padding.scaled())
                .frame(width: style.dimension.buttonHeight2.scaled(), height: style.dimension.buttonHeight2.scaled())
        }
    }
}

public extension GridTaskView where Footer == _GridTaskViewFooter, DetailDisclosure == _GridTaskViewDetailDisclosure, Header == _GridTaskViewHeader {
    init(title: Text,
         detail: Text? = nil,
         isComplete: Bool,
         action: @escaping () -> Void = {},
         instructions: Text? = nil
        ){
        self.init(isHeaderPadded: true,
                  isFooterPadded: true,
                  isDetailDisclosurePadded: false,
                  instructions: instructions,
                  header: { _GridTaskViewHeader(title: title, detail: detail) },
                  footer:{ _GridTaskViewFooter(instructions: instructions, detail: detail, isComplete: isComplete, action: action) },
                  detailDisclosure: { _GridTaskViewDetailDisclosure(isComplete: isComplete) as! DetailDisclosure
                })
        }
}














struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            GridTaskView(title: Text("Doxylamine"), detail: Text("3 remaining"), isComplete: false, action:{}, instructions: Text("Take with a full glass of water"))
        }
        .padding()
    }
}
