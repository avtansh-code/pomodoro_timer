# Mr. Pomodoro Website

Static marketing website for the Mr. Pomodoro Flutter app (iOS, Android, macOS, Windows).

---

## Overview

A modern, responsive static website showcasing the Mr. Pomodoro timer app built with Flutter. The site features clean design, fast loading, and excellent SEO optimization.

**Live Site**: [pomodorotimer.in](https://pomodorotimer.in)

---

## Features

- **Responsive Design** - Works perfectly on desktop, tablet, and mobile
- **Modern UI** - Clean, professional design with smooth animations
- **SEO Optimized** - Proper meta tags and semantic structure
- **Fast Loading** - Optimized CSS, minimal dependencies
- **Accessibility** - Semantic HTML and ARIA labels
- **Static Site** - No server-side processing required

---

## Structure

```
website/
├── www/                    # Static files
│   ├── index.html          # Landing page
│   ├── contact.html        # Contact/support page
│   ├── privacy.html        # Privacy policy
│   ├── 404.html            # Not found page
│   ├── css/
│   │   └── styles.css      # Main stylesheet
│   ├── favicon.png         # Site icon
│   ├── focus_ss.png        # Focus timer screenshot
│   └── stats_ss.png        # Statistics screenshot
│
├── app.yaml                # Google Cloud config
├── .gcloudignore          # Deployment ignore file
└── README.md               # This file
```

---

## Pages

### Landing Page (`index.html`)
- Hero section with app tagline
- Key features showcase (Flutter-focused)
- App screenshots (iOS & Android)
- Download buttons (App Store & Play Store)
- Pomodoro technique explanation
- Privacy commitment
- Footer with links

### Contact Page (`contact.html`)
- Support email contact
- FAQ section
- Social media links
- Issue reporting guidance

### Privacy Policy (`privacy.html`)
- Complete privacy policy
- Data handling information
- User rights
- Contact details

### 404 Page (`404.html`)
- Custom not found page
- Navigation back to home

---

## App Information

The website promotes the **Flutter-based** Mr. Pomodoro app:

| Attribute | Value |
|-----------|-------|
| **Framework** | Flutter (Cross-platform) |
| **Platforms** | iOS 17.0+, Android 13.0+, macOS, Windows |
| **Features** | Customizable timers, statistics, 5 themes, notifications, haptic feedback |
| **Privacy** | 100% offline, no tracking, local storage only |
| **Tests** | 200+ comprehensive tests |

---

## Deployment

### Option 1: GitHub Pages (Free)

```bash
# Push to GitHub
git add website/www/*
git commit -m "Update website"
git push origin main

# Enable GitHub Pages in repository settings
# Select source: main branch, /website/www folder
```

Site will be available at: `https://yourusername.github.io/repository-name`

### Option 2: Netlify (Free)

1. Create account at [netlify.com](https://netlify.com)
2. Connect GitHub repository
3. Set build directory to `website/www`
4. Deploy automatically on push

### Option 3: Vercel (Free)

```bash
# Install Vercel CLI
npm install -g vercel

# Deploy from website/www directory
cd website/www
vercel
```

### Option 4: Google Cloud Platform

```bash
# Install Google Cloud SDK
# Authenticate
gcloud auth login

# Deploy (from website directory)
cd website
gcloud app deploy

# View deployed site
gcloud app browse
```

---

## Customization

### Update Store Links

Store links in `index.html`:

```html
<!-- iOS App Store -->
<a href="https://apps.apple.com/in/app/mr-pomodoro/id6754535454">
  Download on the App Store
</a>

<!-- Google Play Store -->
<a href="https://play.google.com/store/apps/details?id=avtanshgupta.PomodoroTimer">
  Get it on Google Play
</a>
```

### Update Contact Information

Update email addresses in:
- `contact.html` - Support email
- `privacy.html` - Contact section
- `index.html` - Footer

### Add Analytics (Optional)

Add tracking code in `<head>` section:

```html
<!-- Google Analytics -->
<script async src="https://www.googletagmanager.com/gtag/js?id=GA_ID"></script>
<script>
  window.dataLayer = window.dataLayer || [];
  function gtag(){dataLayer.push(arguments);}
  gtag('js', new Date());
  gtag('config', 'GA_ID');
</script>
```

---

## Browser Support

| Browser | Version |
|---------|---------|
| Chrome | 70+ |
| Firefox | 65+ |
| Safari | 12+ |
| Edge | 79+ |
| Mobile browsers | ✅ |

---

## Performance

| Metric | Target |
|--------|--------|
| **Lighthouse Score** | 95+ on all metrics |
| **Page Load** | < 2 seconds on 3G |
| **Images** | Optimized and responsive |
| **CSS** | Minified and efficient |

---

## SEO Features

- Semantic HTML structure
- Open Graph meta tags
- Twitter Card support
- Proper heading hierarchy
- Alt tags for all images
- Mobile-friendly design

---

## Local Development

```bash
# Simple HTTP server (Python)
cd website/www
python3 -m http.server 8000

# Or using Node.js
npx http-server www -p 8000

# Visit: http://localhost:8000
```

---

## Maintenance

### Regular Updates

- Keep app version and requirements current
- Update screenshots when UI changes
- Refresh store links when available
- Update "Last Modified" dates

### Legal Compliance

- Keep privacy policy current
- Update effective dates when making changes
- Ensure store links are working
- Monitor for broken links

---

## Technical Stack

| Component | Technology |
|-----------|------------|
| **Markup** | HTML5 (Semantic) |
| **Styling** | CSS3 (Grid, Flexbox) |
| **JavaScript** | Minimal vanilla JS |
| **Framework** | None (pure static) |
| **Build Process** | None required |

---

## Related Documentation

- **[Main README](../README.md)** - Project overview
- **[Flutter App](../flutter/pomodoro_timer/README.md)** - Flutter development guide
- **[Deployment Guide](../DEPLOYMENT.md)** - Complete deployment instructions

---

## Support

- **Issues**: [GitHub Issues](https://github.com/avtansh-code/pomodoro_timer/issues)
- **Email**: support@pomodorotimer.in

---

**Deployment**: Static hosting  
**Framework**: None (vanilla HTML/CSS/JS)  
**Performance**: Optimized for speed