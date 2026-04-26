<div align="center">

<br>

# 🌾 Krishi Deep
### *Empowering Farmers Through Intelligence*

> IoT monitoring · AI crop recommendations · Blockchain pricing · Multi-platform access — bridging traditional farming and cutting-edge technology.

<br>

![React](https://img.shields.io/badge/React-20232A?style=flat-square&logo=react&logoColor=61DAFB)
![Flutter](https://img.shields.io/badge/Flutter-02569B?style=flat-square&logo=flutter&logoColor=white)
![FastAPI](https://img.shields.io/badge/FastAPI-009688?style=flat-square&logo=fastapi&logoColor=white)
![Python](https://img.shields.io/badge/Python-3776AB?style=flat-square&logo=python&logoColor=white)
![MongoDB](https://img.shields.io/badge/MongoDB-47A248?style=flat-square&logo=mongodb&logoColor=white)
![Firebase](https://img.shields.io/badge/Firebase-FFCA28?style=flat-square&logo=firebase&logoColor=black)
![TensorFlow](https://img.shields.io/badge/TensorFlow-FF6F00?style=flat-square&logo=tensorflow&logoColor=white)
![Arduino](https://img.shields.io/badge/Arduino-00979D?style=flat-square&logo=arduino&logoColor=white)

<br>

🏆 **VITISH 2025** &nbsp;·&nbsp; Problem ID: 25030 &nbsp;·&nbsp; Theme: Agriculture, FoodTech & Rural Development

<br>

</div>

---

## 👥 Team — VIT-229

<div align="center">

| Name | Role |
|:----:|:----:|
| **Shreyash Gautam** | Developer |
| **Dipsita Rout** | Developer |
| **Siddharth Seth** | Developer |
| **Adaysha** | Developer |
| **Nikhil** | Developer |
| **Yash** | Developer |

</div>

---

## 🧠 About the Project

**Krishi Deep** *(meaning "Agricultural Light")* is a smart-farming platform that transforms traditional agriculture into data-driven decision-making. Built for the modern Indian farmer, it combines real-time IoT sensing, AI-powered recommendations, and blockchain-backed market transparency — all accessible via mobile and web.

```
📡 Sense  →  🧠 Analyze  →  🎯 Recommend  →  📱 Deliver  →  🔄 Learn
```

> **Mission:** Make every farmer a data-informed decision maker.

---

## 📋 Problem Statement

**How can we leverage AI and IoT to transform traditional farming into data-driven agriculture — helping farmers make informed decisions and maximize yields?**

- Most farmers rely on guesswork for crop selection and resource management
- No real-time visibility into soil health, weather, or market prices
- Middlemen exploit information asymmetry in price discovery
- Rural connectivity challenges limit access to digital tools

---

## ✨ Key Features

### 🌱 Smart IoT Integration
Real-time monitoring of soil moisture, temperature, humidity, pH, nutrient content, and environmental conditions via ESP32 sensors.

### 🤖 AI-Driven Insights
Intelligent predictions for optimal crop selection, disease detection, yield forecasting, and market price trends — powered by XGBoost, LSTM, and Random Forest models.

### 🔗 Blockchain Transparency
Tamper-proof records for market prices, transaction history, supply chain tracking, and fair trade verification using Docker-based blockchain infrastructure.

### 📱 Multi-Platform Access
Available as a Flutter mobile app (Android & iOS) and a ReactJS web dashboard — with offline-first design for rural connectivity challenges.

### 💬 Interactive Assistant
A personal farming guide with local language support, voice queries, step-by-step guidance, and 24/7 availability.

### 🔔 Smart Alerts
Real-time notifications for crop health warnings, weather forecasts, price fluctuations, and irrigation reminders.

---

## 🏗️ System Architecture

```
┌─────────────────────────────────────────────────────────┐
│                      User Layer                          │
│         Flutter Mobile App    ·    ReactJS Web           │
└──────────────────────┬──────────────────────────────────┘
                       │
┌──────────────────────▼──────────────────────────────────┐
│                   API Gateway (FastAPI)                   │
└──────────┬──────────────────┬──────────────┬────────────┘
           │                  │              │
    ┌──────▼──────┐   ┌───────▼──────┐  ┌───▼──────────┐
    │  AI/ML      │   │  Blockchain  │  │  IoT Gateway │
    │             │   │              │  │              │
    │ • XGBoost   │   │ • Docker     │  │ • ESP32      │
    │ • LSTM      │   │ • Hashlib    │  │ • DHT22      │
    │ • Rand.Forest│  │              │  │ • Sensors    │
    └──────┬──────┘   └───────┬──────┘  └───┬──────────┘
           └──────────────────┴─────────────┘
                              │
                   ┌──────────▼──────────┐
                   │     Data Layer       │
                   │  MongoDB · Firebase  │
                   └─────────────────────┘
```

---

## 🛠️ Tech Stack

| Layer | Technology |
|:------|:-----------|
| Mobile App | Flutter (Dart) |
| Web Frontend | React · TypeScript |
| Backend | Python · FastAPI |
| AI / ML | XGBoost · LSTM · Random Forest · TensorFlow |
| Database | MongoDB · Firebase |
| IoT Hardware | ESP32 · DHT22 · Arduino |
| Blockchain | Docker · Hashlib |

---

## 🔬 Methodology

```
1. 📡 Data Collection    →  IoT sensors monitor soil and environment continuously
2. 🧹 Preprocessing      →  Raw data cleaned, normalized, stored in MongoDB
3. 🧠 Model Training     →  ML algorithms learn from historical + real-time data
4. 🎯 Prediction         →  AI generates crop recommendations and yield forecasts
5. 🔐 Verification       →  Market data secured on blockchain for transparency
6. 📱 Delivery           →  Insights served via mobile app and web dashboard
7. 🔄 Continuous Learning →  User feedback continuously improves model accuracy
```

---

## 🌍 Impact & Benefits

### 💵 Economic
- Increase farmer income by **20–30%** through optimized crop selection
- Reduce input costs by **15–25%** with precise resource management
- Fair market prices — no middleman exploitation

### 🌱 Environmental
- Optimized water usage reduces wastage by **~30%**
- Precise fertilizer application minimizes soil degradation
- AI-driven recommendations encourage organic farming

### 📚 Social & Educational
- Digital literacy programs for rural farmers
- Bridges the urban-rural digital divide
- Community knowledge sharing across farmer networks

### 🏥 Food Security
- Early disease detection prevents crop loss
- Improves food quality and safety
- Ensures consistent supply chain reliability

---

## 💰 Business Model

| Revenue Stream | Description | Audience |
|:--------------|:------------|:---------|
| 🛒 E-Commerce Marketplace | Commission on seeds, fertilizers, equipment | Farmers & Suppliers |
| 💎 Premium Subscriptions | Advanced AI features, detailed analytics | Progressive Farmers |
| 📢 Sponsored Recommendations | Featured products & brand partnerships | Agri-businesses |
| 🏛️ Government Partnerships | Integration with subsidy & rural dev. programs | Public Sector |
| 📊 Data Analytics | Aggregated anonymized market insights | Research Institutions |

---

## 🚀 Getting Started

### Prerequisites

```bash
# Required
Node.js v14+
Python v3.8+
MongoDB
Flutter SDK
Git
```

### 1. Clone the Repository

```bash
git clone https://github.com/shreyashgautam/KrisiDeepVitish.git
cd KrisiDeepVitish
```

### 2. Backend Setup

```bash
cd backend_krisi
pip install -r requirements.txt
uvicorn main:app --reload --host 0.0.0.0 --port 8000
```

### 3. Web Frontend Setup

```bash
cd krisideepweb
npm install
npm start
```

### 4. Mobile App Setup

```bash
cd krishideep_app
flutter pub get
flutter run
```

### 5. IoT Configuration

```
→ Upload Arduino sketch from iot_arduino_code/ to your ESP32
→ Configure WiFi credentials in the sketch
→ Calibrate sensors as per hardware setup guide
```

---

## 🙏 Acknowledgments

- **VIT Chennai** for hosting VITISH 2025
- **ICAR** and the **Ministry of Agriculture** for research guidance
- All farmers who provided valuable real-world feedback
- The open-source community for amazing tools and libraries

---

<div align="center">

🌾 *Sowing Seeds of Smart Farming* 🌾

Built with ❤️ by **Team Krishi Deep — VIT-229**

</div>
