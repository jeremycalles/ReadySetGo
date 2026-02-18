# How to Install ReadySetGo on Your iPhone

ReadySetGo is distributed via **AltStore**, so you can install it on your iPhone without the App Store.

---

## Prerequisites

- Your **iPhone**
- A **computer** (for first-time AltStore setup)
- **USB cable** for first-time setup (wireless refresh may work afterward)
- Computer and iPhone on the **same Wi‑Fi network** for wireless refresh

---

## Step 1: Install AltStore on Your iPhone

AltStore must be installed on your iPhone before you can add the ReadySetGo source. Installation is done from a computer.

1. On your **computer**, go to [altstore.io](https://altstore.io) and download the installer for your operating system.
2. Follow the on-screen instructions to install the helper app and then **install AltStore** onto your iPhone (via USB when prompted).
3. When prompted on the **iPhone**, enter your **Apple ID** (a free account is fine). It is used only to sign the app on your device.
4. If you see **Untrusted Developer**: on the iPhone go to **Settings → General → VPN & Device Management**, tap the developer profile, then **Trust**.

AltStore should now appear on your home screen.

---

## Step 2: Add the ReadySetGo Source in AltStore

1. Open **AltStore** on your iPhone.
2. Tap **Browse** (or **Sources**).
3. Tap the **+** button (**Add Source**).
4. Enter this URL exactly:

   ```
   https://raw.githubusercontent.com/jeremycalles/ReadySetGo/main/ReadySetGo/altstore/source.json
   ```

   This repo uses the **main** branch.

5. Tap **Add** (or **Done**).

The **ReadySetGo** source will appear in your list. You should see the ReadySetGo app with its icon.

---

## Step 3: Install ReadySetGo

1. In AltStore, open the **ReadySetGo** source.
2. Find **ReadySetGo** in the app list.
3. Tap **Get** or **Install**.
4. Wait for the installation to finish.

ReadySetGo will appear on your home screen. Open it like any other app.

---

## Refreshing the App (About Every 7 Days)

Apps installed with AltStore are signed with your Apple ID and expire after about **7 days**. To keep ReadySetGo working:

- **With cable:** Connect your iPhone to the computer you used to install AltStore. Open **AltStore** on the iPhone and tap **Refresh All** (or refresh ReadySetGo).
- **Over Wi‑Fi:** Keep that computer on and on the same Wi‑Fi network as your iPhone. Open **AltStore** on the iPhone and tap **Refresh All**.

Refreshing re-signs the app; you do not need to reinstall or lose data.

### Automating the refresh

You can make refresh easier so you don’t have to open AltStore every time:

1. **Siri Shortcut (recommended)**  
   On your iPhone: open **Shortcuts** → **+** → **Add Action** → search for **AltStore** → add **Refresh All Apps** → name the shortcut (e.g. “Refresh AltStore”) and save.  
   Then you can:
   - Tap the shortcut in Shortcuts, or  
   - Say **“Hey Siri, refresh all apps”** (or the shortcut name) when your iPhone and the computer you used for setup are on the same Wi‑Fi.

2. **Weekly reminder**  
   In **Reminders**, create a recurring reminder every **6 days** (e.g. “Refresh ReadySetGo”) so you’re prompted before the 7-day expiry. When the reminder fires, run the shortcut above or open AltStore and tap **Refresh All**.

3. **Personal Automation (optional)**  
   In Shortcuts → **Automation** → **+** → **Create Personal Automation**, you can add a trigger such as **When I arrive** (e.g. at home, where Wi‑Fi matches your computer). Add the “Refresh All Apps” action. Note: some automations still require you to tap **Run** when the trigger fires.

For refresh over Wi‑Fi to work, the computer you used to install AltStore must be on and on the same Wi‑Fi network when you run the shortcut or refresh.

---

## Troubleshooting

| Issue | What to try |
|-------|-------------|
| Computer doesn’t see my iPhone | Use the USB cable and ensure the device is trusted on your computer. |
| “Untrusted Developer” when opening the app | **Settings → General → VPN & Device Management** → tap the developer profile → **Trust**. |
| **“No value associated with key … iconURL”** when adding the source | You need the source from the **main** branch (URL above). Ensure the repo is up to date and use the exact source URL; do not use a direct GitHub repo URL. |
| Source won’t add or shows an error | Check the URL (no typos, `main` not `maii`). Ensure you have internet. Try again; sometimes the raw CDN is slow. |
| Refresh fails | iPhone and computer on same Wi‑Fi; computer on and running the same helper used at setup; try again with the USB cable. |

---

## Summary

1. Install **AltStore** on your iPhone (using your computer and the instructions at [altstore.io](https://altstore.io)).
2. In AltStore, add the source URL from Step 2.
3. Install **ReadySetGo** from that source.
4. Refresh in AltStore about every 7 days so the app keeps working.
