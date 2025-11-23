# Universal Project Cleanup Script - Quick Start Guide

## 🚀 Quick Start

1. **Make the script executable:**
   ```bash
   chmod +x universal-project-cleanup.sh
   ```

2. **Run it:**
   ```bash
   # Clean current directory
   ./universal-project-cleanup.sh
   
   # Or clean a specific directory
   ./universal-project-cleanup.sh /path/to/your/projects
   ```

3. **That's it!** The script will automatically:
   - Find all Flutter, Node.js, Kotlin/Java, and Swift projects
   - Clean build artifacts and caches
   - Show you how much storage was freed

## 📋 What It Cleans

- ✅ Flutter projects: `build/`, `.dart_tool/`, `ios/Pods/`, `android/build/`
- ✅ Node.js projects: `node_modules/`, `.next/`, `dist/`, `build/`
- ✅ Kotlin/Java projects: `build/`, `.gradle/`, `out/`
- ✅ Swift/iOS projects: `.build/`, `DerivedData/`, `Pods/`

## ⚠️ Important Notes

- **Safe**: Only removes build artifacts, never touches source code
- **Reversible**: You can rebuild everything with `flutter pub get`, `npm install`, etc.
- **Cross-platform**: Works on macOS, Linux, and Windows (with Git Bash/WSL)

## 📖 Full Documentation

See `DEVELOPER_PROJECT_CLEANUP_BLOG.md` for complete guide with:
- Detailed explanations
- Manual cleanup methods
- Troubleshooting
- Best practices
- FAQ

## 🐛 Issues?

The script is designed to be safe and work out-of-the-box. If you encounter issues:
1. Make sure the script is executable: `chmod +x universal-project-cleanup.sh`
2. Check that you have read/write permissions in the target directory
3. See the full blog post for troubleshooting section

