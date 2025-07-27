# durability - Personalized Fitness & Recovery Companion

A comprehensive iOS app that combines AI-powered movement assessment, personalized programming, and specialized recovery modules to help users achieve optimal fitness and injury resilience.

## 🎯 Features

### Core Functionality
- **AI-Powered Movement Assessment**: Comprehensive movement analysis using video recording and analysis
- **Super Metrics Tracking**: Monitor 5 key fitness dimensions (Range of Motion, Flexibility, Mobility, Functional Strength, Aerobic Capacity)
- **Durability Score**: Overall fitness and injury resilience metric (0-100 scale)
- **Personalized Programming**: Adaptive training plans based on assessment results
- **Recovery Modules**: Specialized programs for injury recovery and prevention

### Recovery Modules
- **UCL Recovery**: 12-week program for elbow stability and return to throwing
- **ACL Recovery**: 16-week program for knee stability and return to sport
- **Achilles Recovery**: 14-week program for calf strength and return to running
- **Labral Shoulder Recovery**: 12-week program for shoulder stability
- **IT Band Recovery**: 8-week program for pain-free movement

### Health Integration
- **HealthKit Integration**: Sync with Apple Health for comprehensive health data
- **Activity Tracking**: Monitor steps, workouts, heart rate, and sleep
- **Progress Analytics**: Detailed insights and recommendations

### User Experience
- **Dark Theme**: Modern electric green/blue/purple color scheme
- **Intuitive Navigation**: Tab-based interface with clear sections
- **Onboarding Flow**: Guided setup process for new users
- **Progress Tracking**: Visual progress indicators and trend analysis

## 🏗️ Architecture

### App Structure
```
durability/
├── Models/
│   ├── AppState.swift           # Main app state management
│   ├── AssessmentModels.swift   # Assessment data models
│   ├── RecoveryModules.swift    # Recovery program definitions
│   └── UserProfile.swift        # User profile and data models
├── Views/
│   ├── Main/
│   │   ├── MainTabView.swift           # Main navigation
│   │   ├── ProgressTrackingView.swift  # Progress dashboard
│   │   ├── WorkoutLogView.swift        # Workout tracking
│   │   └── ProfileSettingsView.swift   # User settings
│   ├── Onboarding/
│   │   ├── OnboardingView.swift        # Onboarding flow
│   │   ├── ProfileSurveyView.swift     # User survey
│   │   ├── MovementAssessmentView.swift # Movement assessment
│   │   └── HealthKitIntegrationView.swift # Health integration
│   ├── Assessment/
│   │   └── AssessmentFlowView.swift    # Assessment experience
│   ├── Recovery/
│   │   └── RecoveryModulesView.swift   # Recovery programs
│   ├── Analytics/
│   │   └── AnalyticsDashboardView.swift # Detailed analytics
│   └── HealthKit/
│       └── HealthKitDashboardView.swift # Health data dashboard
├── Theme/
│   └── DurabilityColors.swift   # App color scheme
└── ContentView.swift            # Main app entry point
```

### Data Flow
1. **User Input** → Onboarding Survey → OpenAI LLM → Structured Data → iCloud Storage
2. **Movement Assessment** → Video Recording → Analysis SDK → Movement Metrics → Super Metrics
3. **Health Data** → HealthKit → Data Mapping → Super Metrics Integration
4. **Programming** → User Data + Assessment Results → Decision Tree Logic → Personalized Programming
5. **Progress Tracking** → Ongoing Data → Analytics Engine → Progress Visualization

### Key Components

#### AppState
Central state management for:
- Authentication status
- Onboarding progress
- Assessment state
- Recovery module progress
- User profile data

#### Assessment System
- **AssessmentExercise**: Defines movement assessment exercises
- **ExerciseResult**: Stores individual exercise results
- **SuperMetricScores**: Calculated fitness dimensions
- **AssessmentResult**: Complete assessment session data

#### Recovery Modules
- **RecoveryModule**: Program definition with phases
- **RecoveryPhase**: Weekly program phases with exercises
- **ModuleDifficulty**: Beginner/Intermediate/Advanced levels

#### User Profile
- **UserProfile**: Complete user data model
- **Injury**: Injury history tracking
- **TrainingHistory**: Training background
- **QualitativeState**: Current state assessment

## 🎨 Design System

### Color Palette
- **Background**: Black (#000000)
- **Card Background**: Dark Gray (#262626)
- **Primary Accent**: Electric Green (#00FF80)
- **Secondary Accent**: Electric Blue (#00CCFF)
- **Tertiary Accent**: Electric Purple (#CC00FF)
- **Text**: White (#FFFFFF) / Gray (#808080)

### Typography
- **Headlines**: Large Title / Title / Headline
- **Body**: Body / Subheadline
- **Captions**: Caption / Caption2
- **Weights**: Regular / Medium / Semibold / Bold

### Components
- **Cards**: Rounded corners (16pt), dark background
- **Buttons**: Primary (accent background), Secondary (outlined)
- **Progress Indicators**: Linear progress bars with accent colors
- **Charts**: Radar charts, line charts, progress rings

## 🚀 Development Status

### ✅ Completed Features
- [x] Core app architecture and navigation
- [x] User authentication and profile management
- [x] Onboarding flow with survey and assessment
- [x] Movement library with filtering and search
- [x] Progress tracking with durability score
- [x] Recovery modules with detailed programs
- [x] HealthKit integration framework
- [x] Analytics dashboard with insights
- [x] Dark theme with electric color scheme
- [x] Assessment flow with video recording

### 🔄 In Progress
- [ ] Video analysis integration (Asensei SDK)
- [ ] OpenAI LLM integration for adaptive surveys
- [ ] iCloud data synchronization
- [ ] Advanced analytics and machine learning
- [ ] Social features and sharing

### 📋 Planned Features
- [ ] Wearable device integration (Apple Watch)
- [ ] Community features and leaderboards
- [ ] Advanced recovery module customization
- [ ] Integration with fitness apps (Strava, etc.)
- [ ] Personalized nutrition recommendations
- [ ] Injury prevention algorithms
- [ ] Competition and goal tracking
- [ ] Professional coach integration

## 🛠️ Technical Stack

### Frontend
- **SwiftUI**: Modern declarative UI framework
- **Combine**: Reactive programming for state management
- **Charts**: Data visualization framework

### Backend & Data
- **iCloud/CloudKit**: Data storage and synchronization
- **HealthKit**: Health data integration
- **Core Data**: Local data persistence

### External Integrations
- **OpenAI API**: LLM for adaptive surveys and insights
- **Asensei SDK**: Movement analysis and video processing
- **HealthKit**: Apple Health data access

### Development Tools
- **Xcode**: iOS development environment
- **Swift Package Manager**: Dependency management
- **Git**: Version control

## 📱 User Journey

### 1. Onboarding
1. **Welcome**: App introduction and feature overview
2. **Account Creation**: Sign up or sign in
3. **Profile Survey**: Injury history, training background, goals
4. **Movement Assessment**: Video-based movement analysis
5. **HealthKit Integration**: Connect Apple Health data
6. **Personalized Programming**: Generate initial training plan

### 2. Main App Experience
1. **Movement Library**: Browse and search exercises
2. **Progress Tracking**: Monitor durability score and super metrics
3. **Recovery Modules**: Access specialized recovery programs
4. **Workout Logging**: Track training sessions
5. **Profile Management**: Update settings and preferences

### 3. Assessment & Analytics
1. **Regular Assessments**: Periodic movement re-evaluation
2. **Progress Analytics**: Detailed insights and trends
3. **Health Integration**: Comprehensive health data analysis
4. **Recommendations**: AI-powered suggestions for improvement

## 🔒 Privacy & Security

- **Data Encryption**: All data encrypted in transit and at rest
- **User Consent**: Explicit permission required for all integrations
- **Privacy Protection**: Analytics data anonymized
- **Local Processing**: Sensitive data processed on-device when possible
- **Transparent Policies**: Clear privacy policy and data usage

## 📈 Performance & Scalability

- **Modular Architecture**: Supports feature additions and updates
- **Cloud Scaling**: iCloud backend scales with user growth
- **Offline Support**: Core functionality works without internet
- **Multi-Device Sync**: Ready for iPhone/iPad/Apple Watch
- **Performance Optimization**: Efficient data loading and caching

## 🤝 Contributing

This is a personal project demonstrating modern iOS development practices. The codebase is structured for maintainability and extensibility.

### Development Guidelines
- Follow SwiftUI best practices
- Use MVVM architecture pattern
- Implement proper error handling
- Write comprehensive documentation
- Maintain consistent code style

## 📄 License

This project is for educational and demonstration purposes.

---

**durability** - Building resilient athletes through intelligent movement analysis and personalized programming. 