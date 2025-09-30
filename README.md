# Evergreenix Flutter Task

A Flutter application demonstrating authentication features with comprehensive unit testing, API integration, and modern architectural patterns.

## 🚀 Features

- **User Authentication**: Sign up and sign in functionality
- **API Integration**: RESTful API communication with error handling
- **State Management**: Provider pattern for reactive UI updates
- **Form Validation**: Comprehensive input validation
- **Unit Testing**: Extensive test coverage for all components
- **API Logging**: Detailed request/response logging
- **Responsive UI**: Modern, clean interface with consistent design

## 📱 Screens

- **Sign Up Screen**: User registration with form validation
- **Sign In Screen**: User authentication with remember me option
- **Home Screen**: Main dashboard (placeholder)

## 🏗️ Architecture

### **Clean Architecture Pattern**
```
lib/
├── core/                    # Core functionality
│   ├── constants/          # App constants (colors, dimensions, API endpoints)
│   ├── network/           # API client and network layer
│   ├── utils/             # Utility functions (validators)
│   └── widgets/           # Reusable UI components
├── models/                # Data models
├── repositories/          # Data access layer
├── view_models/          # Business logic layer
└── views/                # UI layer (screens)
```

### **State Management**
- **Provider Pattern**: Used for state management
- **ChangeNotifier**: ViewModels extend ChangeNotifier for reactive updates
- **Context-based**: Uses `context.read()` and `context.watch()` for state access

### **Network Layer**
- **ApiClient**: Centralized HTTP client with error handling
- **ApiLogger**: Comprehensive request/response logging
- **Exception Handling**: Custom exceptions for different error types
- **Repository Pattern**: Data access abstraction

## 🛠️ Getting Started

### **Prerequisites**
- Flutter SDK (3.0.0 or higher)
- Dart SDK (2.17.0 or higher)
- Android Studio / VS Code
- Git

### **Installation Steps**

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd evergreenix_flutter_task
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   # For development
   flutter run
   
   # For specific platform
   flutter run -d android
   flutter run -d ios
   flutter run -d web
   ```

4. **Run tests**
   ```bash
   # Run all tests
   flutter test
   
   # Run specific test files
   flutter test test/unit/validators_test.dart
   flutter test test/unit/auth_repository_test.dart
   ```

### **Development Commands**

```bash
# Analyze code
flutter analyze

# Format code
flutter format .

# Build for production
flutter build apk --release
flutter build ios --release
flutter build web --release

# Run tests with coverage
flutter test --coverage
```

## 🧪 Testing

### **Test Structure**
```
test/
├── unit/                  # Unit tests
│   ├── api_client_test.dart
│   ├── auth_repository_test.dart
│   ├── validators_test.dart
│   └── view_models/
│       ├── signin_viewmodel_test.dart
│       └── signup_viewmodel_test.dart
├── test_utils/           # Test utilities
│   ├── mock_data.dart
│   ├── test_helpers.dart
│   └── test_constants.dart
└── widget_test.dart      # Widget tests
```

### **Test Coverage**
- ✅ **Validators**: Input validation logic (22 tests)
- ✅ **API Client**: HTTP request handling (13 tests)
- ✅ **Auth Repository**: Authentication logic (15 tests)
- ✅ **ViewModels**: Business logic and state management (42 tests)
- ✅ **Widget Tests**: UI component testing (1 test)

### **Running Tests**
```bash
# Run all tests
flutter test

# Run specific test categories
flutter test test/unit/validators_test.dart
flutter test test/unit/auth_repository_test.dart

# Run tests with verbose output
flutter test --verbose

# Run tests with coverage report
flutter test --coverage
```

## 🔧 Configuration

### **API Configuration**
- **Base URL**: Configured in `lib/core/constants/api_endpoints.dart`
- **Headers**: Set in `ApiClient` constructor
- **Timeout**: Configurable in network layer

### **Environment Setup**
- **Development**: Uses mock data and test endpoints
- **Production**: Configured for live API endpoints
- **Testing**: Uses isolated test environment

## 📋 Assumptions Made

### **Technical Assumptions**
1. **Flutter 3.0+**: Project assumes modern Flutter version
2. **Provider Pattern**: State management using Provider package
3. **RESTful API**: Backend follows REST conventions
4. **JSON Communication**: API uses JSON for data exchange
5. **HTTP/HTTPS**: Secure communication protocols

### **Business Assumptions**
1. **User Registration**: Email-based registration with phone number
2. **Authentication**: Email/password login system
3. **Form Validation**: Client-side validation before API calls
4. **Error Handling**: User-friendly error messages
5. **Loading States**: UI feedback during async operations

### **UI/UX Assumptions**
1. **Responsive Design**: Works on different screen sizes
2. **Material Design**: Follows Material Design guidelines
3. **Accessibility**: Basic accessibility considerations
4. **Internationalization**: Ready for multi-language support
5. **Theme Support**: Consistent color scheme and typography

## 🏛️ Architectural Decisions

### **1. Clean Architecture**
**Decision**: Implemented Clean Architecture pattern
**Rationale**: 
- Separation of concerns
- Testability
- Maintainability
- Scalability

**Implementation**:
- Core layer for shared functionality
- Repository pattern for data access
- ViewModels for business logic
- Views for UI presentation

### **2. State Management - Provider**
**Decision**: Used Provider pattern over other state management solutions
**Rationale**:
- Built-in Flutter support
- Simple to understand and implement
- Good for medium-sized apps
- Excellent testing support

**Implementation**:
```dart
MultiProvider(
  providers: [
    ChangeNotifierProvider<SignupViewModel>(...),
    ChangeNotifierProvider<SigninViewModel>(...),
  ],
  child: MyApp(),
)
```

### **3. Network Layer Architecture**
**Decision**: Custom ApiClient with centralized error handling
**Rationale**:
- Full control over HTTP requests
- Consistent error handling
- Easy to mock for testing
- Logging and monitoring capabilities

**Implementation**:
- `ApiClient`: Centralized HTTP client
- `ApiLogger`: Request/response logging
- `ApiExceptions`: Custom exception types
- Repository pattern for data access

### **4. Testing Strategy**
**Decision**: Comprehensive unit testing with mocking
**Rationale**:
- Ensure code quality
- Catch regressions early
- Document expected behavior
- Enable confident refactoring

**Implementation**:
- Mockito for mocking dependencies
- Test utilities for common setup
- Isolated test environments
- Coverage reporting

### **5. Error Handling**
**Decision**: Custom exception hierarchy with user-friendly messages
**Rationale**:
- Consistent error handling across the app
- Better user experience
- Easier debugging
- Centralized error management

**Implementation**:
```dart
// Custom exceptions
class BadRequestException extends ApiExceptions
class UnauthorizedException extends ApiExceptions
class FetchDataException extends ApiExceptions
```

### **6. Form Validation**
**Decision**: Centralized validation utilities
**Rationale**:
- Reusable validation logic
- Consistent validation rules
- Easy to test
- Maintainable validation code

**Implementation**:
- `Validators` class with static methods
- Comprehensive validation rules
- Clear error messages
- Test coverage for all validators

## 📦 Dependencies

### **Core Dependencies**
- `flutter`: SDK
- `provider`: State management
- `http`: HTTP client
- `flutter_screenutil`: Responsive design

### **Development Dependencies**
- `flutter_test`: Testing framework
- `mockito`: Mocking framework
- `build_runner`: Code generation
- `http_mock_adapter`: HTTP mocking

## 🚀 Deployment

### **Android**
```bash
flutter build apk --release
flutter build appbundle --release
```

### **iOS**
```bash
flutter build ios --release
```

### **Web**
```bash
flutter build web --release
```

## 📚 Documentation

- **API Documentation**: See `lib/core/constants/api_endpoints.dart`
- **Test Documentation**: See `test/README.md`
- **Architecture Guide**: See this README's Architecture section
- **Contributing Guide**: Follow Flutter best practices

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Write tests for new functionality
4. Ensure all tests pass
5. Submit a pull request

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 📞 Support

For questions or issues:
- Create an issue in the repository
- Check the documentation
- Review the test cases for usage examples
