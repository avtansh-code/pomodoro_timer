# Website Deployment Setup

This document explains how to set up automatic deployment of the website to the `mr_pomodoro` repository.

## GitHub Workflow

The workflow `.github/workflows/deploy-website.yml` automatically deploys the website files to `https://github.com/avtansh-code/mr_pomodoro` whenever changes are pushed to the `website/` directory.

## Setup Instructions

### 1. Create a Personal Access Token (PAT)

1. Go to GitHub Settings → Developer settings → Personal access tokens → Tokens (classic)
   - Or visit: https://github.com/settings/tokens
2. Click "Generate new token" → "Generate new token (classic)"
3. Give it a descriptive name: `Deploy to mr_pomodoro`
4. Set expiration (recommended: 90 days or 1 year)
5. Select the following scopes:
   - ✅ `repo` (Full control of private repositories)
6. Click "Generate token"
7. **IMPORTANT:** Copy the token immediately (you won't be able to see it again)

### 2. Add the Token as a Repository Secret

1. Go to this repository: `https://github.com/avtansh-code/pomodoro_timer`
2. Navigate to Settings → Secrets and variables → Actions
3. Click "New repository secret"
4. Name: `DEPLOY_TOKEN`
5. Value: Paste the Personal Access Token you created
6. Click "Add secret"

### 3. Verify the Setup

1. Make a change to any file in the `website/` directory
2. Commit and push to the `main` branch
3. Go to the Actions tab in this repository
4. You should see the "Deploy Website to mr_pomodoro Repository" workflow running
5. Once complete, check the `mr_pomodoro` repository to verify the files were deployed

## How It Works

The workflow:
1. Triggers on any push to `main` branch that affects `website/**` files
2. Copies all files from `website/www/` and `website/css/` directories
3. Pushes them to the `main` branch of `avtansh-code/mr_pomodoro` repository
4. Uses force push to ensure the target repo is always up to date

## Manual Trigger

You can also manually trigger the deployment:
1. Go to Actions tab
2. Select "Deploy Website to mr_pomodoro Repository"
3. Click "Run workflow"
4. Select the `main` branch
5. Click "Run workflow"

## Troubleshooting

### Workflow fails with authentication error
- Verify the `DEPLOY_TOKEN` secret is set correctly
- Check if the PAT has expired
- Ensure the PAT has `repo` scope permissions

### Files not appearing in target repository
- Check the workflow logs in the Actions tab
- Verify the target repository exists: `https://github.com/avtansh-code/mr_pomodoro`
- Ensure you have write access to the target repository

### Workflow doesn't trigger automatically
- Verify changes were made to files in the `website/` directory
- Check if the workflow file is on the `main` branch
- Review the workflow syntax for any errors

## Security Notes

- The Personal Access Token should be kept secure
- Only store it as a GitHub secret, never commit it to the repository
- Regenerate the token if it's ever compromised
- Consider setting an expiration date and renewing it regularly
