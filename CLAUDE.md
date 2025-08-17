# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Development Commands

### Building and Running
- Build: `xcodebuild -project recipe_box.xcodeproj -scheme recipe_box build`
- Run tests: `xcodebuild test -project recipe_box.xcodeproj -scheme recipe_box -destination 'platform=iOS Simulator,name=iPhone 15'`
- Open in Xcode: `open recipe_box.xcodeproj`

### Testing
- Unit tests: Located in `recipe_boxTests/` using Swift Testing framework
- UI tests: Located in `recipe_boxUITests/`
- Run single test: Use Xcode Test Navigator or `xcodebuild test` with specific test methods

## Project Architecture

### App Structure
- **Main App**: SwiftUI-based iOS application with entry point in `recipe_boxApp.swift`
- **ContentView**: Primary UI view (currently empty implementation)
- **WebScraper Module**: Complete web scraping system located in `recipe_box/WebScraper/`

### WebScraper Components
- **config.swift**: Configuration management with environment variable support for concurrency, delays, depth limits, and AI integration
- **fetcher.swift**: HTTP client with retry logic, proper headers, and timeout handling
- **parser.swift**: HTML parsing using SwiftSoup to extract titles, text content, and links
- **ai_parser.swift**: AI-powered content extraction using SwiftOpenAI (placeholder implementation)
- **utils.swift**: Host-based request throttling to respect server limits
- **scraper.swift**: Main coordination logic (placeholder)
- **robots.txt & visited_queue.swift**: Web crawling utilities (not yet implemented)

### Dependencies
- **SwiftSoup**: HTML parsing and manipulation
- **SwiftOpenAI**: AI-powered content analysis and extraction
- **SwiftUI/SwiftData**: UI framework and data persistence (SwiftData currently commented out)

### Configuration
The scraper system uses environment variables for configuration:
- `SCRAPER_CONCURRENCY`: Number of concurrent requests (default: 8)
- `SCRAPER_DELAY_MS`: Delay between requests per host (default: 400ms)
- `SCRAPER_MAX_DEPTH`: Maximum crawl depth (default: 1)
- `SCRAPER_USE_AI`: Enable AI parsing (default: false)
- `OPENAI_MODEL`: OpenAI model to use (default: gpt-4o-2024-08-06)

## Development Notes

### Current State
- Basic app shell with SwiftUI setup
- Comprehensive web scraping infrastructure mostly implemented
- AI integration framework in place but not fully implemented
- SwiftData integration prepared but currently disabled
- Tests framework set up but minimal test coverage

### Key Patterns
- Actor-based concurrency for thread-safe operations (HostThrottler, AIExtractor)
- Environment-driven configuration for flexibility
- Structured data models for parsed content with optional AI enhancement
- Retry logic with exponential backoff for network resilience