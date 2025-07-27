# durability App - System Flow Block Diagram

```
┌─────────────────────────────────────────────────────────────────────────────────────┐
│                                durability App System Flow                          │
└─────────────────────────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────────────────────────┐
│                                 USER INTERFACE LAYER                              │
└─────────────────────────────────────────────────────────────────────────────────────┘

┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   Onboarding    │    │  Main Tab Bar   │    │  Profile/Settings│    │  Recovery       │
│     Flow        │    │   Navigation    │    │     Screen      │    │   Modules       │
└─────────────────┘    └─────────────────┘    └─────────────────┘    └─────────────────┘
         │                       │                       │                       │
         │                       │                       │                       │
         ▼                       ▼                       ▼                       ▼
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│ • Account       │    │ • Movement      │    │ • User Profile  │    │ • UCL Recovery  │
│   Creation      │    │   Library       │    │ • Biometrics    │    │ • ACL Recovery  │
│ • Profile       │    │ • Progress      │    │ • App Settings  │    │ • Achilles       │
│   Survey        │    │   Tracking      │    │ • Privacy       │    │   Recovery      │
│ • Movement      │    │ • Workout/Log   │    │ • Re-Assessment │    │ • Shoulder      │
│   Assessment    │    │ • Profile       │    │ • Analytics     │    │   Recovery      │
│ • HealthKit     │    │   Settings      │    │ • Logout        │    │ • IT Band       │
│   Integration   │    │                 │    │                 │    │   Recovery      │
└─────────────────┘    └─────────────────┘    └─────────────────┘    └─────────────────┘

┌─────────────────────────────────────────────────────────────────────────────────────┐
│                              DATA PROCESSING LAYER                                │
└─────────────────────────────────────────────────────────────────────────────────────┘

┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   OpenAI LLM    │    │  Asensei SDK    │    │  HealthKit      │    │  Decision Tree  │
│   Integration   │    │  Movement       │    │   Integration   │    │   Logic Engine  │
│                 │    │   Analysis      │    │                 │    │                 │
└─────────────────┘    └─────────────────┘    └─────────────────┘    └─────────────────┘
         │                       │                       │                       │
         │                       │                       │                       │
         ▼                       ▼                       ▼                       ▼
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│ • Text          │    │ • Video         │    │ • Workout Data  │    │ • Injury        │
│   Processing    │    │   Analysis      │    │ • Heart Rate    │    │   History       │
│ • Structured    │    │ • Joint Angles  │    │ • Sleep Data    │    │ • Super-Metrics │
│   Data          │    │ • Range of      │    │ • VO2 Max       │    │ • Goals         │
│   Extraction    │    │   Motion        │    │ • Activity      │    │ • Current       │
│ • Next Question │    │ • Movement      │    │   Rings         │    │   Training      │
│   Suggestions   │    │   Quality       │    │ • Steps         │    │   Regimen       │
└─────────────────┘    └─────────────────┘    └─────────────────┘    └─────────────────┘

┌─────────────────────────────────────────────────────────────────────────────────────┐
│                              ANALYTICS & METRICS LAYER                            │
└─────────────────────────────────────────────────────────────────────────────────────┘

┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│  Super-Metrics  │    │ Durability      │    │ Progress        │    │ Analytics       │
│   Calculation   │    │   Score         │    │   Tracking      │    │   Engine        │
└─────────────────┘    └─────────────────┘    └─────────────────┘    └─────────────────┘
         │                       │                       │                       │
         │                       │                       │                       │
         ▼                       ▼                       ▼                       ▼
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│ • Range of      │    │ • Weighted      │    │ • Spider/Radar  │    │ • User          │
│   Motion        │    │   Combination   │    │   Chart         │    │   Engagement    │
│ • Flexibility   │    │ • Single Metric │    │ • Trend         │    │ • Feature       │
│ • Mobility      │    │ • 0-100 Scale   │    │   Analysis      │    │   Usage         │
│ • Functional    │    │ • Progress      │    │ • Comparison    │    │ • Outcomes      │
│   Strength      │    │   Indicator     │    │   Views         │    │ • Performance   │
│ • Aerobic       │    │ • Goal Setting  │    │ • Feedback      │    │   Metrics       │
│   Capacity      │    │                 │    │                 │    │                 │
└─────────────────┘    └─────────────────┘    └─────────────────┘    └─────────────────┘

┌─────────────────────────────────────────────────────────────────────────────────────┐
│                              DATA STORAGE LAYER                                   │
└─────────────────────────────────────────────────────────────────────────────────────┘

┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   iCloud        │    │   Local Cache   │    │   HealthKit     │    │   Analytics     │
│   (CloudKit)    │    │                 │    │   Data          │    │   Storage       │
└─────────────────┘    └─────────────────┘    └─────────────────┘    └─────────────────┘
         │                       │                       │                       │
         │                       │                       │                       │
         ▼                       ▼                       ▼                       ▼
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│ • User Profiles │    │ • Assessment    │    │ • Workout       │    │ • Engagement    │
│ • Assessment    │    │   Results       │    │   History       │    │   Data          │
│   Results       │    │ • Current       │    │ • Heart Rate    │    │ • Feature       │
│ • Training      │    │   Session       │    │   Data          │    │ • Performance   │
│   Plans         │    │   Data          │    │ • Sleep Data    │    │ • User          │
│ • Recovery      │    │ • Offline       │    │ • Activity      │    │   Metrics       │
│   Modules       │    │   Access        │    │   Data          │    │ • User          │
│ • Progress      │    │                 │    │                 │    │   Feedback      │
│   Data          │    │                 │    │                 │    │                 │
└─────────────────┘    └─────────────────┘    └─────────────────┘    └─────────────────┘

┌─────────────────────────────────────────────────────────────────────────────────────┐
│                              EXTERNAL INTEGRATIONS                                │
└─────────────────────────────────────────────────────────────────────────────────────┘

┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│   OpenAI API    │    │  Asensei SDK    │    │  HealthKit      │    │  Future APIs    │
│                 │    │                 │    │   Framework     │    │                 │
└─────────────────┘    └─────────────────┘    └─────────────────┘    └─────────────────┘
         │                       │                       │                       │
         │                       │                       │                       │
         ▼                       ▼                       ▼                       ▼
┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
│ • GPT-4/GPT-3.5│    │ • Movement      │    │ • Apple Fitness │    │ • Strava API    │
│ • Text          │    │   Analysis      │    │ • Nike Run Club │    │ • Whoop API     │
│   Processing    │    │ • Pose          │    │ • Third-party   │    │ • Garmin API    │
│ • Structured    │    │   Estimation    │    │   Apps          │    │ • Apple Watch   │
│   Output        │    │ • Real-time     │    │ • Wearable      │    │   Integration   │
│ • Adaptive      │    │   Feedback      │    │   Data          │    │ • Social        │
│   Survey        │    │ • Metrics       │    │ • Health        │    │   Features      │
│   Logic         │    │   Extraction    │    │   Monitoring    │    │                 │
└─────────────────┘    └─────────────────┘    └─────────────────┘    └─────────────────┘

┌─────────────────────────────────────────────────────────────────────────────────────┐
│                              DATA FLOW SUMMARY                                    │
└─────────────────────────────────────────────────────────────────────────────────────┘

1. USER INPUT FLOW:
   User → Onboarding Survey → OpenAI LLM → Structured Data → iCloud Storage

2. MOVEMENT ASSESSMENT FLOW:
   User → Video Recording → Asensei SDK → Movement Metrics → Super-Metrics Calculation

3. HEALTH DATA FLOW:
   HealthKit → Fitness Data → Data Mapping → Super-Metrics Integration

4. PROGRAMMING FLOW:
   User Data + Assessment Results → Decision Tree Logic → Personalized Programming

5. PROGRESS TRACKING FLOW:
   Ongoing Data → Analytics Engine → Progress Visualization → User Feedback

6. RECOVERY MODULE FLOW:
   User Selection → Module Content → Progress Tracking → Integration with Main Plan

┌─────────────────────────────────────────────────────────────────────────────────────┐
│                              SECURITY & PRIVACY                                   │
└─────────────────────────────────────────────────────────────────────────────────────┘

• All data encrypted in transit and at rest
• User consent required for all integrations
• iCloud provides secure, private data storage
• HealthKit data access requires explicit permission
• Analytics data anonymized for privacy protection
• Clear privacy policy and data usage transparency

┌─────────────────────────────────────────────────────────────────────────────────────┐
│                              SCALABILITY CONSIDERATIONS                           │
└─────────────────────────────────────────────────────────────────────────────────────┘

• Modular architecture supports feature additions
• iCloud backend can scale with user growth
• LLM integration allows for advanced AI features
• Recovery modules can be expanded over time
• Analytics data enables continuous improvement
• Multi-device sync ready for future implementation 