# EcoRoute Mobile App Test

## Quick Start

1. Ensure you have Flutter installed. See [Flutter installation guide](https://docs.flutter.dev/get-started/install).
2. Clone the repo: `git clone <your-repo-url>`
3. Navigate to the project directory: `cd ECO_ROUTE_MOBILE`
4. Install dependencies: `flutter pub get`
5. Run the app on a simulator or device: `flutter run`

## Mock Data

- The mock route data is located at `assets/routes.json`.
- It is loaded via Flutter's asset bundle using `rootBundle.loadString`.

## Design Decisions

- **Framework:** Flutter was chosen for cross-platform mobile development.
- **State Management:** Provider package was used to manage route fetching state.
- **Networking:** The `http` package handles API calls; error handling is done with try/catch.
- **Project Structure:** Organized into folders:
  - `/assets` for static files including mock JSON.
  - `/models` for data models.
  - `/services` for networking logic.
  - `/screens` for UI components (Input, Results, Map).
- **Styling & UX:** Consistent spacing, typography, and touch targets ≥48×48 dp. Buttons provide clear loading and error feedback.

## Next Steps

To prepare this app for production, consider the following roadmap:

- Replace the mock routes JSON with a real backend API, adding authentication and secure data transfer.
- Implement caching mechanisms to minimize network usage and improve responsiveness.
- Add user authentication and profile management for personalized routes.
- Enhance UI/UX with animations, theming, and accessibility support.
- Set up automated testing, CI/CD pipelines, and deployment workflows.
- Optimize for different screen sizes and platforms.

These steps will ensure a robust, scalable, and user-friendly EcoRoute app.