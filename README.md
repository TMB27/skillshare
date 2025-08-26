# 🎓 SkillShare - Community Learning Platform

<div align="center">

![Flutter](https://img.shields.io/badge/Flutter-3.5.4-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-3.5.4-0175C2?style=for-the-badge&logo=dart&logoColor=white)
![Supabase](https://img.shields.io/badge/Supabase-2.5.6-3ECF8E?style=for-the-badge&logo=supabase&logoColor=white)
![License](https://img.shields.io/badge/License-MIT-green?style=for-the-badge)

**Connect with your community through skills - Learn, Teach, and Grow together!**

[Features](#-features) • [Screenshots](#-screenshots) • [Installation](#-installation) • [Architecture](#-architecture) • [Contributing](#-contributing)

</div>

## 📱 About SkillShare

SkillShare is a modern, community-driven learning platform built with Flutter that connects learners with teachers in their local area. Whether you want to learn a new skill or share your expertise, SkillShare makes it easy to build meaningful connections through knowledge exchange.

### 🎯 Vision
To create a world where everyone can easily access learning opportunities and share their knowledge with others, fostering stronger communities through skill exchange.

## ✨ Features

### 🔐 **Authentication & User Management**
- **Secure Authentication**: Email/password login with Supabase Auth
- **User Profiles**: Complete profile management with avatars and bio
- **Password Recovery**: Secure forgot password functionality
- **Onboarding**: Smooth first-time user experience

### 🎨 **Skill Discovery & Browsing**
- **Browse Skills**: Discover skills by category, location, and popularity
- **Advanced Search**: Filter by price, duration, skill level, and more
- **Featured Skills**: Highlighted trending and popular skills
- **Skill Details**: Comprehensive skill information with reviews and ratings

### 📚 **Teaching & Learning**
- **Create Skills**: Easy skill creation with rich descriptions and media
- **Skill Management**: Edit, update, and manage your offered skills
- **Booking System**: Schedule learning sessions with instructors
- **Progress Tracking**: Monitor your learning journey

### 💬 **Communication & Interaction**
- **Real-time Messaging**: Chat with instructors and learners
- **Reviews & Ratings**: Rate and review learning experiences
- **Notifications**: Stay updated with booking confirmations and messages
- **Community Features**: Connect with like-minded learners

### 📅 **Booking & Scheduling**
- **Flexible Booking**: Book sessions based on availability
- **Calendar Integration**: Manage your learning schedule
- **Booking Management**: Track past, current, and upcoming sessions
- **Payment Integration**: Secure payment processing (Ready for integration)

### 🌟 **User Experience**
- **Material Design 3**: Modern, accessible, and beautiful UI
- **Dark/Light Theme**: Automatic theme switching based on system preferences
- **Responsive Design**: Optimized for phones, tablets, and different screen sizes
- **Offline Support**: Core features work offline with sync capabilities

## 🔧 Tech Stack

### **Frontend**
- **Flutter 3.5.4**: Cross-platform mobile development
- **Dart 3.5.4**: Programming language
- **Material Design 3**: Modern UI framework
- **Provider**: State management solution
- **GoRouter**: Declarative routing and navigation

### **Backend & Database**
- **Supabase**: Backend-as-a-Service platform
- **PostgreSQL**: Robust relational database
- **Row Level Security (RLS)**: Data security and privacy
- **Real-time Subscriptions**: Live data updates
- **Supabase Auth**: Authentication and user management
- **Supabase Storage**: File and media storage

### **Key Dependencies**
```yaml
dependencies:
  flutter: ^3.5.4
  supabase_flutter: ^2.5.6
  provider: ^6.1.2
  go_router: ^14.2.0
  shared_preferences: ^2.2.3
  image_picker: ^1.1.2
  cached_network_image: ^3.3.1
```

## 📸 Screenshots

*Coming Soon - Screenshots will be added once the app is fully deployed*

## 🚀 Installation

### Prerequisites
- Flutter SDK (>=3.5.4)
- Dart SDK (>=3.5.4)
- Android Studio / VS Code
- Git

### 1. Clone the Repository
```bash
git clone https://github.com/TMB27/skillshare.git
cd skillshare
```

### 2. Install Dependencies
```bash
flutter pub get
```

### 3. Environment Setup
1. Create a Supabase project at [supabase.com](https://supabase.com)
2. Copy your project URL and anon key
3. Create `lib/config/supabase_config.dart`:
```dart
class SupabaseConfig {
  static const String supabaseUrl = 'YOUR_SUPABASE_URL';
  static const String supabaseAnonKey = 'YOUR_SUPABASE_ANON_KEY';
}
```

### 4. Database Setup
Execute the SQL schema provided in the project to set up your Supabase database with all required tables and relationships.

### 5. Run the App
```bash
# Debug mode
flutter run

# Release mode
flutter run --release
```

## 🏗️ Architecture

### **Project Structure**
```
lib/
├── config/          # App configuration and themes
├── models/          # Data models and entities
├── providers/       # State management (Provider pattern)
├── screens/         # UI screens and pages
├── services/        # API and external service integrations
├── utils/           # Utilities and helpers
└── widgets/         # Reusable UI components
```

### **State Management**
- **Provider Pattern**: Clean, testable state management
- **AuthProvider**: Handles authentication state and user management
- **SkillsProvider**: Manages skill data and operations

### **Database Schema**
- **Profiles**: User information and settings
- **Skills**: Available skills with details and metadata
- **Bookings**: Learning session bookings and scheduling
- **Reviews**: Ratings and feedback system
- **Messages**: Real-time communication
- **Conversations**: Chat thread management

## 🛡️ Security Features

- **Row Level Security (RLS)**: Database-level security policies
- **Secure Authentication**: Supabase Auth with email verification
- **Data Validation**: Client and server-side input validation
- **Privacy Controls**: User data protection and privacy settings

## 🌟 Production Ready Features

- **Error Handling**: Comprehensive error management and user feedback
- **Loading States**: Smooth loading indicators and progress feedback
- **Offline Support**: Core functionality works without internet
- **Performance Optimized**: Efficient data loading and caching
- **Accessibility**: Screen reader support and accessibility features
- **Internationalization Ready**: Prepared for multi-language support

## 📱 Platform Support

- ✅ **Android** (API 21+)
- ✅ **iOS** (iOS 12+)
- 🔄 **Web** (In development)
- 🔄 **Desktop** (Future release)

## 🤝 Contributing

We welcome contributions! Please see our [Contributing Guidelines](CONTRIBUTING.md) for details.

### Development Workflow
1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

### Code Style
- Follow [Dart Style Guide](https://dart.dev/guides/language/effective-dart/style)
- Use meaningful commit messages
- Add tests for new features
- Update documentation as needed

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- **Flutter Team**: For the amazing framework
- **Supabase Team**: For the excellent backend platform
- **Community Contributors**: For feedback and contributions
- **Material Design**: For the beautiful design system

## 📞 Support & Contact

- **Issues**: [GitHub Issues](https://github.com/TMB27/skillshare/issues)
- **Discussions**: [GitHub Discussions](https://github.com/TMB27/skillshare/discussions)
- **Email**: [Contact Us](mailto:tejasbadhe72@gmail.com)

---

<div align="center">

**Made with ❤️ by Tejas Badhe using Flutter**

⭐ **Star this repo if you find it helpful!** ⭐

</div>
