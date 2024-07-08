# InTheShade

An application which allows users to open Safari's Private Browsing mode, even when a workplace or school MDM profile, other configuration profile, or Screen Time controls won't allow them to.

<img width="1348" alt="Screenshot 2024-07-08 at 17 42 05" src="https://github.com/Terabyte1385/InTheShade/assets/78782971/9b2bf08c-dad5-4718-8160-132e88cabfb4">


It works by using the [ASWebAuthenticationSession](https://developer.apple.com/documentation/authenticationservices/aswebauthenticationsession) class to open a private login session... but to a local HTML instead, which can be used to open a new Private tab.
`ASWebAuthenticationSession` does not respect any Private Browsing mode restrictions, so it can be used to 'login' to InTheShade, which will help users launch a new Private Browsing tab.

## Compatibility
`ASWebAuthenticationSession` and `SwiftUI`, which are critical for the functionality of InTheShade, work with macOS Catalina (10.15) or later. 
However, InTheShade works with macOS Monterey (12) or later.

| macOS Version | Compatibility | Tested |
| ------------- | ------------- | ------ |
| Sequoia ¹⁵ | &#9745; Supported | &#9745; Yes |
| Sonoma ¹⁴ | &#9745; Supported | &#9745; Yes |
| Ventura ¹³ | &#9745; Supported | &#9746; No |
| Monterey ¹² | &#9745; Supported | &#9746; No |
| Big Sur ¹¹ | &#9745; Supported | &#9746; No |
| Catalina ¹⁰~¹⁵ | &#9745; Supported | &#9746; No |
| High Sierra ¹⁰~¹⁴ | &#9746; Unsupported | - |

## Installation
To install InTheShade:
- Go to [Releases](https://github.com/Terabyte1385/InTheShade/releases)
- Download the `InTheShade.app` file
- Launch from anywhere (recommended that you move InTheShade to the Applications folder for easy access)

## Contributing
**Have an issue or feature request?** -> Check [issues](https://github.com/Terabyte1385/InTheShade/issues/) and [create a new one](https://github.com/Terabyte1385/InTheShade/issues/new) if there isn't one matching your query.

**Have any other question?** -> [Start a Discussion](https://github.com/Terabyte1385/InTheShade/discussions)

**Do you know how to code and want to help develop the project?** -> Open the project in Xcode and create [pull requests](https://github.com/Terabyte1385/InTheShade/pull)
