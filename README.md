# CreditApp

![Flutter](https://img.shields.io/badge/Flutter-%2302569B.svg?style=flat&logo=flutter&logoColor=white) ![Dart](https://img.shields.io/badge/Dart-%230175C2.svg?style=flat&logo=dart&logoColor=white) ![GetX](https://img.shields.io/badge/State%20Management-GetX-blueviolet)

**CreditApp** is a Flutter-based mobile application designed to simplify credit-related operations, such as creating transactions and managing shop selections. Built with clean architecture and GetX for state management, it offers a user-friendly interface with responsive design and robust functionality.

## Features

- **Transaction Creation:** Users can initiate credit transactions with a confirmation prompt to prevent accidental actions.
- **Shop Selection:** Displays a selected shop in a non-editable field (previously a dropdown), with loading states for fetching shop data.
- **Responsive UI:** Styled with rounded buttons, consistent padding, and dynamic font sizing.
- **State Management:** Leverages GetX for reactive state handling (e.g., loading indicators, button states).
- **Validation:** Includes form validation for critical inputs like shop IDs.

## Getting Started

### Prerequisites

- [Flutter SDK](https://flutter.dev/docs/get-started/install) (v3.x or later)
- [Dart](https://dart.dev/get-dart) (included with Flutter)
- An IDE (e.g., VS Code, Android Studio) with Flutter plugins
- A device/emulator for testing

### Installation

1. **Clone the Repository:**
   ```bash
   git clone https://github.com/abir-anhad/creditapp.git
   cd creditapp
   ```

2. **Install Dependencies:**
   ```bash
   flutter pub get
   ```

3. **Run the App:**
   ```bash
   flutter run
   ```
   Ensure a device or emulator is connected.


### Key Files

- **`transaction_controller.dart`:** Manages transaction creation and shop selection logic, including reactive states like `isCreatingTransaction` and `selectedShop`.
- **`shop_model.dart`:** Defines the `ShopModel` class with properties like `id` and `shopName`.
- **`shop_input.dart`:** Contains `_buildShopDropdown` (now a non-editable `TextFormField`) for displaying the selected shop.
- **`app_colors.dart`:** Centralizes color definitions (e.g., `AppColors.primary`).

## Usage

### Creating a Transaction
- Press the "Create Transaction" button.
- A confirmation dialog ("Are you sure?") appears.
- On "Yes," the `createTransaction()` method in the controller executes, with a loading spinner shown during processing.

### Viewing Selected Shop
- The shop field displays the name of the currently selected shop (e.g., `controller.selectedShop.value.shopName`).
- If shops are loading (`isLoadingShops.value`), a `CircularProgressIndicator` appears below the field.


## Contributing

1. Fork the repository.
2. Create a feature branch (`git checkout -b feature/new-feature`).
3. Commit changes (`git commit -m "Add new feature"`).
4. Push to the branch (`git push origin feature/new-feature`).
5. Open a Pull Request.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Contact

- **Author:** Abir Sarkar
- **GitHub:** [abir-anhad](https://github.com/abir-anhad)
- **Issues:** Report bugs or suggest features [here](https://github.com/abir-anhad/creditapp/issues)

---

### Assumptions & Customization
- **App Purpose:** Assumed to be credit-focused based on the name and code context (transactions, shops).
- **Tech Stack:** Inferred Flutter with GetX from `Obx`, `controller`, and Dart syntax.
- **Missing Details:** No specific backend, API, or model details were available, so I kept it generic. Add those if present (e.g., “Connects to a REST API at `api.creditapp.com`”).
- **License:** Assumed MIT as a common default; replace with the actual license if specified.
