# Mr. Pomodoro Website

Static marketing website for the Mr. Pomodoro app (iOS & Android).

---

## Overview

A modern, responsive static website showcasing the Mr. Pomodoro timer app. The site features clean design, fast loading, and excellent SEO optimization.

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
│   ├── css/
│   │   └── styles.css      # Main stylesheet
│   ├── favicon.png         # Site icon
│   ├── ios_focus.png       # iOS screenshot
│   └── android_focus.png   # Android screenshot
│
├── app.yaml                # Google Cloud config
├── .gcloudignore          # Deployment ignore file
└── README.md               # This file
```

---

## Pages

### Landing Page (`index.html`)
- Hero section with app tagline
- Key features showcase
- App screenshots
- Download buttons (iOS & Android)
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

Replace placeholder links in `index.html`:

```html
<!-- iOS App Store -->
<a href="YOUR_APP_STORE_URL">Download on the App Store</a>

<!-- Google Play Store -->
<a href="YOUR_PLAY_STORE_URL">Get it on Google Play</a>
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

- ✅ Chrome 70+
- ✅ Firefox 65+
- ✅ Safari 12+
- ✅ Edge 79+
- ✅ Mobile browsers

---

## Performance

- **Lighthouse Score**: 95+ on all metrics
- **Page Load**: < 2 seconds on 3G
- **Images**: Optimized and responsive
- **CSS**: Minified and efficient

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

- **HTML5** - Semantic markup
- **CSS3** - Modern styling with Grid and Flexbox
- **JavaScript** - Minimal vanilla JS for interactions
- **No Framework** - Pure static files
- **No Build Process** - Direct deployment

---

## Related Documentation

- **[Main README](../README.md)** - Project overview
- **[Privacy Policy](../PrivacyPolicy.md)** - Complete privacy information
- **[iOS App](../iOS/README.md)** - iOS development guide
- **[Android App](../android/README.md)** - Android development guide

---

## Support

- **Issues**: [GitHub Issues](https://github.com/avtansh-code/pomodoro_timer/issues)
- **Email**: support@pomodorotimer.in

---

**Deployment**: Static hosting  
**Framework**: None (vanilla HTML/CSS/JS)  
**Performance**: Optimized for speed
