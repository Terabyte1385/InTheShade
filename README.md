# InTheShade

An application which allows users to open Safari's Private Browsing mode, even when a workplace or school MDM profile, other configuration profile, or Screen Time controls won't allow them to.

It works by using the [ASWebAuthenticationSession](https://developer.apple.com/documentation/authenticationservices/aswebauthenticationsession) class to open a private login session... but to a local HTML instead, which can be used to open a new Private tab.
`ASWebAuthenticationSession` does not respect any Private Browsing mode restrictions, so it can be used to 'login' to InTheShade, which will help users launch a new Private Browsing tab.

## Compatibility
`ASWebAuthenticationSession` and `SwiftUI`, which are critical for the functionality of InTheShade, work with macOS Catalina (10.15) or later. However, InTheShade works with macOS Monterey (12) or later.
