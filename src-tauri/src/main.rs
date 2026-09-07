#![cfg_attr(
    all(not(debug_assertions), target_os = "windows"),
    windows_subsystem = "windows"
)]

use log::LevelFilter;
use tauri::{Emitter, Manager, Window};
use tauri_plugin_log::{Target, TargetKind};

#[derive(Clone, serde::Serialize)]
struct Payload {
    args: Vec<String>,
    cwd: String,
}

// Create the command:
// This command must be async so that it doesn't run on the main thread.
#[tauri::command]
async fn close_splashscreen(window: Window) {
    // Close splashscreen
    window
        .get_webview_window("splashscreen")
        .expect("no window labeled 'splashscreen' found")
        .close()
        .unwrap();
    // Show main window
    window
        .get_webview_window("main")
        .expect("no window labeled 'main' found")
        .show()
        .unwrap();
}

fn main() {
    tauri::Builder::default()
        .invoke_handler(tauri::generate_handler![close_splashscreen])
        .plugin(tauri_plugin_process::init())
        .plugin(tauri_plugin_fs::init())
        .plugin(tauri_plugin_sql::Builder::default().build())
        .plugin(tauri_plugin_store::Builder::default().build())
        .plugin(tauri_plugin_single_instance::init(|app, argv, cwd| {
            println!("{}, {argv:?}, {cwd}", app.package_info().name);
            app.emit("single-instance", Payload { args: argv, cwd })
                .unwrap();
        }))
        .plugin(
            tauri_plugin_log::Builder::default()
                // Use Local Time instead of UTC
                .timezone_strategy(tauri_plugin_log::TimezoneStrategy::UseLocal)
                // Only SAVE Error, WARN and INFO logs
                .level(LevelFilter::Info)
                .targets([
                    Target::new(TargetKind::LogDir { file_name: None }),
                    Target::new(TargetKind::Stdout),
                    Target::new(TargetKind::Webview),
                ])
                .build(),
        )
        .run(tauri::generate_context!())
        .expect("error while running tauri application");
}
