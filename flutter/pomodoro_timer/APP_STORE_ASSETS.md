# App Store Assets & Marketing Guide

Complete guide for preparing marketing assets for Google Play Store and Apple App Store.

## Quick Overview

### Asset Directory Structure
```
assets/
├── icon/
│   ├── app_icon.png (1024x1024)
│   └── app_icon_foreground.png (1024x1024)
├── splash/
│   ├── splash_logo.png (512x512)
│   ├── splash_logo_dark.png (512x512)
│   ├── splash_logo_android12.png (512x512)
│   └── splash_logo_android12_dark.png (512x512)
└── store/
    ├── feature_graphic.png
    ├── promo_graphic.png
    └── screenshots/
        ├── android/
        └── ios/
```

---

## 📱 Google Play Store Assets

### Required Assets

#### 1. **App Icon** ✅ (Automated)
- **Size**: 512x512px
- **Format**: PNG (32-bit)
- **Note**: Generated automatically from `assets/icon/app_icon.png`

#### 2. **Feature Graphic** ⚠️ Required
- **Size**: 1024x500px
- **Format**: PNG or JPEG
- **File**: `assets/store/feature_graphic.png`
- **Purpose**: Displayed at top of store listing
- **Design Tips**:
  - Show app in use or key feature
  - Include app name/logo
  - Use brand colors (#FF5722)
  - Avoid text (auto-translated)
  - High contrast, eye-catching

#### 3. **Screenshots** ⚠️ Required (2-8 images)

**Phone Screenshots** (Required):
- **Size**: 1080x1920px or 1080x2340px (recommended)
- **Count**: Minimum 2, maximum 8
- **Format**: PNG or JPEG
- **Recommended**: 5 screenshots showing:
  1. Main timer screen (work session)
  2. Timer in break mode
  3. Settings screen
  4. Statistics/history view
  5. Theme selection or features

**Tablet Screenshots** (Optional but recommended):
- **Size**: 2560x1600px or 2960x1848px
- **Count**: Up to 8
- **Note**: Show tablet-optimized UI

**Design Guidelines**:
- Show actual app screenshots
- Add minimal overlay text if needed
- Use device frames (optional)
- Consistent style across all screenshots
- Show key features and benefits
- Include status bar (looks more real)

#### 4. **Promo Graphic** (Optional)
- **Size**: 180x120px
- **Format**: PNG or JPEG
- **Purpose**: Used in promotional campaigns
- **File**: `assets/store/promo_graphic.png`

#### 5. **Promo Video** (Optional)
- **Length**: 30 seconds to 2 minutes
- **Format**: YouTube or Vimeo link
- **Content**: App demo, features walkthrough

### Store Listing Text

**Short Description** (80 characters max):
```
Focus better with Pomodoro Timer. Simple, effective time management.
```

**Full Description** (4000 characters max):
```
🍅 Pomodoro Timer - Boost Your Productivity

Transform your work habits with the proven Pomodoro Technique! Our beautifully designed timer helps you focus, take breaks, and achieve more every day.

✨ KEY FEATURES

⏱️ Customizable Timer
• Set your perfect work duration (1-60 minutes)
• Adjust short and long break lengths
• Configure sessions before long breaks
• Visual countdown with session indicators

📊 Track Your Progress
• Comprehensive statistics and history
• View completed sessions by day, week, or month
• Monitor total focus time and breaks
• Celebrate your productivity streaks

🎨 Beautiful Design
• Material You design language
• Light and dark themes
• Smooth animations
• Intuitive, clutter-free interface

🔔 Smart Notifications
• Get notified when sessions complete
• Customizable notification sounds
• Haptic feedback for better UX
• Never miss a break!

⚙️ Flexible Settings
• Personalize timer durations
• Choose your preferred theme
• Adjust notification preferences
• Reset to defaults anytime

🌟 WHY POMODORO TECHNIQUE?

The Pomodoro Technique is a proven time management method:
1. Work for 25 minutes (1 Pomodoro)
2. Take a 5-minute break
3. After 4 Pomodoros, take a longer 15-30 minute break

Benefits:
✓ Improved focus and concentration
✓ Reduced mental fatigue
✓ Better time awareness
✓ Increased productivity
✓ Work-life balance

Perfect for:
• Students studying for exams
• Professionals working from home
• Freelancers managing projects
• Anyone wanting to boost productivity
• Teams using agile methodologies

📱 NO ADS. NO TRACKING. JUST FOCUS.

Your privacy matters. We don't collect personal data or show ads. Just a clean, simple timer to help you work better.

💪 START FOCUSING TODAY

Download now and experience the power of focused work sessions!

---

Keywords: pomodoro, timer, productivity, focus, time management, study timer, work timer, breaks, concentration, task management
```

---

##  App Store (iOS) Assets

### Required Assets

#### 1. **App Icon** ✅ (Automated)
- **Sizes**: Multiple (handled by flutter_launcher_icons)
- **Format**: PNG
- **Note**: Generated automatically

#### 2. **Screenshots** ⚠️ Required

**iPhone Screenshots** (Required for each):
- **6.9" Display** (iPhone 16 Pro Max): 1320x2868px or 1242x2688px
- **6.7" Display** (iPhone 15 Plus): 1290x2796px
- **6.5" Display** (iPhone 14 Plus): 1284x2778px
- **6.1" Display** (iPhone 15): 1179x2556px
- **5.5" Display** (iPhone 8 Plus): 1242x2208px

**iPad Screenshots** (Required if supporting iPad):
- **12.9" Display** (iPad Pro): 2048x2732px
- **11" Display** (iPad Pro): 1668x2388px

**Count**: 3-10 screenshots per device size
**Format**: PNG or JPEG

**Recommended Set** (5 screenshots):
1. Main timer with work session active
2. Break session view
3. Statistics screen showing data
4. Settings with customization options
5. Theme selection or key feature highlight

#### 3. **App Preview Video** (Optional but recommended)
- **Length**: 15-30 seconds
- **Format**: M4V, MP4, or MOV
- **Aspect Ratio**: Match device screenshots
- **Count**: Up to 3 per device size
- **Content**: Show app in action, key features

### App Store Text

**App Name** (30 characters max):
```
Pomodoro Timer
```

**Subtitle** (30 characters max):
```
Focus & Productivity
```

**Promotional Text** (170 characters - updatable anytime):
```
Boost your productivity with the proven Pomodoro Technique. Clean design, powerful features, no ads. Perfect for students, professionals, and teams!
```

**Description** (4000 characters max):
```
🍅 POMODORO TIMER - TRANSFORM YOUR PRODUCTIVITY

Focus better, work smarter, and achieve more with our beautifully designed Pomodoro Timer. Based on the proven Pomodoro Technique, this app helps you break work into focused intervals with regular breaks.

✨ POWERFUL FEATURES

CUSTOMIZABLE TIMER
• Set work sessions from 1-60 minutes
• Adjust short break duration
• Configure long break length
• Choose sessions before long break

COMPREHENSIVE STATISTICS
• Track all completed sessions
• View history by day, week, or month
• Monitor total focus time
• Visualize your productivity trends

BEAUTIFUL DESIGN
• Material 3 design language
• Light and dark themes
• Smooth, delightful animations
• Clean, distraction-free interface

SMART NOTIFICATIONS
• Session completion alerts
• Customizable sounds
• Haptic feedback
• Background support

⏱️ WHAT IS POMODORO TECHNIQUE?

The Pomodoro Technique is a time management method that uses a timer to break work into focused intervals:

1. Work for 25 minutes (1 Pomodoro)
2. Take a 5-minute break
3. After 4 Pomodoros, take a 15-30 minute break

🎯 PROVEN BENEFITS

✓ Enhanced focus and concentration
✓ Reduced mental fatigue
✓ Better time management
✓ Increased productivity
✓ Improved work-life balance
✓ Reduced procrastination

👥 PERFECT FOR

• Students preparing for exams
• Remote workers and freelancers
• Developers and designers
• Writers and content creators
• Anyone wanting better focus
• Teams using agile methods

🔒 PRIVACY FIRST

No ads. No tracking. No data collection. Just a clean, simple timer focused on helping you work better.

💪 START TODAY

Download now and experience the power of focused work!

---

App Store Keywords: pomodoro, timer, focus, productivity, study, work, time management, concentration, breaks
```

**Keywords** (100 characters max):
```
pomodoro,timer,focus,productivity,study,work,breaks,concentration,time management
```

---

## 🎨 Design Tools & Resources

### Recommended Tools

1. **Figma** (Free) - Professional design tool
2. **Canva** (Free/Paid) - Easy graphic creation
3. **Adobe Express** (Free/Paid) - Quick graphics
4. **Sketch** (Paid, Mac) - Professional design
5. **Affinity Designer** (One-time purchase) - Alternative to Adobe

### Icon Design Resources

- **Flaticon** - Free icons (attribute required)
- **Icons8** - Icon library
- **Font Awesome** - Icon fonts
- **Material Icons** - Google's icon set

### Screenshot Tools

**Android**:
- Device Art Generator (Android Studio)
- MockUPhone (online)
- Previewed.app (paid)

**iOS**:
- Screenshot frames built into Xcode
- Previewed.app (paid)
- App Store Screenshot Generator

---

## 📐 Design Specifications

### Brand Colors
- **Primary**: #FF5722 (Deep Orange)
- **Secondary**: #FF7043 (Light Deep Orange)
- **Background Light**: #FFFFFF
- **Background Dark**: #212121

### Typography
- **Primary Font**: Roboto (Android) / SF Pro (iOS)
- **Display**: Bold, 24-32pt
- **Body**: Regular, 14-16pt
- **Caption**: Regular, 12pt

### Icon Design Guidelines

1. **Simplicity**: Use simple, recognizable symbol
2. **Centering**: Keep main elements centered
3. **Padding**: Leave 10% margin around edges
4. **Contrast**: Works on light and dark backgrounds
5. **Colors**: Use brand colors (#FF5722)
6. **Symbol**: Timer, tomato, or clock symbol recommended

---

## ✅ Pre-Launch Checklist

### Graphics
- [ ] App icon created (1024x1024)
- [ ] Adaptive icon foreground created
- [ ] Splash screen images created
- [ ] Feature graphic created (Google Play)
- [ ] 5 phone screenshots captured
- [ ] Tablet screenshots captured (optional)
- [ ] iPad screenshots captured (if supporting)

### Text
- [ ] App description written
- [ ] Keywords researched and added
- [ ] Short description (Google Play)
- [ ] Subtitle (App Store)
- [ ] Promotional text written

### Legal
- [ ] Privacy policy URL ready
- [ ] Terms of service (if needed)
- [ ] Age rating determined
- [ ] Content rating questionnaire completed

### Store Listings
- [ ] Google Play developer account ($25 one-time)
- [ ] Apple Developer account ($99/year)
- [ ] App category selected
- [ ] Contact email set
- [ ] Support website URL added

---

## 🚀 Launch Strategy

### Pre-Launch (1-2 weeks before)
1. Beta test with friends/family
2. Collect feedback and fix bugs
3. Prepare all store assets
4. Set up analytics (if using)
5. Create social media accounts

### Launch Day
1. Submit to both stores
2. Announce on social media
3. Share with friends/family
4. Post in relevant communities (Reddit, ProductHunt)
5. Monitor reviews and ratings

### Post-Launch (Ongoing)
1. Respond to all reviews
2. Monitor crash reports
3. Plan feature updates
4. Track key metrics
5. Iterate based on feedback

---

**Last Updated**: January 7, 2026
**Status**: Ready for Asset Creation 📸
