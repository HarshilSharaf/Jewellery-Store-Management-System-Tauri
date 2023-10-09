#![cfg_attr(
  all(not(debug_assertions), target_os = "windows"),
  windows_subsystem = "windows"
)]

use tauri::Manager;
use tauri_plugin_log::{LogTarget};
use log::LevelFilter;
use tauri::{Window};

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
  window.get_window("splashscreen").expect("no window labeled 'splashscreen' found").close().unwrap();
  // Show main window
  window.get_window("main").expect("no window labeled 'main' found").show().unwrap();
}


fn main() {
  tauri::Builder::default()
      .invoke_handler(tauri::generate_handler![close_splashscreen])
      .plugin(tauri_plugin_sql::Builder::default().build())
      .plugin(tauri_plugin_store::Builder::default().build())
      .plugin(tauri_plugin_single_instance::init(|app, argv, cwd| {
          println!("{}, {argv:?}, {cwd}", app.package_info().name);
          app.emit_all("single-instance", Payload { args: argv, cwd })
              .unwrap();
      }))
      .plugin(tauri_plugin_log::Builder::default()
      // Use Local Time instead of UTC
      .timezone_strategy(tauri_plugin_log::TimezoneStrategy::UseLocal)
      // Only SAVE Error, WARN and INFO logs
      .level(LevelFilter::Info)
      .targets([
          LogTarget::LogDir,
          LogTarget::Stdout,
          LogTarget::Webview,
      ]).build())
      .run(tauri::generate_context!())
      .expect("error while running tauri application");
}
