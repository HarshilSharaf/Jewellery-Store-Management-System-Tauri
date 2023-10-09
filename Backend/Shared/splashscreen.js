function close_splashscreen() {
  const invoke = window.__TAURI__.invoke;
  // close splashscreen after app loads
  document.addEventListener("DOMContentLoaded", () => {
    // close splashscreen after 2.5 seconds
    setTimeout(() => {
      invoke("close_splashscreen");
    }, "2500");
  });
}

close_splashscreen();
