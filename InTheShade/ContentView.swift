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

import Foundation

func urlEncodeLaunchpadHTML() -> String? {
    // Get the path to the file in the app bundle
    guard let filePath = Bundle.main.path(forResource: "launchpad", ofType: "html") else {
        print("File not found.")
        return nil
    }
    
    do {
        // Read the file contents
        let fileContents = try String(contentsOfFile: filePath, encoding: .utf8)
        
        // URL encode the contents
        let allowedCharacterSet = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789-._~")
        if let encodedString = fileContents.addingPercentEncoding(withAllowedCharacters: allowedCharacterSet) {
            return encodedString
        } else {
            print("Failed to URL encode the file contents.")
            return nil
        }
    } catch {
        print("Error reading file: \(error)")
        return nil
    }
}

class EphermalViewModel: NSObject, ObservableObject, ASWebAuthenticationPresentationContextProviding {
    func presentationAnchor(for session: ASWebAuthenticationSession) -> ASPresentationAnchor {
        return ASPresentationAnchor()
    }
    func startEphermal() -> StartEphermalSessionResult {
        let scheme = UUID().uuidString
        var result = StartEphermalSessionResult(success: false, error: nil)
        if let encodedHTML = urlEncodeLaunchpadHTML() {
            let session = ASWebAuthenticationSession(url: URL(string: "data:text/html,\(encodedHTML)")!, callbackURLScheme: "\(scheme)") { (url, error) in
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
        } else {
            // Need to improve error handling
            fatalError("launchpad.html could not be found or accessed. App reinstallation likely required")
        }
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
