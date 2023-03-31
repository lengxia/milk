// Prevents additional console window on Windows in release, DO NOT REMOVE!!
#![cfg_attr(not(debug_assertions), windows_subsystem = "windows")]

use tauri::{window, Manager};
use window_vibrancy::{NSVisualEffectMaterial, NSVisualEffectState};
#[cfg(target_os = "macos")]
use window_vibrancy::apply_vibrancy;
#[cfg(target_os = "windows")]
use window_vibrancy::apply_blur;

// Learn more about Tauri commands at https://tauri.app/v1/guides/features/command
#[tauri::command]
fn greet(name: &str) -> String {
    format!("Hello, {}! You've been greeted from Rust!", name)
}
//https://zhuanlan.zhihu.com/p/539708101
fn main() {
    tauri::Builder::default()
        .setup(|app| {
            let window = app.get_window("main").unwrap();

            #[cfg(target_os = "macos")]
            apply_vibrancy(
                &window,
                NSVisualEffectMaterial::HudWindow,
                Some(NSVisualEffectState::Active),
                None,
            )
            .expect("当前系统不支持磨砂效果");

            #[cfg(target_os = "windows")]
            apply_blur(&window, Some((18, 18, 18, 125))).expect("当前系统不支持磨砂效果");

            Ok(())
        })
        .invoke_handler(tauri::generate_handler![greet])
        .run(tauri::generate_context!())
        .expect("error while running tauri application");
        
}
