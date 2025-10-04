<div align="center">

# 🌾 Krishi Deep

### *Empowering Farmers Through Intelligence*

[![VITISH 2025](https://img.shields.io/badge/VITISH-2025-green?style=for-the-badge)](https://vitish.in)
[![Team](https://img.shields.io/badge/Team-VIT--229-orange?style=for-the-badge)](https://github.com)
[![Status](https://img.shields.io/badge/Status-Active-success?style=for-the-badge)](https://github.com)

**AI-Powered Smart Farming Platform for the Modern Farmer**

[Features](#-key-features) • [Architecture](#-system-architecture) • [Tech Stack](#️-tech-stack) • [Getting Started](#-getting-started) • [Team](#-team)

</div>

---

## 📋 Problem Statement

**Problem ID:** `25030`  
**Title:** AI-Based Crop Recommendation for Farmers  
**Theme:** Agriculture, FoodTech & Rural Development  
**Category:** Software

> *How can we leverage AI and IoT to transform traditional farming into data-driven agriculture, helping farmers make informed decisions and maximize yields?*

---

## 💡 What is Krishi Deep?

**Krishi Deep** (meaning "Agricultural Light") is a revolutionary smart-farming platform that bridges the gap between traditional agriculture and cutting-edge technology. We empower farmers with:

- 📊 **Real-time environmental monitoring** through IoT sensors
- 🤖 **Intelligent crop recommendations** powered by AI/ML
- 🔗 **Transparent market pricing** secured by blockchain
- 📱 **Easy-to-use mobile and web interfaces** in local languages
- 🌐 **Offline-first design** for rural connectivity challenges

Our mission is simple: **Make every farmer a data-informed decision maker.**

---

## ✨ Key Features

<table>
<tr>
<td width="50%">

### 🌱 Smart IoT Integration
Real-time monitoring of:
- Soil moisture levels
- Temperature & humidity
- pH and nutrient content
- Environmental conditions

</td>
<td width="50%">

### 🤖 AI-Driven Insights
Intelligent predictions for:
- Optimal crop selection
- Disease detection & prevention
- Yield forecasting
- Market price trends

</td>
</tr>
<tr>
<td width="50%">

### 🔗 Blockchain Transparency
Secure and tamper-proof:
- Market price records
- Transaction history
- Supply chain tracking
- Fair trade verification

</td>
<td width="50%">

### 📱 Multi-Platform Access
Available on:
- Mobile app (Android & iOS)
- Web dashboard
- Offline mode support
- Multi-language interface

</td>
</tr>
<tr>
<td width="50%">

### 💬 Interactive Assistant
Personal farming guide with:
- Local language support
- Voice-based queries
- Step-by-step guidance
- 24/7 availability

</td>
<td width="50%">

### 🔔 Smart Alerts
Real-time notifications for:
- Crop health warnings
- Weather forecasts
- Price fluctuations
- Irrigation reminders

</td>
</tr>
</table>

---

## 🏗️ System Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                          User Layer                              │
│  ┌──────────────────┐              ┌──────────────────┐         │
│  │   Mobile App     │              │   Web Dashboard  │         │
│  │   (Flutter)      │              │   (ReactJS)      │         │
│  └────────┬─────────┘              └────────┬─────────┘         │
└───────────┼──────────────────────────────────┼──────────────────┘
            │                                  │
            └──────────────┬───────────────────┘
                           │
┌──────────────────────────▼───────────────────────────────────────┐
│                      API Gateway Layer                            │
│                      (FastAPI)                                    │
└──────────────────────────┬───────────────────────────────────────┘
                           │
            ┌──────────────┼──────────────┐
            │              │              │
┌───────────▼────┐  ┌──────▼──────┐  ┌───▼──────────┐
│   AI/ML Models │  │  Blockchain │  │  IoT Gateway │
│                │  │    Layer    │  │              │
│ • XGBoost      │  │             │  │ • ESP32      │
│ • LSTM         │  │ • Docker    │  │ • DHT22      │
│ • Random Forest│  │ • Hashlib   │  │ • Sensors    │
└────────┬───────┘  └──────┬──────┘  └───┬──────────┘
         │                 │             │
         └────────┬────────┴─────────────┘
                  │
         ┌────────▼─────────┐
         │   Data Layer     │
         │                  │
         │ • MongoDB        │
         │ • Firebase       │
         └──────────────────┘
```

---

## 🛠️ Tech Stack

### Frontend Development
![HTML5](https://img.shields.io/badge/HTML5-E34F26?style=flat-square&logo=html5&logoColor=white)
![CSS3](https://img.shields.io/badge/CSS3-1572B6?style=flat-square&logo=css3&logoColor=white)
![JavaScript](https://img.shields.io/badge/JavaScript-F7DF1E?style=flat-square&logo=javascript&logoColor=black)
![React](https://img.shields.io/badge/React-61DAFB?style=flat-square&logo=react&logoColor=black)
![Flutter](https://img.shields.io/badge/Flutter-02569B?style=flat-square&logo=flutter&logoColor=white)
![Material UI](https://img.shields.io/badge/Material_UI-0081CB?style=flat-square&logo=material-ui&logoColor=white)

### Backend & AI/ML
![Python](https://img.shields.io/badge/Python-3776AB?style=flat-square&logo=python&logoColor=white)
![FastAPI](https://img.shields.io/badge/FastAPI-009688?style=flat-square&logo=fastapi&logoColor=white)
![XGBoost](https://img.shields.io/badge/XGBoost-FF6600?style=flat-square&logo=xgboost&logoColor=white)
![TensorFlow](https://img.shields.io/badge/TensorFlow-FF6F00?style=flat-square&logo=tensorflow&logoColor=white)

### Database & Cloud
![MongoDB](https://img.shields.io/badge/MongoDB-47A248?style=flat-square&logo=mongodb&logoColor=white)
![Firebase](https://img.shields.io/badge/Firebase-FFCA28?style=flat-square&logo=firebase&logoColor=black)

### IoT & Hardware
![Arduino](https://img.shields.io/badge/Arduino-00979D?style=flat-square&logo=arduino&logoColor=white)
![ESP32](https://img.shields.io/badge/ESP32-000000?style=flat-square&logo=espressif&logoColor=white)

### Blockchain
![Docker](https://img.shields.io/badge/Docker-2496ED?style=flat-square&logo=docker&logoColor=white)

---

## 🔬 Methodology

```mermaid
graph LR
    A[IoT Sensors] -->|Real-time Data| B[Data Collection]
    B --> C[Preprocessing]
    C --> D[AI Model Training]
    D --> E[Predictions]
    E --> F[API Integration]
    F --> G[User Interface]
    G --> H[Farmer Action]
    H --> I[Feedback Loop]
    I --> B
```

### Step-by-Step Process

1. **📡 Data Collection** - IoT sensors continuously monitor soil and environmental parameters
2. **🧹 Preprocessing** - Raw data is cleaned, normalized, and stored in MongoDB
3. **🧠 Model Training** - ML algorithms learn patterns from historical and real-time data
4. **🎯 Prediction** - AI models generate crop recommendations and forecasts
5. **🔐 Blockchain Verification** - Market data is secured on blockchain for transparency
6. **📱 Delivery** - Insights delivered through intuitive mobile and web interfaces
7. **🔄 Continuous Learning** - User feedback improves model accuracy over time

---

## 💰 Business Model

| Revenue Stream | Description | Target Audience |
|----------------|-------------|-----------------|
| **🛒 E-Commerce Marketplace** | Commission on sales of seeds, fertilizers, and farming equipment | Farmers & Suppliers |
| **💎 Premium Subscriptions** | Advanced AI features, detailed analytics, and priority support | Progressive Farmers |
| **📢 Sponsored Recommendations** | Featured products and brand partnerships | Agri-businesses |
| **🏛️ Government Partnerships** | Integration with subsidy schemes and rural development programs | Public Sector |
| **📊 Data Analytics** | Aggregated market insights (anonymized) | Research Institutions |

---

## 🌍 Impact & Benefits

### 💵 Economic Impact
- Increase farmer income by **20-30%** through optimized crop selection
- Reduce input costs by **15-25%** with precise resource management
- Access to fair market prices eliminates middleman exploitation

### 📚 Educational Empowerment
- Digital literacy programs for rural farmers
- Knowledge sharing through community features
- Best practices from successful farmers

### 🌱 Environmental Sustainability
- Optimized water usage reduces wastage by **30%**
- Precise fertilizer application minimizes soil degradation
- Promotes organic farming through AI-driven recommendations

### 👥 Social Transformation
- Empowers small-scale and marginalized farmers
- Bridges urban-rural digital divide
- Creates community support networks

### 🏥 Food Security & Health
- Early disease detection prevents crop loss
- Improves food quality and safety
- Ensures consistent supply chain

---

## 📚 Research & References

- **ICAR** - Smart Farming and Digital Agriculture in India
- **Ministry of Agriculture & Farmers Welfare** - Digital Agriculture Mission 2021-2025
- **NITI Aayog & IBM (2019)** - AI in Indian Agriculture: Crop Yield Prediction & Advisory Systems
- **Springer (2020)** - IoT Applications in Precision Farming
- **OpenWeatherMap API** - [Weather Data Integration](https://openweathermap.org/api)

---

## 🚀 Getting Started

### Prerequisites
```bash
# Required Software
- Node.js (v14+)
- Python (v3.8+)
- MongoDB
- Git
```

### Installation

**1. Clone the Repository**
```bash
git clone https://github.com/your-username/KrishiDeep.git
cd KrishiDeep
```

**2. Backend Setup**
```bash
cd backend
pip install -r requirements.txt
uvicorn main:app --reload --host 0.0.0.0 --port 8000
```

**3. Frontend Setup**
```bash
cd frontend
npm install
npm start
```

**4. Mobile App Setup**
```bash
cd mobile
flutter pub get
flutter run
```

**5. IoT Configuration**
- Upload Arduino sketch to ESP32
- Configure WiFi credentials
- Set up sensor calibration

---

## 👥 Team

<div align="center">

### 🌾 Team Krishi Deep | VIT-229

</div>

| 👤 Member | 🎯 Role | 🔗 Expertise |
|-----------|---------|--------------|
| **Dipsita** *(Team Leader)* | ML & Backend Integration | Machine Learning, System Architecture |
| **Shreyash Gautam** | Full-Stack Developer & Data Analyst | ReactJS, Python, Data Analysis |
| **Siddharth** | AI/ML Engineer | Deep Learning, Model Optimization |
| **Adaysha** | IoT Developer | ESP32, Sensor Integration, Arduino |
| **Nikhil** | Blockchain & Cloud Integration | Docker, Distributed Systems |
| **Yash** | Mobile App & UI/UX Designer | Flutter, User Experience Design |

---

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

## 🙏 Acknowledgments

Special thanks to:
- **VIT Chennai** for hosting VITISH 2025
- **ICAR** and **Ministry of Agriculture** for research insights
- All farmers who provided valuable feedback during development
- Open-source community for amazing tools and libraries

---

<div align="center">

### 🌾 *Sowing Seeds of Smart Farming* 🌾

**Made with ❤️ by Team Krishi Deep**

[![GitHub](https://img.shields.io/badge/GitHub-View_Code-black?style=for-the-badge&logo=github)](https://github.com)
[![Demo](https://img.shields.io/badge/Demo-Live_Preview-blue?style=for-the-badge&logo=google-chrome)](https://demo.com)
[![Docs](https://img.shields.io/badge/Docs-Read_More-green?style=for-the-badge&logo=read-the-docs)](https://docs.com)

</div>