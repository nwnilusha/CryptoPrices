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
- Offline/No-network detection and auto-refresh when network is restored
- Debug logs (visible only in **Debug mode**)
- Localization support (English, Spanish, French)
- UI Tests
- Unit tests for API layer and ViewModels
- Support for light and dark themes (system default + manual toggle)

## Tech Stack
- **Swift** Development language
- **MVVM-C architecture**
- **SwiftUI** for UI
- **Async/await** for networking
- **URLSession** for API calls
- **Dependency Injection**
- **AsyncImage** for remote image loading
- **Network Monitoring** using `NWPathMonitor`
- **Unit/UI Testing** with XCTest

## Project Structure
Features/ 
- CoinList/ – List of cryptocurrencies
- CoinDetail/ – Detailed coin info
- Settings/ – User preferences and theming
- DebugLogs/ – Debugging console (debug mode only)

Core/ 
- Networking/ → CoinService.swift
- NetworkMonitor/ → NetworkMonitor.swift
- Theme/ → ThemeManager.swift
- Extensions/ → Bundle extensions
- Coordinators/ → AppCoordinator.swift
- Components/ → Shared UI elements
- Mocks/ → mock data/services for previews and tests
  
Resources/
- Assets.xcassets
-  Localizable.strings (for localization)
  
Tests/
- Unit Test
- UI Test

## How to Run
1. Clone the repository:
```bash
git clone https://github.com/nwnilusha/CryptoPrices.git
```
2. Open `CryptoPrices.xcodeproj` in Xcode (Xcode 15+ recommended).
3. Build and run on Simulator or device.

## Theming
- Uses iOS system-provided **dynamic colors** for automatic light/dark adaptation.
- Includes a manual theme picker (System / Light / Dark).

## Possible Improvements
- Show sparkline charts using `Charts` framework
- Offline caching with SwiftData/NSCache

## License
This project is for interview/demo purposes only and uses the free CoinGecko public API.
