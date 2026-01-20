import React, { useState, useEffect, useRef, useMemo } from 'react';
import { 
  Search, MapPin, Hospital, Clock, ChevronRight, 
  CheckCircle, Info, ShieldCheck, Stethoscope, ChevronLeft, 
  Calendar as CalendarIcon, User, Star
} from 'lucide-react';

// --- MOCK DATA ---
const CLINICS = [
    {
        id: 'c1',
        name: 'AquaHealth Physio & Recovery',
        branchesCount: 3,
        distance: '1.2 km',
        rating: 4.9,
        specialties: ['Post-Swim Recovery', 'Joint Mobility'],
        services: [
            { id: 's1', name: 'Initial Assessment', price: 95, duration: '60 min' },
            { id: 's2', name: 'Hydrotherapy Session', price: 75, duration: '45 min' },
            { id: 's3', name: 'Manual Therapy', price: 120, duration: '60 min' }
        ],
        branches: [
            { id: 'b1', name: 'Olympic Park Branch', open: 8, close: 19, beds: 3 },
            { id: 'b2', name: 'Downtown Wellness Center', open: 9, close: 20, beds: 2 }
        ],
        image: 'https://images.unsplash.com/photo-1590233156170-ef1f6305f884?auto=format&fit=crop&q=80&w=800'
    },
    {
        id: 'c2',
        name: 'Elite Sports Medical',
        branchesCount: 1,
        distance: '4.5 km',
        rating: 4.8,
        specialties: ['Injury Rehab', 'Dry Needling'],
        services: [
            { id: 's4', name: 'Sports Massage', price: 60, duration: '30 min' },
            { id: 's5', name: 'Cupping Therapy', price: 85, duration: '45 min' }
        ],
        branches: [
            { id: 'b3', name: 'Main HQ', open: 7, close: 17, beds: 4 }
        ],
        image: 'https://images.unsplash.com/photo-1519494026892-80bbd2d6fd0d?auto=format&fit=crop&q=80&w=800'
    }
];

const DAY_NAMES = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
const getNext14Days = () => {
    const days = [];
    for (let i = 0; i < 14; i++) {
        const d = new Date();
        d.setDate(d.getDate() + i);
        days.push(d);
    }
    return days;
};

// --- SUB-COMPONENTS ---

const StepIndicator = ({ step }) => {
    const steps = ['Clinic', 'Branch', 'Schedule', 'Service'];
    return (
        <div className="px-6 py-4 bg-white/80 backdrop-blur-md border-b border-gray-100 sticky top-[72px] z-20 shadow-sm">
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
    const [bookingData, setBookingData] = useState({
        clinic: null,
        branch: null,
        date: new Date().toISOString().split('T')[0],
        slot: null, 
        service: null
    });

    const [searchTerm, setSearchTerm] = useState('');
    const next14Days = useMemo(() => getNext14Days(), []);

    const goToStep = (step) => setCurrentStep(step);
    const handleBack = () => {
        if (currentStep > 0) setCurrentStep(currentStep - 1);
        else window.history.back();
    };

    // --- COMPUTED DATA ---
    const filteredClinics = useMemo(() => {
        if (!searchTerm.trim()) return CLINICS;
        const lowSearch = searchTerm.toLowerCase();
        return CLINICS.filter(clinic => 
            clinic.name.toLowerCase().includes(lowSearch) ||
            clinic.specialties.some(s => s.toLowerCase().includes(lowSearch))
        );
    }, [searchTerm]);

    // --- VIEW RENDERERS ---

    const renderClinicList = () => (
        <div className="space-y-6 animate-in">
            {/* Functional Search Bar */}
            <div className="bg-white p-5 rounded-[32px] shadow-sm border border-gray-100">
                <div className="relative">
                    <Search className="absolute left-4 top-1/2 -translate-y-1/2 w-5 h-5 text-gray-300" />
                    <input 
                        type="text" 
                        placeholder="Search clinic or specialty..." 
                        value={searchTerm}
                        onChange={(e) => setSearchTerm(e.target.value)}
                        className="w-full pl-12 pr-4 py-4 bg-gray-50 border-none rounded-2xl focus:ring-2 focus:ring-blue-500 transition-all text-sm font-semibold"
                    />
                </div>
            </div>

            <div className="space-y-5 pb-10">
                {filteredClinics.length > 0 ? filteredClinics.map(clinic => (
                    <div key={clinic.id} className="bg-white rounded-[36px] overflow-hidden shadow-xl shadow-gray-200/50 border border-white group active:scale-[0.98] transition-all cursor-pointer" 
                         onClick={() => { setBookingData({...bookingData, clinic}); goToStep(1); }}>
                        <div className="relative h-52">
                            <img src={clinic.image} className="w-full h-full object-cover group-hover:scale-105 transition-transform duration-1000" alt={clinic.name} />
                            <div className="absolute inset-0 bg-gradient-to-t from-black/80 via-black/20 to-transparent"></div>
                            <div className="absolute top-4 right-4 bg-white/90 backdrop-blur px-3 py-1.5 rounded-2xl flex items-center shadow-lg border border-white">
                                <Star className="w-3 h-3 text-amber-400 fill-amber-400 mr-1" />
                                <span className="text-[10px] font-black text-gray-800">{clinic.rating}</span>
                            </div>
                            <div className="absolute bottom-4 left-6">
                                <h3 className="text-2xl font-black text-white leading-tight tracking-tight">{clinic.name}</h3>
                                <div className="flex items-center text-blue-200 text-xs font-bold mt-1 uppercase tracking-widest opacity-90">
                                    <MapPin className="w-3 h-3 mr-1" /> {clinic.distance} away
                                </div>
                            </div>
                        </div>
                        <div className="p-6 flex justify-between items-center bg-white">
                            <div className="flex flex-wrap gap-2">
                                {clinic.specialties.map((s, idx) => (
                                    <span key={idx} className="px-3 py-1.5 bg-gray-50 text-gray-500 rounded-xl text-[9px] font-black uppercase tracking-widest">{s}</span>
                                ))}
                            </div>
                            <div className="w-12 h-12 bg-blue-50 text-blue-600 rounded-2xl flex items-center justify-center group-hover:bg-blue-600 group-hover:text-white transition-all duration-300">
                                <ChevronRight className="w-6 h-6" />
                            </div>
                        </div>
                    </div>
                )) : (
                    <div className="text-center py-20">
                        <div className="bg-gray-50 w-20 h-20 rounded-full flex items-center justify-center mx-auto mb-4">
                            <Search className="w-8 h-8 text-gray-300" />
                        </div>
                        <p className="font-bold text-gray-400 uppercase text-xs tracking-widest">No matching clinics found</p>
                    </div>
                )}
            </div>
        </div>
    );

    const renderBranchSelection = () => (
        <div className="space-y-6 animate-in">
            <div className="px-2">
                <h2 className="text-3xl font-black text-gray-900 tracking-tight leading-tight">Where would you like<br/>to go?</h2>
                <p className="text-sm text-gray-400 font-medium mt-2">Select your preferred {bookingData.clinic?.name} branch.</p>
            </div>
            <div className="space-y-3">
                {bookingData.clinic?.branches.map(branch => (
                    <button key={branch.id} className="w-full p-6 bg-white rounded-[32px] shadow-sm border border-gray-100 flex items-center justify-between group active:bg-blue-50 transition-all text-left" 
                            onClick={() => { setBookingData({...bookingData, branch}); goToStep(2); }}>
                        <div className="flex items-center space-x-5">
                            <div className="w-16 h-16 bg-blue-50 text-blue-600 rounded-2xl flex items-center justify-center group-hover:bg-blue-600 group-hover:text-white transition-all duration-500 shadow-inner">
                                <Hospital className="w-8 h-8" />
                            </div>
                            <div>
                                <h4 className="font-black text-gray-900 text-xl leading-tight">{branch.name}</h4>
                                <p className="text-[10px] text-gray-400 font-black uppercase tracking-[0.2em] mt-1.5 flex items-center">
                                    <Clock className="w-3 h-3 mr-1" /> Open: {branch.open}:00 - {branch.close}:00
                                </p>
                            </div>
                        </div>
                        <ChevronRight className="w-6 h-6 text-gray-200 group-hover:text-blue-500 transition-colors" />
                    </button>
                ))}
            </div>
        </div>
    );

    const renderSlotGrid = () => {
        const branch = bookingData.branch;
        const hours = Array.from({ length: branch.close - branch.open }, (_, i) => branch.open + i);
        const beds = Array.from({ length: branch.beds }, (_, i) => `Bed ${i + 1}`);

        return (
            <div className="space-y-6 animate-in pb-20">
                <div className="flex space-x-3 overflow-x-auto no-scrollbar pb-4 px-1">
                    {next14Days.map((date, idx) => {
                        const dateStr = date.toISOString().split('T')[0];
                        const isActive = bookingData.date === dateStr;
                        return (
                            <button key={idx} 
                                    onClick={() => setBookingData({...bookingData, date: dateStr})}
                                    className={`flex-shrink-0 w-16 py-4 rounded-[24px] flex flex-col items-center justify-center transition-all duration-300 ${isActive ? 'bg-blue-600 text-white shadow-xl shadow-blue-200 scale-105' : 'bg-white text-gray-400 border border-gray-100'}`}>
                                <span className="text-[9px] font-black uppercase tracking-tighter opacity-80 mb-1">{DAY_NAMES[date.getDay()]}</span>
                                <span className="text-lg font-black">{date.getDate()}</span>
                            </button>
                        );
                    })}
                </div>

                <div className="px-2">
                    <h2 className="text-2xl font-black text-gray-900 tracking-tight">Pick Bed & Time</h2>
                    <p className="text-xs text-blue-600 font-black uppercase tracking-widest mt-1">Precise Selection • {branch.name}</p>
                </div>

                <div className="bg-white rounded-[36px] overflow-hidden border border-gray-50 shadow-2xl shadow-gray-200/50 relative">
                    <div className="overflow-x-auto no-scrollbar relative max-h-[450px]">
                        <div style={{ display: 'grid', gridTemplateColumns: `80px repeat(${branch.beds}, 1fr)`, minWidth: '320px' }}>
                            <div className="sticky top-0 z-20 bg-gray-50/90 backdrop-blur-sm p-4 border-r border-b border-gray-100 flex items-center justify-center">
                                <Clock className="w-4 h-4 text-gray-400" />
                            </div>
                            {beds.map(bed => (
                                <div key={bed} className="sticky top-0 z-20 bg-gray-50/90 backdrop-blur-sm p-4 border-b border-gray-100 text-center text-[10px] font-black text-gray-500 uppercase tracking-[0.2em]">{bed}</div>
                            ))}
                            {hours.map(h => {
                                const timeStr = `${String(h).padStart(2, '0')}:00`;
                                return (
                                    <React.Fragment key={h}>
                                        <div className="sticky left-0 z-10 bg-white border-r border-b border-gray-50 p-4 flex items-center justify-center text-[11px] font-black text-gray-900">
                                            {h > 12 ? `${h-12} PM` : (h === 12 ? '12 PM' : `${h} AM`)}
                                        </div>
                                        {beds.map(bed => {
                                            const isBooked = (h === 11 && bed === 'Bed 2') || (h === 15 && bed === 'Bed 1') || (h === 10 && bed === 'Bed 3');
                                            const isSelected = bookingData.slot?.time === timeStr && bookingData.slot?.bed === bed;
                                            return (
                                                <div key={bed} onClick={() => !isBooked && setBookingData({...bookingData, slot: {bed, time: timeStr}})}
                                                    className={`h-16 border-b border-r border-gray-50 transition-all duration-300 flex items-center justify-center relative ${isBooked ? 'bg-gray-100/50 cursor-not-allowed' : 'bg-white cursor-pointer active:scale-95'}`}
                                                >
                                                    {isBooked ? (
                                                        <div className="w-full h-full flex items-center justify-center opacity-40">
                                                            <div className="w-1.5 h-1.5 bg-gray-300 rounded-full"></div>
                                                        </div>
                                                    ) : isSelected ? (
                                                        <div className="absolute inset-2 bg-blue-600 rounded-2xl shadow-xl shadow-blue-200 flex items-center justify-center text-white animate-scale-in">
                                                            <CheckCircle className="w-6 h-6" />
                                                        </div>
                                                    ) : (
                                                        <div className="w-2 h-2 rounded-full bg-blue-100 opacity-0 group-hover:opacity-100 transition-opacity"></div>
                                                    )}
                                                </div>
                                            );
                                        })}
                                    </React.Fragment>
                                );
                            })}
                        </div>
                    </div>
                </div>

                {bookingData.slot && (
                    <div className="fixed bottom-0 left-0 right-0 p-6 bg-white/80 backdrop-blur-xl border-t border-gray-100 max-w-md mx-auto rounded-t-[36px] shadow-2xl z-40 animate-slide-up">
                        <div className="flex items-center justify-between">
                            <div>
                                <p className="text-[10px] font-black text-gray-400 uppercase tracking-widest">Time & Space</p>
                                <p className="text-lg font-black text-gray-900 leading-tight">{bookingData.slot.time} • {bookingData.slot.bed}</p>
                            </div>
                            <button onClick={() => goToStep(3)} className="bg-blue-600 text-white px-8 py-4 rounded-2xl font-black text-sm shadow-xl shadow-blue-100 flex items-center hover:bg-blue-700 active:scale-95 transition-all">
                                Next Step <ChevronRight className="w-5 h-5 ml-2" />
                            </button>
                        </div>
                    </div>
                )}
            </div>
        );
    };

    const renderServiceSelect = () => (
        <div className="space-y-6 animate-in">
             <div className="px-2">
                <h2 className="text-3xl font-black text-gray-900 tracking-tight leading-tight">Choose Treatment</h2>
                <p className="text-sm text-gray-400 font-medium mt-1">Medical sessions for {bookingData.clinic?.name}</p>
            </div>
            <div className="space-y-4 pb-32">
                {bookingData.clinic?.services.map(service => {
                    const isSelected = bookingData.service?.id === service.id;
                    return (
                        <button key={service.id} onClick={() => setBookingData({...bookingData, service})}
                            className={`w-full p-6 rounded-[32px] border-2 transition-all duration-300 flex items-center justify-between text-left ${isSelected ? 'border-blue-600 bg-blue-50 shadow-xl shadow-blue-50 scale-[1.02]' : 'border-gray-100 bg-white hover:border-blue-100 shadow-sm'}`}>
                            <div className="flex items-center space-x-5">
                                <div className={`w-14 h-14 rounded-2xl flex items-center justify-center transition-all ${isSelected ? 'bg-blue-600 text-white rotate-6' : 'bg-emerald-50 text-emerald-600'}`}>
                                    <Stethoscope className="w-7 h-7" />
                                </div>
                                <div>
                                    <h4 className="font-black text-gray-900 text-lg leading-tight">{service.name}</h4>
                                    <p className="text-[10px] text-gray-400 font-black uppercase tracking-widest mt-1">{service.duration} • Performance</p>
                                </div>
                            </div>
                            <div className="text-right">
                                <p className="text-2xl font-black text-blue-600 tracking-tighter">${service.price}</p>
                            </div>
                        </button>
                    );
                })}
            </div>

            {bookingData.service && (
                <div className="fixed bottom-0 left-0 right-0 p-8 bg-white border-t border-gray-100 flex items-center justify-between shadow-2xl z-40 max-w-md mx-auto rounded-t-[40px] animate-slide-up">
                    <div className="space-y-0.5">
                        <p className="text-[10px] font-black text-gray-400 uppercase tracking-widest">Total Securely</p>
                        <p className="text-3xl font-black text-gray-900 tracking-tighter">${bookingData.service.price}</p>
                    </div>
                    <button onClick={() => goToStep(4)} className="bg-blue-600 text-white px-10 py-5 rounded-3xl font-black shadow-2xl shadow-blue-100 flex items-center active:scale-95 transition-all text-sm tracking-widest">
                        GO TO CHECKOUT <ChevronRight className="w-5 h-5 ml-2" />
                    </button>
                </div>
            )}
        </div>
    );

    const renderConfirmation = () => {
        const [sliderPos, setSliderPos] = useState(0);
        const sliderRef = useRef(null);

        const handleSliderMove = (e) => {
            const rect = sliderRef.current.getBoundingClientRect();
            const clientX = e.touches ? e.touches[0].clientX : e.clientX;
            const x = clientX - rect.left;
            const percentage = Math.min(Math.max((x / rect.width) * 100, 0), 100);
            if (percentage > 95) {
                showSnackbar("Booking Secured! See you in the pool.");
                setTimeout(() => window.location.reload(), 2000);
            }
            setSliderPos(percentage);
        };

        return (
            <div className="space-y-8 animate-in pb-16">
                <div className="text-center pt-8">
                    <div className="w-24 h-24 bg-blue-600 text-white rounded-[32px] flex items-center justify-center mx-auto mb-6 shadow-2xl shadow-blue-100 animate-bounce">
                        <ShieldCheck className="w-12 h-12" />
                    </div>
                    <h2 className="text-4xl font-black text-gray-900 tracking-tighter leading-tight">Almost there!</h2>
                    <p className="text-sm text-gray-400 font-medium mt-2">Secure your specialized recovery slot</p>
                </div>

                <div className="bg-white rounded-[40px] p-10 shadow-2xl shadow-gray-200 border border-white space-y-8 mx-2 relative overflow-hidden">
                    <div className="absolute top-0 right-0 w-32 h-32 bg-blue-50 rounded-full -mr-16 -mt-16 opacity-50"></div>
                    <div className="border-b border-gray-50 pb-8 relative z-10">
                        <p className="text-[10px] font-black text-blue-600 uppercase tracking-[0.3em] mb-3">Session Breakdown</p>
                        <h4 className="text-2xl font-black text-gray-900 leading-tight tracking-tight">{bookingData.clinic?.name}</h4>
                        <div className="flex items-center text-sm text-gray-500 font-bold mt-2">
                             <MapPin className="w-4 h-4 mr-1 text-gray-300" /> {bookingData.branch?.name}
                        </div>
                    </div>
                    <div className="grid grid-cols-2 gap-10 relative z-10">
                        <div className="flex items-start space-x-4">
                            <div className="bg-blue-50 p-2.5 rounded-2xl text-blue-600"><Clock className="w-5 h-5" /></div>
                            <div>
                                <p className="text-[9px] font-black text-gray-400 uppercase tracking-widest mb-1">Schedule</p>
                                <p className="font-black text-gray-900 text-lg leading-none">{bookingData.slot?.time}</p>
                            </div>
                        </div>
                        <div className="flex items-start space-x-4">
                            <div className="bg-blue-50 p-2.5 rounded-2xl text-blue-600"><User className="w-5 h-5" /></div>
                            <div>
                                <p className="text-[9px] font-black text-gray-400 uppercase tracking-widest mb-1">Resource</p>
                                <p className="font-black text-gray-900 text-lg leading-none">{bookingData.slot?.bed}</p>
                            </div>
                        </div>
                    </div>
                    <div className="bg-gray-50 p-8 rounded-[32px] flex justify-between items-center relative z-10 border border-white">
                        <div className="space-y-1">
                            <p className="text-[10px] font-black text-gray-400 uppercase tracking-widest">Medical Fee</p>
                            <p className="text-sm font-bold text-gray-500 leading-none">{bookingData.service?.name}</p>
                        </div>
                        <p className="text-4xl font-black text-gray-900 tracking-tighter">${bookingData.service?.price}</p>
                    </div>
                    <p className="text-[10px] text-center font-bold text-gray-400 uppercase tracking-widest px-8 leading-relaxed opacity-60">
                        Precise allocation locked. Free cancellation up to 24h before dive-in.
                    </p>
                </div>

                <div className="px-2 mt-10">
                    <div ref={sliderRef} className="relative h-24 bg-gray-100/50 rounded-[40px] overflow-hidden p-3 touch-none select-none shadow-inner flex items-center"
                        onMouseMove={(e) => sliderPos > 0 && handleSliderMove(e)} onTouchMove={(e) => sliderPos > 0 && handleSliderMove(e)}
                        onMouseDown={() => setSliderPos(1)} onTouchStart={() => setSliderPos(1)}
                        onMouseUp={() => sliderPos < 95 && setSliderPos(0)} onTouchEnd={() => sliderPos < 95 && setSliderPos(0)}
                    >
                        <div className="absolute inset-0 flex items-center justify-center pointer-events-none">
                            <p className="text-[10px] font-black text-gray-400 uppercase tracking-[0.4em] ml-16">Slide to Book</p>
                        </div>
                        <div className="absolute bg-blue-600 h-18 w-18 rounded-[30px] flex items-center justify-center text-white shadow-2xl transition-all duration-75 cursor-grab active:cursor-grabbing border-4 border-white/20"
                            style={{ left: '12px', transform: `translateX(${sliderPos * 2.8}px)`, backgroundColor: sliderPos > 90 ? '#10B981' : '#2563EB' }}
                        >
                            {sliderPos > 90 ? <CheckCircle className="w-10 h-10" /> : <ChevronRight className="w-10 h-10" />}
                        </div>
                    </div>
                </div>
            </div>
        );
    };

    const showSnackbar = (msg) => {
        const sn = document.createElement('div');
        sn.className = "fixed bottom-10 left-1/2 -translate-x-1/2 bg-slate-900 text-white px-10 py-5 rounded-full text-sm font-black shadow-2xl z-[100] animate-bounce";
        sn.textContent = msg;
        document.body.appendChild(sn);
        setTimeout(() => sn.remove(), 2500);
    }

    return (
        <div className="max-w-md mx-auto min-h-screen bg-[#F8FAFC]">
            {/* Header */}
            <header className="bg-white/90 backdrop-blur-md px-6 pt-12 pb-5 flex items-center justify-between sticky top-0 z-30 border-b border-gray-50">
                <div className="flex items-center space-x-4">
                    <button onClick={handleBack} 
                        className="p-2.5 rounded-2xl transition-all border bg-white border-gray-100 text-gray-900 shadow-sm active:scale-90 hover:bg-gray-50"
                    >
                        <ChevronLeft className="w-6 h-6" />
                    </button>
                    <h1 className="text-2xl font-black text-gray-900 tracking-tight">Recovery</h1>
                </div>
                <div className="w-11 h-11 rounded-2xl bg-blue-50 flex items-center justify-center text-blue-600 border border-blue-100 shadow-inner">
                    <Hospital className="w-6 h-6" />
                </div>
            </header>

            {currentStep < 4 && <StepIndicator step={currentStep} />}

            <main className="px-5 py-8">
                <div className="view-container">
                    {currentStep === 0 && renderClinicList()}
                    {currentStep === 1 && renderBranchSelection()}
                    {currentStep === 2 && renderSlotGrid()}
                    {currentStep === 3 && renderServiceSelect()}
                    {currentStep === 4 && renderConfirmation()}
                </div>
            </main>

            <style>{`
                @keyframes fadeIn { from { opacity: 0; transform: translateY(20px); } to { opacity: 1; transform: translateY(0); } }
                @keyframes slideUp { from { opacity: 0; transform: translateY(100%); } to { opacity: 1; transform: translateY(0); } }
                @keyframes scaleIn { from { transform: scale(0.85); opacity: 0; } to { transform: scale(1); opacity: 1; } }
                .animate-in { animation: fadeIn 0.6s cubic-bezier(0.16, 1, 0.3, 1) forwards; }
                .animate-slide-up { animation: slideUp 0.6s cubic-bezier(0.16, 1, 0.3, 1) forwards; }
                .animate-scale-in { animation: scaleIn 0.4s cubic-bezier(0.34, 1.56, 0.64, 1) forwards; }
                .no-scrollbar::-webkit-scrollbar { display: none; }
                .no-scrollbar { -ms-overflow-style: none; scrollbar-width: none; }
            `}</style>
        </div>
    );
}