import Foundation
import IOKit.ps
import AVFoundation
import AppKit

enum IntensityLevel: Int {
    case soft = 1
    case medium = 3
    case hard = 5
}

/// Preloads and plays layered, overlapping reactions with near-instant latency.
final class AudioEngine: NSObject {
    private var players: [AVAudioPlayer] = []
    private var nssoundCache: [String: NSSound] = [:]

    private let queue = DispatchQueue(label: "com.slapmac.audio", qos: .userInteractive)

    override init() {
        super.init()
    }

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

    private func retainPlayer(_ p: AVAudioPlayer) {
        players.append(p)
        if players.count > 32 {
            players.removeFirst(players.count - 32)
        }
    }
}

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

var lastPlayedURL: URL? = nil

let callback: IOPowerSourceCallbackType = { context in
    let currentState = getCurrentPowerSource()
    if currentState != lastState {
        if currentState == "AC Power" || currentState == "Battery Power" {
            let stateStr = currentState == "AC Power" ? "Plugged in!" : "Unplugged!"
            print(stateStr)
            var urls = getAudioURLs(in: "/Users/dr.arora/chargemebbg/sounds/in")
            
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

let loopSource = IOPSNotificationCreateRunLoopSource(callback, nil).takeRetainedValue()
CFRunLoopAddSource(CFRunLoopGetCurrent(), loopSource, .defaultMode)

// Play the startup sound
let startupURL = URL(fileURLWithPath: "/Users/dr.arora/chargemebbg/assets/startup.aiff")
engine.playCustomURLs([startupURL], intensity: .hard, volume: 1.0)

// Keep the script running
RunLoop.current.run()
