import React, { useState, useEffect, useRef, useMemo } from 'react';
import { 
  Search, MapPin, Clock, ChevronRight, 
  CheckCircle, ShieldCheck, ChevronLeft, 
  Calendar as CalendarIcon, Users, Trophy, Zap, 
  MessageCircle, Star, Share2, Monitor, Target, Award
} from 'lucide-react';

// --- MOCK DATA: ONLINE COACHES & PROGRAMS ---
const COACHES = [
    {
        id: 'c1',
        name: 'Coach Michael Thorne',
        specialty: 'Olympic Performance',
        rating: 5.0,
        reviews: 128,
        image: 'https://images.unsplash.com/photo-1548382113-7615065835ee?auto=format&fit=crop&q=80&w=800',
        bio: 'Former Olympic relay coach with 15+ years experience in biomechanical stroke analysis. Specialized in elite competitive training.',
        phone: '1234567890',
        programs: [
            { id: 'prog1', title: '12-Week Stroke Mastery', price: 199.99, duration: '12 Weeks (24 sessions)', goal: 'Technique', photo_url: 'https://placehold.co/600x400/7c3aed/ffffff?text=STROKE+MASTERY', description: 'Comprehensive training plan focused on maximizing efficiency across all four strokes with weekly video reviews.' },
            { id: 'prog2', title: 'Power & Explosiveness', price: 145.00, duration: '8 Weeks (16 sessions)', goal: 'Strength', photo_url: 'https://placehold.co/600x400/5b21b6/ffffff?text=POWER+SWIM', description: 'Dryland and in-water drills designed to increase your burst speed and turn power.' }
        ]
    },
    {
        id: 'c2',
        name: 'Sarah "The Fin" Wilson',
        specialty: 'Open Water & Endurance',
        rating: 4.9,
        reviews: 95,
        image: 'https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?auto=format&fit=crop&q=80&w=800',
        bio: 'Specialist in long-distance open water preparation. Helping swimmers transition from the pool to the sea with confidence.',
        phone: '9876543210',
        programs: [
            { id: 'prog3', title: 'Open Water Confidence', price: 99.50, duration: '4 Weeks (8 sessions)', goal: 'Endurance', photo_url: 'https://placehold.co/600x400/8b5cf6/ffffff?text=OPEN+WATER', description: 'A four-week guide to transitioning from pool swimming to open water confidence and safety.' },
            { id: 'prog4', title: 'Nutrition for Triathletes', price: 49.00, duration: '6 Sessions', goal: 'Wellness', photo_url: 'https://placehold.co/600x400/a78bfa/ffffff?text=NUTRITION', description: 'Learn how to fuel your body correctly for long-distance endurance events.' }
        ]
    }
];

const StepIndicator = ({ step }) => {
    const steps = ['Expert', 'Portfolio', 'Curriculum'];
    return (
        <div className="px-6 py-4 bg-white/90 backdrop-blur-md border-b border-gray-100 sticky top-[72px] z-20 shadow-sm">
            <div className="flex justify-between items-center relative">
                <div className="absolute top-1/2 left-0 w-full h-0.5 bg-gray-100 -translate-y-1/2 z-0"></div>
                <div 
                    className="absolute top-1/2 left-0 h-0.5 bg-purple-600 -translate-y-1/2 z-0 transition-all duration-700 ease-out" 
                    style={{ width: `${(step / (steps.length - 1)) * 100}%` }}
                ></div>
                {steps.map((label, idx) => (
                    <div key={idx} className="relative z-10 flex flex-col items-center">
                        <div className={`w-7 h-7 rounded-full flex items-center justify-center text-[10px] font-black transition-all duration-300 ${step >= idx ? 'bg-purple-600 text-white scale-110 shadow-lg shadow-purple-100' : 'bg-white border-2 border-gray-100 text-gray-300'}`}>
                            {step > idx ? <CheckCircle className="w-4 h-4" /> : idx + 1}
                        </div>
                        <span className={`text-[8px] mt-1.5 font-black uppercase tracking-widest ${step >= idx ? 'text-purple-600' : 'text-gray-300'}`}>{label}</span>
                    </div>
                ))}
            </div>
        </div>
    );
};

export default function App() {
    const [currentStep, setCurrentStep] = useState(0); 
    const [bookingData, setBookingData] = useState({
        coach: null,
        program: null
    });
    const [searchTerm, setSearchTerm] = useState('');
    const [goalFilter, setGoalFilter] = useState('All');

    // --- UTILITIES ---
    const showSnackbar = (msg) => {
        const sn = document.createElement('div');
        sn.className = "fixed bottom-10 left-1/2 -translate-x-1/2 bg-slate-900 text-white px-10 py-5 rounded-full text-sm font-black shadow-2xl z-[100] animate-bounce text-center min-w-[280px]";
        sn.textContent = msg;
        document.body.appendChild(sn);
        setTimeout(() => sn.remove(), 2500);
    };

    const handleBack = () => {
        if (currentStep > 0) setCurrentStep(currentStep - 1);
        else window.history.back();
    };

    const handleShare = (coach, e) => {
        e.stopPropagation();
        const text = `Check out ${coach.name} on Swim 360! Expert online coaching: https://swim360.app/coaches/${coach.id}`;
        const dummy = document.createElement('input');
        document.body.appendChild(dummy);
        dummy.value = text;
        dummy.select();
        document.execCommand('copy');
        document.body.removeChild(dummy);
        showSnackbar("Coach profile link copied!");
    };

    const getWhatsAppLink = (phone, name) => {
        const message = `Hi ${name}, I saw your online programs on Swim 360 and would like to ask a few questions!`;
        return `https://wa.me/${phone.replace(/\D/g, '')}?text=${encodeURIComponent(message)}`;
    };

    // --- COMPUTED DATA ---
    const filteredCoaches = useMemo(() => {
        const lowSearch = searchTerm.toLowerCase();
        return COACHES.filter(c => 
            (c.name.toLowerCase().includes(lowSearch) || c.specialty.toLowerCase().includes(lowSearch)) &&
            (goalFilter === 'All' || c.programs.some(p => p.goal === goalFilter))
        );
    }, [searchTerm, goalFilter]);

    // --- RENDERERS ---

    const renderCoachList = () => (
        <div className="space-y-6 animate-in">
            {/* Search & Filters */}
            <div className="bg-white p-5 rounded-[32px] shadow-sm border border-gray-100 space-y-4">
                <div className="relative">
                    <Search className="absolute left-4 top-1/2 -translate-y-1/2 w-5 h-5 text-gray-300" />
                    <input 
                        type="text" 
                        placeholder="Search by name or specialty..." 
                        value={searchTerm}
                        onChange={(e) => setSearchTerm(e.target.value)}
                        className="w-full pl-12 pr-4 py-4 bg-gray-50 border-none rounded-2xl focus:ring-2 focus:ring-purple-500 transition-all text-sm font-semibold"
                    />
                </div>
                <div className="flex space-x-2 overflow-x-auto no-scrollbar pb-1">
                    {['All', 'Technique', 'Endurance', 'Strength', 'Wellness'].map(goal => (
                        <button 
                            key={goal}
                            onClick={() => setGoalFilter(goal)}
                            className={`px-5 py-2 rounded-xl text-[10px] font-black uppercase tracking-widest transition-all ${goalFilter === goal ? 'bg-purple-600 text-white shadow-md' : 'bg-gray-50 text-gray-400'}`}
                        >
                            {goal}
                        </button>
                    ))}
                </div>
            </div>

            {/* Coach Cards */}
            <div className="space-y-5 pb-20">
                {filteredCoaches.map(coach => (
                    <div key={coach.id} className="bg-white rounded-[36px] overflow-hidden shadow-xl shadow-gray-200/50 border border-white group active:scale-[0.98] transition-all cursor-pointer relative" 
                         onClick={() => { setBookingData({...bookingData, coach}); setCurrentStep(1); }}>
                        <div className="relative h-64">
                            <img src={coach.image} className="w-full h-full object-cover group-hover:scale-105 transition-transform duration-1000" alt={coach.name} />
                            <div className="absolute inset-0 bg-gradient-to-t from-black/90 via-black/20 to-transparent"></div>
                            
                            <button onClick={(e) => handleShare(coach, e)} className="absolute top-4 left-4 bg-white/90 backdrop-blur p-2.5 rounded-2xl shadow-lg border border-white text-gray-700 hover:bg-white transition-colors">
                                <Share2 className="w-4 h-4" />
                            </button>

                            <div className="absolute top-4 right-4 bg-white/90 backdrop-blur px-3 py-1.5 rounded-2xl flex items-center shadow-lg border border-white">
                                <Star className="w-3 h-3 text-amber-400 fill-amber-400 mr-1" />
                                <span className="text-[10px] font-black text-gray-800">{coach.rating} ({coach.reviews})</span>
                            </div>

                            <div className="absolute bottom-5 left-6 right-6">
                                <div className="flex items-center space-x-2 mb-2">
                                    <span className="px-3 py-1 bg-purple-600 text-white rounded-lg text-[9px] font-black uppercase tracking-widest">Verified Expert</span>
                                    <span className="px-3 py-1 bg-white/20 backdrop-blur text-white rounded-lg text-[9px] font-black uppercase tracking-widest">{coach.programs.length} Programs</span>
                                </div>
                                <h3 className="text-3xl font-black text-white leading-tight tracking-tight">{coach.name}</h3>
                                <p className="text-purple-200 text-xs font-bold mt-1 uppercase tracking-widest opacity-90">{coach.specialty}</p>
                            </div>
                        </div>
                        <div className="p-6 bg-white flex justify-between items-center">
                            <div className="flex items-center space-x-2">
                                <Award className="w-4 h-4 text-purple-600" />
                                <span className="text-[10px] font-black text-gray-400 uppercase tracking-widest">Performance Specialist</span>
                            </div>
                            <div className="w-12 h-12 bg-purple-50 text-purple-600 rounded-2xl flex items-center justify-center group-hover:bg-purple-600 group-hover:text-white transition-all duration-300">
                                <ChevronRight className="w-6 h-6" />
                            </div>
                        </div>
                    </div>
                ))}
            </div>
        </div>
    );

    const renderCoachProfile = () => {
        const { coach } = bookingData;
        return (
            <div className="space-y-8 animate-in pb-20">
                <div className="px-2">
                    <div className="flex items-center space-x-4 mb-6">
                        <img src={coach.image} className="w-20 h-20 rounded-3xl object-cover border-4 border-white shadow-xl" />
                        <div>
                            <h2 className="text-2xl font-black text-gray-900 leading-tight">{coach.name}</h2>
                            <p className="text-sm font-bold text-purple-600 uppercase tracking-wider">{coach.specialty}</p>
                        </div>
                    </div>
                    <div className="p-6 bg-white rounded-[32px] border border-gray-100 shadow-sm space-y-3">
                        <h4 className="text-[10px] font-black text-gray-400 uppercase tracking-widest">Coach Background</h4>
                        <p className="text-sm text-gray-600 font-medium leading-relaxed">{coach.bio}</p>
                        <div className="pt-4 border-t border-gray-50 flex space-x-4">
                            <a href={getWhatsAppLink(coach.phone, coach.name)} target="_blank" className="flex-1 py-3 bg-[#25D366] text-white rounded-2xl flex items-center justify-center text-xs font-black shadow-lg hover:brightness-110 transition-all">
                                <MessageCircle className="w-4 h-4 mr-2" /> WhatsApp
                            </a>
                            <button onClick={(e) => handleShare(coach, e)} className="p-3 bg-gray-50 text-gray-400 rounded-2xl hover:bg-gray-100">
                                <Share2 className="w-5 h-5" />
                            </button>
                        </div>
                    </div>
                </div>

                <div className="px-2 space-y-4">
                    <h3 className="text-xl font-black text-gray-900 ml-1 mb-4">Training Programs</h3>
                    {coach.programs.map(program => (
                        <div key={program.id} 
                             onClick={() => { setBookingData({...bookingData, program}); setCurrentStep(2); }}
                             className="bg-white p-5 rounded-[28px] shadow-lg border border-gray-50 flex items-center space-x-4 active:scale-95 transition-all cursor-pointer">
                            <img src={program.photo_url} className="w-24 h-24 object-cover rounded-2xl flex-shrink-0" alt={program.title} />
                            <div className="flex-grow min-w-0">
                                <span className="px-2 py-0.5 bg-purple-50 text-purple-600 rounded-lg text-[8px] font-black uppercase tracking-tighter">{program.goal}</span>
                                <h4 className="text-lg font-black text-gray-900 truncate mt-1">{program.title}</h4>
                                <p className="text-[10px] font-bold text-gray-400 uppercase tracking-widest">Duration: {program.duration}</p>
                                <p className="text-xl font-black text-purple-600 mt-2">${program.price.toFixed(2)}</p>
                            </div>
                            <div className="p-2 bg-gray-50 rounded-full text-gray-300">
                                <ChevronRight className="w-5 h-5" />
                            </div>
                        </div>
                    ))}
                </div>
            </div>
        );
    };

    const renderProgramDetails = () => {
        const { program } = bookingData;
        return (
            <div className="space-y-8 animate-in pb-32">
                <div className="relative h-64 -mx-5 -mt-8 overflow-hidden">
                    <img src={program.photo_url} className="w-full h-full object-cover" alt={program.title} />
                    <div className="absolute inset-0 bg-gradient-to-t from-[#F8FAFC] to-transparent"></div>
                    <div className="absolute bottom-6 left-6 right-6 flex justify-between items-end">
                         <span className="px-4 py-1.5 bg-purple-600 text-white rounded-xl text-[10px] font-black uppercase tracking-widest shadow-xl">Enrollment Open</span>
                         <div className="bg-white/90 backdrop-blur p-4 rounded-3xl shadow-xl text-center min-w-[80px]">
                            <p className="text-[9px] font-black text-gray-400 uppercase tracking-widest">Price</p>
                            <p className="text-xl font-black text-gray-900">${program.price}</p>
                         </div>
                    </div>
                </div>

                <div className="space-y-6">
                    <div className="px-2">
                        <h2 className="text-4xl font-black text-gray-900 tracking-tighter leading-none">{program.title}</h2>
                        <div className="flex items-center mt-3 space-x-3">
                            <div className="flex items-center bg-gray-100 px-3 py-1.5 rounded-xl">
                                <Monitor className="w-4 h-4 text-gray-500 mr-2" />
                                <span className="text-[10px] font-black text-gray-500 uppercase">Online Course</span>
                            </div>
                            <div className="flex items-center bg-purple-50 px-3 py-1.5 rounded-xl">
                                <Zap className="w-4 h-4 text-purple-500 mr-2" />
                                <span className="text-[10px] font-black text-purple-500 uppercase">{program.goal} Focused</span>
                            </div>
                        </div>
                    </div>

                    <div className="p-6 bg-white rounded-[32px] border border-gray-100 shadow-sm space-y-4 mx-2">
                        <h4 className="text-lg font-black text-gray-900">What's Included</h4>
                        <div className="space-y-3">
                            <div className="flex items-start space-x-3">
                                <div className="p-1.5 bg-purple-50 rounded-lg text-purple-600 mt-0.5"><Clock className="w-4 h-4" /></div>
                                <div><p className="text-sm font-bold text-gray-800">{program.duration} Program</p><p className="text-xs text-gray-400 font-medium">Self-paced with weekly milestones</p></div>
                            </div>
                            <div className="flex items-start space-x-3">
                                <div className="p-1.5 bg-rose-50 rounded-lg text-rose-600 mt-0.5"><Trophy className="w-4 h-4" /></div>
                                <div><p className="text-sm font-bold text-gray-800">Expert Feedback</p><p className="text-xs text-gray-400 font-medium">Monthly video stroke review included</p></div>
                            </div>
                        </div>
                    </div>

                    <div className="px-2 space-y-3">
                        <h4 className="text-lg font-black text-gray-900">Curriculum Overview</h4>
                        <p className="text-sm text-gray-600 font-medium leading-relaxed">{program.description}</p>
                    </div>
                </div>

                {/* Final join Momentum Bar */}
                <div className="fixed bottom-0 left-0 right-0 p-8 bg-white/95 backdrop-blur-md border-t border-gray-100 max-w-md mx-auto rounded-t-[40px] shadow-2xl z-40 flex items-center justify-between">
                    <div>
                        <p className="text-[10px] font-black text-gray-400 uppercase tracking-widest">Full Access</p>
                        <p className="text-3xl font-black text-gray-900 tracking-tighter">${program.price}</p>
                    </div>
                    <button 
                        onClick={() => {
                            showSnackbar("Starting your enrollment...");
                            setTimeout(() => { window.location.href = 'checkout_screen.html'; }, 1500);
                        }}
                        className="bg-purple-600 text-white px-10 py-5 rounded-3xl font-black shadow-2xl shadow-purple-200 flex items-center active:scale-95 transition-all text-sm tracking-widest"
                    >
                        JOIN PROGRAM
                        <ChevronRight className="w-5 h-5 ml-2" />
                    </button>
                </div>
            </div>
        );
    };

    return (
        <div className="max-w-md mx-auto min-h-screen bg-[#F8FAFC]">
            {/* Header */}
            <header className="bg-white/90 backdrop-blur-md px-6 pt-12 pb-5 flex items-center justify-between sticky top-0 z-30 border-b border-gray-50">
                <div className="flex items-center space-x-4">
                    <button onClick={handleBack} 
                        className={`p-2.5 rounded-2xl transition-all border bg-white border-gray-100 text-gray-900 shadow-sm active:scale-90 hover:bg-gray-50`}
                    >
                        <ChevronLeft className="w-6 h-6" />
                    </button>
                    <h1 className="text-2xl font-black text-gray-900 tracking-tight">Expert Coaches</h1>
                </div>
                <div className="w-11 h-11 rounded-2xl bg-purple-50 flex items-center justify-center text-purple-600 border border-purple-100 shadow-inner">
                    <Monitor className="w-6 h-6" />
                </div>
            </header>

            {currentStep < 3 && <StepIndicator step={currentStep} />}

            <main className="px-5 py-8">
                <div className="view-container">
                    {currentStep === 0 && renderCoachList()}
                    {currentStep === 1 && renderCoachProfile()}
                    {currentStep === 2 && renderProgramDetails()}
                </div>
            </main>

            <style>{`
                @keyframes fadeIn { from { opacity: 0; transform: translateY(20px); } to { opacity: 1; transform: translateY(0); } }
                .animate-in { animation: fadeIn 0.6s cubic-bezier(0.16, 1, 0.3, 1) forwards; }
                .no-scrollbar::-webkit-scrollbar { display: none; }
                .no-scrollbar { -ms-overflow-style: none; scrollbar-width: none; }
                .line-clamp-2 { display: -webkit-box; -webkit-line-clamp: 2; -webkit-box-orient: vertical; overflow: hidden; }
            `}</style>
        </div>
    );
}