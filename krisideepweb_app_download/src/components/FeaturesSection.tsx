import { Brain, Satellite, MessageCircle, TrendingUp, Wifi, Camera, Leaf, Globe, Shield, Sparkles, Star } from "lucide-react";
import { Card, CardContent } from "@/components/ui/card";
import { Language } from "./LanguageSwitcher";
import img1 from '../assets/image1.png'
import img2 from '../assets/image2.png'
import img3 from '../assets/image3.png'
import img4 from '../assets/img4.png'
import img5 from '../assets/image5.png'
import img6 from '../assets/image6.png'

interface FeaturesSectionProps {
  language: Language;
}

const translations = {
  en: {
    title: "Intelligent Features",
    subtitle: "for Modern Farming",
    description: "Discover how Krisideep transforms traditional farming with cutting-edge AI technology and real-time insights.",
    features: [
      {
        icon: Brain,
        title: "AI Crop Recommendations",
        description: "Get personalized crop suggestions based on soil conditions, weather patterns, and market demand.",
        gradient: "from-purple-500 to-pink-500",
        bgGradient: "from-purple-500/10 to-pink-500/10",
        imageUrl: img1,
      },
      {
        icon: Satellite,
        title: "Satellite Soil Analysis",
        description: "Real-time soil pH, moisture, and nutrient analysis using advanced satellite data and IoT sensors.",
        gradient: "from-blue-500 to-cyan-500",
        bgGradient: "from-blue-500/10 to-cyan-500/10",
        imageUrl:img2
      },
      {
        icon: MessageCircle,
        title: "Multilingual Chat Support",
        description: "Voice and text support in Hindi, Tamil, and English for seamless communication.",
        gradient: "from-emerald-500 to-teal-500",
        bgGradient: "from-emerald-500/10 to-teal-500/10",
        imageUrl: img3
      },
      {
        icon: TrendingUp,
        title: "Market Price Forecasting",
        description: "Stay ahead with accurate market price predictions and demand trends for better profits.",
        gradient: "from-orange-500 to-red-500",
        bgGradient: "from-orange-500/10 to-red-500/10",
        imageUrl: img5
      },
      {
        icon: Wifi,
        title: "Offline Functionality",
        description: "Access critical farming data and recommendations even in low-connectivity rural areas.",
        gradient: "from-indigo-500 to-purple-500",
        bgGradient: "from-indigo-500/10 to-purple-500/10",
        imageUrl: img6
      },
      {
        icon: Camera,
        title: "Disease Detection",
        description: "Instantly identify crop diseases and pests using AI-powered image recognition technology.",
        gradient: "from-green-500 to-emerald-500",
        bgGradient: "from-green-500/10 to-emerald-500/10",
        imageUrl: img4
      },

    ]
  },
  hi: {
    title: "बुद्धिमान सुविधाएं",
    subtitle: "आधुनिक खेती के लिए",
    description: "जानें कि कैसे कृषिदीप अत्याधुनिक एआई तकनीक और रीयल-टाइम जानकारी के साथ पारंपरिक खेती को बदल देता है।",
    features: [
      {
        icon: Brain,
        title: "एआई फसल सुझाव",
        description: "मिट्टी की स्थिति, मौसम के पैटर्न और बाजार की मांग के आधार पर व्यक्तिगत फसल सुझाव प्राप्त करें।",
        gradient: "from-purple-500 to-pink-500",
        bgGradient: "from-purple-500/10 to-pink-500/10",
        imageUrl: "https://images.unsplash.com/photo-1574323347407-f5e1ad6d020b?w=400&h=300&fit=crop&crop=center"
      },
      {
        icon: Satellite,
        title: "सैटेलाइट मिट्टी विश्लेषण",
        description: "उन्नत सैटेलाइट डेटा और IoT सेंसर का उपयोग करके रीयल-टाइम मिट्टी का pH, नमी और पोषक तत्व विश्लेषण।",
        gradient: "from-blue-500 to-cyan-500",
        bgGradient: "from-blue-500/10 to-cyan-500/10",
        imageUrl: "https://images.unsplash.com/photo-1446776653964-20c1d3a81b06?w=400&h=300&fit=crop&crop=center"
      },
      {
        icon: MessageCircle,
        title: "बहुभाषी चैट सपोर्ट",
        description: "निर्बाध संचार के लिए हिंदी, तमिल और अंग्रेजी में आवाज और टेक्स्ट सपोर्ट।",
        gradient: "from-emerald-500 to-teal-500",
        bgGradient: "from-emerald-500/10 to-teal-500/10",
        imageUrl: "https://images.unsplash.com/photo-1577563908411-5077b6dc7624?w=400&h=300&fit=crop&crop=center"
      },
      {
        icon: TrendingUp,
        title: "बाजार मूल्य पूर्वानुमान",
        description: "बेहतर मुनाफे के लिए सटीक बाजार मूल्य भविष्यवाणी और मांग के रुझान के साथ आगे रहें।",
        gradient: "from-orange-500 to-red-500",
        bgGradient: "from-orange-500/10 to-red-500/10",
        imageUrl: "https://images.unsplash.com/photo-1611224923853-80b023f02d71?w=400&h=300&fit=crop&crop=center"
      },
      {
        icon: Wifi,
        title: "ऑफलाइन कार्यक्षमता",
        description: "कम कनेक्टिविटी वाले ग्रामीण क्षेत्रों में भी महत्वपूर्ण खेती डेटा और सुझावों तक पहुंच।",
        gradient: "from-indigo-500 to-purple-500",
        bgGradient: "from-indigo-500/10 to-purple-500/10",
        imageUrl: "https://images.unsplash.com/photo-1516321318423-f06f85e504b3?w=400&h=300&fit=crop&crop=center"
      },
      {
        icon: Camera,
        title: "बीमारी का पता लगाना",
        description: "एआई-संचालित छवि पहचान तकनीक का उपयोग करके फसल की बीमारियों और कीटों की तुरंत पहचान करें।",
        gradient: "from-green-500 to-emerald-500",
        bgGradient: "from-green-500/10 to-emerald-500/10",
        imageUrl: "https://images.unsplash.com/photo-1416879595882-3373a0480b5b?w=400&h=300&fit=crop&crop=center"
      },
      {
        icon: Leaf,
        title: "टिकाऊ प्रथाएं",
        description: "फसल चक्र और जैविक तरीकों के सुझावों के साथ पर्यावरण-अनुकूल खेती को बढ़ावा दें।",
        gradient: "from-teal-500 to-green-500",
        bgGradient: "from-teal-500/10 to-green-500/10",
        imageUrl: "https://images.unsplash.com/photo-1500382017468-9049fed747ef?w=400&h=300&fit=crop&crop=center"
      },
      {
        icon: Globe,
        title: "मौसम एकीकरण",
        description: "खेती की गतिविधियों की प्रभावी योजना बनाने के लिए स्थानीयकृत मौसम पूर्वानुमान और अलर्ट।",
        gradient: "from-sky-500 to-blue-500",
        bgGradient: "from-sky-500/10 to-blue-500/10",
        imageUrl: "https://images.unsplash.com/photo-1504608524841-42fe6f032b4b?w=400&h=300&fit=crop&crop=center"
      },
      {
        icon: Shield,
        title: "डेटा सुरक्षा",
        description: "आपका खेती डेटा एन्क्रिप्टेड और सुरक्षित है, गोपनीयता और अनुपालन सुनिश्चित करता है।",
        gradient: "from-slate-500 to-gray-500",
        bgGradient: "from-slate-500/10 to-gray-500/10",
        imageUrl: "https://images.unsplash.com/photo-1563013544-824ae1b704d3?w=400&h=300&fit=crop&crop=center"
      }
    ]
  },
  ta: {
    title: "அறிவார்ந்த அம்சங்கள்",
    subtitle: "நவீன விவசாயத்திற்காக",
    description: "அதிநவீன AI தொழில்நுட்பம் மற்றும் நிகழ்நேர நுண்ணறிவுகளுடன் கிருஷிதீப் எவ்வாறு பாரம்பரிய விவசாயத்தை மாற்றுகிறது என்பதைக் கண்டறியுங்கள்.",
    features: [
      {
        icon: Brain,
        title: "AI பயிர் பரிந்துரைகள்",
        description: "மண் நிலைமைகள், வானிலை முறைகள் மற்றும் சந்தை தேவையின் அடிப்படையில் தனிப்பயனாக்கப்பட்ட பயிர் பரிந்துரைகளைப் பெறுங்கள்.",
        gradient: "from-purple-500 to-pink-500",
        bgGradient: "from-purple-500/10 to-pink-500/10",
        imageUrl: "https://images.unsplash.com/photo-1574323347407-f5e1ad6d020b?w=400&h=300&fit=crop&crop=center"
      },
      {
        icon: Satellite,
        title: "செயற்கைக்கோள் மண் பகுப்பாய்வு",
        description: "மேம்பட்ட செயற்கைக்கோள் தரவு மற்றும் IoT சென்சார்களைப் பயன்படுத்தி நிகழ்நேர மண் pH, ஈரப்பதம் மற்றும் ஊட்டச்சத்து பகுப்பாய்வு।",
        gradient: "from-blue-500 to-cyan-500",
        bgGradient: "from-blue-500/10 to-cyan-500/10",
        imageUrl: "https://images.unsplash.com/photo-1446776653964-20c1d3a81b06?w=400&h=300&fit=crop&crop=center"
      },
      {
        icon: MessageCircle,
        title: "பலமொழி அரட்டை ஆதரவு",
        description: "தடையற்ற தொடர்புக்காக தமிழ், இந்தி மற்றும் ஆங்கிலத்தில் குரல் மற்றும் உரை ஆதரவு.",
        gradient: "from-emerald-500 to-teal-500",
        bgGradient: "from-emerald-500/10 to-teal-500/10",
        imageUrl: "https://images.unsplash.com/photo-1577563908411-5077b6dc7624?w=400&h=300&fit=crop&crop=center"
      },
      {
        icon: TrendingUp,
        title: "சந்தை விலை முன்னறிவிப்பு",
        description: "சிறந்த லாபத்திற்காக துல்லியமான சந்தை விலை முன்னறிவிப்புகள் மற்றும் தேவை போக்குகளுடன் முன்னால் இருங்கள்.",
        gradient: "from-orange-500 to-red-500",
        bgGradient: "from-orange-500/10 to-red-500/10",
        imageUrl: "https://images.unsplash.com/photo-1611224923853-80b023f02d71?w=400&h=300&fit=crop&crop=center"
      },
      {
        icon: Wifi,
        title: "ஆஃப்லைன் செயல்பாடு",
        description: "குறைந்த இணைப்பு உள்ள கிராமப்புறங்களில் கூட முக்கிய விவசாய தரவு மற்றும் பரிந்துரைகளை அணுகுங்கள்.",
        gradient: "from-indigo-500 to-purple-500",
        bgGradient: "from-indigo-500/10 to-purple-500/10",
        imageUrl: "https://images.unsplash.com/photo-1516321318423-f06f85e504b3?w=400&h=300&fit=crop&crop=center"
      },
      {
        icon: Camera,
        title: "நோய் கண்டறிதல்",
        description: "AI-இயக்கப்படும் படம் அடையாள தொழில்நுட்பத்தைப் பயன்படுத்தி பயிர் நோய்கள் மற்றும் பூச்சிகளை உடனடியாக அடையாளம் காணுங்கள்.",
        gradient: "from-green-500 to-emerald-500",
        bgGradient: "from-green-500/10 to-emerald-500/10",
        imageUrl: "https://images.unsplash.com/photo-1416879595882-3373a0480b5b?w=400&h=300&fit=crop&crop=center"
      },
      {
        icon: Leaf,
        title: "நிலையான நடைமுறைகள்",
        description: "பயிர் சுழற்சி மற்றும் இயற்கை முறைகளுக்கான பரிந்துரைகளுடன் சுற்றுச்சூழல் நட்பு விவசாயத்தை ஊக்குவிக்கவும்.",
        gradient: "from-teal-500 to-green-500",
        bgGradient: "from-teal-500/10 to-green-500/10",
        imageUrl: "https://images.unsplash.com/photo-1500382017468-9049fed747ef?w=400&h=300&fit=crop&crop=center"
      },
      {
        icon: Globe,
        title: "வானிலை ஒருங்கிணைப்பு",
        description: "விவசாய நடவடிக்கைகளை திறம்பட திட்டமிட உள்ளூர்மயமாக்கப்பட்ட வானிலை முன்னறிவிப்புகள் மற்றும் எச்சரிக்கைகள்.",
        gradient: "from-sky-500 to-blue-500",
        bgGradient: "from-sky-500/10 to-blue-500/10",
        imageUrl: "https://images.unsplash.com/photo-1504608524841-42fe6f032b4b?w=400&h=300&fit=crop&crop=center"
      },
      {
        icon: Shield,
        title: "தரவு பாதுகாப்பு",
        description: "உங்கள் விவசாய தரவு குறியாக்கம் செய்யப்பட்டு பாதுகாப்பானது, தனியுரிmai மற்றும் இணக்கத்தை உறுதி செய்கிறது.",
        gradient: "from-slate-500 to-gray-500",
        bgGradient: "from-slate-500/10 to-gray-500/10",
        imageUrl: "https://images.unsplash.com/photo-1563013544-824ae1b704d3?w=400&h=300&fit=crop&crop=center"
      }
    ]
  }
};

export const FeaturesSection = ({ language }: FeaturesSectionProps) => {
  const t = translations[language];

  return (
    <section id="features" className="relative py-24 lg:py-32 overflow-hidden">
      {/* Enhanced Background */}
      <div className="absolute inset-0 bg-gradient-to-br from-slate-50 via-white to-emerald-50/30 dark:from-slate-900 dark:via-slate-800 dark:to-emerald-900/10"></div>
      
      {/* Animated background particles */}
      <div className="absolute inset-0 overflow-hidden pointer-events-none">
        {[...Array(12)].map((_, i) => (
          <div
            key={i}
            className="absolute w-2 h-2 bg-emerald-400/20 dark:bg-emerald-400/30 rounded-full animate-pulse"
            style={{
              left: `${Math.random() * 100}%`,
              top: `${Math.random() * 100}%`,
              animationDelay: `${i * 0.8}s`,
              animationDuration: `${3 + Math.random() * 2}s`
            }}
          />
        ))}
      </div>

      <div className="container mx-auto px-4 sm:px-6 lg:px-8 relative z-10">
        {/* Enhanced Header */}
        <div className="text-center mb-20 animate-fade-in">
          <div className="inline-flex items-center gap-2 px-4 py-2 rounded-full bg-emerald-100 dark:bg-emerald-900/30 border border-emerald-200 dark:border-emerald-700 mb-8">
            <Sparkles className="h-4 w-4 text-emerald-600 dark:text-emerald-400" />
            <span className="text-emerald-800 dark:text-emerald-200 text-sm font-semibold">Advanced Technology</span>
          </div>
          
          <h2 className="text-4xl sm:text-5xl lg:text-6xl font-black mb-6">
            <span className="text-slate-800 dark:text-white drop-shadow-lg">{t.title}</span>
            <br />
            <span className="bg-gradient-to-r from-emerald-500 via-teal-500 to-cyan-500 bg-clip-text text-transparent animate-glow-pulse">
              {t.subtitle}
            </span>
          </h2>
          
          <p className="text-xl text-slate-600 dark:text-slate-300 max-w-4xl mx-auto leading-relaxed font-medium">
            {t.description}
          </p>
        </div>

        {/* Enhanced Features Grid */}
        <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8 lg:gap-10">
          {t.features.map((feature, index) => (
            <Card 
              key={index} 
              className="group relative overflow-hidden bg-white/80 dark:bg-slate-800/80 backdrop-blur-xl border border-white/20 dark:border-slate-700/30 hover:border-emerald-200 dark:hover:border-emerald-600/50 transition-all duration-700 hover:scale-105 hover:shadow-2xl hover:shadow-emerald-500/20 animate-scale-in rounded-3xl"
              style={{animationDelay: `${index * 0.15}s`}}
            >
              {/* Image Header */}
              <div className="relative h-48 overflow-hidden rounded-t-3xl">
                <img
                  src={feature.imageUrl}
                  alt={feature.title}
                  className="w-full h-full object-cover transition-transform duration-700 group-hover:scale-110"
                  loading="lazy"
                />
                {/* Gradient overlay */}
                <div className={`absolute inset-0 bg-gradient-to-t ${feature.bgGradient} to-transparent opacity-70 group-hover:opacity-50 transition-all duration-700`}></div>
                
                {/* Enhanced floating elements */}
                <div className="absolute top-4 right-4 w-3 h-3 bg-white/80 rounded-full animate-pulse-slow shadow-lg"></div>
                <div className="absolute top-6 left-6 w-2 h-2 bg-white/60 rounded-full animate-bounce-gentle"></div>
                <div className="absolute bottom-4 right-6 w-1 h-1 bg-white/90 rounded-full animate-ping-slow"></div>
                
                {/* Shimmer effect */}
                <div className="absolute inset-0 bg-gradient-to-r from-transparent via-white/20 to-transparent -translate-x-full group-hover:translate-x-full transition-transform duration-1000 opacity-0 group-hover:opacity-100"></div>
              </div>

              <CardContent className="p-10 space-y-6">
                <div className="space-y-5">
                  <h3 className="text-xl font-black text-slate-800 dark:text-white group-hover:text-emerald-600 dark:group-hover:text-emerald-400 transition-all duration-700 leading-tight transform group-hover:translate-y-[-2px]">
                    {feature.title}
                  </h3>
                  
                  <p className="text-slate-600 dark:text-slate-300 leading-relaxed font-medium group-hover:text-slate-700 dark:group-hover:text-slate-200 transition-all duration-700 transform group-hover:translate-y-[-1px]">
                    {feature.description}
                  </p>
                </div>

                {/* Enhanced bottom decoration */}
                <div className="flex items-center justify-between pt-5 border-t border-slate-200/50 dark:border-slate-700/50 group-hover:border-emerald-200/50 dark:group-hover:border-emerald-600/30 transition-all duration-700">
                  <div className="flex gap-2">
                    {[...Array(3)].map((_, i) => (
                      <div
                        key={i}
                        className={`w-2 h-2 rounded-full bg-gradient-to-r ${feature.gradient} opacity-40 group-hover:opacity-100 transition-all duration-700 group-hover:scale-125 animate-pulse-delayed`}
                        style={{ animationDelay: `${i * 0.3}s` }}
                      />
                    ))}
                  </div>
                  <div className="opacity-0 group-hover:opacity-100 transition-all duration-700 transform translate-x-2 group-hover:translate-x-0">
                    <div className={`w-6 h-1 rounded-full bg-gradient-to-r ${feature.gradient} animate-pulse-glow`}></div>
                  </div>
                </div>
              </CardContent>

              {/* Glow effect */}
              <div className={`absolute inset-0 bg-gradient-to-r ${feature.gradient} opacity-0 group-hover:opacity-10 transition-opacity duration-700 rounded-3xl pointer-events-none`}></div>
            </Card>
          ))}
        </div>

        {/* Bottom CTA */}
        <div className="text-center mt-20">
          <div className="inline-flex items-center gap-2 px-6 py-3 rounded-full bg-gradient-to-r from-emerald-500 to-teal-600 text-white font-semibold shadow-xl hover:shadow-2xl hover:shadow-emerald-500/30 transition-all duration-500 hover:scale-105 cursor-pointer">
            <Leaf className="h-5 w-5" />
            <span>Explore All Features</span>
            <Sparkles className="h-4 w-4 animate-pulse" />
          </div>
        </div>
      </div>

      <style>{`
        @keyframes fade-in {
          from { opacity: 0; transform: translateY(30px); }
          to { opacity: 1; transform: translateY(0); }
        }
        
        @keyframes scale-in {
          from { opacity: 0; transform: scale(0.9) translateY(20px); }
          to { opacity: 1; transform: scale(1) translateY(0); }
        }
        
        @keyframes glow-pulse {
          0%, 100% { text-shadow: 0 0 20px rgba(16, 185, 129, 0.5); }
          50% { text-shadow: 0 0 40px rgba(16, 185, 129, 0.8), 0 0 60px rgba(16, 185, 129, 0.4); }
        }
        
        @keyframes pulse-slow {
          0%, 100% { opacity: 0.4; }
          50% { opacity: 0.9; }
        }
        
        @keyframes bounce-gentle {
          0%, 100% { transform: translateY(0); }
          50% { transform: translateY(-4px); }
        }
        
        @keyframes ping-slow {
          0% { transform: scale(1); opacity: 1; }
          75%, 100% { transform: scale(2); opacity: 0; }
        }
        
        @keyframes pulse-delayed {
          0%, 50% { opacity: 0.4; }
          100% { opacity: 1; }
        }
        
        @keyframes pulse-glow {
          0%, 100% { opacity: 0.6; box-shadow: 0 0 10px currentColor; }
          50% { opacity: 1; box-shadow: 0 0 20px currentColor; }
        }
        
        .animate-pulse-slow { animation: pulse-slow 3s ease-in-out infinite; }
        .animate-bounce-gentle { animation: bounce-gentle 2s ease-in-out infinite; }
        .animate-ping-slow { animation: ping-slow 4s ease-in-out infinite; }
        .animate-pulse-delayed { animation: pulse-delayed 2s ease-in-out infinite; }
        .animate-pulse-glow { animation: pulse-glow 2s ease-in-out infinite; }
      `}</style>
    </section>
  );
};