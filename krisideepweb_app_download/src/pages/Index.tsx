import { useState } from "react";
import { Navbar } from "@/components/Navbar";
import { HeroSection } from "@/components/HeroSection";
import { FeaturesSection } from "@/components/FeaturesSection";
import { DownloadSection } from "@/components/DownloadSection";
import { ContactSection } from "@/components/ContactSection";
import { Language } from "@/components/LanguageSwitcher";

const Index = () => {
  const [language, setLanguage] = useState<Language>('en');

  return (
    <div className="min-h-screen bg-background">
      <Navbar language={language} onLanguageChange={setLanguage} />
      <HeroSection language={language} />
      <FeaturesSection language={language} />
      <DownloadSection language={language} />
      <ContactSection language={language} />
      
      {/* Footer */}
      <footer className="bg-primary/5 border-t border-border/50 py-8">
        <div className="container mx-auto px-4 sm:px-6 lg:px-8">
          <div className="text-center space-y-4">
            <div className="flex items-center justify-center gap-3">
              <div className="p-2 rounded-xl gradient-primary shadow-soft">
                <span className="text-primary-foreground font-bold text-lg">K</span>
              </div>
              <span className="text-xl font-bold text-foreground">Krisideep</span>
            </div>
            <p className="text-muted-foreground">
              {language === 'en' && "Empowering Indian farmers with AI-driven agricultural solutions"}
              {language === 'hi' && "एआई-संचालित कृषि समाधानों के साथ भारतीय किसानों को सशक्त बनाना"}
              {language === 'ta' && "AI-இயக்கப்படும் விவசாய தீர்வுகளுடன் இந்திய விவசாயிகளை வலுப்படுத்துதல்"}
            </p>
            <div className="text-sm text-muted-foreground">
              © 2024 Krisideep. All rights reserved.
            </div>
          </div>
        </div>
      </footer>
    </div>
  );
};

export default Index;
