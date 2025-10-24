//
    // Project: MacOSNotesAppPersistence
    //  File: ContentView.swift
    //  Created by Noah Carpenter
    //  🐱 Follow me on YouTube! 🎥
    //  https://www.youtube.com/@NoahDoesCoding97
    //  Like and Subscribe for coding tutorials and fun! 💻✨
    //  Fun Fact: Cats have five toes on their front paws, but only four on their back paws! 🐾
    //  Dream Big, Code Bigger

/**
 A simple macOS notes view that persists text to disk.
 
 - How it works:
   - The text inside `TextEditor` is saved to a plain text file named `notes.txt`.
   - The file is stored in the app's Documents directory as resolved by `FileManager`.
 
 - Where do saved notes go?
   - In a sandboxed macOS app, the Documents directory resolves under the app container, typically:
     `~/Library/Containers/<your-app-bundle-identifier>/Data/Documents/notes.txt`
   - If you open that path in Finder (Go to Folder…), you'll see `notes.txt` after saving.
 
 - Tip: `print` statements in `loadNote()` show the resolved filename in the Xcode console.
 */
import SwiftUI
import AppKit
import UniformTypeIdentifiers

// MARK: - ContentView

/// Main view that provides a simple notes editor with Save/Load actions.
struct ContentView: View {
    /// The text currently being edited in the TextEditor.
    @State private var noteText = ""
    /// Short-lived status message shown below the buttons (e.g., "Saved!").
    @State private var saveMessage = ""
    
    /// The file location for the saved note.
    /// - Returns: A URL pointing to `notes.txt` inside the app's Documents directory.
    ///            In a sandboxed macOS app this maps to
    ///            `~/Library/Containers/<bundle-id>/Data/Documents/notes.txt`.
    var fileURL: URL {
        let manager = FileManager.default // Provides access to app sandbox file locations
        let docs = manager.urls(for: .documentDirectory, in: .userDomainMask).first! // The app-scoped Documents directory
        return docs.appendingPathComponent("notes.txt") // Append our filename
    }
    
    // MARK: - Body
    var body: some View {
        // Root layout for the notes screen
        VStack(spacing: 20) {
            // Title
            Text("Simple Notes")
                .font(.title2)
                .fontWeight(.semibold)
            
            TextEditor(text: $noteText) // Multiline text input bound to noteText
                .border(Color.gray.opacity(0.4))
                .frame(height: 250) // Give the editor a comfortable height
                .padding(.horizontal)
            
            // Actions: Save and Load
            HStack(spacing: 40) {
                Button(action: saveNote) { // Persist to disk
                    Label("Save", systemImage: "square.and.arrow.down.fill")
                }
                .buttonStyle(.borderedProminent)
                
                Button(action: loadNote) { // Read from disk if it exists
                    Label("Load", systemImage: "arrow.triangle.2.circlepath")
                }
                .buttonStyle(.bordered)
                
                Button(action: saveNoteAs) { // Let the user choose a location
                    Label("Save As…", systemImage: "square.and.arrow.down.on.square")
                }
                .buttonStyle(.bordered)
                .help("Choose where to save the note")
                
                // Quick link to show the file/folder in Finder
                Button(action: revealInFinder) {
                    Label("Reveal", systemImage: "folder")
                }
                .buttonStyle(.bordered)
                .help("Reveal the saved note in Finder")
            }
            
            // Transient status message (e.g., "Saved!")
            Text(saveMessage)
                .font(.caption)
                .foregroundColor(.green)
                .animation(.easeInOut, value: saveMessage)
        }
        .padding()
        .frame(minWidth: 400, minHeight: 400)
        // Load any existing note when the view first appears
        .onAppear {
            loadNote()
        }
    }
    
    // MARK: - Save Function
    
    /// Writes the current `noteText` to `fileURL` as UTF-8 text.
    /// Shows a brief success or error message.
    func saveNote() {
        do {
            try noteText.write(to: fileURL, atomically: true, encoding: .utf8) // Atomically write to our notes file
            showSaveMessage("Saved!")
        } catch {
            // Surface any error to the UI
            showSaveMessage("Save failed: \(error.localizedDescription)")
        }
    }
    
    // MARK: - Load Function
    
    /// Loads text from `fileURL` into `noteText` if the file exists.
    /// Prints the filename to the console for visibility.
    func loadNote() {
        let manager = FileManager.default // We'll check if the file exists first
        if manager.fileExists(atPath: fileURL.path) { // Only attempt to read if a saved note is present
            do {
                noteText = try String(contentsOf: fileURL, encoding: .utf8) // Populate the editor with saved content
                print("📂 Loaded from file: \(fileURL.lastPathComponent)")
            } catch {
                showSaveMessage("Load failed: \(error.localizedDescription)")
            }
        } else {
            print("ℹ️ No saved file found yet.") // Nothing saved yet
        }
    }
    
    // MARK: - Helper for Feedback
    
    /// Displays a status message for ~2 seconds, then clears it.
    func showSaveMessage(_ text: String) {
        saveMessage = text
        // Auto-clear the message after a short delay
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            saveMessage = ""
        }
    }
    
    /// Presents a Save Panel so the user can choose where to save the note.
    /// This keeps things sandbox-friendly while allowing saving to standard folders like ~/Documents.
    func saveNoteAs() {
        let panel = NSSavePanel()
        panel.title = "Save Note As"
        panel.nameFieldStringValue = "notes.txt"
        panel.allowedContentTypes = [.plainText]
        panel.canCreateDirectories = true

        panel.begin { response in
            guard response == .OK, let url = panel.url else { return }
            do {
                try noteText.write(to: url, atomically: true, encoding: .utf8)
                showSaveMessage("Saved to \(url.lastPathComponent)")
            } catch {
                showSaveMessage("Save failed: \(error.localizedDescription)")
            }
        }
    }
    
    /// Reveals the saved note (or its folder) in Finder so users can see where it lives
    /// in the sandboxed Documents directory.
    func revealInFinder() {
        let manager = FileManager.default
        let notePath = fileURL.path
        if manager.fileExists(atPath: notePath) {
            // If the file exists, select it in Finder
            NSWorkspace.shared.activateFileViewerSelecting([fileURL])
        } else {
            // If it doesn't exist yet, open the containing Documents folder
            let folderURL = fileURL.deletingLastPathComponent()
            NSWorkspace.shared.open(folderURL)
        }
    }
}

// Preview for Xcode canvas
#Preview {
    ContentView()
}

