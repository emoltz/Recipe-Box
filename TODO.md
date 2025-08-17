# TODO - Recipe Box Development

## Core Development Tasks

### High Priority
- [ ] **Complete ContentView implementation** - Currently empty, needs recipe browsing UI
- [ ] **Finish scraper.swift main coordination logic** - Currently placeholder, needs main scraping orchestration
- [ ] **Implement AIExtractor functionality** in `ai_parser.swift` - Currently empty actor, needs OpenAI integration
- [ ] **Add robots.txt parsing** - Referenced in file structure but not implemented
- [ ] **Implement visited queue system** - File exists but needs queue logic for crawl management

### Data & Integration
- [ ] **Enable SwiftData integration** - Currently commented out in `recipe_boxApp.swift`
- [ ] **Create Recipe data model** - Define SwiftData model for storing parsed recipes
- [ ] **Set up proper environment configuration** - Create `.env` or config file for scraper settings
- [ ] **Add comprehensive error handling** - Enhance error handling across scraping components
- [ ] **Implement data persistence** - Connect parsed recipes to SwiftData storage

### UI/UX Development
- [ ] **Design recipe browsing interface** - Main view for displaying collected recipes
- [ ] **Add recipe detail view** - Individual recipe display with ingredients, instructions
- [ ] **Implement search functionality** - Search through saved recipes
- [ ] **Add filtering capabilities** - Filter by cuisine, difficulty, time, etc.
- [ ] **Create recipe import flow** - UI for adding new recipe URLs to scrape
- [ ] **Add settings screen** - Configure scraping parameters and preferences

### Testing & Quality
- [ ] **Expand unit test coverage** - Replace placeholder test with actual component tests
- [ ] **Add integration tests** - Test web scraping components end-to-end
- [ ] **Add UI tests** - Test recipe browsing and management workflows
- [ ] **Test AI parsing accuracy** - Validate AI extraction quality across different recipe sites
- [ ] **Add performance testing** - Test scraping performance and memory usage

### Advanced Features
- [ ] **Recipe categorization** - Auto-categorize recipes by cuisine, type, etc.
- [ ] **Duplicate detection** - Identify and merge duplicate recipes
- [ ] **Offline support** - Enable recipe viewing without internet
- [ ] **Export functionality** - Export recipes to various formats (PDF, text, etc.)
- [ ] **Recipe scaling** - Adjust ingredient quantities for different serving sizes
- [ ] **Shopping list generation** - Create shopping lists from selected recipes

### DevOps & Deployment
- [ ] **Set up proper app icons** - Replace placeholder app icons
- [ ] **Configure build settings** - Optimize for App Store deployment
- [ ] **Add app documentation** - User guide for recipe management features
- [ ] **Set up CI/CD pipeline** - Automated testing and deployment
- [ ] **App Store preparation** - Screenshots, descriptions, compliance

## Current State Notes
- Basic SwiftUI app shell in place
- Web scraping infrastructure mostly implemented but incomplete
- AI integration framework ready but not connected
- No UI beyond empty ContentView
- Testing framework set up but minimal coverage

## Environment Variables Reference
```
SCRAPER_CONCURRENCY=8          # Concurrent requests
SCRAPER_DELAY_MS=400          # Delay between requests per host
SCRAPER_MAX_DEPTH=1           # Maximum crawl depth
SCRAPER_USE_AI=false          # Enable AI parsing
OPENAI_MODEL=gpt-4o-2024-08-06 # OpenAI model for parsing
```