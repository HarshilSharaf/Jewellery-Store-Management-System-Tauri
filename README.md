# Jewellery Store Management System - Tauri

This application is designed to manage jewellery stores and store their day-to-day data.
It operates offline and does not require an active internet connection. 
The main repository for running this project utilizes this [submodule](https://github.com/HarshilSharaf/Jewellery-Store-Management-System-Client/) for the client-side code.
The application runs on an Angular frontend and Tauri backend, and it requires a web view to be installed on the target device.

This application runs on Tauri v2 and Rust 1.77 or newer.

## Features

- Modern and Easy To Use UI
- Efficient RAM and Storage Consumption
- Error Logging
- Configurable Database
- Business Analytics Dashboard
- Customer Details Management (Save/Update/Delete)
- Product Management (Save/Update/Delete)
- Order Receipt Download as PDF

## Run Locally

On Linux Mint 22 or Ubuntu 24.04, install the Tauri 2 native dependencies first:

```bash
sudo apt update
sudo apt install -y \
  libwebkit2gtk-4.1-dev \
  build-essential \
  curl \
  wget \
  file \
  libssl-dev \
  libayatana-appindicator3-dev \
  librsvg2-dev
```

1. Clone the project:

```bash
git clone https://github.com/HarshilSharaf/Jewellery-Store-Management-System-Tauri
```
2. Navigate to the project directory:

```bash
cd Jewellery-Store-Management-System-Tauri
```

3. Install Project dependencies:

```bash
npm install
```

4. Update Tauri dependencies:

```bash
cd src-tauri
cargo check
```

5. Create the database schema:
   Run all the scripts provided in the following path:
    ```
    https://github.com/HarshilSharaf/Jewellery-Store-Management-System-Tauri/tree/main/Scripts
    ```
    To execute all scripts at once, follow these steps:
     - open cmd
     - ```cd Tables``` or ```cd Stored-Procedures\${CHILD_FOLDERS}```
     - ```for %S in (*.sql) do mysql -u USERNAME -pPASSWORD DATABASE < %S``` (Here Password should be entered **without** space after -p )
     - (Here, replace USERNAME, PASSWORD, and DATABASE with your MySQL credentials.)

6. Run the project

```bash
  npm run tauri dev
```

## Contributing
Contributions are welcome! Please create pull requests for any issues or feature requests.\
This project is still a work in progress.

## References
 - https://tauri.app/v1/guides/
 - https://tauri.app/v1/api/js/
