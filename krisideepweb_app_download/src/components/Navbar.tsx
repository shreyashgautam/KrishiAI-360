import { useState, useEffect } from "react";
import { Menu, X, Leaf, Sparkles } from "lucide-react";
import { Button } from "@/components/ui/button";
import { LanguageSwitcher, Language } from "./LanguageSwitcher";

interface NavbarProps {
  language: Language;
  onLanguageChange: (language: Language) => void;
}

const translations = {
  en: {
    features: "Features",
    download: "Download",
    contact: "Contact",
    getStarted: "Get Started"
  },
  hi: {
    features: "विशेषताएं",
    download: "डाउनलोड",
    contact: "संपर्क",
    getStarted: "शुरू करें"
  },
  ta: {
    features: "அம்சங்கள்",
    download: "பதிவிறக்கம்",
    contact: "தொடர்பு",
    getStarted: "தொடங்குங்கள்"
  }
};

export const Navbar = ({ language, onLanguageChange }: NavbarProps) => {
  const [isMenuOpen, setIsMenuOpen] = useState(false);
  const [isScrolled, setIsScrolled] = useState(false);
  const [activeSection, setActiveSection] = useState("");
  const [mousePosition, setMousePosition] = useState({ x: 0, y: 0 });
  const t = translations[language];

  useEffect(() => {
    const handleScroll = () => {
      const scrollPosition = window.scrollY;
      setIsScrolled(scrollPosition > 20);

      // Update active section based on scroll position
      const sections = ['features', 'download', 'contact'];
      const currentSection = sections.find(section => {
        const element = document.getElementById(section);
        if (element) {
          const rect = element.getBoundingClientRect();
          return rect.top <= 100 && rect.bottom >= 100;
        }
        return false;
      });
      setActiveSection(currentSection || "");
    };

    const handleMouseMove = (e: MouseEvent) => {
      setMousePosition({ x: e.clientX, y: e.clientY });
    };

    window.addEventListener('scroll', handleScroll);
    window.addEventListener('mousemove', handleMouseMove);
    return () => {
      window.removeEventListener('scroll', handleScroll);
      window.removeEventListener('mousemove', handleMouseMove);
    };
  }, []);

  const navItems = [
    { name: t.features, href: "#features", id: "features" },
    { name: t.download, href: "#download", id: "download" },
    { name: t.contact, href: "#contact", id: "contact" }
  ];

  const handleNavClick = (href: string) => {
    setIsMenuOpen(false);
    const element = document.querySelector(href);
    if (element) {
      element.scrollIntoView({ behavior: 'smooth', block: 'start' });
    }
  };

  return (
    <>
      {/* Floating particles background */}
      <div className="fixed inset-0 overflow-hidden pointer-events-none z-0">
        <div className="absolute inset-0">
          {[...Array(6)].map((_, i) => (
            <div
              key={i}
              className="absolute w-1 h-1 bg-gradient-to-r from-emerald-400 to-teal-400 rounded-full animate-pulse opacity-30"
              style={{
                left: `${20 + i * 15}%`,
                top: `${10 + i * 8}%`,
                animationDelay: `${i * 0.8}s`,
                animationDuration: `${3 + i * 0.5}s`
              }}
            />
          ))}
        </div>
      </div>

      <nav className={`fixed top-0 left-0 right-0 z-50 transition-all duration-700 ease-out ${
        isScrolled 
          ? 'bg-white/80 dark:bg-slate-900/80 backdrop-blur-2xl shadow-2xl shadow-slate-200/20 dark:shadow-slate-900/40' 
          : 'bg-transparent'
      }`}>
        
        {/* Gradient border */}
        <div className={`absolute inset-x-0 bottom-0 h-px bg-gradient-to-r from-transparent via-emerald-500/50 to-transparent transition-opacity duration-700 ${
          isScrolled ? 'opacity-100' : 'opacity-0'
        }`} />

        {/* Glassmorphism container */}
        <div className={`relative ${isScrolled ? 'bg-gradient-to-r from-white/90 via-white/95 to-white/90 dark:from-slate-900/90 dark:via-slate-900/95 dark:to-slate-900/90' : ''} backdrop-blur-xl border border-white/20 dark:border-slate-700/30 rounded-none ${isScrolled ? 'shadow-inner' : ''}`}>
          <div className="container mx-auto px-4 sm:px-6 lg:px-8">
            <div className="flex items-center justify-between h-16 lg:h-20">
              
              {/* Enhanced Logo */}
              <div className="flex items-center gap-4 group cursor-pointer transform hover:scale-105 transition-all duration-500 ease-out">
                <div className={`relative p-3 rounded-2xl bg-gradient-to-br from-emerald-400 via-emerald-500 to-teal-600 shadow-xl group-hover:shadow-2xl group-hover:shadow-emerald-500/40 transition-all duration-500 ease-out overflow-hidden ${
                  isScrolled ? 'scale-90' : 'scale-100'
                }`}>
                  {/* Shine effect */}
                  <div className="absolute inset-0 bg-gradient-to-tr from-white/30 to-transparent opacity-0 group-hover:opacity-100 transition-opacity duration-500" />
                  <Leaf className="h-7 w-7 text-white group-hover:rotate-12 transition-transform duration-500 relative z-10" />
                  <Sparkles className="absolute -top-1 -right-1 h-3 w-3 text-white/80 animate-pulse" />
                </div>
                
                <div className="flex flex-col">
                  <span className={`font-extrabold bg-gradient-to-r from-slate-800 via-slate-700 to-slate-900 dark:from-white dark:via-slate-100 dark:to-slate-200 bg-clip-text text-transparent tracking-tight transition-all duration-500 ${
                    isScrolled ? 'text-lg' : 'text-xl'
                  }`}>
                    Krisideep
                  </span>
                  <span className="text-xs bg-gradient-to-r from-emerald-600 to-teal-600 bg-clip-text text-transparent font-semibold opacity-80 group-hover:opacity-100 transition-all duration-300">
                    Smart Farming AI ✨
                  </span>
                </div>
              </div>

              {/* Desktop Navigation - Enhanced */}
              <div className="hidden lg:flex items-center gap-2">
                {navItems.map((item, index) => (
                  <div key={item.name} className="relative">
                    <a
                      href={item.href}
                      onClick={(e) => {
                        e.preventDefault();
                        handleNavClick(item.href);
                      }}
                      className={`relative px-6 py-3 font-semibold transition-all duration-300 ease-out group flex items-center gap-2 rounded-2xl ${
                        activeSection === item.id 
                          ? 'text-white bg-gradient-to-r from-emerald-500 to-teal-600 shadow-lg shadow-emerald-500/30' 
                          : 'text-slate-700 dark:text-slate-300 hover:text-emerald-600 dark:hover:text-emerald-400'
                      }`}
                      style={{
                        animationDelay: `${index * 100}ms`
                      }}
                    >
                      {/* Glassmorphism background for non-active items */}
                      {activeSection !== item.id && (
                        <div className="absolute inset-0 bg-white/50 dark:bg-slate-800/50 backdrop-blur-sm rounded-2xl opacity-0 group-hover:opacity-100 transition-all duration-300 border border-white/20 dark:border-slate-700/30" />
                      )}
                      
                      <span className="relative z-10">{item.name}</span>
                      
                      {/* Active indicator */}
                      {activeSection === item.id && (
                        <div className="absolute -bottom-1 left-1/2 transform -translate-x-1/2 w-2 h-2 bg-white rounded-full shadow-lg" />
                      )}
                      
                      {/* Hover effect particles */}
                      <div className="absolute inset-0 opacity-0 group-hover:opacity-100 transition-opacity duration-500">
                        <div className="absolute top-1 right-1 w-1 h-1 bg-emerald-400 rounded-full animate-ping" />
                        <div className="absolute bottom-1 left-1 w-1 h-1 bg-teal-400 rounded-full animate-pulse" />
                      </div>
                    </a>
                  </div>
                ))}
              </div>

              {/* Desktop Actions - Enhanced */}
              <div className="hidden lg:flex items-center gap-4">
                <div className="p-2 rounded-xl bg-white/50 dark:bg-slate-800/50 backdrop-blur-sm border border-white/20 dark:border-slate-700/30 hover:border-emerald-500/30 transition-all duration-300">
                  <LanguageSwitcher currentLanguage={language} onLanguageChange={onLanguageChange} />
                </div>
                
                <Button 
                  className={`relative overflow-hidden bg-gradient-to-r from-emerald-500 via-emerald-600 to-teal-600 hover:from-emerald-600 hover:via-emerald-700 hover:to-teal-700 text-white border-0 shadow-xl shadow-emerald-500/30 hover:shadow-2xl hover:shadow-emerald-500/40 transition-all duration-500 hover:scale-110 transform font-bold px-8 py-3 rounded-2xl group ${
                    isScrolled ? 'text-sm' : 'text-base'
                  }`}
                >
                  {/* Shine animation */}
                  <div className="absolute inset-0 bg-gradient-to-r from-transparent via-white/20 to-transparent skew-x-12 -translate-x-full group-hover:translate-x-full transition-transform duration-1000" />
                  
                  <span className="relative z-10 flex items-center gap-2">
                    {t.getStarted}
                    <Sparkles className="h-4 w-4 animate-pulse" />
                  </span>
                </Button>
              </div>

              {/* Mobile Menu Button - Enhanced */}
              <div className="lg:hidden flex items-center gap-3">
                <div className="p-2 rounded-xl bg-white/50 dark:bg-slate-800/50 backdrop-blur-sm border border-white/20 dark:border-slate-700/30">
                  <LanguageSwitcher currentLanguage={language} onLanguageChange={onLanguageChange} />
                </div>
                
                <Button
                  variant="ghost"
                  size="sm"
                  onClick={() => setIsMenuOpen(!isMenuOpen)}
                  className="relative p-3 rounded-xl bg-white/50 dark:bg-slate-800/50 backdrop-blur-sm border border-white/20 dark:border-slate-700/30 hover:border-emerald-500/30 transition-all duration-300 hover:scale-110 transform group"
                >
                  <div className="relative">
                    {isMenuOpen ? (
                      <X className="h-5 w-5 text-slate-700 dark:text-slate-300 group-hover:text-emerald-600 transition-all duration-300 group-hover:rotate-90" />
                    ) : (
                      <Menu className="h-5 w-5 text-slate-700 dark:text-slate-300 group-hover:text-emerald-600 transition-all duration-300 group-hover:scale-110" />
                    )}
                  </div>
                </Button>
              </div>
            </div>

            {/* Mobile Navigation - Ultra Enhanced */}
            <div className={`lg:hidden absolute top-full left-4 right-4 mt-2 bg-white/90 dark:bg-slate-900/90 backdrop-blur-2xl border border-white/20 dark:border-slate-700/30 shadow-2xl shadow-slate-200/20 dark:shadow-slate-900/40 transition-all duration-500 ease-out transform rounded-3xl overflow-hidden ${
              isMenuOpen 
                ? 'opacity-100 translate-y-0 scale-100' 
                : 'opacity-0 -translate-y-8 scale-95 pointer-events-none'
            }`}>
              {/* Gradient border */}
              <div className="absolute inset-0 bg-gradient-to-br from-emerald-500/20 via-transparent to-teal-500/20 rounded-3xl" />
              
              <div className="relative p-6 space-y-3">
                {navItems.map((item, index) => (
                  <a
                    key={item.name}
                    href={item.href}
                    onClick={(e) => {
                      e.preventDefault();
                      handleNavClick(item.href);
                    }}
                    className={`flex items-center gap-4 text-slate-700 dark:text-slate-300 font-semibold py-4 px-6 rounded-2xl transition-all duration-300 transform hover:translate-x-2 group ${
                      activeSection === item.id 
                        ? 'text-white bg-gradient-to-r from-emerald-500 to-teal-600 shadow-lg shadow-emerald-500/30' 
                        : 'hover:text-emerald-600 dark:hover:text-emerald-400 hover:bg-white/60 dark:hover:bg-slate-800/60 backdrop-blur-sm border border-transparent hover:border-emerald-500/20'
                    }`}
                    style={{
                      animationDelay: `${index * 100}ms`,
                      animation: isMenuOpen ? `slideInLeft 0.5s ease-out ${index * 100}ms both` : ''
                    }}
                  >
                    <div className="w-2 h-2 rounded-full bg-emerald-500 opacity-50 group-hover:opacity-100 transition-opacity duration-300" />
                    {item.name}
                    {activeSection === item.id && (
                      <div className="ml-auto flex gap-1">
                        <div className="w-1 h-1 bg-white rounded-full animate-pulse" />
                        <div className="w-1 h-1 bg-white rounded-full animate-pulse" style={{ animationDelay: '0.2s' }} />
                        <div className="w-1 h-1 bg-white rounded-full animate-pulse" style={{ animationDelay: '0.4s' }} />
                      </div>
                    )}
                  </a>
                ))}
                
                <div className="pt-4 border-t border-slate-200/50 dark:border-slate-700/50">
                  <Button 
                    className="w-full relative overflow-hidden bg-gradient-to-r from-emerald-500 via-emerald-600 to-teal-600 hover:from-emerald-600 hover:via-emerald-700 hover:to-teal-700 text-white border-0 shadow-xl shadow-emerald-500/30 hover:shadow-2xl hover:shadow-emerald-500/40 transition-all duration-500 hover:scale-105 transform font-bold py-4 rounded-2xl group"
                    style={{
                      animation: isMenuOpen ? 'slideInUp 0.6s ease-out 0.3s both' : ''
                    }}
                  >
                    <div className="absolute inset-0 bg-gradient-to-r from-transparent via-white/20 to-transparent skew-x-12 -translate-x-full group-hover:translate-x-full transition-transform duration-1000" />
                    <span className="relative z-10 flex items-center justify-center gap-2">
                      {t.getStarted}
                      <Sparkles className="h-4 w-4 animate-pulse" />
                    </span>
                  </Button>
                </div>
              </div>
            </div>
          </div>
        </div>
      </nav>
      
      <style>{`
        @keyframes slideInLeft {
          from {
            opacity: 0;
            transform: translateX(-30px) scale(0.95);
          }
          to {
            opacity: 1;
            transform: translateX(0) scale(1);
          }
        }
        
        @keyframes slideInUp {
          from {
            opacity: 0;
            transform: translateY(30px) scale(0.95);
          }
          to {
            opacity: 1;
            transform: translateY(0) scale(1);
          }
        }
        
        @keyframes float {
          0%, 100% { transform: translateY(0px) rotate(0deg); }
          50% { transform: translateY(-10px) rotate(5deg); }
        }
        
        .animate-float {
          animation: float 6s ease-in-out infinite;
        }
      `}</style>
    </>
  );
};