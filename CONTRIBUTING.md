# Contributing to Mr. Pomodoro

Thank you for your interest in contributing to Mr. Pomodoro! We welcome contributions from the community and are excited to have you join us.

---

## 📋 Table of Contents

- [Code of Conduct](#code-of-conduct)
- [Getting Started](#getting-started)
- [Development Setup](#development-setup)
- [How to Contribute](#how-to-contribute)
- [Coding Standards](#coding-standards)
- [Commit Guidelines](#commit-guidelines)
- [Pull Request Process](#pull-request-process)
- [Testing Guidelines](#testing-guidelines)
- [Documentation](#documentation)
- [Community](#community)

---

## 📜 Code of Conduct

This project adheres to the Contributor Covenant [Code of Conduct](CODE_OF_CONDUCT.md). By participating, you are expected to uphold this code. Please report unacceptable behavior to support@pomodorotimer.in.

---

## 🚀 Getting Started

### Prerequisites

**For iOS Development:**
- macOS 13.0 or later
- Xcode 15.0 or later
- iOS 18.6 SDK
- Swift 5.0+

**For Android Development:**
- Android Studio Hedgehog or later
- JDK 17+
- Android SDK (API 26-34)
- Kotlin 1.9+

**For Website Development:**
- Any modern text editor
- Local web server (optional)
- Basic HTML/CSS/JavaScript knowledge

---

## 🛠️ Development Setup

### iOS Setup

```bash
# Clone the repository
git clone https://github.com/avtansh-code/pomodoro_timer.git
cd pomodoro_timer/iOS

# Open in Xcode
open PomodoroTimer.xcodeproj

# Build and run (⌘+R)
```

See [iOS/README.md](iOS/README.md) for detailed instructions.

### Android Setup

```bash
# Clone the repository
git clone https://github.com/avtansh-code/pomodoro_timer.git
cd pomodoro_timer/android

# Build the project
./gradlew build

# Run tests
./gradlew test

# Install on device/emulator
./gradlew installDebug
```

See [android/README.md](android/README.md) for detailed instructions.

### Website Setup

```bash
# Navigate to website directory
cd website/www

# Open in browser or use a local server
# Option 1: Direct file opening
open index.html

# Option 2: Python server
python3 -m http.server 8000

# Option 3: Node.js server
npx serve
```

See [website/README.md](website/README.md) for deployment instructions.

---

## 🤝 How to Contribute

### Reporting Bugs

Before creating a bug report, please check existing issues to avoid duplicates.

**When filing a bug report, include:**
- A clear, descriptive title
- Steps to reproduce the issue
- Expected behavior vs. actual behavior
- Screenshots or screen recordings (if applicable)
- Device/OS version and app version
- Relevant logs or error messages

**Use this template:**

```markdown
**Description:**
[Clear description of the bug]

**Steps to Reproduce:**
1. Go to '...'
2. Click on '...'
3. Scroll down to '...'
4. See error

**Expected Behavior:**
[What you expected to happen]

**Actual Behavior:**
[What actually happened]

**Environment:**
- Platform: iOS/Android
- OS Version: [e.g., iOS 18.6]
- App Version: [e.g., 1.1.0]
- Device: [e.g., iPhone 15 Pro]

**Screenshots:**
[If applicable]

**Additional Context:**
[Any other relevant information]
```

### Suggesting Enhancements

We welcome feature requests and enhancement suggestions!

**When suggesting an enhancement:**
- Use a clear, descriptive title
- Provide a detailed description of the proposed feature
- Explain why this enhancement would be useful
- Include mockups or examples (if applicable)
- Consider the scope (small, medium, large)

### Contributing Code

1. **Fork the repository**
2. **Create a feature branch** from `main`
   ```bash
   git checkout -b feature/your-feature-name
   ```
3. **Make your changes** following our coding standards
4. **Write/update tests** for your changes
5. **Update documentation** as needed
6. **Commit your changes** using conventional commits
7. **Push to your fork**
   ```bash
   git push origin feature/your-feature-name
   ```
8. **Open a Pull Request** with a clear description

---

## 📝 Coding Standards

### iOS (Swift)

**Follow Swift API Design Guidelines:**

```swift
// ✅ Good: Clear, descriptive names
func startFocusSession(duration: TimeInterval)
var completedSessionsCount: Int

// ❌ Avoid: Abbreviations and unclear names
func strtSes(dur: TimeInterval)
var cnt: Int
```

**Code Style:**
- Use 4 spaces for indentation
- Maximum line length: 120 characters
- Use `// MARK:` for code organization
- Document public APIs with doc comments
- Use `guard` for early returns
- Prefer `let` over `var` when possible

**Architecture:**
- Follow MVVM pattern
- Keep ViewModels testable (no UIKit dependencies)
- Use dependency injection
- Separate business logic from UI

### Android (Kotlin)

**Follow Kotlin Coding Conventions:**

```kotlin
// ✅ Good: Clear naming and structure
fun startFocusSession(duration: Duration)
val completedSessionsCount: Int

// ❌ Avoid: Poor naming
fun strt(d: Duration)
var cnt: Int
```

**Code Style:**
- Use 4 spaces for indentation
- Maximum line length: 120 characters
- Use KDoc for public APIs
- Follow Material Design guidelines
- Use Jetpack Compose best practices

**Architecture:**
- Follow Clean Architecture principles
- Maintain clear layer separation (Domain/Data/Presentation)
- Use Hilt for dependency injection
- Use StateFlow for reactive state
- Write unit tests for business logic

### General Best Practices

- **Write self-documenting code** with clear variable/function names
- **Keep functions small** and focused (single responsibility)
- **Avoid magic numbers** - use named constants
- **Handle errors gracefully** with proper error handling
- **Write defensive code** with input validation
- **Comment complex logic** but prefer clear code over comments
- **Follow DRY principle** (Don't Repeat Yourself)
- **Optimize for readability** over cleverness

---

## 💬 Commit Guidelines

We follow [Conventional Commits](https://www.conventionalcommits.org/) for clear commit history.

### Commit Message Format

```
<type>(<scope>): <subject>

<body>

<footer>
```

### Types

- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation changes
- `style`: Code style changes (formatting, no logic change)
- `refactor`: Code refactoring
- `perf`: Performance improvements
- `test`: Adding or updating tests
- `chore`: Maintenance tasks, dependencies

### Examples

```bash
# Feature
feat(timer): add long press to reset timer

# Bug fix
fix(stats): correct streak calculation for timezone changes

# Documentation
docs(readme): update installation instructions

# Refactoring
refactor(settings): extract duration picker into reusable component

# Performance
perf(timer): optimize circular progress rendering

# Test
test(timer): add unit tests for session completion
```

### Commit Message Guidelines

- Use present tense ("add feature" not "added feature")
- Use imperative mood ("move cursor to..." not "moves cursor to...")
- First line should be 50 characters or less
- Reference issues and PRs in the body when applicable
- Explain *what* and *why*, not *how* (code shows how)

---

## 🔄 Pull Request Process

### Before Submitting

- [ ] Code follows the project's coding standards
- [ ] All tests pass locally
- [ ] New tests added for new features
- [ ] Documentation updated (if applicable)
- [ ] No console warnings or errors
- [ ] Commits follow conventional commit format
- [ ] Branch is up to date with `main`

### PR Title Format

Follow the same convention as commit messages:

```
feat(timer): add pause notification action
fix(android): resolve notification crash on Android 14
docs: update contributing guidelines
```

### PR Description Template

```markdown
## Description
[Clear description of what this PR does]

## Type of Change
- [ ] Bug fix (non-breaking change fixing an issue)
- [ ] New feature (non-breaking change adding functionality)
- [ ] Breaking change (fix or feature causing existing functionality to not work as expected)
- [ ] Documentation update

## Related Issues
Fixes #[issue number]
Related to #[issue number]

## How Has This Been Tested?
- [ ] iOS Simulator
- [ ] iOS Device
- [ ] Android Emulator
- [ ] Android Device
- [ ] Unit Tests
- [ ] UI Tests

## Screenshots (if applicable)
[Add screenshots or screen recordings]

## Checklist
- [ ] My code follows the project's coding standards
- [ ] I have performed a self-review of my code
- [ ] I have commented my code, particularly in hard-to-understand areas
- [ ] I have updated the documentation accordingly
- [ ] My changes generate no new warnings
- [ ] I have added tests that prove my fix is effective or that my feature works
- [ ] New and existing unit tests pass locally
- [ ] Any dependent changes have been merged and published
```

### Review Process

1. **Automated checks** run on every PR (tests, linting)
2. **Code review** by at least one maintainer
3. **Address feedback** with additional commits
4. **Squash and merge** once approved
5. **Delete branch** after merge

### Getting Your PR Merged

- Respond to review comments promptly
- Keep the PR focused on a single concern
- Break large changes into smaller, reviewable PRs
- Be patient and respectful during review
- Update your PR if the base branch changes

---

## 🧪 Testing Guidelines

### Writing Tests

**iOS (XCTest):**

```swift
class TimerManagerTests: XCTestCase {
    var sut: TimerManager!
    
    override func setUp() {
        super.setUp()
        sut = TimerManager()
    }
    
    func testStartTimer_UpdatesState() {
        // Given
        let duration: TimeInterval = 1500
        
        // When
        sut.startTimer(duration: duration)
        
        // Then
        XCTAssertEqual(sut.state, .running)
        XCTAssertEqual(sut.remainingTime, duration)
    }
}
```

**Android (JUnit):**

```kotlin
class TimerManagerTest {
    private lateinit var timerManager: TimerManager
    
    @Before
    fun setup() {
        timerManager = TimerManager()
    }
    
    @Test
    fun `startTimer updates state correctly`() {
        // Given
        val duration = 1500L
        
        // When
        timerManager.startTimer(duration)
        
        // Then
        assertEquals(TimerState.RUNNING, timerManager.state.value)
        assertEquals(duration, timerManager.remainingTime.value)
    }
}
```

### Test Coverage

- Aim for **60%+ overall coverage**
- **80%+ coverage** for domain/business logic
- Test edge cases and error conditions
- Write integration tests for critical flows
- UI tests for key user journeys

### Running Tests

**iOS:**
```bash
# Run all tests
xcodebuild test -project PomodoroTimer.xcodeproj -scheme PomodoroTimer

# Run specific test
xcodebuild test -project PomodoroTimer.xcodeproj -scheme PomodoroTimer -only-testing:PomodoroTimerTests/TimerManagerTests
```

**Android:**
```bash
# Run all tests
./gradlew test

# Run specific test class
./gradlew test --tests TimerManagerTest

# Run with coverage
./gradlew testDebugUnitTestCoverage
```

---

## 📚 Documentation

### Code Documentation

**iOS (Swift DocC):**

```swift
/// Starts a new focus session with the specified duration.
///
/// This method initializes a new Pomodoro session and begins the countdown timer.
/// The timer will continue running even if the app is backgrounded.
///
/// - Parameter duration: The length of the focus session in seconds.
/// - Throws: `TimerError.alreadyRunning` if a session is already in progress.
/// - Note: Call `stopTimer()` to cancel the session before it completes.
func startFocusSession(duration: TimeInterval) throws {
    // Implementation
}
```

**Android (KDoc):**

```kotlin
/**
 * Starts a new focus session with the specified duration.
 *
 * This method initializes a new Pomodoro session and begins the countdown timer.
 * The timer will continue running even if the app is backgrounded.
 *
 * @param duration The length of the focus session in milliseconds.
 * @throws IllegalStateException if a session is already in progress.
 * @see stopTimer
 */
fun startFocusSession(duration: Duration) {
    // Implementation
}
```

### README Updates

When adding features or making significant changes:
- Update the main [README.md](README.md)
- Update platform-specific READMEs ([iOS](iOS/README.md), [Android](android/README.md))
- Add examples and usage instructions
- Update screenshots if UI changes

### Documentation Standards

- Use clear, concise language
- Include code examples
- Add diagrams for complex concepts
- Keep documentation up to date with code changes
- Use proper markdown formatting

---

## 👥 Community

### Communication Channels

- **GitHub Issues:** Bug reports and feature requests
- **GitHub Discussions:** General questions and community chat
- **Email:** support@pomodorotimer.in

### Getting Help

- Check existing documentation first
- Search closed issues for similar problems
- Ask clear, specific questions
- Provide context and examples
- Be patient and respectful

### Recognition

Contributors will be recognized in:
- Release notes for their contributions
- GitHub contributor graphs
- Special mentions for significant contributions

---

## 🏆 Recognition

We appreciate all contributions, big and small! Contributors are recognized through:

- Mention in release notes
- Contributor badge on GitHub
- Listing in project documentation
- Special recognition for major features

---

## 📧 Contact

For questions or concerns about contributing:

- **Email:** support@pomodorotimer.in
- **GitHub Issues:** [Project Issues](https://github.com/avtansh-code/pomodoro_timer/issues)
- **Response Time:** Within 48 hours

---

## 📄 License

By contributing to Mr. Pomodoro, you agree that your contributions will be licensed under the same license as the project. See [LICENSE](LICENSE) for details.

---

Thank you for contributing to Mr. Pomodoro! 🍅

**Together, we can build the best productivity app for everyone.**
