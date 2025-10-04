import { Button } from "@/components/ui/button";
import { Card, CardContent } from "@/components/ui/card";
import { Download, Smartphone, Shield, Zap, Users, Star, Sparkles, ArrowRight, CheckCircle } from "lucide-react";
import { Language } from "./LanguageSwitcher";
import appMockup from "@/assets/krisideep-app-mockup.png";

interface DownloadSectionProps {
  language: Language;
}

const translations = {
  en: {
    title: "Download Krisideep",
    subtitle: "Take smart farming with you wherever you go",
    description: "Our mobile application provides enterprise-grade agricultural insights with an intuitive interface designed for Indian farmers.",
    appTitle: "Krisideep Mobile App",
    appSubtitle: "Smart Farming at Your Fingertips",
    appDescription: "Monitor crops, receive instant AI recommendations, and manage your farming operations from anywhere. Available with seamless multilingual support.",
    downloadButton: "Download Now",
    secureDownload: "Secure Download",
    secureNote: "All downloads are digitally signed and verified. No personal information required for basic features.",
    features: [
      { icon: Zap, text: "Real-time crop insights" },
      { icon: Shield, text: "Offline functionality" },
      { icon: Users, text: "Multilingual support" },
      { icon: Star, text: "AI-powered recommendations" }
    ],
    whatsIncluded: "What's Included",
    includedFeatures: [
      "Real-time soil analysis",
      "Crop disease detection", 
      "Market price alerts",
      "Weather forecasts",
      "Voice commands in local languages"
    ]
  },
  hi: {
    title: "कृषिदीप डाउनलोड करें",
    subtitle: "जहाँ भी जाएं, स्मार्ट खेती अपने साथ ले जाएं",
    description: "हमारा मोबाइल एप्लिकेशन भारतीय किसानों के लिए डिज़ाइन किए गए सहज इंटरफेस के साथ एंटरप्राइज-ग्रेड कृषि अंतर्दृष्टि प्रदान करता है।",
    appTitle: "कृषिदीप मोबाइल ऐप",
    appSubtitle: "आपकी उंगलियों पर स्मार्ट खेती",
    appDescription: "फसलों की निगरानी करें, तत्काल एआई सिफारिशें प्राप्त करें, और कहीं से भी अपने खेती के संचालन का प्रबंधन करें। निर्बाध बहुभाषी सहायता के साथ उपलब्ध।",
    downloadButton: "अभी डाउनलोड करें",
    secureDownload: "सुरक्षित डाउनलोड",
    secureNote: "सभी डाउनलोड डिजिटल रूप से हस्ताक्षरित और सत्यापित हैं। बुनियादी सुविधाओं के लिए कोई व्यक्तिगत जानकारी आवश्यक नहीं।",
    features: [
      { icon: Zap, text: "रीयल-टाइम फसल अंतर्दृष्टि" },
      { icon: Shield, text: "ऑफलाइन कार्यक्षमता" },
      { icon: Users, text: "बहुभाषी सहायता" },
      { icon: Star, text: "एआई-संचालित सिफारिशें" }
    ],
    whatsIncluded: "क्या शामिल है",
    includedFeatures: [
      "रीयल-टाइम मिट्टी विश्लेषण",
      "फसल रोग का पता लगाना",
      "बाजार मूल्य अलर्ट",
      "मौसम पूर्वानुमान",
      "स्थानीय भाषाओं में आवाज कमांड"
    ]
  },
  ta: {
    title: "கிருஷிதீப் பதிவிறக்கம்",
    subtitle: "நீங்கள் எங்கு சென்றாலும் ஸ்மார்ட் விவசாயத்தை எடுத்துச் செல்லுங்கள்",
    description: "எங்கள் மொபைல் பயன்பாடு இந்திய விவசாயிகளுக்காக வடிவமைக்கப்பட்ட உள்ளுணர்வு இடைமுகத்துடன் நிறுவன-தர விவசாய நுண்ணறிவுகளை வழங்குகிறது।",
    appTitle: "கிருஷிதீப் மொபைல் ஆப்",
    appSubtitle: "உங்கள் விரல் நுனியில் ஸ்மார்ட் விவசாயம்",
    appDescription: "பயிர்களைக் கண்காணிக்கவும், உடனடி AI பரிந்துரைகளைப் பெறவும், எங்கிருந்தும் உங்கள் விவசாய நடவடிக்கைகளை நிர்வகிக்கவும். தடையற்ற பலமொழி ஆதரவுடன் கிடைக்கிறது।",
    downloadButton: "இப்போது பதிவிறக்கவும்",
    secureDownload: "பாதுகாப்பான பதிவிறக்கம்",
    secureNote: "அனைத்து பதிவிறக்கங்களும் டிஜிட்டல் முறையில் கையொப்பமிடப்பட்டு சரிபார்க்கப்பட்டுள்ளன. அடிப்படை அம்சங்களுக்கு தனிப்பட்ட தகவல் தேவையில்லை।",
    features: [
      { icon: Zap, text: "நிகழ்நேர பயிர் நுண்ணறிவுகள்" },
      { icon: Shield, text: "ஆஃப்லைன் செயல்பாடு" },
      { icon: Users, text: "பலமொழி ஆதரவு" },
      { icon: Star, text: "AI-இயக்கப்படும் பரிந்துரைகள்" }
    ],
    whatsIncluded: "என்ன அடங்கியுள்ளது",
    includedFeatures: [
      "நிகழ்நேர மண் பகுப்பாய்வு",
      "பயிர் நோய் கண்டறிதல்",
      "சந்தை விலை எச்சரிக்கைகள்",
      "வானிலை முன்னறிவிப்புகள்",
      "உள்ளூர் மொழிகளில் குரல் கட்டளைகள்"
    ]
  }
};

export const DownloadSection = ({ language }: DownloadSectionProps) => {
  const t = translations[language];

  return (
    <section id="download" className="relative py-24 lg:py-32 overflow-hidden">
      {/* Enhanced Background */}
      <div className="absolute inset-0 bg-gradient-to-br from-white via-emerald-50/30 to-teal-50/50 dark:from-slate-900 dark:via-slate-800 dark:to-emerald-900/10"></div>
      
      {/* Animated particles */}
      <div className="absolute inset-0 overflow-hidden pointer-events-none">
        {[...Array(12)].map((_, i) => (
          <div
            key={i}
            className="absolute w-2 h-2 bg-emerald-400/20 rounded-full animate-pulse-slow"
            style={{
              left: `${Math.random() * 100}%`,
              top: `${Math.random() * 100}%`,
              animationDelay: `${i * 1.2}s`,
              animationDuration: `${4 + Math.random() * 2}s`
            }}
          />
        ))}
      </div>

      <div className="container mx-auto px-4 sm:px-6 lg:px-8 relative z-10">
        {/* Enhanced Header */}
        <div className="text-center mb-20 animate-fade-in">
          <div className="inline-flex items-center gap-2 px-6 py-3 rounded-full bg-emerald-100 dark:bg-emerald-900/30 border border-emerald-200 dark:border-emerald-700 mb-8 shadow-lg">
            <Smartphone className="h-4 w-4 text-emerald-600 dark:text-emerald-400" />
            <span className="text-emerald-800 dark:text-emerald-200 text-sm font-bold tracking-wide">Mobile App</span>
          </div>
          
          <h2 className="text-4xl sm:text-5xl lg:text-6xl font-black mb-6">
            <span className="bg-gradient-to-r from-emerald-600 via-teal-500 to-cyan-500 bg-clip-text text-transparent animate-glow-pulse drop-shadow-lg">
              {t.title}
            </span>
          </h2>
          
          <p className="text-xl text-slate-600 dark:text-slate-300 max-w-4xl mx-auto leading-relaxed font-medium">
            {t.subtitle}
          </p>
        </div>

        {/* Enhanced Main Content - Adjusted for smaller image */}
        <div className="grid lg:grid-cols-5 gap-12 items-center mb-20">
          {/* Smaller App Mockup - Now takes 2 columns */}
          <div className="lg:col-span-2 relative animate-fade-in-left flex justify-center">
            {/* Glowing background elements - smaller */}
            <div className="absolute inset-0 bg-gradient-to-br from-emerald-500/20 via-teal-500/20 to-cyan-500/20 rounded-[2rem] blur-2xl opacity-60 animate-pulse-glow scale-110"></div>
            <div className="absolute -top-2 -right-2 w-16 h-16 bg-gradient-to-br from-emerald-400/30 to-teal-400/30 rounded-full blur-xl animate-float-gentle"></div>
            <div className="absolute -bottom-3 -left-3 w-20 h-20 bg-gradient-to-br from-teal-400/20 to-cyan-400/20 rounded-full blur-xl animate-float-reverse"></div>
            
            {/* Compact premium device frame */}
            <div className="relative w-full max-w-xs bg-gradient-to-br from-white/95 via-white/90 to-white/85 dark:from-slate-800/95 dark:via-slate-800/90 dark:to-slate-800/85 backdrop-blur-xl rounded-[2rem] p-4 shadow-2xl border border-white/40 dark:border-slate-700/40 hover:scale-110 transition-all duration-700 group">
              {/* Phone bezel effect - smaller */}
              <div className="relative bg-gradient-to-br from-slate-900 to-slate-700 rounded-[1.5rem] p-2 shadow-inner">
                <div className="bg-black rounded-[1.3rem] p-0.5 relative overflow-hidden">
                  {/* Screen glow */}
                  <div className="absolute inset-0 bg-gradient-to-br from-emerald-500/20 via-transparent to-teal-500/20 rounded-[1.2rem]"></div>
                  
                  <img
                    src={appMockup}
                    alt="Krisideep Mobile App"
                    className="w-full h-auto rounded-[1.1rem] relative z-10 group-hover:scale-105 transition-transform duration-700 shadow-lg"
                  />
                  
                  {/* Screen shine effect */}
                  <div className="absolute inset-0 bg-gradient-to-tr from-white/30 via-transparent to-transparent rounded-[1.2rem] opacity-0 group-hover:opacity-100 transition-opacity duration-700"></div>
                </div>
                
                {/* Home indicator - smaller */}
                <div className="absolute bottom-0.5 left-1/2 transform -translate-x-1/2 w-20 h-0.5 bg-white/40 rounded-full"></div>
              </div>

              {/* Floating UI elements - adjusted */}
              <div className="absolute -top-1 left-4 w-3 h-3 bg-emerald-400 rounded-full animate-ping opacity-60"></div>
              <div className="absolute -bottom-1 right-6 w-2 h-2 bg-teal-400 rounded-full animate-pulse opacity-80"></div>
            </div>
          </div>

          {/* Enhanced Content - Now takes 3 columns */}
          <div className="lg:col-span-3 space-y-8 animate-fade-in-right">
            <div className="space-y-6">
              <div className="flex items-center gap-4 mb-6">
                <div className="p-4 rounded-2xl bg-gradient-to-br from-emerald-500 to-teal-600 shadow-xl">
                  <Smartphone className="h-7 w-7 text-white drop-shadow-lg" />
                </div>
                <div>
                  <span className="text-sm font-bold text-emerald-600 dark:text-emerald-400 uppercase tracking-wider">{t.appTitle}</span>
                  <div className="w-12 h-0.5 bg-gradient-to-r from-emerald-500 to-teal-500 mt-1"></div>
                </div>
              </div>
              
              <h3 className="text-3xl lg:text-4xl font-black text-slate-800 dark:text-white leading-tight">
                {t.appSubtitle}
              </h3>
              
              <p className="text-lg text-slate-600 dark:text-slate-300 leading-relaxed font-medium">
                {t.appDescription}
              </p>
            </div>

            {/* Enhanced Features Grid */}
            <div className="grid grid-cols-1 sm:grid-cols-2 gap-4">
              {t.features.map((feature, index) => (
                <div 
                  key={index} 
                  className="group flex items-center gap-4 p-6 rounded-2xl bg-gradient-to-r from-white/70 to-white/50 dark:from-slate-800/70 dark:to-slate-800/50 backdrop-blur-xl border border-white/40 dark:border-slate-700/40 hover:border-emerald-200 dark:hover:border-emerald-600/50 hover:scale-105 transition-all duration-500 animate-scale-in shadow-lg hover:shadow-xl"
                  style={{animationDelay: `${index * 0.15}s`}}
                >
                  <div className="p-3 rounded-xl bg-gradient-to-br from-emerald-500 to-teal-600 shadow-lg group-hover:scale-110 transition-transform duration-300">
                    <feature.icon className="h-5 w-5 text-white drop-shadow-sm" />
                  </div>
                  <span className="font-semibold text-slate-800 dark:text-white group-hover:text-emerald-600 dark:group-hover:text-emerald-400 transition-colors duration-300">{feature.text}</span>
                </div>
              ))}
            </div>

            {/* Enhanced Download Button */}
            <div className="space-y-6">
              <Button 
                size="lg" 
                className="group relative overflow-hidden w-full sm:w-auto bg-gradient-to-r from-emerald-500 via-emerald-600 to-teal-600 hover:from-emerald-600 hover:via-emerald-700 hover:to-teal-700 text-white border-0 shadow-2xl shadow-emerald-500/40 hover:shadow-2xl hover:shadow-emerald-500/60 transition-all duration-500 hover:scale-110 transform font-bold text-lg px-12 py-5 rounded-2xl"
              >
                {/* Shine effect */}
                <div className="absolute inset-0 bg-gradient-to-r from-transparent via-white/30 to-transparent skew-x-12 -translate-x-full group-hover:translate-x-full transition-transform duration-1000"></div>
                
                <Download className="mr-3 h-6 w-6 group-hover:animate-bounce" />
                <span className="relative z-10">{t.downloadButton}</span>
                <ArrowRight className="ml-3 h-6 w-6 group-hover:translate-x-1 transition-transform duration-300" />
              </Button>
              
              {/* Enhanced Security Notice */}
              <div className="flex items-start gap-4 p-6 bg-gradient-to-r from-slate-50/90 to-white/90 dark:from-slate-800/90 dark:to-slate-700/90 rounded-2xl border border-slate-200/60 dark:border-slate-600/60 shadow-xl backdrop-blur-sm">
                <div className="p-2 rounded-xl bg-gradient-to-br from-green-500 to-emerald-600 shadow-lg">
                  <Shield className="h-5 w-5 text-white" />
                </div>
                <div>
                  <div className="font-bold text-slate-800 dark:text-white mb-2 flex items-center gap-2">
                    {t.secureDownload}
                    <CheckCircle className="h-4 w-4 text-green-500" />
                  </div>
                  <div className="text-sm text-slate-600 dark:text-slate-300 leading-relaxed">
                    {t.secureNote}
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>

        {/* Enhanced What's Included Section */}
        <Card className="relative overflow-hidden bg-gradient-to-br from-white/95 via-white/90 to-emerald-50/60 dark:from-slate-800/95 dark:via-slate-800/90 dark:to-emerald-900/30 backdrop-blur-2xl border border-white/40 dark:border-slate-700/40 shadow-2xl rounded-3xl animate-slide-up">
          {/* Background decoration - enhanced */}
          <div className="absolute top-0 right-0 w-72 h-72 bg-gradient-to-bl from-emerald-500/15 via-teal-500/10 to-transparent rounded-3xl"></div>
          <div className="absolute bottom-0 left-0 w-56 h-56 bg-gradient-to-tr from-teal-500/15 via-cyan-500/10 to-transparent rounded-3xl"></div>
          
          <CardContent className="p-12 relative z-10">
            <div className="grid md:grid-cols-2 gap-16 items-center">
              {/* Features List */}
              <div className="space-y-8">
                <div className="flex items-center gap-3 mb-8">
                  <div className="p-4 rounded-xl bg-gradient-to-br from-emerald-500 to-teal-600 shadow-xl">
                    <Sparkles className="h-6 w-6 text-white" />
                  </div>
                  <h3 className="text-3xl font-black text-slate-800 dark:text-white">{t.whatsIncluded}</h3>
                </div>
                
                <div className="space-y-5">
                  {t.includedFeatures.map((feature, index) => (
                    <div 
                      key={index} 
                      className="group flex items-center gap-5 p-5 rounded-xl bg-white/60 dark:bg-slate-700/60 backdrop-blur-sm border border-white/40 dark:border-slate-600/40 hover:bg-white/80 dark:hover:bg-slate-700/80 hover:scale-105 transition-all duration-500 animate-fade-in-left shadow-lg hover:shadow-xl"
                      style={{animationDelay: `${index * 0.1}s`}}
                    >
                      <div className="w-4 h-4 rounded-full bg-gradient-to-r from-emerald-500 to-teal-500 shadow-lg group-hover:scale-125 transition-transform duration-300 flex-shrink-0"></div>
                      <span className="font-semibold text-slate-800 dark:text-white group-hover:text-emerald-600 dark:group-hover:text-emerald-400 transition-colors duration-300">{feature}</span>
                    </div>
                  ))}
                </div>
              </div>
              
              {/* Enhanced Stats Card */}
              <div className="relative group">
                {/* Glow effect - enhanced */}
                <div className="absolute inset-0 bg-gradient-to-br from-emerald-500/25 to-teal-500/25 rounded-3xl blur-2xl opacity-70 group-hover:opacity-90 transition-opacity duration-500"></div>
                
                <div className="relative p-12 bg-gradient-to-br from-emerald-500 via-emerald-600 to-teal-600 rounded-3xl text-center text-white shadow-2xl transform group-hover:scale-105 transition-all duration-500 border border-emerald-400/40">
                  {/* Background pattern - enhanced */}
                  <div className="absolute inset-0 bg-gradient-to-tr from-white/15 via-white/5 to-transparent rounded-3xl"></div>
                  
                  <div className="relative z-10 space-y-8">
                    <div className="text-6xl font-black drop-shadow-2xl animate-pulse-glow">50K+</div>
                    <div className="text-xl font-bold drop-shadow-lg">
                      {language === 'en' ? 'Active Farmers' : 
                       language === 'hi' ? 'सक्रिय किसान' : 
                       'செயலில் உள்ள விவசாயிகள்'}
                    </div>
                    
                    <div className="flex justify-center gap-2 mb-6">
                      {[...Array(5)].map((_, i) => (
                        <Star 
                          key={i} 
                          className="h-7 w-7 fill-current text-yellow-300 drop-shadow-xl animate-pulse"
                          style={{ animationDelay: `${i * 0.2}s` }}
                        />
                      ))}
                    </div>
                    
                    <div className="text-base opacity-95 font-medium drop-shadow-md">
                      {language === 'en' ? '5.0 Average Rating' : 
                       language === 'hi' ? '5.0 औसत रेटिंग' : 
                       '5.0 சராசரி மதிப்பீடு'}
                    </div>
                  </div>

                  {/* Floating elements - enhanced */}
                  <div className="absolute -top-3 -right-3 w-5 h-5 bg-white/40 rounded-full animate-ping"></div>
                  <div className="absolute -bottom-3 -left-3 w-4 h-4 bg-yellow-300/70 rounded-full animate-pulse"></div>
                </div>
              </div>
            </div>
          </CardContent>
        </Card>
      </div>

      <style>{`
        @keyframes fade-in {
          from { opacity: 0; transform: translateY(30px); }
          to { opacity: 1; transform: translateY(0); }
        }
        
        @keyframes fade-in-left {
          from { opacity: 0; transform: translateX(-30px); }
          to { opacity: 1; transform: translateX(0); }
        }
        
        @keyframes fade-in-right {
          from { opacity: 0; transform: translateX(30px); }
          to { opacity: 1; transform: translateX(0); }
        }
        
        @keyframes scale-in {
          from { opacity: 0; transform: scale(0.9) translateY(20px); }
          to { opacity: 1; transform: scale(1) translateY(0); }
        }
        
        @keyframes slide-up {
          from { opacity: 0; transform: translateY(50px); }
          to { opacity: 1; transform: translateY(0); }
        }
        
        @keyframes pulse-slow {
          0%, 100% { opacity: 0.3; }
          50% { opacity: 0.8; }
        }
        
        @keyframes pulse-glow {
          0%, 100% { opacity: 0.6; }
          50% { opacity: 1; }
        }
        
        @keyframes float-gentle {
          0%, 100% { transform: translateY(0px) rotate(0deg); }
          50% { transform: translateY(-8px) rotate(2deg); }
        }
        
        @keyframes float-reverse {
          0%, 100% { transform: translateY(0px) rotate(0deg); }
          50% { transform: translateY(8px) rotate(-2deg); }
        }
        
        @keyframes glow-pulse {
          0%, 100% { text-shadow: 0 0 20px rgba(16, 185, 129, 0.5); }
          50% { text-shadow: 0 0 40px rgba(16, 185, 129, 0.8), 0 0 60px rgba(16, 185, 129, 0.4); }
        }
        
        .animate-fade-in { animation: fade-in 1s ease-out; }
        .animate-fade-in-left { animation: fade-in-left 1s ease-out both; }
        .animate-fade-in-right { animation: fade-in-right 1s ease-out 0.3s both; }
        .animate-scale-in { animation: scale-in 0.8s ease-out both; }
        .animate-slide-up { animation: slide-up 1s ease-out 0.5s both; }
        .animate-pulse-slow { animation: pulse-slow 4s ease-in-out infinite; }
        .animate-pulse-glow { animation: pulse-glow 3s ease-in-out infinite; }
        .animate-float-gentle { animation: float-gentle 6s ease-in-out infinite; }
        .animate-float-reverse { animation: float-reverse 8s ease-in-out infinite; }
        .animate-glow-pulse { animation: glow-pulse 3s ease-in-out infinite; }
      `}</style>
    </section>
  );
};