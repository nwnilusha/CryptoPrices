# Crypto Prices iOS App

A simple SwiftUI iOS app that displays the cryptocurrencies by market cap using the [CoinGecko API](https://api.coingecko.com/api/v3/coins/markets?vs_currency=eur&order=market_cap_desc&per_page=100&page=1&sparkline=false).

## Features
- List of cryptocurrencies with:
  - Display name
  - Coin image
  - Current price (EUR)
  - 24h price change percentage
- Detail view with more information about the selected coin
- Pull-to-refresh functionality
- Search coins by name or symbol
- Pagination support for larger datasets
- Offline/No-network detection with retry option
- Debug logs (visible only in **Debug mode**)
- Localization support
- Unit tests for API layer and ViewModels
- Support for light and dark themes (system default + manual toggle)

## Tech Stack
- **Swift** Development language
- **MVVM-C architecture**
- **SwiftUI** for UI
- **Async/await** for networking
- **URLSession** for API calls
- **AsyncImage** for remote image loading
- **Network Monitoring** using `NWPathMonitor`
- **Unit Testing** with XCTest
---

## Project Structure
Features/
├── CoinList/        # List of cryptocurrencies
├── CoinDetail/      # Detailed coin info
├── Settings/        # User preferences and theming
└── DebugLogs/       # Debug console (Debug mode only)

Core/
├── Networking/      # API calls (CoinService)
├── NetworkMonitor/  # Reachability (NWPathMonitor)
├── Theme/           # Theme manager
├── Extensions/      # Utility extensions
├── Constants/       # CacheKeys and constants
├── Coordinators/    # AppCoordinator
├── Components/      # Shared UI components 
└── Mocks/           # Mock services & fake JSON for previews/tests

Resources/
├── Assets.xcassets
└── Localizable.strings (for localization)

## How to Run
1. Clone the repository:
```bash
git clone https://github.com/repo/crypto-prices-ios.git
```
2. Open `CryptoPrices.xcodeproj` in Xcode (Xcode 15+ recommended).
3. Build and run on Simulator or device.

## Theming
- Uses iOS system-provided **dynamic colors** for automatic light/dark adaptation.
- Includes a manual theme picker (System / Light / Dark).

## Possible Improvements
- Show sparkline charts using `Charts` framework
- Offline caching with SwiftData/CoreData

## License
This project is for interview/demo purposes only and uses the free CoinGecko public API.
