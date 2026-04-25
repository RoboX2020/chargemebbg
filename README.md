<p align="center">
  <img src="assets/banner.png" alt="ChargeMeBBG Banner" width="100%">
</p>

<h1 align="center">ChargeMeBBG ⚡️💋</h1>

<p align="center">
  <strong>Zero-latency, hardware-level auditory feedback system for your Mac's power states.</strong>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/macOS-10.15%2B-black?style=for-the-badge&logo=apple" alt="macOS Version">
  <img src="https://img.shields.io/badge/Swift-5.5%2B-orange?style=for-the-badge&logo=swift" alt="Swift Version">
  <img src="https://img.shields.io/badge/Latency-Zero-brightgreen?style=for-the-badge" alt="Latency">
</p>

---

## What is this?
**ChargeMeBBG** is a natively compiled Swift daemon that listens to your Mac's `IOKit` hardware-level power interrupts. Instead of inefficiently polling your battery status, this engine reacts instantly the millisecond you plug or unplug your charging cable. 

When a power state change is detected, it utilizes an optimized `AVAudioPlayer` engine to inject randomized auditory feedback (from your personal library) directly into your speakers with zero spin-up lag.

Turn mundane charging into a dopamine hit.

## Features
- **Zero Polling:** Bypasses shell polling lag. Built on `IOPSNotificationCreateRunLoopSource` for true hardware interrupts.
- **Overlapping Audio:** Powered by `AVAudioPlayer` with asynchronous dispatch queues. Play multiple sounds simultaneously without clipping.
- **Smart Randomization:** Automatically randomizes through your sound library while intelligently preventing consecutive repeats.
- **Drop-in Library:** No hardcoding. Just drop `.mp3`, `.wav`, or `.aiff` files into the `sounds/in/` directory and they are instantly added to the rotation pool.

## Installation

1. **Clone the repository:**
   ```bash
   git clone https://github.com/RoboX2020/chargemebbg.git
   cd chargemebbg
   ```

2. **Compile the daemon:**
   ```bash
   swiftc chargemebbg.swift -o chargemebbg_daemon
   ```

3. **Run it silently in the background:**
   ```bash
   nohup ./chargemebbg_daemon > /dev/null 2>&1 &
   ```
   *The daemon will now persist silently. You can close your terminal.*

## Adding Your Own Sounds
This repository comes pre-loaded with a few curated AI and classic moans. 

Want to use your own? Simple:
1. Find your favorite `.mp3`, `.wav`, or `.aiff` sound bites.
2. Drop them into the `sounds/in/` folder.
3. **Done.** You don't even need to restart the daemon. The engine evaluates the directory dynamically on every trigger!

## Stopping the Daemon
If you ever need to stop the background listener:
```bash
pkill -f chargemebbg_daemon
```

---
<p align="center">
  <i>"Put it in."</i>
</p>
