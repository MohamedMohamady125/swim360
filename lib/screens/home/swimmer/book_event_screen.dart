import React, { useState, useEffect, useRef, useMemo } from 'react';
import { 
  Search, MapPin, Clock, ChevronRight, 
  CheckCircle, ShieldCheck, ChevronLeft, 
  Calendar as CalendarIcon, Users, Trophy, Zap, 
  MessageCircle, Star, Share2
} from 'lucide-react';

// --- MOCK DATA ---
const EVENTS = [
    {
        id: 'e1',
        name: 'Regional Championship 2026',
        type: 'Championship',
        date: '2025-11-10', 
        displayDate: 'Nov 10, 2025',
        startTime: '09:00 AM',
        duration: '3 hrs',
        location: 'Central Pool (NYC)',
        price: 45.00,
        seatsLeft: 25,
        totalSeats: 100,
        organizer: 'National Swim Federation',
        organizerPhone: '1234567890',
        rating: 4.9,
        image: 'https://images.unsplash.com/photo-1530549387634-e5a529577059?auto=format&fit=crop&q=80&w=800',
        description: 'The premier swimming event of the season, featuring top athletes from five regions competing for the coveted gold medal. All elite and high-performance squads are invited.',
        requirements: ['A-Level Times achieved', 'Active Membership', 'Official racing kit']
    },
    {
        id: 'e2',
        name: 'Open Water Fun Swim',
        type: 'Fun Swim',
        date: '2025-11-15',
        displayDate: 'Nov 15, 2025',
        startTime: '08:30 AM',
        duration: '2 hrs',
        location: 'Sea Coast (LA)',
        price: 0, 
        seatsLeft: 12,
        totalSeats: 50,
        organizer: 'Coastal Swim Club',
        organizerPhone: '9876543210',
        rating: 4.7,
        image: 'https://images.unsplash.com/photo-1519494026892-80bbd2d6fd0d?auto=format&fit=crop&q=80&w=800',
        description: 'A social and non-competitive open water swimming event perfect for all levels. Wetsuits are encouraged. Meet at the main beach flagpole.',
        requirements: ['Basic open water experience', 'Safety buoy required']
    },
    {
        id: 'e3',
        name: 'Masters Training Clinic',
        type: 'Training',
        date: '2025-12-01',
        displayDate: 'Dec 01, 2025',
        startTime: '07:00 PM',
        duration: '90 mins',
        location: 'Local Gym Pool (LON)',
        price: 15.00,
        seatsLeft: 4,
        totalSeats: 15,
        organizer: 'Coach Sarah Wilson',
        organizerPhone: '5554443332',
        rating: 5.0,
        image: 'https://images.unsplash.com/photo-1461896744630-47b7178d4944?auto=format&fit=crop&q=80&w=800',
        description: 'High-intensity technique drills led by professional coaches. Perfect for masters swimmers looking to shave seconds off their personal bests.',
        requirements: ['Age 25+', 'Goggles and Cap']
    }
];

// --- SUB-COMPONENTS ---

const StepIndicator = ({ step }) => {
    // Streamlined steps: Removed "Verify" to skip straight to payment
    const steps = ['Explore', 'Details', 'Options'];
    return (
        <div className="px-6 py-4 bg-white/90 backdrop-blur-md border-b border-gray-100 sticky top-[72px] z-20 shadow-sm">
            <div className="flex justify-between items-center relative">
                <div className="absolute top-1/2 left-0 w-full h-0.5 bg-gray-100 -translate-y-1/2 z-0"></div>
                <div 
                    className="absolute top-1/2 left-0 h-0.5 bg-rose-600 -translate-y-1/2 z-0 transition-all duration-700 ease-out" 
                    style={{ width: `${(step / (steps.length - 1)) * 100}%` }}
                ></div>
                {steps.map((label, idx) => (
                    <div key={idx} className="relative z-10 flex flex-col items-center">
                        <div className={`w-7 h-7 rounded-full flex items-center justify-center text-[10px] font-black transition-all duration-300 ${step >= idx ? 'bg-rose-600 text-white scale-110 shadow-lg shadow-rose-100' : 'bg-white border-2 border-gray-100 text-gray-300'}`}>
                            {step > idx ? <CheckCircle className="w-4 h-4" /> : idx + 1}
                        </div>
                        <span className={`text-[8px] mt-1.5 font-black uppercase tracking-widest ${step >= idx ? 'text-rose-600' : 'text-gray-300'}`}>{label}</span>
                    </div>
                ))}
            </div>
        </div>
    );
};

export default function App() {
    const [currentStep, setCurrentStep] = useState(0); 
    const [bookingData, setBookingData] = useState({
        event: null,
        ticketQuantity: 1,
        totalPrice: 0
    });
    const [searchTerm, setSearchTerm] = useState('');
    const [sortBy, setSortBy] = useState('date'); 

    // --- UTILITIES ---
    const showSnackbar = (msg) => {
        const sn = document.createElement('div');
        sn.className = "fixed bottom-10 left-1/2 -translate-x-1/2 bg-slate-900 text-white px-10 py-5 rounded-full text-sm font-black shadow-2xl z-[100] animate-bounce text-center min-w-[280px]";
        sn.textContent = msg;
        document.body.appendChild(sn);
        setTimeout(() => sn.remove(), 2500);
    };

    const goToStep = (step) => setCurrentStep(step);
    
    const handleBack = () => {
        if (currentStep > 0) goToStep(currentStep - 1);
        else window.history.back();
    };

    const handleShare = (event, e) => {
        e.stopPropagation();
        const text = `Check out this event on Swim 360: ${event.name} on ${event.displayDate}! https://swim360.app/events/${event.id}`;
        const dummy = document.createElement('input');
        document.body.appendChild(dummy);
        dummy.value = text;
        dummy.select();
        document.execCommand('copy');
        document.body.removeChild(dummy);
        showSnackbar("Event link copied to clipboard!");
    };

    const getWhatsAppLink = (phone, name) => {
        const message = `Hi, I'm interested in registering for the "${name}" event on Swim 360. Could you please provide more details?`;
        return `https://wa.me/${phone.replace(/\D/g, '')}?text=${encodeURIComponent(message)}`;
    };

    // --- COMPUTED DATA ---
    const filteredEvents = useMemo(() => {
        const lowSearch = searchTerm.toLowerCase();
        let result = EVENTS.filter(e => 
            e.name.toLowerCase().includes(lowSearch) || 
            e.type.toLowerCase().includes(lowSearch) ||
            e.location.toLowerCase().includes(lowSearch)
        );

        if (sortBy === 'date') {
            result.sort((a, b) => new Date(a.date) - new Date(b.date));
        } else if (sortBy === 'price') {
            result.sort((a, b) => a.price - b.price);
        }

        return result;
    }, [searchTerm, sortBy]);

    // --- VIEW RENDERERS ---

    const renderBrowse = () => (
        <div className="space-y-6 animate-in">
            <div className="bg-white p-5 rounded-[32px] shadow-sm border border-gray-100 space-y-4">
                <div className="relative">
                    <Search className="absolute left-4 top-1/2 -translate-y-1/2 w-5 h-5 text-gray-300" />
                    <input 
                        type="text" 
                        placeholder="Search events, locations..." 
                        value={searchTerm}
                        onChange={(e) => setSearchTerm(e.target.value)}
                        className="w-full pl-12 pr-4 py-4 bg-gray-50 border-none rounded-2xl focus:ring-2 focus:ring-rose-500 transition-all text-sm font-semibold"
                    />
                </div>
                <div className="flex items-center justify-between px-1">
                    <span className="text-[10px] font-black text-gray-400 uppercase tracking-widest">Sort By</span>
                    <div className="flex space-x-2">
                        <button onClick={() => setSortBy('date')} className={`px-4 py-2 rounded-xl text-[10px] font-black uppercase tracking-widest transition-all ${sortBy === 'date' ? 'bg-rose-600 text-white shadow-md' : 'bg-gray-50 text-gray-400 hover:bg-gray-100'}`}>Date</button>
                        <button onClick={() => setSortBy('price')} className={`px-4 py-2 rounded-xl text-[10px] font-black uppercase tracking-widest transition-all ${sortBy === 'price' ? 'bg-rose-600 text-white shadow-md' : 'bg-gray-50 text-gray-400 hover:bg-gray-100'}`}>Price</button>
                    </div>
                </div>
            </div>

            <div className="space-y-5 pb-20">
                {filteredEvents.map(event => (
                    <div key={event.id} className="bg-white rounded-[36px] overflow-hidden shadow-xl shadow-gray-200/50 border border-white group active:scale-[0.98] transition-all cursor-pointer relative" 
                         onClick={() => { setBookingData({...bookingData, event}); goToStep(1); }}>
                        <div className="relative h-56">
                            <img src={event.image} className="w-full h-full object-cover group-hover:scale-105 transition-transform duration-1000" alt={event.name} />
                            <div className="absolute inset-0 bg-gradient-to-t from-black/90 via-black/20 to-transparent"></div>
                            
                            <button onClick={(e) => handleShare(event, e)} className="absolute top-4 left-4 bg-white/90 backdrop-blur p-2.5 rounded-2xl shadow-lg border border-white text-gray-700 hover:bg-white transition-colors">
                                <Share2 className="w-4 h-4" />
                            </button>

                            <div className="absolute top-4 right-4 bg-white/90 backdrop-blur px-3 py-1.5 rounded-2xl flex items-center shadow-lg border border-white">
                                <Star className="w-3 h-3 text-amber-400 fill-amber-400 mr-1" />
                                <span className="text-[10px] font-black text-gray-800">{event.rating}</span>
                            </div>
                            <div className="absolute bottom-5 left-6 right-6">
                                <span className="px-3 py-1 bg-rose-600 text-white rounded-lg text-[9px] font-black uppercase tracking-widest">{event.type}</span>
                                <h3 className="text-2xl font-black text-white leading-tight tracking-tight mt-2">{event.name}</h3>
                                <div className="flex items-center text-rose-100 text-xs font-bold mt-1 uppercase tracking-widest opacity-90">
                                    <CalendarIcon className="w-3 h-3 mr-1" /> {event.displayDate}
                                </div>
                            </div>
                        </div>
                        <div className="p-6 flex justify-between items-center bg-white">
                            <div>
                                <div className="flex items-center text-gray-400 text-[10px] font-black uppercase tracking-widest mb-1">
                                    <MapPin className="w-3 h-3 mr-1" /> {event.location}
                                </div>
                                <p className={`text-sm font-black ${event.seatsLeft < 10 ? 'text-rose-600' : 'text-emerald-500'}`}>
                                    {event.seatsLeft} spots left
                                </p>
                            </div>
                            <div className="text-right">
                                <p className="text-2xl font-black text-gray-900 tracking-tighter">{event.price === 0 ? 'FREE' : `$${event.price}`}</p>
                                <p className="text-[10px] font-black text-gray-300 uppercase tracking-widest">Entry Fee</p>
                            </div>
                        </div>
                    </div>
                ))}
            </div>
        </div>
    );

    const renderDetails = () => {
        const { event } = bookingData;
        return (
            <div className="space-y-8 animate-in pb-32">
                <div className="relative h-64 -mx-5 -mt-8 overflow-hidden">
                    <img src={event.image} className="w-full h-full object-cover" alt={event.name} />
                    <div className="absolute inset-0 bg-gradient-to-t from-[#F8FAFC] to-transparent"></div>
                    <button onClick={(e) => handleShare(event, e)} className="absolute top-12 left-6 bg-white p-3 rounded-2xl shadow-xl text-gray-700 active:scale-90 transition-transform">
                        <Share2 className="w-5 h-5" />
                    </button>
                </div>
                <div className="space-y-6">
                    <div className="px-2">
                        <div className="flex items-center space-x-2 mb-2">
                            <span className="px-3 py-1 bg-rose-50 text-rose-600 rounded-lg text-[10px] font-black uppercase tracking-widest">{event.type}</span>
                            {event.seatsLeft < 10 && <span className="px-3 py-1 bg-amber-50 text-amber-600 rounded-lg text-[10px] font-black uppercase tracking-widest animate-pulse">Selling Out</span>}
                        </div>
                        <h2 className="text-4xl font-black text-gray-900 tracking-tighter leading-none">{event.name}</h2>
                        <p className="text-sm font-bold text-blue-600 mt-2">By {event.organizer}</p>
                    </div>
                    <div className="grid grid-cols-2 gap-4">
                        <div className="p-5 bg-white rounded-3xl border border-gray-100 shadow-sm flex items-center space-x-4">
                            <div className="bg-rose-50 p-2.5 rounded-2xl text-rose-600"><CalendarIcon className="w-5 h-5" /></div>
                            <div>
                                <p className="text-[9px] font-black text-gray-400 uppercase tracking-widest">Date</p>
                                <p className="font-black text-gray-900 text-sm leading-none">{event.displayDate}</p>
                            </div>
                        </div>
                        <div className="p-5 bg-white rounded-3xl border border-gray-100 shadow-sm flex items-center space-x-4">
                            <div className="bg-blue-50 p-2.5 rounded-2xl text-blue-600"><Clock className="w-5 h-5" /></div>
                            <div>
                                <p className="text-[9px] font-black text-gray-400 uppercase tracking-widest">Start</p>
                                <p className="font-black text-gray-900 text-sm leading-none">{event.startTime}</p>
                            </div>
                        </div>
                    </div>
                    <div className="px-2 space-y-4">
                        <h4 className="text-lg font-black text-gray-900">About the Event</h4>
                        <p className="text-sm text-gray-500 font-medium leading-relaxed">{event.description}</p>
                    </div>
                </div>
                <div className="fixed bottom-0 left-0 right-0 p-8 bg-white/80 backdrop-blur-xl border-t border-gray-100 max-w-md mx-auto rounded-t-[40px] shadow-2xl z-40 flex items-center justify-between">
                    <div>
                        <p className="text-[10px] font-black text-gray-400 uppercase tracking-widest">Entry Fee</p>
                        <p className="text-3xl font-black text-gray-900 tracking-tighter">{event.price === 0 ? 'FREE' : `$${event.price}`}</p>
                    </div>
                    <button onClick={() => goToStep(2)} className="bg-rose-600 text-white px-10 py-5 rounded-3xl font-black shadow-2xl shadow-rose-200 flex items-center active:scale-95 transition-all text-sm tracking-widest">
                        GET TICKETS <ChevronRight className="w-5 h-5 ml-2" />
                    </button>
                </div>
            </div>
        );
    };

    const renderOptions = () => {
        const { event, ticketQuantity } = bookingData;
        return (
            <div className="space-y-8 animate-in">
                <div className="px-2">
                    <h2 className="text-3xl font-black text-gray-900 tracking-tight leading-tight">Quantity & Options</h2>
                    <p className="text-sm text-gray-400 font-medium mt-2">How many tickets do you need?</p>
                </div>
                <div className="bg-white rounded-[40px] p-8 shadow-xl border border-gray-50 space-y-8">
                    <div className="flex items-center justify-between">
                        <div>
                            <h4 className="font-black text-gray-900 text-xl">General Entry</h4>
                            <p className="text-xs text-gray-400 font-bold uppercase tracking-widest mt-1">Full access to {event.name}</p>
                        </div>
                        <div className="flex items-center space-x-5 bg-gray-50 p-2 rounded-[24px]">
                            <button onClick={() => setBookingData({...bookingData, ticketQuantity: Math.max(1, ticketQuantity - 1)})} className="w-12 h-12 bg-white rounded-2xl flex items-center justify-center font-black text-gray-900 shadow-sm active:scale-90 transition-transform">-</button>
                            <span className="font-black text-xl w-6 text-center">{ticketQuantity}</span>
                            <button onClick={() => setBookingData({...bookingData, ticketQuantity: Math.min(event.seatsLeft, ticketQuantity + 1)})} className="w-12 h-12 bg-white rounded-2xl flex items-center justify-center font-black text-gray-900 shadow-sm active:scale-90 transition-transform">+</button>
                        </div>
                    </div>
                    <div className="border-t border-gray-100 pt-8 flex justify-between items-center">
                        <div className="space-y-1">
                            <p className="text-[10px] font-black text-gray-400 uppercase tracking-widest">Grand Total</p>
                            <p className="text-4xl font-black text-gray-900 tracking-tighter">${(event.price * ticketQuantity).toFixed(2)}</p>
                        </div>
                        <div className="bg-emerald-50 text-emerald-600 px-4 py-2 rounded-2xl text-xs font-black">PRICE LOCKED</div>
                    </div>
                </div>
                <div className="space-y-4">
                    {/* DIRECT REDIRECT TO CHECKOUT - verification removed for speed */}
                    <button 
                        onClick={() => {
                            showSnackbar("Securely redirecting to checkout...");
                            setTimeout(() => { window.location.href = 'checkout_screen.html'; }, 1500);
                        }} 
                        className="w-full py-5 bg-rose-600 text-white rounded-[32px] font-black shadow-2xl shadow-rose-100 flex items-center justify-center active:scale-95 transition-all text-sm tracking-widest uppercase"
                    >
                        Continue to Checkout <ChevronRight className="w-5 h-5 ml-3" />
                    </button>
                    
                    <a href={getWhatsAppLink(event.organizerPhone, event.name)} target="_blank" rel="noopener noreferrer" className="w-full py-5 bg-white border border-gray-100 text-emerald-500 rounded-[32px] font-black flex items-center justify-center space-x-3 hover:bg-emerald-50 transition-colors">
                        <MessageCircle className="w-6 h-6" />
                        <span>Chat with Organizer (WhatsApp)</span>
                    </a>
                </div>
            </div>
        );
    };

    return (
        <div className="max-w-md mx-auto min-h-screen bg-[#F8FAFC]">
            <header className="bg-white/90 backdrop-blur-md px-6 pt-12 pb-5 flex items-center justify-between sticky top-0 z-30 border-b border-gray-50">
                <div className="flex items-center space-x-4">
                    <button onClick={handleBack} className="p-2.5 rounded-2xl transition-all border bg-white border-gray-100 text-gray-900 shadow-sm active:scale-90 hover:bg-gray-50">
                        <ChevronLeft className="w-6 h-6" />
                    </button>
                    <h1 className="text-2xl font-black text-gray-900 tracking-tight">Events</h1>
                </div>
                <div className="w-11 h-11 rounded-2xl bg-rose-50 flex items-center justify-center text-rose-600 border border-rose-100 shadow-inner">
                    <Trophy className="w-6 h-6" />
                </div>
            </header>

            {currentStep < 3 && <StepIndicator step={currentStep} />}

            <main className="px-5 py-8">
                <div className="view-container">
                    {currentStep === 0 && renderBrowse()}
                    {currentStep === 1 && renderDetails()}
                    {currentStep === 2 && renderOptions()}
                </div>
            </main>

            <style>{`
                @keyframes fadeIn { from { opacity: 0; transform: translateY(20px); } to { opacity: 1; transform: translateY(0); } }
                .animate-in { animation: fadeIn 0.6s cubic-bezier(0.16, 1, 0.3, 1) forwards; }
                .no-scrollbar::-webkit-scrollbar { display: none; }
                .no-scrollbar { -ms-overflow-style: none; scrollbar-width: none; }
            `}</style>
        </div>
    );
}