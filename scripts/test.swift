import Foundation
import IOKit.ps

let callback: IOPowerSourceCallbackType = { context in
    print("Power state changed!")
}

let loopSource = IOPSNotificationCreateRunLoopSource(callback, nil).takeRetainedValue()
print("Listening...")
// CFRunLoopAddSource(CFRunLoopGetCurrent(), loopSource, .defaultMode)
// CFRunLoopRun()
