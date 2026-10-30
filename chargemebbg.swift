// ============================================================================
// ChargeMeBBG - plays a random sound the instant you plug in or unplug your
// MacBook's charger. A joke project with real engineering: instead of
// checking the battery over and over (polling), it asks macOS to tap it on
// the shoulder the moment the power state changes.
//
// THE TWO VERSIONS IN THIS REPO:
//   - chargemebbg.swift (THIS FILE): the real one. A tiny always-on program
//     ("daemon") built on macOS's IOKit power notifications.
//   - scripts/chargemebbg.sh: an older, simpler Bash version that polls.
//
// OTHER FOLDERS:
//   sounds/in/    your sound library for plug-IN events (you add the files)
//   sounds/out/   sounds for unplug events
//   scripts/      helper scripts that download or generate sounds for you
//
// RUN IT:  swift chargemebbg.swift   (macOS only, needs no dependencies)
// NOTE: the sound folder path is hardcoded to one Mac below
// ("/Users/dr.arora/chargemebbg/sounds/in"). On any other machine, change
// that path or no sounds will be found. That hardcoding is left as-is.
// ============================================================================

// Apple's base toolbox: files, URLs, queues
import Foundation
// the power-source notifications (the whole point)
import IOKit.ps
// audio playback (AVAudioPlayer)
import AVFoundation
// macOS app bits (NSSound, used for the cache)
import AppKit

// How hard the charger "hit": louder sounds for harder plugs.
// The raw values (1/3/5) feed the volume boost math in playCustomURLs.
enum IntensityLevel: Int {
    case soft = 1
    case medium = 3
    case hard = 5
}

/// Preloads and plays layered, overlapping reactions with near-instant latency.
// AudioEngine owns playback. It keeps a bench of up to 32 recent players so
// several sounds can overlap without each new one stopping the last.
final class AudioEngine: NSObject {
    private var players: [AVAudioPlayer] = []
    private var nssoundCache: [String: NSSound] = [:]

    // All audio work happens on this dedicated line ("queue") marked
    // userInteractive = highest priority, so a sound never waits behind
    // background chores. That is where the "near-instant latency" comes from.
    private let queue = DispatchQueue(label: "com.slapmac.audio", qos: .userInteractive)

    override init() {
        super.init()
    }

    // Plays a list of sound files at once, slightly staggered (15 ms apart)
    // so overlapping sounds layer instead of digitally clashing.
    // volume is 0.0-1.0; intensity nudges it up (harder = louder).
    func playCustomURLs(_ urls: [URL], intensity: IntensityLevel, volume: Float) {
        queue.async {
            let v = max(0, min(1, volume))
            let boost = 0.55 + Double(intensity.rawValue) / 5.0 * 0.5
            for (i, url) in urls.enumerated() {
                let delay = 0.015 * Double(i)
                DispatchQueue.global(qos: .userInteractive).asyncAfter(deadline: .now() + delay) {
                    do {
                        let p = try AVAudioPlayer(contentsOf: url)
                        p.volume = Float(boost) * v
                        p.prepareToPlay()
                        p.play()
                        self.retainPlayer(p)
                    } catch {
                        print("Failed to play \(url): \(error)")
                    }
                }
            }
        }
    }

    // Keeps a played sound alive until it finishes (AVAudioPlayer goes
    // silent immediately if nothing holds onto it). Caps the bench at 32
    // players, dropping the oldest.
    private func retainPlayer(_ p: AVAudioPlayer) {
        players.append(p)
        if players.count > 32 {
            players.removeFirst(players.count - 32)
        }
    }
}

// Lists every sound file in a folder. Only .mp3/.aiff/.wav/.m4a count.
// Returns an empty list (not an error) if the folder is missing.
func getAudioURLs(in directory: String) -> [URL] {
    let fm = FileManager.default
    guard let contents = try? fm.contentsOfDirectory(atPath: directory) else { return [] }
    let validExts = [".mp3", ".aiff", ".wav", ".m4a"]
    let validFiles = contents.filter { file in
        validExts.contains { file.lowercased().hasSuffix($0) }
    }
    return validFiles.map { URL(fileURLWithPath: directory + "/" + $0) }
}

let engine = AudioEngine()

// Asks macOS what is feeding the computer right now:
// "AC Power" (charger in), "Battery Power" (unplugged), or "Unknown".
func getCurrentPowerSource() -> String {
    let snapshot = IOPSCopyPowerSourcesInfo().takeRetainedValue()
    let sources = IOPSCopyPowerSourcesList(snapshot).takeRetainedValue() as Array
    for source in sources {
        let description = IOPSGetPowerSourceDescription(snapshot, source).takeUnretainedValue() as! [String: Any]
        if let state = description[kIOPSPowerSourceStateKey] as? String {
            return state // usually "AC Power" or "Battery Power"
        }
    }
    return "Unknown"
}

var lastState = getCurrentPowerSource()

// Remembers the last sound played so the same one never plays twice in a row.
var lastPlayedURL: URL? = nil

// The heart of the program: macOS calls this function itself the instant
// the power state changes (plug in, unplug, battery swap, ...).
let callback: IOPowerSourceCallbackType = { context in
    let currentState = getCurrentPowerSource()
    if currentState != lastState {
        if currentState == "AC Power" || currentState == "Battery Power" {
            let stateStr = currentState == "AC Power" ? "Plugged in!" : "Unplugged!"
            print(stateStr)
            var urls = getAudioURLs(in: "/Users/dr.arora/chargemebbg/sounds/in")
            
            // No repeats back-to-back: remove the previous sound from the hat.
            if urls.count > 1, let last = lastPlayedURL, let index = urls.firstIndex(of: last) {
                urls.remove(at: index)
            }
            
            if let randomURL = urls.randomElement() {
                lastPlayedURL = randomURL
                engine.playCustomURLs([randomURL], intensity: .hard, volume: 1.0)
            }
        }
        lastState = currentState
    }
}

print("Starting chargemebbg Swift Daemon... Listening for power events with near-instant latency!")
print("Waiting for you to plug in or unplug your charger!")

// Register the callback above with macOS and attach it to the run loop
// (the program's idle "wait for something to happen" loop).
let loopSource = IOPSNotificationCreateRunLoopSource(callback, nil).takeRetainedValue()
CFRunLoopAddSource(CFRunLoopGetCurrent(), loopSource, .defaultMode)

// Play the startup sound
let startupURL = URL(fileURLWithPath: "/Users/dr.arora/chargemebbg/assets/startup.aiff")
engine.playCustomURLs([startupURL], intensity: .hard, volume: 1.0)

// Keep the script running
// Park the program in the run loop forever; only power events wake it.
RunLoop.current.run()
