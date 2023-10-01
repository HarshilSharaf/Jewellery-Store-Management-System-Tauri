#![cfg_attr(
  all(not(debug_assertions), target_os = "windows"),
  windows_subsystem = "windows"
)]

use tauri::Manager;
use tauri_plugin_log::{LogTarget};
use log::LevelFilter;
#[derive(Clone, serde::Serialize)]
struct Payload {
  args: Vec<String>,
  cwd: String,
}

fn main() {
  tauri::Builder::default()
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
