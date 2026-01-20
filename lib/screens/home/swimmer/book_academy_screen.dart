import React, { useState, useMemo, useRef } from 'react';
import { 
  Search, MapPin, Clock, ChevronRight, 
  CheckCircle, ShieldCheck, ChevronLeft, 
  Users, Trophy, MessageCircle, Star, Share2, 
  GraduationCap, Layers, Map, Info, ChevronDown, Building2
} from 'lucide-react';

// --- MOCK DATA: ACADEMIES WITH BRANCH-SPECIFIC PROGRAMS ---
const ACADEMIES = [
    {
        id: 'acad1',
        name: 'Elite Performance Academy',
        area: 'New Cairo',
        rating: 4.9,
        reviews: 240,
        image: 'https://images.unsplash.com/photo-1576013551627-0cc20b96c2a7?q=80&w=800&auto=format&fit=crop',
        description: 'Cairo’s leading high-performance swim center. We focus on technical excellence and competitive stamina for athletes of all ages.',
        phone: '20123456789',
        branches: [
            { 
                id: 'b1', 
                name: 'Fifth Settlement Branch', 
                address: 'Street 90, North Investors',
                availableProgramIds: ['p1', 'p2'] 
            },
            { 
                id: 'b2', 
                name: 'Rehab City Hub', 
                address: 'Gate 6, Club Square',
                availableProgramIds: ['p1'] 
            }
        ],
        programs: [
            { 
                id: 'p1', 
                name: 'Beginner - Level 1', 
                description: 'Foundational safety, breath control, and basic freestyle mechanics.',
                price: 85.00, 
                enrolled: 18, 
                capacity: 20, 
                schedules: ['Sat/Sun 10:00 AM', 'Wed/Fri 12:00 PM'],
                sessionsPerWeek: 2,
                duration: '1 Month'
            },
            { 
                id: 'p2', 
                name: 'Intermediate Squad', 
                description: 'Refining stroke technique for all four competitive strokes and turn efficiency.',
                price: 120.00, 
                enrolled: 8, 
                capacity: 15, 
                schedules: ['Mon/Wed/Fri 04:00 PM', 'Tue/Thu/Sat 06:00 PM'],
                sessionsPerWeek: 3,
                duration: '3 Months'
            }
        ]
    },
    {
        id: 'acad2',
        name: 'Blue Wave Swim Center',
        area: 'Maadi',
        rating: 4.8,
        reviews: 185,
        image: 'https://images.unsplash.com/photo-1530549387634-e5a529577059?auto=format&fit=crop&q=80&w=800',
        description: 'A community-focused academy specializing in developmental swimming and water safety for children and adults.',
        phone: '20198765432',
        branches: [
            { 
                id: 'b3', 
                name: 'Maadi Grand Mall Branch', 
                address: 'Road 250, Digla',
                availableProgramIds: ['p3'] 
            },
            { 
                id: 'b4', 
                name: 'Sarayet El Maadi', 
                address: 'Corniche El Nil',
                availableProgramIds: ['p3'] 
            }
        ],
        programs: [
            { 
                id: 'p3', 
                name: 'Junior Sharks (6-8 yrs)', 
                description: 'Fun-based learning environment for young swimmers to master group coordination.',
                price: 95.00, 
                enrolled: 10, 
                capacity: 12, 
                schedules: ['Tue/Thu 05:00 PM', 'Sat/Sun 09:00 AM'],
                sessionsPerWeek: 2,
                duration: '2 Months'
            }
        ]
    }
];

const StepIndicator = ({ step }) => {
    const steps = ['Academy', 'Branch', 'Level', 'Summary'];
    return (
        <div className="px-6 py-4 bg-white/90 backdrop-blur-md border-b border-gray-100 sticky top-[72px] z-20 shadow-sm">
            <div className="flex justify-between items-center relative">
                <div className="absolute top-1/2 left-0 w-full h-0.5 bg-gray-100 -translate-y-1/2 z-0"></div>
                <div 
                    className="absolute top-1/2 left-0 h-0.5 bg-blue-600 -translate-y-1/2 z-0 transition-all duration-700 ease-out" 
                    style={{ width: `${(step / (steps.length - 1)) * 100}%` }}
                ></div>
                {steps.map((label, idx) => (
                    <div key={idx} className="relative z-10 flex flex-col items-center">
                        <div className={`w-7 h-7 rounded-full flex items-center justify-center text-[10px] font-black transition-all duration-300 ${step >= idx ? 'bg-blue-600 text-white scale-110 shadow-lg shadow-blue-100' : 'bg-white border-2 border-gray-100 text-gray-300'}`}>
                            {step > idx ? <CheckCircle className="w-4 h-4" /> : idx + 1}
                        </div>
                        <span className={`text-[8px] mt-1.5 font-black uppercase tracking-widest ${step >= idx ? 'text-blue-600' : 'text-gray-300'}`}>{label}</span>
                    </div>
                ))}
            </div>
        </div>
    );
};

export default function App() {
    const [currentStep, setCurrentStep] = useState(0); 
    const [selectedAcademy, setSelectedAcademy] = useState(null);
    const [selectedBranch, setSelectedBranch] = useState(null);
    const [selectedProgram, setSelectedProgram] = useState(null);
    const [selectedSchedule, setSelectedSchedule] = useState(null);
    
    const [searchTerm, setSearchTerm] = useState('');
    const [activeScheduleProgramId, setActiveScheduleProgramId] = useState(null);
    const [sliderPos, setSliderPos] = useState(0);
    const sliderRef = useRef(null);

    // --- UTILITIES ---
    const showSnackbar = (msg) => {
        const sn = document.createElement('div');
        sn.className = "fixed bottom-10 left-1/2 -translate-x-1/2 bg-slate-900 text-white px-10 py-5 rounded-full text-sm font-black shadow-2xl z-[100] animate-bounce text-center min-w-[280px]";
        sn.textContent = msg;
        document.body.appendChild(sn);
        setTimeout(() => sn.remove(), 2500);
    };

    const handleBack = () => {
        if (currentStep === 0) window.history.back();
        else if (currentStep === 1) { setSelectedAcademy(null); setCurrentStep(0); }
        else if (currentStep === 2) { setSelectedBranch(null); setCurrentStep(1); }
        else if (currentStep === 3) { setSelectedProgram(null); setSelectedSchedule(null); setCurrentStep(2); }
    };

    const handleAcademySelect = (academy) => {
        setSelectedAcademy(academy);
        setCurrentStep(1);
    };

    const handleBranchSelect = (branch) => {
        setSelectedBranch(branch);
        setCurrentStep(2);
    };

    const handleEnroll = (program) => {
        if (!selectedSchedule || activeScheduleProgramId !== program.id) {
            showSnackbar("Please choose a time schedule first.");
            setActiveScheduleProgramId(program.id);
            return;
        }
        setSelectedProgram(program);
        setCurrentStep(3);
    };

    const handleSliderMove = (e) => {
        if (!sliderRef.current) return;
        const rect = sliderRef.current.getBoundingClientRect();
        const clientX = e.touches ? e.touches[0].clientX : e.clientX;
        const x = clientX - rect.left;
        const percentage = Math.min(Math.max((x / rect.width) * 100, 0), 100);
        
        if (percentage > 95) {
            showSnackbar("Registration confirmed! Redirecting to checkout...");
            setTimeout(() => {
                window.location.href = 'checkout_screen.html';
            }, 1500);
        }
        setSliderPos(percentage);
    };

    const resetSlider = () => {
        if (sliderPos < 95) setSliderPos(0);
    };

    // --- COMPUTED DATA ---
    const filteredAcademies = useMemo(() => {
        const lowSearch = searchTerm.toLowerCase();
        return ACADEMIES.filter(a => 
            (a.name.toLowerCase().includes(lowSearch) || a.area.toLowerCase().includes(lowSearch))
        );
    }, [searchTerm]);

    const branchPrograms = useMemo(() => {
        if (!selectedAcademy || !selectedBranch) return [];
        return selectedAcademy.programs.filter(p => selectedBranch.availableProgramIds.includes(p.id));
    }, [selectedAcademy, selectedBranch]);

    // --- RENDERERS ---

    const renderAcademyList = () => (
        <div className="space-y-6 animate-in">
            <div className="bg-white p-5 rounded-[32px] shadow-sm border border-gray-100 space-y-4">
                <div className="relative">
                    <Search className="absolute left-4 top-1/2 -translate-y-1/2 w-5 h-5 text-gray-300" />
                    <input 
                        type="text" 
                        placeholder="Search academy or area..." 
                        value={searchTerm}
                        onChange={(e) => setSearchTerm(e.target.value)}
                        className="w-full pl-12 pr-4 py-4 bg-gray-50 border-none rounded-2xl focus:ring-2 focus:ring-blue-500 transition-all text-sm font-semibold"
                    />
                </div>
            </div>

            <div className="space-y-5 pb-20">
                {filteredAcademies.map(academy => (
                    <div key={academy.id} className="bg-white rounded-[36px] overflow-hidden shadow-xl shadow-gray-200/50 border border-white group active:scale-[0.98] transition-all cursor-pointer relative" 
                         onClick={() => handleAcademySelect(academy)}>
                        <div className="relative h-60">
                            <img src={academy.image} className="w-full h-full object-cover group-hover:scale-105 transition-transform duration-1000" alt={academy.name} />
                            <div className="absolute inset-0 bg-gradient-to-t from-black/80 via-black/20 to-transparent"></div>
                            <div className="absolute bottom-5 left-6 right-6">
                                <h3 className="text-3xl font-black text-white leading-tight tracking-tight">{academy.name}</h3>
                                <div className="flex items-center text-blue-200 text-xs font-bold mt-1 uppercase tracking-widest opacity-90">
                                    <MapPin className="w-3 h-3 mr-1" /> {academy.area}
                                </div>
                            </div>
                        </div>
                        <div className="p-6 bg-white flex justify-between items-center">
                            <div className="flex items-center space-x-3">
                                <div className="w-10 h-10 bg-blue-50 rounded-xl flex items-center justify-center text-blue-600">
                                    <GraduationCap className="w-6 h-6" />
                                </div>
                                <p className="text-[10px] font-black text-gray-400 uppercase tracking-widest">Enrollment Open</p>
                            </div>
                            <div className="bg-blue-600 text-white px-6 py-2.5 rounded-2xl text-[10px] font-black uppercase tracking-widest shadow-lg">
                                View Branches
                            </div>
                        </div>
                    </div>
                ))}
            </div>
        </div>
    );

    const renderBranchList = () => (
        <div className="space-y-8 animate-in">
            <div className="px-2">
                <h2 className="text-3xl font-black text-gray-900 tracking-tight leading-tight">Choose Location</h2>
                <p className="text-sm text-gray-400 font-medium mt-2">Where would you like to train with {selectedAcademy.name}?</p>
            </div>
            
            <div className="space-y-4">
                {selectedAcademy.branches.map(branch => (
                    <button key={branch.id} 
                            onClick={() => handleBranchSelect(branch)}
                            className="w-full p-6 bg-white rounded-[32px] shadow-sm border border-gray-100 flex items-center justify-between group active:bg-blue-50 transition-all text-left">
                        <div className="flex items-center space-x-5">
                            <div className="w-14 h-14 bg-blue-50 text-blue-600 rounded-2xl flex items-center justify-center group-hover:bg-blue-600 group-hover:text-white transition-colors">
                                <Building2 className="w-7 h-7" />
                            </div>
                            <div>
                                <h4 className="font-black text-gray-900 text-lg leading-tight">{branch.name}</h4>
                                <p className="text-xs text-gray-400 font-medium mt-1">{branch.address}</p>
                            </div>
                        </div>
                        <ChevronRight className="w-6 h-6 text-gray-200 group-hover:text-blue-600" />
                    </button>
                ))}
            </div>
        </div>
    );

    const renderProgramList = () => (
        <div className="space-y-8 animate-in pb-32">
            <div className="px-2 text-right">
                <h2 className="text-3xl font-black text-gray-900 tracking-tight leading-tight">Select Level</h2>
                <p className="text-sm text-gray-400 font-medium mt-2">Programs at {selectedBranch.name}</p>
            </div>

            <div className="space-y-6">
                {branchPrograms.map(program => {
                    const spotsLeft = program.capacity - program.enrolled;
                    const isExpanded = activeScheduleProgramId === program.id;

                    return (
                        <div key={program.id} className="bg-white p-6 rounded-[32px] shadow-xl border border-gray-50 space-y-6">
                            <div className="flex justify-between items-start">
                                <div className="space-y-1">
                                    <h4 className="text-xl font-black text-gray-900 tracking-tight">{program.name}</h4>
                                    <p className="text-sm text-gray-500 font-medium leading-relaxed line-clamp-2">{program.description}</p>
                                </div>
                                <div className="text-right flex-shrink-0 ml-2">
                                    <p className="text-2xl font-black text-blue-600 tracking-tighter">${program.price}</p>
                                    <p className="text-[9px] font-black text-gray-400 uppercase tracking-widest">{program.duration}</p>
                                </div>
                            </div>

                            <div className="grid grid-cols-2 gap-3">
                                <div className="bg-gray-50 p-4 rounded-2xl border border-gray-100 text-center">
                                    <p className="text-[9px] text-gray-400 font-black uppercase tracking-widest mb-1">Commitment</p>
                                    <p className="text-xs font-bold text-gray-800 flex items-center justify-center">
                                        <Layers className="w-3 h-3 mr-1.5 text-blue-500" /> {program.sessionsPerWeek} sessions/week
                                    </p>
                                </div>
                                
                                <div className="relative">
                                    <button 
                                        onClick={() => setActiveScheduleProgramId(isExpanded ? null : program.id)}
                                        className={`w-full h-full p-4 rounded-2xl border flex flex-col transition-all text-center ${isExpanded ? 'border-blue-500 bg-blue-50' : 'border-gray-100 bg-gray-50'}`}
                                    >
                                        <p className="text-[9px] text-gray-400 font-black uppercase tracking-widest mb-1">Schedule View</p>
                                        <p className="text-xs font-bold text-gray-800 flex items-center justify-between w-full">
                                            <span className="truncate">{selectedSchedule && activeScheduleProgramId === program.id ? selectedSchedule : `${program.schedules.length} Options`}</span>
                                            <ChevronDown className={`w-3 h-3 transition-transform ${isExpanded ? 'rotate-180' : ''}`} />
                                        </p>
                                    </button>
                                    
                                    {isExpanded && (
                                        <div className="absolute top-full left-0 right-0 mt-2 bg-white rounded-2xl shadow-2xl border border-blue-100 z-50 p-2 space-y-1 animate-in">
                                            {program.schedules.map((sched, idx) => (
                                                <button 
                                                    key={idx}
                                                    onClick={() => { setSelectedSchedule(sched); setActiveScheduleProgramId(program.id); }}
                                                    className={`w-full p-3 rounded-xl text-left text-[10px] font-bold uppercase tracking-tight transition-colors ${selectedSchedule === sched && activeScheduleProgramId === program.id ? 'bg-blue-600 text-white shadow-lg' : 'bg-gray-50 text-gray-700'}`}
                                                >
                                                    {sched}
                                                </button>
                                            ))}
                                        </div>
                                    )}
                                </div>
                            </div>

                            <div className="space-y-2">
                                <div className="flex justify-between items-center text-[10px] font-black uppercase tracking-widest">
                                    <span className="text-gray-400">Capacity</span>
                                    <span className={spotsLeft <= 5 ? "text-rose-500 font-bold" : "text-emerald-500 font-bold"}>{spotsLeft} Spots Left</span>
                                </div>
                                <div className="h-2 w-full bg-gray-100 rounded-full overflow-hidden">
                                    <div className="h-full bg-blue-600 transition-all duration-1000" style={{ width: `${(program.enrolled / program.capacity) * 100}%` }}></div>
                                </div>
                            </div>

                            <button 
                                onClick={() => handleEnroll(program)}
                                className="w-full py-5 bg-blue-600 text-white rounded-[24px] font-black shadow-xl shadow-blue-100 active:scale-95 transition-all text-sm tracking-widest"
                            >
                                CONTINUE
                            </button>
                        </div>
                    );
                })}
            </div>
        </div>
    );

    const renderSummary = () => (
        <div className="space-y-8 animate-in pb-16">
            <div className="text-center pt-8">
                <div className="w-24 h-24 bg-blue-600 text-white rounded-[32px] flex items-center justify-center mx-auto mb-6 shadow-2xl shadow-blue-100 animate-bounce">
                    <ShieldCheck className="w-12 h-12" />
                </div>
                <h2 className="text-4xl font-black text-gray-900 tracking-tighter leading-tight">Review Order</h2>
                <p className="text-sm text-gray-400 font-medium mt-2">Ready to secure your spot?</p>
            </div>

            <div className="bg-white rounded-[40px] p-10 shadow-2xl shadow-gray-200 border border-white space-y-8 mx-2 relative overflow-hidden">
                <div className="border-b border-gray-50 pb-8">
                    <p className="text-[10px] font-black text-blue-600 uppercase tracking-[0.3em] mb-3">Academic Selection</p>
                    <h4 className="text-2xl font-black text-gray-900 leading-tight tracking-tight">{selectedAcademy?.name}</h4>
                    <div className="flex items-center text-sm text-gray-500 font-bold mt-2">
                            <MapPin className="w-4 h-4 mr-1 text-gray-300" /> {selectedBranch?.name}
                    </div>
                </div>

                <div className="grid grid-cols-2 gap-10">
                    <div>
                        <p className="text-[9px] font-black text-gray-400 uppercase tracking-widest mb-1">Level</p>
                        <p className="font-black text-gray-900 text-lg leading-none">{selectedProgram?.name}</p>
                    </div>
                    <div>
                        <p className="text-[9px] font-black text-gray-400 uppercase tracking-widest mb-1">Schedule</p>
                        <p className="font-black text-gray-900 text-lg leading-none">{selectedSchedule}</p>
                    </div>
                </div>

                <div className="bg-gray-50 p-8 rounded-[32px] flex justify-between items-center border border-white">
                    <div className="space-y-1">
                        <p className="text-[10px] font-black text-gray-400 uppercase tracking-widest">Amount Due</p>
                        <p className="text-sm font-bold text-gray-500 leading-none">Monthly Subscription</p>
                    </div>
                    <p className="text-4xl font-black text-gray-900 tracking-tighter">${selectedProgram?.price}</p>
                </div>
            </div>

            <div className="px-2 mt-10">
                <div 
                    ref={sliderRef}
                    className="relative h-24 bg-gray-100 rounded-[40px] overflow-hidden p-3 touch-none select-none shadow-inner flex items-center"
                    onMouseMove={handleSliderMove}
                    onTouchMove={handleSliderMove}
                    onMouseDown={() => setSliderPos(1)}
                    onTouchStart={() => setSliderPos(1)}
                    onMouseUp={resetSlider}
                    onMouseLeave={resetSlider}
                    onTouchEnd={resetSlider}
                >
                    <div className="absolute inset-0 flex items-center justify-center pointer-events-none">
                        <p className="text-[10px] font-black text-gray-400 uppercase tracking-[0.4em] ml-16">Slide to Enroll</p>
                    </div>
                    <div 
                        className="absolute bg-blue-600 h-18 w-18 rounded-[30px] flex items-center justify-center text-white shadow-2xl transition-all duration-75 cursor-grab active:cursor-grabbing border-4 border-white/20"
                        style={{ 
                            left: '12px',
                            transform: `translateX(${sliderPos * 2.8}px)`,
                            backgroundColor: sliderPos > 90 ? '#10B981' : '#2563EB'
                        }}
                    >
                        {sliderPos > 90 ? <CheckCircle className="w-10 h-10" /> : <ChevronRight className="w-10 h-10" />}
                    </div>
                </div>
            </div>
        </div>
    );

    return (
        <div className="max-w-md mx-auto min-h-screen bg-[#F8FAFC]">
            <header className="bg-white/90 backdrop-blur-md px-6 pt-12 pb-5 flex items-center justify-between sticky top-0 z-30 border-b border-gray-50">
                <div className="flex items-center space-x-4">
                    <button onClick={handleBack} className="p-2.5 rounded-2xl transition-all border bg-white border-gray-100 text-gray-900 shadow-sm active:scale-90 hover:bg-gray-50">
                        <ChevronLeft className="w-6 h-6" />
                    </button>
                    <h1 className="text-2xl font-black text-gray-900 tracking-tight">Academies</h1>
                </div>
                <div className="w-11 h-11 rounded-2xl bg-blue-50 flex items-center justify-center text-blue-600 border border-blue-100 shadow-inner">
                    <Trophy className="w-6 h-6" />
                </div>
            </header>

            {currentStep < 3 && <StepIndicator step={currentStep} />}

            <main className="px-5 py-8">
                <div className="view-container">
                    {currentStep === 0 && renderAcademyList()}
                    {currentStep === 1 && renderBranchList()}
                    {currentStep === 2 && renderProgramList()}
                    {currentStep === 3 && renderSummary()}
                </div>
            </main>

            <style>{`
                @keyframes fadeIn { from { opacity: 0; transform: translateY(20px); } to { opacity: 1; transform: translateY(0); } }
                .animate-in { animation: fadeIn 0.4s cubic-bezier(0.16, 1, 0.3, 1) forwards; }
                .no-scrollbar::-webkit-scrollbar { display: none; }
                .no-scrollbar { -ms-overflow-style: none; scrollbar-width: none; }
                .line-clamp-2 { display: -webkit-box; -webkit-line-clamp: 2; -webkit-box-orient: vertical; overflow: hidden; }
            `}</style>
        </div>
    );
}