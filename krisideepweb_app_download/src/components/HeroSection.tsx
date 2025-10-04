import { Button } from "@/components/ui/button";
import { ArrowRight, Smartphone, Leaf, Users, TrendingUp, Sparkles, Star } from "lucide-react";
import { Language } from "./LanguageSwitcher";
import heroImage from "@/assets/indian-farmer-hero.jpg";

interface HeroSectionProps {
  language: Language;
}

const translations = {
  en: {
    title: "Empowering Indian Farmers with",
    titleHighlight: "AI-Driven Agriculture",
    subtitle: "Get personalized crop recommendations, real-time soil analysis, and market insights - all in your local language. Transform your farming with smart technology.",
    downloadApp: "Download Krisideep",
    learnMore: "Learn More",
    stats: {
      farmers: "50K+ Farmers",
      accuracy: "95% Accuracy",
      languages: "3 Languages",
    
    }
  },
  hi: {
    title: "भारतीय किसानों को सशक्त बनाना",
    titleHighlight: "एआई-संचालित कृषि के साथ",
    subtitle: "व्यक्तिगत फसल सिफारिशें, रीयल-टाइम मिट्टी विश्लेषण, और बाजार की जानकारी प्राप्त करें - सब कुछ आपकी स्थानीय भाषा में। स्मार्ट तकनीक के साथ अपनी खेती को बदलें।",
    downloadApp: "कृषिदीप डाउनलोड करें",
    learnMore: "और जानें",
    stats: {
      farmers: "50K+ किसान",
      accuracy: "95% सटीकता",
      languages: "3 भाषाएं",
    
    }
  },
  ta: {
    title: "இந்திய விவசாயிகளை வலுப்படுத்துதல்",
    titleHighlight: "AI-இயக்கப்படும் விவசாயத்துடன்",
    subtitle: "தனிப்பயனாக்கப்பட்ட பயிர் பரிந்துரைகள், நிகழ்நேர மண் பகுப்பாய்வு மற்றும் சந்தை நுண்ணறிவுகளைப் பெறுங்கள் - அனைத்தும் உங்கள் உள்ளூர் மொழியில். ஸ்மார்ட் தொழில்நுட்பத்துடன் உங்கள் விவசாயத்தை மாற்றுங்கள்.",
    downloadApp: "கிருஷிதீப் பதிவிறக்கம்",
    learnMore: "மேலும் அறிக",
    stats: {
      farmers: "50K+ விவசாயிகள்",
      accuracy: "95% துல்லியம்",
      languages: "3 மொழிகள்",
      
    }
  }
};

export const HeroSection = ({ language }: HeroSectionProps) => {
  const t = translations[language];

  const scrollToDownload = () => {
    document.getElementById('download')?.scrollIntoView({ behavior: 'smooth' });
  };

  const scrollToFeatures = () => {
    document.getElementById('features')?.scrollIntoView({ behavior: 'smooth' });
  };

  return (
    <section className="relative min-h-screen flex items-center overflow-hidden">
      {/* Enhanced Background with better overlay */}
      <div className="absolute inset-0 z-0">
        <img 
          src={heroImage} 
          alt="Indian farmer with smartphone"
          className="w-full h-full object-cover scale-105 transition-transform duration-1000 hover:scale-110"
        />
        {/* Light gradient overlay for better image visibility */}
        <div className="absolute inset-0 bg-gradient-to-br from-slate-900/40 via-slate-800/30 to-emerald-900/20"></div>
        {/* Subtle pattern overlay */}
        <div className="absolute inset-0 bg-gradient-to-t from-slate-900/50 via-transparent to-transparent"></div>
      </div>

      {/* Animated Background Elements */}
      <div className="absolute inset-0 overflow-hidden pointer-events-none">
        {[...Array(8)].map((_, i) => (
          <div
            key={i}
            className="absolute w-2 h-2 bg-emerald-400/30 rounded-full animate-pulse"
            style={{
              left: `${10 + i * 12}%`,
              top: `${15 + i * 10}%`,
              animationDelay: `${i * 0.7}s`,
              animationDuration: `${3 + i * 0.3}s`
            }}
          />
        ))}
      </div>

      {/* Enhanced Floating Elements */}
    

      {/* Main Content */}
      <div className="container mx-auto px-4 sm:px-6 lg:px-8 relative z-10 pt-16">
        <div className="grid lg:grid-cols-2 gap-12 items-center">
          <div className="space-y-8 animate-fade-in-left">
            <div className="space-y-6">
              {/* Enhanced Title */}
              <h1 className="text-4xl sm:text-5xl lg:text-7xl font-black leading-tight">
                <span className="text-white drop-shadow-2xl">{t.title}</span>
                <br />
                <span className="bg-gradient-to-r from-emerald-400 via-teal-300 to-cyan-400 bg-clip-text text-transparent animate-glow-pulse drop-shadow-lg">
                  {t.titleHighlight}
                </span>
              </h1>
              
              {/* Enhanced Subtitle */}
              <p className="text-xl sm:text-2xl text-white/95 leading-relaxed max-w-2xl font-medium drop-shadow-lg">
                {t.subtitle}
              </p>
            </div>

            {/* Enhanced Buttons */}
            <div className="flex flex-col sm:flex-row gap-4">
              <Button 
                onClick={scrollToDownload}
                size="lg" 
                className="relative overflow-hidden bg-gradient-to-r from-emerald-500 via-emerald-600 to-teal-600 hover:from-emerald-600 hover:via-emerald-700 hover:to-teal-700 text-white border-0 shadow-2xl shadow-emerald-500/30 hover:shadow-2xl hover:shadow-emerald-500/50 transition-all duration-500 hover:scale-110 transform font-bold text-lg px-10 py-4 rounded-2xl group"
              >
                {/* Shine effect */}
                <div className="absolute inset-0 bg-gradient-to-r from-transparent via-white/20 to-transparent skew-x-12 -translate-x-full group-hover:translate-x-full transition-transform duration-1000" />
                
                <Smartphone className="mr-3 h-6 w-6 group-hover:animate-pulse" />
                <span className="relative z-10">{t.downloadApp}</span>
                <ArrowRight className="ml-3 h-6 w-6 group-hover:translate-x-1 transition-transform duration-300" />
              </Button>
              
              <Button 
                onClick={scrollToFeatures}
                size="lg" 
                variant="outline" 
                className="border-2 border-white/40 text-black hover:bg-white/20 backdrop-blur-xl text-lg px-10 py-4 rounded-2xl transition-all duration-300 hover:scale-105 font-semibold hover:border-white/60 hover:shadow-xl"
              >
                {t.learnMore}
              </Button>
            </div>

            {/* Enhanced Stats */}
            <div className="grid grid-cols-2 sm:grid-cols-4 gap-6 pt-8 border-t border-white/30">
              {Object.values(t.stats).map((stat, index) => (
                <div 
                  key={index} 
                  className="text-center animate-scale-in bg-white/10 backdrop-blur-xl rounded-2xl p-4 border border-white/20 hover:bg-white/20 transition-all duration-300 hover:scale-105 group" 
                  style={{animationDelay: `${index * 0.2}s`}}
                >
                  <div className="text-2xl sm:text-3xl font-black text-white drop-shadow-lg group-hover:text-emerald-200 transition-colors duration-300">
                    {stat.split(' ')[0]}
                  </div>
                  <div className="text-sm text-white/80 font-medium mt-1">
                    {stat.split(' ').slice(1).join(' ')}
                  </div>
                </div>
              ))}
            </div>
          </div>

          {/* Enhanced Right Side Card */}
          <div className="hidden lg:block animate-fade-in-right">
            <div className="relative group">
              {/* Glowing background */}
              <div className="absolute inset-0 bg-gradient-to-br from-emerald-500/20 via-teal-500/20 to-cyan-500/20 rounded-3xl blur-3xl opacity-60 group-hover:opacity-80 transition-opacity duration-500 animate-pulse-glow"></div>
              
              {/* Main card */}
              <div className="relative p-8 bg-white/15 backdrop-blur-2xl rounded-3xl border border-white/30 shadow-2xl hover:shadow-3xl transition-all duration-500 hover:scale-105">
                <div className="space-y-6">
                  {/* Header */}
                  <div className="flex items-center gap-4 mb-6">
                    <div className="p-3 bg-gradient-to-br from-emerald-500 to-teal-600 rounded-xl shadow-lg">
                      <Users className="h-6 w-6 text-white" />
                    </div>
                    <div>
                      <span className="text-white font-bold text-lg block">Connected Farmers</span>
                      <span className="text-white/70 text-sm">Growing community</span>
                    </div>
                  </div>

                  {/* Progress Bar */}
                  <div className="space-y-3">
                    <div className="flex justify-between items-center">
                      <span className="text-white/90 font-medium">AI Accuracy</span>
                      <span className="text-emerald-300 font-bold">95%</span>
                    </div>
                    <div className="h-3 bg-white/20 rounded-full overflow-hidden backdrop-blur-sm">
                      <div className="h-full w-[95%] bg-gradient-to-r from-emerald-400 to-teal-400 rounded-full animate-scale-in shadow-lg" style={{animationDelay: '0.5s'}}></div>
                    </div>
                  </div>

                  {/* Features List */}
                  <div className="space-y-3 pt-4 border-t border-white/20">
                    {['Real-time Analysis', 'Multi-language Support', 'Market Insights'].map((feature, idx) => (
                      <div key={idx} className="flex items-center gap-3" style={{animationDelay: `${idx * 0.2 + 0.8}s`}}>
                        <div className="w-2 h-2 bg-emerald-400 rounded-full animate-pulse"></div>
                        <span className="text-white/90 font-medium">{feature}</span>
                      </div>
                    ))}
                  </div>

                  {/* Bottom text */}
                  <div className="text-white/70 text-sm text-center pt-4 border-t border-white/20 font-medium">
                    ✨ AI accuracy improving daily
                  </div>
                </div>

                {/* Floating indicators */}
                <div className="absolute -top-2 -right-2 w-4 h-4 bg-emerald-400 rounded-full animate-ping"></div>
                <div className="absolute -bottom-2 -left-2 w-3 h-3 bg-teal-400 rounded-full animate-pulse"></div>
              </div>
            </div>
          </div>
        </div>
      </div>

      {/* Enhanced Scroll Indicator */}
      <div className="absolute bottom-8 left-1/2 transform -translate-x-1/2 animate-bounce-gentle z-10">
        <div className="flex flex-col items-center gap-2 group cursor-pointer" onClick={scrollToFeatures}>
          <div className="text-white/70 text-sm font-medium group-hover:text-white transition-colors duration-300">
            Scroll Down
          </div>
          <div className="w-8 h-12 border-2 border-white/40 rounded-full flex justify-center group-hover:border-white/60 transition-colors duration-300">
            <div className="w-2 h-4 bg-white/70 rounded-full mt-2 animate-glow-pulse group-hover:bg-white transition-colors duration-300"></div>
          </div>
        </div>
      </div>

      <style>{`
        @keyframes float {
          0%, 100% { transform: translateY(0px) rotate(0deg); }
          50% { transform: translateY(-15px) rotate(5deg); }
        }
        
        @keyframes float-delayed {
          0%, 100% { transform: translateY(0px) rotate(0deg); }
          50% { transform: translateY(-20px) rotate(-3deg); }
        }
        
        @keyframes fade-in-left {
          from { opacity: 0; transform: translateX(-50px); }
          to { opacity: 1; transform: translateX(0); }
        }
        
        @keyframes fade-in-right {
          from { opacity: 0; transform: translateX(50px); }
          to { opacity: 1; transform: translateX(0); }
        }
        
        @keyframes scale-in {
          from { opacity: 0; transform: scale(0.8); }
          to { opacity: 1; transform: scale(1); }
        }
        
        @keyframes glow-pulse {
          0%, 100% { text-shadow: 0 0 20px rgba(16, 185, 129, 0.5); }
          50% { text-shadow: 0 0 40px rgba(16, 185, 129, 0.8), 0 0 60px rgba(16, 185, 129, 0.4); }
        }
        
        @keyframes pulse-glow {
          0%, 100% { opacity: 0.4; }
          50% { opacity: 0.8; }
        }
        
        @keyframes bounce-gentle {
          0%, 100% { transform: translateY(0) translateX(-50%); }
          50% { transform: translateY(-10px) translateX(-50%); }
        }
        
        .animate-float { animation: float 6s ease-in-out infinite; }
        .animate-float-delayed { animation: float-delayed 7s ease-in-out infinite; }
        .animate-fade-in-left { animation: fade-in-left 1s ease-out; }
        .animate-fade-in-right { animation: fade-in-right 1s ease-out 0.3s both; }
        .animate-scale-in { animation: scale-in 0.8s ease-out both; }
        .animate-glow-pulse { animation: glow-pulse 3s ease-in-out infinite; }
        .animate-pulse-glow { animation: pulse-glow 3s ease-in-out infinite; }
        .animate-bounce-gentle { animation: bounce-gentle 2s ease-in-out infinite; }
      `}</style>
    </section>
  );
};