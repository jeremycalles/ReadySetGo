# How to Install ReadySetGo on Your iPhone

ReadySetGo is distributed via **AltStore**, so you can install it on your iPhone without the App Store.

---

## Prerequisites

- A Mac (with AltServer) or a Windows PC (with AltServer)
- Your iPhone
- USB cable (for first-time setup; wireless refresh may work afterward)
- Same Wi‑Fi network for your computer and iPhone (for wireless refresh)

---

## Step 1: Install AltStore on Your iPhone

### On your Mac

1. **Download AltServer** from [altstore.io](https://altstore.io) → **Download** → **macOS**.
2. **Install AltServer**: open the disk image and drag AltServer into **Applications**.
3. **Install the Mail plug-in** (required for AltStore on macOS):
   - Click the **AltServer icon** in the menu bar.
   - Choose **Install Mail Plug-in**.
   - Open **Mail** and enable the plug-in: **Mail → Settings (or Preferences) → Manage Plug-ins** → enable **AltPlugin**.
   - Restart Mail if prompted.
4. **Connect your iPhone** to your Mac with the USB cable.
5. In the menu bar: **AltServer → Install AltStore → [your iPhone name]**.
6. When asked on the iPhone, enter your **Apple ID** (a free account is enough). This is used only for signing the app on your device.
7. If you see **Untrusted Developer**: on the iPhone go to **Settings → General → VPN & Device Management**, tap the developer profile, then **Trust**.

AltStore should now appear on your home screen.

---

## Step 2: Add the ReadySetGo Source in AltStore

1. Open **AltStore** on your iPhone.
2. Tap **Browse** (or **Sources**).
3. Tap the **+** button (Add Source).
4. Enter this URL:

   ```
   https://raw.githubusercontent.com/jeremycalles/ReadySetGo/main/ReadySetGo/altstore/source.json
   ```

   If the repo’s default branch is **master** instead of **main**, use:

   ```
   https://raw.githubusercontent.com/jeremycalles/ReadySetGo/master/ReadySetGo/altstore/source.json
   ```

5. Tap **Add** (or **Done**).

The **ReadySetGo** source will appear in your list.

---

## Step 3: Install ReadySetGo

1. In AltStore, open the **ReadySetGo** source.
2. Find **ReadySetGo** in the app list.
3. Tap **Get** or **Install**.
4. Wait for the installation to finish.

ReadySetGo will appear on your home screen. Open it like any other app.

---

## Refreshing the App (About Every 7 Days)

Apps installed with AltStore use a free Apple ID and expire after about **7 days**. To keep ReadySetGo working:

- **With cable:** Connect your iPhone to your Mac and make sure **AltServer** is running. AltStore can then refresh the app.
- **Same Wi‑Fi:** Leave **AltServer** running on your Mac and your iPhone on the same Wi‑Fi network. Open **AltStore** on the iPhone and tap **Refresh All**.

Refreshing re-signs the app; you do not need to reinstall or lose data.

---

## Troubleshooting

| Issue | What to try |
|-------|---------------------|
| AltServer doesn’t see my iPhone | Use the USB cable; check that the device is trusted in Finder. |
| “Untrusted Developer” when opening the app | **Settings → General → VPN & Device Management** → tap the profile → **Trust**. |
| Refresh fails | iPhone and Mac on same Wi‑Fi; AltServer running; try again with the cable. |
| Source won’t add | Confirm the URL is correct and that you have internet. The repo’s default branch might be `main` or `master`. |

---

## Summary

1. Install **AltServer** on your Mac (or PC) and **AltStore** on your iPhone.
2. In AltStore, add the source URL above.
3. Install **ReadySetGo** from that source.
4. Refresh in AltStore about every 7 days so the app keeps working.
