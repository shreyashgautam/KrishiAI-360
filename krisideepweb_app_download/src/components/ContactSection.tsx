import { useState } from "react";
import { Button } from "@/components/ui/button";
import { Card, CardContent } from "@/components/ui/card";
import { Input } from "@/components/ui/input";
import { Textarea } from "@/components/ui/textarea";
import { Mail, Phone, MapPin, Send, Clock, Users, MessageCircle, Star, Sparkles } from "lucide-react";
import { Language } from "./LanguageSwitcher";
import { useToast } from "@/hooks/use-toast";

interface ContactSectionProps {
  language: Language;
}

const translations = {
  en: {
    title: "Get in Touch",
    subtitle: "Contact Our Agricultural Experts",
    description: "Have questions about Krisideep? Our team of agricultural specialists is here to help you maximize your farming potential.",
    form: {
      name: "Full Name",
      email: "Email Address",
      phone: "Phone Number",
      subject: "Subject",
      message: "Your Message",
      namePlaceholder: "Enter your full name",
      emailPlaceholder: "your.email@example.com",
      phonePlaceholder: "+91 98765 43210",
      subjectPlaceholder: "How can we help you?",
      messagePlaceholder: "Tell us about your farming needs or questions...",
      send: "Send Message",
      sending: "Sending..."
    },
    contact: {
      email: {
        title: "Email Support",
        value: "shreyashgautam2007@gmail.com",
        description: "Get detailed answers to your questions"
      },
      phone: {
        title: "Phone Support",
        value: "+91 79036 32892",
        description: "Talk to our agricultural experts"
      },
      address: {
        title: "Office Address",
        value: "VIT Chennai\nChennai, Tamil Nadu, India",
        description: "Visit our research center"
      }
    },
    hours: {
      title: "Support Hours",
      weekdays: "Monday - Friday: 9 AM - 6 PM",
      weekend: "Saturday: 9 AM - 2 PM",
      closed: "Sunday: Closed"
    },
    team: {
      title: "Expert Team",
      description: "Agricultural scientists and AI specialists"
    },
    success: "Message sent successfully! We'll get back to you within 24 hours.",
    error: "Failed to send message. Please try again."
  },
  hi: {
    title: "संपर्क में रहें",
    subtitle: "हमारे कृषि विशेषज्ञों से संपर्क करें",
    description: "कृषिदीप के बारे में प्रश्न हैं? कृषि विशेषज्ञों की हमारी टीम आपकी खेती की क्षमता को अधिकतम करने में आपकी मदद के लिए यहाँ है।",
    form: {
      name: "पूरा नाम",
      email: "ईमेल पता",
      phone: "फोन नंबर",
      subject: "विषय",
      message: "आपका संदेश",
      namePlaceholder: "अपना पूरा नाम दर्ज करें",
      emailPlaceholder: "your.email@example.com",
      phonePlaceholder: "+91 98765 43210",
      subjectPlaceholder: "हम आपकी कैसे मदद कर सकते हैं?",
      messagePlaceholder: "अपनी खेती की जरूरतों या प्रश्नों के बारे में बताएं...",
      send: "संदेश भेजें",
      sending: "भेजा जा रहा..."
    },
    contact: {
      email: {
        title: "ईमेल सहायता",
        value: "shreyashgautam2007@gmail.com",
        description: "अपने प्रश्नों के विस्तृत उत्तर प्राप्त करें"
      },
      phone: {
        title: "फोन सहायता",
        value: "+91 79036 32892",
        description: "हमारे कृषि विशेषज्ञों से बात करें"
      },
      address: {
        title: "कार्यालय का पता",
        value: "VIT चेन्नई\nचेन्नई, तमिल नाडु, भारत",
        description: "हमारे अनुसंधान केंद्र पर जाएं"
      }
    },
    hours: {
      title: "सहायता घंटे",
      weekdays: "सोमवार - शुक्रवार: सुबह 9 - शाम 6",
      weekend: "शनिवार: सुबह 9 - दोपहर 2",
      closed: "रविवार: बंद"
    },
    team: {
      title: "विशेषज्ञ टीम",
      description: "कृषि वैज्ञानिक और AI विशेषज्ञ"
    },
    success: "संदेश सफलतापूर्वक भेजा गया! हम 24 घंटों के भीतर आपसे संपर्क करेंगे।",
    error: "संदेश भेजने में विफल। कृपया पुनः प्रयास करें।"
  },
  ta: {
    title: "தொடர்பில் இருங்கள்",
    subtitle: "எங்கள் விவசாய நிபுணர்களைத் தொடர்பு கொள்ளுங்கள்",
    description: "கிருஷிதீப் பற்றி கேள்விகள் உள்ளனவா? விவசாய நிபுணர்களின் எங்கள் குழு உங்கள் விவசாய திறனை அதிகப்படுத்த உங்களுக்கு உதவ இங்கே உள்ளது.",
    form: {
      name: "முழு பெயர்",
      email: "மின்னஞ்சல் முகவரி",
      phone: "தொலைபேசி எண்",
      subject: "பொருள்",
      message: "உங்கள் செய்தி",
      namePlaceholder: "உங்கள் முழு பெயரை உள்ளிடவும்",
      emailPlaceholder: "your.email@example.com",
      phonePlaceholder: "+91 98765 43210",
      subjectPlaceholder: "நாங்கள் உங்களுக்கு எவ்வாறு உதவ முடியும்?",
      messagePlaceholder: "உங்கள் விவசாய தேவைகள் அல்லது கேள்விகளைப் பற்றி சொல்லுங்கள்...",
      send: "செய்தி அனுப்பவும்",
      sending: "அனுப்புகிறது..."
    },
    contact: {
      email: {
        title: "மின்னஞ்சல் ஆதரவு",
        value: "shreyashgautam2007@gmail.com",
        description: "உங்கள் கேள்விகளுக்கு விரிவான பதில்களைப் பெறுங்கள்"
      },
      phone: {
        title: "தொலைபேசி ஆதரவு",
        value: "+91 79036 32892",
        description: "எங்கள் விவசாய நிபுணர்களுடன் பேசுங்கள்"
      },
      address: {
        title: "அலுவலக முகவரி",
        value: "VIT சென்னை\nசென்னை, தமிழ்நாடு, இந்தியா",
        description: "எங்கள் ஆராய்ச்சி மையத்தைப் பார்வையிடுங்கள்"
      }
    },
    hours: {
      title: "ஆதரவு நேரங்கள்",
      weekdays: "திங்கள் - வெள்ளி: காலை 9 - மாலை 6",
      weekend: "சனி: காலை 9 - பிற்பகல் 2",
      closed: "ஞாயிறு: மூடப்பட்டது"
    },
    team: {
      title: "நிபுணர் குழு",
      description: "விவசாய விஞ்ஞானிகள் மற்றும் AI நிபுணர்கள்"
    },
    success: "செய்தி வெற்றிகரமாக அனுப்பப்பட்டது! நாங்கள் 24 மணி நேரத்திற்குள் உங்களைத் தொடர்பு கொள்வோம்.",
    error: "செய்தி அனுப்புவதில் தோல்வி. தயவு செய்து மீண்டும் முயற்சிக்கவும்."
  }
};

export const ContactSection = ({ language }: ContactSectionProps) => {
  const [formData, setFormData] = useState({
    name: "",
    email: "",
    phone: "",
    subject: "",
    message: ""
  });
  const [isSubmitting, setIsSubmitting] = useState(false);
  const { toast } = useToast();
  const t = translations[language];

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    setIsSubmitting(true);
    
    // Simulate form submission
    try {
      await new Promise(resolve => setTimeout(resolve, 2000));
      toast({
        title: t.success,
        variant: "default",
      });
      setFormData({ name: "", email: "", phone: "", subject: "", message: "" });
    } catch (error) {
      toast({
        title: t.error,
        variant: "destructive",
      });
    } finally {
      setIsSubmitting(false);
    }
  };

  const handleChange = (e: React.ChangeEvent<HTMLInputElement | HTMLTextAreaElement>) => {
    setFormData(prev => ({
      ...prev,
      [e.target.name]: e.target.value
    }));
  };

  return (
    <section id="contact" className="relative py-20 lg:py-28 overflow-hidden">
      {/* Animated background */}
      <div className="absolute inset-0 bg-gradient-to-br from-slate-50 via-white to-emerald-50/30 dark:from-slate-900 dark:via-slate-800 dark:to-emerald-900/10"></div>
      
      {/* Floating particles */}
      <div className="absolute inset-0 overflow-hidden pointer-events-none">
        {[...Array(8)].map((_, i) => (
          <div
            key={i}
            className="absolute w-2 h-2 bg-emerald-400/20 rounded-full animate-float"
            style={{
              left: `${Math.random() * 100}%`,
              top: `${Math.random() * 100}%`,
              animationDelay: `${i * 2}s`,
              animationDuration: `${6 + Math.random() * 4}s`
            }}
          />
        ))}
      </div>

      <div className="container mx-auto px-4 sm:px-6 lg:px-8 relative z-10">
        {/* Header */}
        <div className="text-center mb-16 animate-fade-in">
          <div className="inline-flex items-center gap-2 px-4 py-2 rounded-full bg-emerald-100 dark:bg-emerald-900/30 border border-emerald-200 dark:border-emerald-700 mb-6">
            <MessageCircle className="h-4 w-4 text-emerald-600 dark:text-emerald-400" />
            <span className="text-emerald-800 dark:text-emerald-200 text-sm font-semibold">Contact Us</span>
          </div>
          
          <h2 className="text-3xl sm:text-4xl lg:text-5xl font-bold mb-4">
            <span className="bg-gradient-to-r from-emerald-600 via-teal-500 to-cyan-500 bg-clip-text text-transparent animate-pulse-glow">{t.title}</span>
          </h2>
          <p className="text-xl text-slate-700 dark:text-slate-300 font-medium mb-4">{t.subtitle}</p>
          <p className="text-lg text-slate-600 dark:text-slate-400 max-w-3xl mx-auto leading-relaxed">
            {t.description}
          </p>
        </div>

        <div className="grid lg:grid-cols-3 gap-12">
          {/* Contact Form - 2/3 width */}
          <div className="lg:col-span-2 animate-slide-in-left">
            <Card className="bg-white/70 dark:bg-slate-800/70 backdrop-blur-xl border border-white/50 dark:border-slate-700/50 shadow-2xl rounded-2xl hover:shadow-3xl transition-all duration-500">
              <CardContent className="p-8">
                <form onSubmit={handleSubmit} className="space-y-6">
                  <div className="grid sm:grid-cols-2 gap-6">
                    <div className="space-y-2 animate-fade-in-up" style={{animationDelay: '0.1s'}}>
                      <label className="text-sm font-semibold text-slate-700 dark:text-slate-300">{t.form.name}</label>
                      <Input
                        name="name"
                        value={formData.name}
                        onChange={handleChange}
                        placeholder={t.form.namePlaceholder}
                        required
                        className="h-12 transition-all duration-300 focus:scale-105 hover:shadow-lg"
                      />
                    </div>
                    <div className="space-y-2 animate-fade-in-up" style={{animationDelay: '0.2s'}}>
                      <label className="text-sm font-semibold text-slate-700 dark:text-slate-300">{t.form.email}</label>
                      <Input
                        name="email"
                        type="email"
                        value={formData.email}
                        onChange={handleChange}
                        placeholder={t.form.emailPlaceholder}
                        required
                        className="h-12 transition-all duration-300 focus:scale-105 hover:shadow-lg"
                      />
                    </div>
                  </div>

                  <div className="grid sm:grid-cols-2 gap-6">
                    <div className="space-y-2 animate-fade-in-up" style={{animationDelay: '0.3s'}}>
                      <label className="text-sm font-semibold text-slate-700 dark:text-slate-300">{t.form.phone}</label>
                      <Input
                        name="phone"
                        type="tel"
                        value={formData.phone}
                        onChange={handleChange}
                        placeholder={t.form.phonePlaceholder}
                        className="h-12 transition-all duration-300 focus:scale-105 hover:shadow-lg"
                      />
                    </div>
                    <div className="space-y-2 animate-fade-in-up" style={{animationDelay: '0.4s'}}>
                      <label className="text-sm font-semibold text-slate-700 dark:text-slate-300">{t.form.subject}</label>
                      <Input
                        name="subject"
                        value={formData.subject}
                        onChange={handleChange}
                        placeholder={t.form.subjectPlaceholder}
                        required
                        className="h-12 transition-all duration-300 focus:scale-105 hover:shadow-lg"
                      />
                    </div>
                  </div>

                  <div className="space-y-2 animate-fade-in-up" style={{animationDelay: '0.5s'}}>
                    <label className="text-sm font-semibold text-slate-700 dark:text-slate-300">{t.form.message}</label>
                    <Textarea
                      name="message"
                      value={formData.message}
                      onChange={handleChange}
                      placeholder={t.form.messagePlaceholder}
                      rows={6}
                      required
                      className="transition-all duration-300 focus:scale-105 hover:shadow-lg resize-none"
                    />
                  </div>

                  <Button
                    type="submit"
                    size="lg"
                    disabled={isSubmitting}
                    className="w-full bg-gradient-to-r from-emerald-500 to-teal-600 hover:from-emerald-600 hover:to-teal-700 border-0 shadow-lg hover:shadow-xl transition-all duration-300 hover:scale-105 animate-fade-in-up"
                    style={{animationDelay: '0.6s'}}
                  >
                    {isSubmitting ? (
                      <div className="flex items-center gap-2">
                        <div className="animate-spin rounded-full h-4 w-4 border-2 border-white/30 border-t-white"></div>
                        {t.form.sending}
                      </div>
                    ) : (
                      <>
                        <Send className="mr-2 h-5 w-5" />
                        {t.form.send}
                      </>
                    )}
                  </Button>
                </form>
              </CardContent>
            </Card>
          </div>

          {/* Contact Info - 1/3 width */}
          <div className="space-y-6 animate-slide-in-right">
            {/* Contact Methods */}
            <Card className="bg-white/70 dark:bg-slate-800/70 backdrop-blur-xl border border-white/50 dark:border-slate-700/50 shadow-xl rounded-2xl hover:shadow-2xl transition-all duration-500 hover:scale-105">
              <CardContent className="p-6 space-y-6">
                <div className="space-y-4">
                  <div className="flex items-start gap-4 animate-slide-in" style={{animationDelay: '0.1s'}}>
                    <div className="p-2 rounded-lg bg-gradient-to-br from-emerald-500 to-teal-600 shadow-lg">
                      <Mail className="h-5 w-5 text-white" />
                    </div>
                    <div>
                      <h4 className="font-semibold text-slate-800 dark:text-white">{t.contact.email.title}</h4>
                      <p className="text-sm text-emerald-600 dark:text-emerald-400 font-medium">{t.contact.email.value}</p>
                      <p className="text-xs text-slate-500 dark:text-slate-400">{t.contact.email.description}</p>
                    </div>
                  </div>

                  <div className="flex items-start gap-4 animate-slide-in" style={{animationDelay: '0.2s'}}>
                    <div className="p-2 rounded-lg bg-gradient-to-br from-emerald-500 to-teal-600 shadow-lg">
                      <Phone className="h-5 w-5 text-white" />
                    </div>
                    <div>
                      <h4 className="font-semibold text-slate-800 dark:text-white">{t.contact.phone.title}</h4>
                      <p className="text-sm text-emerald-600 dark:text-emerald-400 font-medium">{t.contact.phone.value}</p>
                      <p className="text-xs text-slate-500 dark:text-slate-400">{t.contact.phone.description}</p>
                    </div>
                  </div>

                  <div className="flex items-start gap-4 animate-slide-in" style={{animationDelay: '0.3s'}}>
                    <div className="p-2 rounded-lg bg-gradient-to-br from-emerald-500 to-teal-600 shadow-lg">
                      <MapPin className="h-5 w-5 text-white" />
                    </div>
                    <div>
                      <h4 className="font-semibold text-slate-800 dark:text-white">{t.contact.address.title}</h4>
                      <p className="text-sm text-slate-700 dark:text-slate-300 whitespace-pre-line">{t.contact.address.value}</p>
                      <p className="text-xs text-slate-500 dark:text-slate-400">{t.contact.address.description}</p>
                    </div>
                  </div>
                </div>
              </CardContent>
            </Card>

            {/* Support Hours */}
            <Card className="bg-white/70 dark:bg-slate-800/70 backdrop-blur-xl border border-white/50 dark:border-slate-700/50 shadow-xl rounded-2xl hover:shadow-2xl transition-all duration-500 hover:scale-105 animate-fade-in-up" style={{animationDelay: '0.4s'}}>
              <CardContent className="p-6">
                <div className="flex items-center gap-3 mb-4">
                  <div className="p-2 rounded-lg bg-gradient-to-br from-emerald-500 to-teal-600 shadow-lg">
                    <Clock className="h-5 w-5 text-white" />
                  </div>
                  <h4 className="font-semibold text-slate-800 dark:text-white">{t.hours.title}</h4>
                </div>
                <div className="space-y-2">
                  <p className="text-sm text-slate-600 dark:text-slate-300">{t.hours.weekdays}</p>
                  <p className="text-sm text-slate-600 dark:text-slate-300">{t.hours.weekend}</p>
                  <p className="text-sm text-slate-500 dark:text-slate-400">{t.hours.closed}</p>
                </div>
              </CardContent>
            </Card>

            {/* Team Info */}
            <Card className="bg-white/70 dark:bg-slate-800/70 backdrop-blur-xl border border-white/50 dark:border-slate-700/50 shadow-xl rounded-2xl hover:shadow-2xl transition-all duration-500 hover:scale-105 animate-fade-in-up" style={{animationDelay: '0.5s'}}>
              <CardContent className="p-6">
                <div className="flex items-center gap-3 mb-4">
                  <div className="p-2 rounded-lg bg-gradient-to-br from-emerald-500 to-teal-600 shadow-lg">
                    <Users className="h-5 w-5 text-white" />
                  </div>
                  <h4 className="font-semibold text-slate-800 dark:text-white">{t.team.title}</h4>
                </div>
                <p className="text-sm text-slate-600 dark:text-slate-300">{t.team.description}</p>
              </CardContent>
            </Card>
          </div>
        </div>
      </div>

      <style>{`
        @keyframes fade-in {
          from { opacity: 0; transform: translateY(20px); }
          to { opacity: 1; transform: translateY(0); }
        }
        
        @keyframes fade-in-up {
          from { opacity: 0; transform: translateY(30px); }
          to { opacity: 1; transform: translateY(0); }
        }
        
        @keyframes slide-in-left {
          from { opacity: 0; transform: translateX(-50px); }
          to { opacity: 1; transform: translateX(0); }
        }
        
        @keyframes slide-in-right {
          from { opacity: 0; transform: translateX(50px); }
          to { opacity: 1; transform: translateX(0); }
        }
        
        @keyframes slide-in {
          from { opacity: 0; transform: translateX(20px); }
          to { opacity: 1; transform: translateX(0); }
        }
        
        @keyframes float {
          0%, 100% { transform: translateY(0px); }
          50% { transform: translateY(-20px); }
        }
        
        @keyframes pulse-glow {
          0%, 100% { text-shadow: 0 0 20px rgba(16, 185, 129, 0.3); }
          50% { text-shadow: 0 0 30px rgba(16, 185, 129, 0.6); }
        }
        
        .animate-fade-in { animation: fade-in 1s ease-out; }
        .animate-fade-in-up { animation: fade-in-up 0.8s ease-out both; }
        .animate-slide-in-left { animation: slide-in-left 1s ease-out; }
        .animate-slide-in-right { animation: slide-in-right 1s ease-out 0.2s both; }
        .animate-slide-in { animation: slide-in 0.6s ease-out both; }
        .animate-float { animation: float ease-in-out infinite; }
        .animate-pulse-glow { animation: pulse-glow 2s ease-in-out infinite; }
      `}</style>
    </section>
  );
};