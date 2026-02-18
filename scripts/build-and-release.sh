#!/usr/bin/env bash
# Build ReadySetGo IPA and create a GitHub release for AltStore.
# Requires: Xcode, gh CLI (brew install gh), authenticated gh (gh auth login).
# Run from repo root: ./scripts/build-and-release.sh
#
# Signing: set EXPORT_OPTIONS_TEAM_ID to your Apple team ID (no commit), or
# copy ExportOptions.plist.example to ExportOptions.plist and set teamID (plist is gitignored).

set -e

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$REPO_ROOT"

# Refuse to run if any secret-bearing file is tracked (prevents accidental push)
for f in ExportOptions.plist "build/ExportOptions.plist" Configuration.xcconfig .env; do
  if git ls-files --error-unmatch "$f" &>/dev/null; then
    echo "Error: '$f' is tracked by git. Remove it (e.g. 'git rm --cached $f') to avoid uploading secrets." >&2
    exit 1
  fi
done

SCHEME="ReadySetGo"
CONFIGURATION="Release"
ARCHIVE_PATH="build/ReadySetGo.xcarchive"
EXPORT_PATH="build/export"
SOURCE_JSON="ReadySetGo/altstore/source.json"
PBXPROJ="$REPO_ROOT/ReadySetGo.xcodeproj/project.pbxproj"

# Require Release for distribution (no Debug builds)
if [[ "$CONFIGURATION" != "Release" ]]; then
  echo "Error: Refusing to build for release with configuration '$CONFIGURATION'. Set CONFIGURATION=Release." >&2
  exit 1
fi

# Compute next release version: v{MARKETING_VERSION}.{NEXT_BUILD} (e.g. v1.0.1, v1.0.2)
MARKETING_VERSION=$(grep -m1 "MARKETING_VERSION" "$PBXPROJ" | sed 's/.*= *\(.*\);/\1/' | tr -d ' ')
LATEST_TAG=$(gh release list --limit 1 -q .tagName 2>/dev/null || true)
if [[ -z "$LATEST_TAG" ]]; then
  NEXT_BUILD=1
else
  # Parse build from tag (e.g. v1.0.1 -> 1, v1.0.2 -> 2)
  LAST_NUM=$(echo "$LATEST_TAG" | sed 's/^v//; s/.*\.\([0-9]*\)$/\1/')
  NEXT_BUILD=$((LAST_NUM + 1))
fi
VERSION_TAG="v${MARKETING_VERSION}.${NEXT_BUILD}"
IPA_NAME="ReadySetGo-${MARKETING_VERSION}.${NEXT_BUILD}.ipa"

echo "==> Next release: $VERSION_TAG (build $NEXT_BUILD)"

# Bump build number in Xcode project so the IPA has the correct CFBundleVersion
sed -i '' "s/CURRENT_PROJECT_VERSION = [0-9]*;/CURRENT_PROJECT_VERSION = $NEXT_BUILD;/g" "$PBXPROJ"

# Resolve export options plist (never use committed secrets)
EXPORT_OPTS_PLIST=""
if [[ -n "${EXPORT_OPTIONS_TEAM_ID:-}" ]]; then
  mkdir -p build
  EXPORT_OPTS_PLIST="$REPO_ROOT/build/ExportOptions.plist"
  plutil -create xml1 -o "$EXPORT_OPTS_PLIST" - <<PLIST
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>method</key>
	<string>development</string>
	<key>teamID</key>
	<string>${EXPORT_OPTIONS_TEAM_ID}</string>
</dict>
</plist>
PLIST
elif [[ -f "$REPO_ROOT/ExportOptions.plist" ]]; then
  EXPORT_OPTS_PLIST="$REPO_ROOT/ExportOptions.plist"
else
  echo "Error: No export options. Either:" >&2
  echo "  1. Set EXPORT_OPTIONS_TEAM_ID (e.g. export EXPORT_OPTIONS_TEAM_ID=XXXXXXXXXX)" >&2
  echo "  2. Or copy ExportOptions.plist.example to ExportOptions.plist and set your teamID" >&2
  echo "     (ExportOptions.plist is gitignored and will not be committed)" >&2
  exit 1
fi

echo "==> Building $CONFIGURATION and archiving..."
rm -rf "$ARCHIVE_PATH" "$EXPORT_PATH"
xcodebuild archive \
  -scheme "$SCHEME" \
  -configuration "$CONFIGURATION" \
  -archivePath "$ARCHIVE_PATH" \
  -destination 'generic/platform=iOS' \
  -allowProvisioningUpdates \
  -quiet

echo "==> Exporting IPA..."
xcodebuild -exportArchive \
  -archivePath "$ARCHIVE_PATH" \
  -exportPath "$EXPORT_PATH" \
  -exportOptionsPlist "$EXPORT_OPTS_PLIST" \
  -quiet

# Exported app is typically named ReadySetGo.ipa
EXPORTED_IPA="$EXPORT_PATH/ReadySetGo.ipa"
if [[ ! -f "$EXPORTED_IPA" ]]; then
  echo "Expected IPA at $EXPORTED_IPA; contents of $EXPORT_PATH:"
  ls -la "$EXPORT_PATH"
  exit 1
fi

cp "$EXPORTED_IPA" "build/$IPA_NAME"
IPA_PATH="build/$IPA_NAME"
SIZE_BYTES=$(stat -f%z "$IPA_PATH" 2>/dev/null || stat --format=%s "$IPA_PATH" 2>/dev/null)

REPO=$(gh repo view --json nameWithOwner,defaultBranchRef -q .nameWithOwner)
DEFAULT_BRANCH=$(gh repo view --json defaultBranchRef -q .defaultBranchRef.name)
DOWNLOAD_URL="https://github.com/${REPO}/releases/download/${VERSION_TAG}/${IPA_NAME}"
SOURCE_URL="https://raw.githubusercontent.com/${REPO}/${DEFAULT_BRANCH}/ReadySetGo/altstore/source.json"
RELEASE_DATE=$(date +%Y-%m-%d)

echo "==> Updating source.json with new version $VERSION_TAG (size $SIZE_BYTES bytes)..."
python3 -c "
import json
with open('$SOURCE_JSON', 'r') as f:
    data = json.load(f)
new_entry = {
    'version': '$MARKETING_VERSION',
    'buildVersion': '$NEXT_BUILD',
    'date': '$RELEASE_DATE',
    'localizedDescription': 'Release $VERSION_TAG',
    'downloadURL': '$DOWNLOAD_URL',
    'size': $SIZE_BYTES,
    'minOSVersion': '26.0'
}
data['apps'][0]['versions'].insert(0, new_entry)
with open('$SOURCE_JSON', 'w') as f:
    json.dump(data, f, indent=2)
"

echo "==> Creating GitHub release $VERSION_TAG with $IPA_NAME..."
gh release create "$VERSION_TAG" "$IPA_PATH" \
  --title "$VERSION_TAG" \
  --notes "AltStore release. In AltStore: Browse → + → add source: ${SOURCE_URL}"

echo "==> Deleting IPA assets from older releases..."
while IFS= read -r tag; do
  [[ -z "$tag" || "$tag" == "$VERSION_TAG" ]] && continue
  while IFS= read -r asset_name; do
    [[ -z "$asset_name" ]] && continue
    case "$asset_name" in
      *.ipa) echo "  Removing $asset_name from $tag"; gh release delete-asset "$tag" "$asset_name" -y ;;
    esac
  done < <(gh release view "$tag" --json assets -q '.assets[].name' 2>/dev/null)
done < <(gh release list -q .tagName 2>/dev/null)
echo "==> Done removing old IPAs."

echo "==> Done. Commit the updated $SOURCE_JSON and $PBXPROJ and push so AltStore and the project stay in sync."
echo "   git add $SOURCE_JSON $PBXPROJ && git commit -m 'Release $VERSION_TAG' && git push"
