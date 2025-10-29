# Security Policy

## Supported Versions

We release patches for security vulnerabilities in the following versions:

| Version | Supported          |
| ------- | ------------------ |
| 1.1.x   | :white_check_mark: |
| 1.0.x   | :white_check_mark: |
| < 1.0   | :x:                |

## Reporting a Vulnerability

We take the security of Mr. Pomodoro seriously. If you believe you have found a security vulnerability, please report it to us responsibly.

### How to Report

**Please DO NOT open a public GitHub issue for security vulnerabilities.**

Instead, report security issues by email to:

**security@pomodorotimer.in**

or

**support@pomodorotimer.in**

### What to Include

Please include the following information in your report:

- **Type of vulnerability** (e.g., data exposure, injection, etc.)
- **Full description** of the vulnerability
- **Steps to reproduce** the issue
- **Potential impact** of the vulnerability
- **Affected versions** (iOS/Android version, app version)
- **Suggested fix** (if you have one)
- **Your contact information** for follow-up questions

### Example Report

```
Subject: [SECURITY] Potential data leak in statistics export

Description:
I discovered that the statistics export feature may inadvertently 
include sensitive session data in the exported file metadata.

Steps to Reproduce:
1. Open the Statistics screen
2. Export session data
3. Examine the exported file metadata

Impact:
Potentially exposes session timestamps to anyone with file access.

Affected Versions:
- iOS 1.1.0
- Android 1.1.0

Suggested Fix:
Strip metadata before file export or use a different export format.
```

## Response Timeline

We will acknowledge your email within **48 hours** and provide a more detailed response within **7 days** indicating the next steps in handling your report.

After the initial reply, we will:

1. **Investigate** the vulnerability thoroughly
2. **Develop a fix** if the report is confirmed
3. **Test** the fix across platforms
4. **Release** a security update
5. **Notify** you of the fix and publicly disclose (with credit, if desired)

## Disclosure Policy

- Security issues will be disclosed publicly only **after a fix is released**
- We will coordinate the disclosure with you if you discovered the vulnerability
- We will credit you in the security advisory (unless you prefer to remain anonymous)
- We ask for **90 days** to investigate and fix issues before public disclosure

## Security Best Practices for Users

### General Security

- ✅ Keep your app updated to the latest version
- ✅ Use official app stores only (App Store, Google Play)
- ✅ Enable device passcode/biometric authentication
- ✅ Review app permissions regularly
- ✅ Report suspicious behavior immediately

### Data Privacy

Mr. Pomodoro is designed with privacy as a core principle:

- **No cloud storage** - All data stays on your device
- **No analytics** - We don't track your usage
- **No third-party services** - No external connections
- **Local encryption** - Data protected by iOS/Android security
- **No accounts** - No login required, no passwords to leak

### Platform Security

**iOS:**
- Data protected by iOS sandbox and encryption
- Requires iOS 18.6+ with latest security updates
- Uses secure system APIs only

**Android:**
- Data protected by Android sandbox and app-specific storage
- Requires Android 8.0+ (API 26) with security patches
- Uses encrypted DataStore and Room database

## Security Features

### App-Level Security

- **No network connections** - Completely offline operation
- **Sandboxed storage** - App data isolated from other apps
- **No external dependencies** - Minimal third-party libraries
- **Code signing** - Verified app authenticity
- **Secure coding practices** - Input validation, error handling

### Data Protection

- **Local-only storage** - No remote data transmission
- **Encrypted databases** - Room/CoreData with encryption
- **Secure preferences** - DataStore/UserDefaults with protection
- **No logging** - Sensitive data never logged
- **Memory management** - Proper cleanup of sensitive data

## Known Security Considerations

### Current Limitations

1. **No account system** - Data cannot be recovered if device is lost (by design)
2. **Device-level security** - App security depends on device security
3. **Backup security** - Device backups may contain app data (controllable by user)

### Not Considered Vulnerabilities

The following are intentional design decisions, not security issues:

- App data accessible through device backups
- No password protection within the app (relies on device security)
- Statistics visible to anyone with device access
- No data encryption beyond OS-level protection

## Security Updates

Security updates will be released as:

- **Critical:** Immediate release (same day)
- **High:** 1-7 days
- **Medium:** Included in next regular release
- **Low:** Included in future releases

Users will be notified through:

- App Store/Play Store update notes
- In-app notifications (if applicable)
- GitHub security advisories
- Email (if you've reported the issue)

## Bug Bounty Program

Currently, we do not operate a formal bug bounty program. However:

- We deeply appreciate security research
- Contributors will be publicly credited (if desired)
- Significant findings may receive recognition/swag
- We may introduce a bounty program in the future

## Compliance

Mr. Pomodoro complies with:

- **GDPR** - EU data protection regulations
- **CCPA** - California privacy laws
- **App Store Guidelines** - Apple's privacy requirements
- **Play Store Policy** - Google's privacy requirements

See our [Privacy Policy](PrivacyPolicy.md) for details.

## Contact

For security concerns:

- **Email:** security@pomodorotimer.in or support@pomodorotimer.in
- **Response Time:** Within 48 hours
- **PGP Key:** Available upon request

For general issues:

- **GitHub Issues:** [Project Issues](https://github.com/avtansh-code/pomodoro_timer/issues)
- **Discussions:** [GitHub Discussions](https://github.com/avtansh-code/pomodoro_timer/discussions)

## Security Hall of Fame

We recognize security researchers who help keep Mr. Pomodoro safe:

*No security issues reported yet. Be the first to help us!*

---

## Acknowledgments

We thank the security community for helping keep Mr. Pomodoro safe for all users.

**Last Updated:** October 28, 2025

---

*This security policy is based on industry best practices and may be updated as needed.*
