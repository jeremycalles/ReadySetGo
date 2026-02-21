#!/usr/bin/env bash
# Archive, export, and optionally upload ReadySetGo to App Store Connect.
# Usage:
#   ./scripts/archive-and-upload.sh           # archive + export only
#   ./scripts/archive-and-upload.sh --upload   # archive + export + upload (requires API key or Apple ID)
#
# Prerequisites:
#   - Xcode command line tools, signing configured in Xcode (Team set on target).
#   - For export: copy scripts/ExportOptions.plist.example to scripts/ExportOptions.plist
#     and set your teamID (from Apple Developer → Membership).
#   - For upload: App Store Connect API key (team) or Apple ID + app-specific password.

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
SCHEME="ReadySetGo"
ARCHIVE_NAME="ReadySetGo.xcarchive"
ARCHIVE_PATH="$PROJECT_ROOT/build/$ARCHIVE_NAME"
EXPORT_PATH="$PROJECT_ROOT/build/export"
EXPORT_OPTIONS_PLIST="${EXPORT_OPTIONS_PLIST:-$SCRIPT_DIR/ExportOptions.plist}"
IPA_NAME="ReadySetGo.ipa"
IPA_PATH="$EXPORT_PATH/$IPA_NAME"

UPLOAD=false
if [[ "${1:-}" == "--upload" ]]; then
  UPLOAD=true
fi

cd "$PROJECT_ROOT"

echo "==> Archiving scheme: $SCHEME"
xcodebuild archive \
  -scheme "$SCHEME" \
  -configuration Release \
  -destination "generic/platform=iOS" \
  -archivePath "$ARCHIVE_PATH" \
  -allowProvisioningUpdates

if [[ ! -f "$EXPORT_OPTIONS_PLIST" ]]; then
  echo " error: ExportOptions.plist not found at $EXPORT_OPTIONS_PLIST"
  echo " Copy scripts/ExportOptions.plist.example to scripts/ExportOptions.plist and set your teamID."
  exit 1
fi

echo "==> Exporting IPA for App Store Connect"
rm -rf "$EXPORT_PATH"
mkdir -p "$EXPORT_PATH"
xcodebuild -exportArchive \
  -archivePath "$ARCHIVE_PATH" \
  -exportPath "$EXPORT_PATH" \
  -exportOptionsPlist "$EXPORT_OPTIONS_PLIST"

if [[ ! -f "$IPA_PATH" ]]; then
  echo " error: Expected IPA at $IPA_PATH"
  exit 1
fi
echo "==> IPA ready: $IPA_PATH"

if [[ "$UPLOAD" != "true" ]]; then
  echo "==> Done. To upload, run: $0 --upload"
  exit 0
fi

echo "==> Uploading to App Store Connect"
if [[ -n "${APP_STORE_CONNECT_API_KEY_ID:-}" && -n "${APP_STORE_CONNECT_ISSUER_ID:-}" ]]; then
  # API key auth: put AuthKey_<KEY_ID>.p8 in ~/.appstoreconnect/private_keys/ or set API_PRIVATE_KEYS_DIR
  xcrun altool --upload-app -f "$IPA_PATH" \
    --api-key "$APP_STORE_CONNECT_API_KEY_ID" \
    --api-issuer "$APP_STORE_CONNECT_ISSUER_ID"
else
  # Interactive: prompts for Apple ID and app-specific password
  echo " No API key in env. You will be prompted for Apple ID and app-specific password."
  echo " Generate an app-specific password at appleid.apple.com → Sign-In and Security."
  xcrun altool --upload-app -f "$IPA_PATH"
fi

echo "==> Upload finished. Build will appear in App Store Connect after processing."
