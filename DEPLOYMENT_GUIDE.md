# GitHub Pages Deployment Guide

This guide will help you deploy your MkDocs documentation site to GitHub Pages.

## Prerequisites

- GitHub repository: `yuva19102003/DEVOPS-TOOL`
- GitHub Actions workflow already configured (`.github/workflows/deploy.yml`)

## Step-by-Step Deployment Instructions

### 1. Enable GitHub Pages

1. Go to your GitHub repository: https://github.com/yuva19102003/DEVOPS-TOOL
2. Click on **Settings** (top navigation bar)
3. In the left sidebar, click on **Pages** (under "Code and automation")
4. Under **Source**, select:
   - Source: **Deploy from a branch**
   - Branch: **gh-pages** (select from dropdown)
   - Folder: **/ (root)**
5. Click **Save**

### 2. Push Your Code to GitHub

Make sure all your changes are committed and pushed to the `main` branch:

```bash
# Add all files
git add .

# Commit changes
git commit -m "Add MkDocs documentation site with GitHub Pages deployment"

# Push to main branch
git push origin main
```

### 3. Monitor the Deployment

1. Go to the **Actions** tab in your GitHub repository
2. You should see a workflow run called "Deploy MkDocs Site"
3. Click on it to monitor the progress
4. Wait for the workflow to complete (green checkmark)

### 4. Access Your Documentation Site

Once the deployment is complete, your documentation will be available at:

**https://yuva19102003.github.io/DEVOPS-TOOL/**

## How It Works

The GitHub Actions workflow (`.github/workflows/deploy.yml`) automatically:

1. Triggers on every push to the `main` branch
2. Checks out your code
3. Sets up Python 3.11
4. Installs `mkdocs-material`
5. Runs `mkdocs gh-deploy` which:
   - Builds the static site from your Markdown files
   - Creates/updates the `gh-pages` branch
   - Pushes the built site to the `gh-pages` branch

GitHub Pages then serves the content from the `gh-pages` branch.

## Troubleshooting

### Workflow Fails

- Check the Actions tab for error messages
- Ensure the branch name is `main` (not `master`)
- Verify all file paths in `mkdocs.yml` are correct

### Site Not Loading

- Wait a few minutes after the first deployment
- Check that GitHub Pages is enabled and set to `gh-pages` branch
- Clear your browser cache

### 404 Errors on Pages

- Verify all file references in `mkdocs.yml` navigation match actual files
- Check that `docs_dir: ..` is correctly set in `mkdocs.yml`

## Making Updates

To update your documentation:

1. Edit your Markdown files
2. Commit and push to `main` branch
3. GitHub Actions will automatically rebuild and redeploy
4. Changes will be live in a few minutes

## Local Testing

Before pushing, always test locally:

```bash
cd docs-site
mkdocs serve
```

Then visit http://127.0.0.1:8000 to preview your changes.
