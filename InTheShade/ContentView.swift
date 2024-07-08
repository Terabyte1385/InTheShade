//
//  ContentView.swift
//  InTheShade
//
//  Created by Terabyte1385 on 07.07.2024.
//

import SwiftUI
import AuthenticationServices

struct StartEphermalSessionResult: Equatable {
    static func == (lhs: StartEphermalSessionResult, rhs: StartEphermalSessionResult) -> Bool {
        // Compare the success flag first
        guard lhs.success == rhs.success else {
            return false
        }
        
        // Compare the optional errors
        if let lhsError = lhs.error as NSError?, let rhsError = rhs.error as NSError? {
            // Both errors are non-nil, compare them
            return lhsError.localizedDescription == rhsError.localizedDescription
        } else {
            // One or both errors are nil
            return lhs.error == nil && rhs.error == nil
        }
    }
    
    let success: Bool
    let error: Error?
}

class EphermalViewModel: NSObject, ObservableObject, ASWebAuthenticationPresentationContextProviding {
    func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        return ASPresentationAnchor()
    }
    func startEphermal() -> StartEphermalSessionResult {
        let scheme = UUID().uuidString
        var result = StartEphermalSessionResult(success: false, error: nil)
        let session = ASWebAuthenticationSession(url: URL(string: "data:text/html,%3C%21DOCTYPE%20html%3E%0A%3Chtml%3E%0A%3Chead%3E%0A%20%20%20%20%3Ctitle%3EInTheShade%20Launchpad%3C%2Ftitle%3E%0A%20%20%20%20%3Cmeta%20charset%3D%22utf-8%22%3E%0A%20%20%20%20%3Cmeta%20http-equiv%3D%22Content-type%22%20content%3D%22text%2Fhtml%3B%20charset%3Dutf-8%22%3E%0A%20%20%20%20%3Cmeta%20name%3D%22viewport%22%20content%3D%22width%3Ddevice-width%2C%20initial-scale%3D1%22%3E%0A%20%20%20%20%3Cstyle%20type%3D%22text%2Fcss%22%3E%0A%20%20%20%20%20%20%20%20body%20%7B%0A%20%20%20%20%20%20%20%20%20%20%20%20background-color%3A%20%231a1a1a%3B%0A%20%20%20%20%20%20%20%20%20%20%20%20margin%3A%200%3B%0A%20%20%20%20%20%20%20%20%20%20%20%20padding%3A%200%3B%0A%20%20%20%20%20%20%20%20%20%20%20%20font-family%3A%20-apple-system%2C%20system-ui%2C%20BlinkMacSystemFont%2C%20%22Segoe%20UI%22%2C%20%22Open%20Sans%22%2C%20%22Helvetica%20Neue%22%2C%20Helvetica%2C%20Arial%2C%20sans-serif%3B%0A%20%20%20%20%20%20%20%20%7D%0A%20%20%20%20%20%20%20%20div%20%7B%0A%20%20%20%20%20%20%20%20%20%20%20%20width%3A%20600px%3B%0A%20%20%20%20%20%20%20%20%20%20%20%20margin%3A%205em%20auto%3B%0A%20%20%20%20%20%20%20%20%20%20%20%20padding-top%3A%200%25%3B%0A%20%20%20%20%20%20%20%20%20%20%20%20padding%3A%201em%202em%3B%0A%20%20%20%20%20%20%20%20%20%20%20%20background-color%3A%20%23363636%3B%0A%20%20%20%20%20%20%20%20%20%20%20%20border-radius%3A%200.5em%3B%0A%20%20%20%20%20%20%20%20%20%20%20%20box-shadow%3A%202px%203px%207px%202px%20rgba%280%2C%200%2C%200%2C%200.02%29%3B%0A%20%20%20%20%20%20%20%20%7D%0A%20%20%20%20%20%20%20%20.navDiv%20%7B%0A%20%20%20%20%20%20%20%20%20%20%20%20width%3A%20500px%3B%0A%20%20%20%20%20%20%20%20%20%20%20%20height%3A%2055px%3B%0A%20%20%20%20%20%20%20%20%20%20%20%20background-color%3A%20%23363636%3B%0A%20%20%20%20%20%20%20%20%20%20%20%20margin%3A%200.5%20auto%3B%0A%20%20%20%20%20%20%20%20%20%20%20%20text-align%3A%20center%3B%0A%20%20%20%20%20%20%20%20%20%20%20%20box-shadow%3A%200px%200px%200px%200px%20rgba%280%2C%200%2C%200%2C%200%29%3B%0A%20%20%20%20%20%20%20%20%7D%0A%20%20%20%20%20%20%20%20.regularLink%3Alink%2C%0A%20%20%20%20%20%20%20%20.regularLink%3Avisited%20%7B%0A%20%20%20%20%20%20%20%20%20%20%20%20color%3A%20%234ca8ff%3B%0A%20%20%20%20%20%20%20%20%20%20%20%20padding-bottom%3A%2015px%3B%0A%20%20%20%20%20%20%20%20%20%20%20%20text-decoration%3A%20none%3B%0A%20%20%20%20%20%20%20%20%7D%0A%20%20%20%20%20%20%20%20.navLink%20%7B%0A%20%20%20%20%20%20%20%20%20%20%20%20color%3A%20%234ca8ff%3B%0A%20%20%20%20%20%20%20%20%20%20%20%20text-decoration%3A%20none%3B%0A%20%20%20%20%20%20%20%20%20%20%20%20padding-left%3A%2010px%3B%0A%20%20%20%20%20%20%20%20%7D%0A%20%20%20%20%20%20%20%20h1%2C%20p%20%7B%0A%20%20%20%20%20%20%20%20%20%20%20%20filter%3A%20invert%28100%25%29%3B%0A%20%20%20%20%20%20%20%20%7D%0A%20%20%20%20%20%20%20%20hr%20%7B%0A%20%20%20%20%20%20%20%20%20%20%20%20border%3A%200%3B%0A%20%20%20%20%20%20%20%20%20%20%20%20border-top%3A%201px%20solid%20gray%3B%0A%20%20%20%20%20%20%20%20%20%20%20%20opacity%3A%2025%25%3B%0A%20%20%20%20%20%20%20%20%20%20%20%20padding-top%3A%2025px%3B%0A%20%20%20%20%20%20%20%20%7D%0A%20%20%20%20%20%20%20%20.item%20%7B%0A%20%20%20%20%20%20%20%20%20%20%20%20flex%3A%201%3B%0A%20%20%20%20%20%20%20%20%7D%0A%20%20%20%20%20%20%20%20%23navcontainer%20%7B%0A%20%20%20%20%20%20%20%20%20%20%20%20width%3A%20auto%3B%0A%20%20%20%20%20%20%20%20%20%20%20%20display%3A%20flex%3B%0A%20%20%20%20%20%20%20%20%20%20%20%20flex-direction%3A%20row%3B%0A%20%20%20%20%20%20%20%20%20%20%20%20justify-content%3A%20center%3B%0A%20%20%20%20%20%20%20%20%20%20%20%20text-align%3A%20center%3B%0A%20%20%20%20%20%20%20%20%20%20%20%20margin%3A%20auto%3B%0A%20%20%20%20%20%20%20%20%20%20%20%20padding%3A%200%3B%0A%20%20%20%20%20%20%20%20%20%20%20%20display%3A%20flex%3B%0A%20%20%20%20%20%20%20%20%20%20%20%20justify-content%3A%20center%3B%0A%20%20%20%20%20%20%20%20%20%20%20%20align-items%3A%20center%3B%0A%20%20%20%20%20%20%20%20%7D%0A%20%20%20%20%20%20%20%20.btn%20%7B%0A%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20background-color%3A%20%23bebebe23%3B%0A%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20border%3A%202px%20solid%20%23bebebe%3B%0A%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20color%3A%20rgb%28255%2C%20255%2C%20255%29%3B%0A%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20padding%3A%204px%2015px%3B%0A%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20font-size%3A%2012px%3B%0A%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20text-align%3A%20center%3B%0A%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20text-decoration%3A%20none%3B%0A%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20display%3A%20inline-block%3B%0A%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20margin%3A%204px%202px%3B%0A%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20cursor%3A%20pointer%3B%0A%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20border-radius%3A%2032px%3B%0A%20%20%20%20%20%20%20%20%20%20%20%20%7D%0A%20%20%20%20%3C%2Fstyle%3E%0A%20%20%20%20%3Cscript%3E%0A%20%20%20%20%20%20%20%20console.warn%28%22WARNING%21%20DO%20NOT%20USE%20THE%20WEB%20CONSOLE%20ON%20ANY%20WEBSITE%20IF%20YOU%20DON%27T%20KNOW%20WHAT%20YOU%27RE%20DOING%21%20An%20attacker%20may%20be%20telling%20you%20to%20paste%20malicious%20code%20as%20part%20of%20an%20attack%20called%20Self-XSS.%20Learn%20more%3A%20https%3A%2F%2Fen.wikipedia.org%2Fwiki%2FSelf-XSS%22%29%0A%20%20%20%20%3C%2Fscript%3E%0A%3C%2Fhead%3E%0A%3Cbody%3E%0A%20%20%20%20%3Cdiv%3E%0A%20%20%20%20%20%20%20%20%3Ch1%3EYou%27re%20now%20in%20the%20shade%3C%2Fh1%3E%0A%20%20%20%20%20%20%20%20%3Cbutton%20class%3D%22btn%22%20onclick%3D%22window.open%28%27favorites%3A%2F%2F%27%2C%20%27_blank%27%29%3B%22%3E%2B%20New%20Private%20Tab%3C%2Fbutton%3E%0A%20%20%20%20%20%20%20%20%3C%21--%20%3Cbutton%20class%3D%22btn%22%3E%E2%98%85%20Favorites%3C%2Fbutton%3E%20--%3E%0A%20%20%20%20%20%20%20%20%3Cp%3E%26nbsp%3B%3C%2Fp%3E%0A%20%20%20%20%20%20%20%20%3Cp%3EInTheShade%20ran%20successfully%20and%20has%20started%20a%20private%20browsing%20session%20for%20you.%3C%2Fp%3E%0A%20%20%20%20%20%20%20%20%3Cp%3EYou%20can%20safely%20close%20this%20tab%20if%20you%20have%20launched%20another%20private%20tab%20using%20either%20the%20buttons%20above%20or%20the%20%E2%8C%98%20%2B%20T%20shortcut.%3C%2Fp%3E%0A%20%20%20%20%20%20%20%20%3Cp%3E%26nbsp%3B%3C%2Fp%3E%0A%20%20%20%20%20%20%20%20%3Clink%3E%3Ca%20class%3D%22regularLink%22%20href%3D%22https%3A%2F%2Fgithub.com%2FTerabyte1385%2FInTheShade%22%3EGive%20InTheShade%20a%20star%20on%0A%20%20%20%20%20%20%20%20%20%20%20%20GitHub%3C%2Fa%3E%3C%2Flink%3E%0A%20%20%20%20%20%20%20%20%3Ch1%3E%3C%2Fh1%3E%0A%20%20%20%20%20%20%20%20%3Clink%3E%3Ca%20class%3D%22regularLink%22%20href%3D%22https%3A%2F%2Fgithub.com%2FTerabyte1385%2FInTheShade%2Freleases%22%3EDownload%20the%20latest%0A%20%20%20%20%20%20%20%20%20%20%20%20version%3C%2Fa%3E%3C%2Flink%3E%0A%20%20%20%20%20%20%20%20%3Cp%3E%26nbsp%3B%3C%2Fp%3E%0A%20%20%20%20%20%20%20%20%3Chr%20%2F%3E%0A%20%20%20%20%20%20%20%20%3Cdiv%20id%3D%22navcontainer%22%20class%3D%22navDiv%22%20style%3D%22padding-bottom%3A%2010px%3B%22%3E%0A%20%20%20%20%20%20%20%20%20%20%20%20%3Cp%3ELaunched%20by%20InTheShade.%3C%2Fp%3E%0A%20%20%20%20%20%20%20%20%20%20%20%20%3Cdiv%20id%3D%22paddingNav%22%20style%3D%22max-width%3A%200px%3B%22%3E%3C%2Fdiv%3E%0A%20%20%20%20%20%20%20%20%20%20%20%20%3Clink%5C%3E%3Ca%20class%3D%22navLink%22%20href%3D%22https%3A%2F%2Fgithub.com%2FTerabyte1385%2FInTheShade%22%3EView%20on%20GitHub%3C%2Fa%3E%3C%2Flink%3E%0A%20%20%20%20%20%20%20%20%3C%2Fdiv%3E%0A%20%20%20%20%3C%2Fdiv%3E%0A%3C%2Fbody%3E%0A%3C%2Fhtml%3E")!, callbackURLScheme: "\(scheme)") { (url, error) in
            if let error = error {
                result = StartEphermalSessionResult(success: false, error: error)
            }
        }
        if result.error != nil {
            return result
        }
        print(scheme)
        session.presentationContextProvider = self
        session.prefersEphemeralWebBrowserSession = true
        let sessionResult = session.start()
        return StartEphermalSessionResult(success: sessionResult, error: nil)
    }
}

struct ContentView: View {
    @StateObject var ephermalVM = EphermalViewModel()
    @State private var errorShow = false
    
    @State private var start: StartEphermalSessionResult? = nil
    
    var body: some View {
        VStack {
            Text("InTheShade is active. Check your Safari windows for the InTheShade Launchpad.")
            Text("It's safe to quit InTheShade if the private browsing window has opened.")
            HStack {
                Button(action: {
                    self.start = nil
                    self.start = ephermalVM.startEphermal()
                }, label: {
                    Text("Relaunch")
                })
                .padding()
                Button(action: {
                    exit(0)
                }, label: {
                    Text("Quit")
                })
                .padding()
            }
        }
        .onChange(of: errorShow, perform: { new in
            print("new errorShow value: \(new)")
        })
        // MARK: - NOT WORKING RIGHT NOW
        /*
        .onChange(of: start, perform: { new in
            print("start changed")
            if new == nil {
                self.errorShow = false
            } else {
                if new!.success == false {
                    errorShow = true
                } else {
                    if errorShow == false {
                        exit(0)
                    }
                }
            }
        })
         */
        // MARK: - [END] NOT WORKING RIGHT NOW
        .onAppear {
            self.start = ephermalVM.startEphermal()
        }
        .alert("Could not launch a private Safari session.\n\n\(self.start?.error == nil ? "An unknown error occured. Retry or restart InTheShade." : "\(self.start?.error?.localizedDescription ?? "An unknown error occured. Retry launching InTheShade.")")", isPresented: $errorShow) {
            Button("Retry") {
                self.errorShow = false
                self.start = nil
                self.start = ephermalVM.startEphermal()
            }
            Button("Cancel & Quit", role: .cancel) {
                exit(0)
            }
        }
        .padding()
    }
}
