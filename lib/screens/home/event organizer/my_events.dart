import React, { useState, useMemo } from 'react';
import { 
  Plus, Calendar, ChevronDown, Check, 
  Building2, X, Info, ArrowLeft, ArrowRight,
  ShieldOff, RotateCcw, CheckCircle, AlertCircle,
  Clock, Layers, MapPin, Activity, Video, 
  Tag, Users, DollarSign, Camera, Globe, 
  Trophy, UserCheck, Navigation, Layout, Edit3, Eye, Trash2,
  ChevronLeft // تم إضافة الأيقونة المفقودة لإصلاح الخطأ
} from 'lucide-react';

// --- الثوابت والقوائم ---
const EVENT_TYPES = ["Championship", "Clinic", "Seminar", "Zoom Meeting", "Fun Swim", "Training", "Other"];
const AUDIENCES = ["Swimmers", "Nutritionists", "Doctors", "Parents", "Coaches", "Other"];

const INITIAL_EVENTS = [
    { 
        id: 'e1', name: 'Regional Championship 2026', 
        date: '2026-01-23', time: '09:00', duration_value: '3', duration_unit: 'hours', 
        price: 45.00, tickets: 100, 
        location_name: 'Central Pool (NYC)', location_url: 'https://maps.google.com/event1',
        age_range: '12-18', target_audience: 'Swimmers',
        type: 'Championship', 
        description: 'The premier swimming event of the season, featuring top athletes from five regions competing for the gold medal.', 
        video_url: 'https://vimeo.com/event1', 
        photo_url: 'https://images.unsplash.com/photo-1530549387634-e5a529577059?auto=format&fit=crop&q=80&w=400' 
    },
    { 
        id: 'e2', name: 'Open Water Fun Swim', 
        date: '2026-02-15', time: '08:30', duration_value: '2', duration_unit: 'hours', 
        price: 0.00, tickets: 50, 
        location_name: 'Sea Coast (LA)', location_url: 'https://maps.google.com/event2',
        age_range: 'All Ages', target_audience: 'Parents',
        type: 'Fun Swim', 
        description: 'A social and non-competitive open water swimming event perfect for all levels. Wetsuits are encouraged.', 
        video_url: '', 
        photo_url: 'https://images.unsplash.com/photo-1519494026892-80bbd2d6fd0d?auto=format&fit=crop&q=80&w=400' 
    }
];

export default function App() {
    const [events, setEvents] = useState(INITIAL_EVENTS);
    const [view, setView] = useState('list'); // 'list', 'edit', 'details'
    const [editingEvent, setEditingEvent] = useState(null);
    const [notification, setNotification] = useState(null);
    const [loading, setLoading] = useState(false);

    // --- أدوات مساعدة ---
    const showNotify = (msg, type = 'success') => {
        setNotification({ msg, type });
        setTimeout(() => setNotification(null), 3000);
    };

    const formatTime24to12 = (time24) => {
        if (!time24) return '';
        const [hr24, min] = time24.split(':');
        let hr = parseInt(hr24);
        const ampm = hr >= 12 ? 'PM' : 'AM';
        hr = hr % 12 || 12;
        return `${String(hr).padStart(2, '0')}:${min} ${ampm}`;
    };

    const handleEditClick = (event) => {
        setEditingEvent({ ...event });
        setView('edit');
    };

    const handleDetailsClick = (event) => {
        setEditingEvent(event);
        setView('details');
    };

    const handleSave = (e) => {
        e.preventDefault();
        
        if (!editingEvent?.name || !editingEvent?.location_name || !editingEvent?.tickets) {
            showNotify("Please fill in all required fields", "error");
            return;
        }

        setLoading(true);
        setTimeout(() => {
            setEvents(events.map(ev => ev.id === editingEvent.id ? editingEvent : ev));
            setLoading(false);
            showNotify("Event details updated successfully!");
            setView('list');
        }, 1000);
    };

    // --- واجهات العرض ---

    const renderList = () => (
        <div className="p-6 space-y-8 animate-in text-left">
            <header className="space-y-1">
                <h1 className="text-3xl font-black text-gray-900 tracking-tight">My Events</h1>
                <p className="text-sm text-gray-400 font-medium">Manage and promote your upcoming listings</p>
            </header>

            <div className="space-y-4 pb-20">
                {events.map(event => (
                    <div key={event.id} className="bg-white rounded-[32px] border border-gray-100 shadow-sm p-4 flex items-center space-x-4 hover:shadow-md transition-all group">
                        <div className="w-20 h-20 rounded-2xl bg-gray-50 overflow-hidden flex-shrink-0 relative">
                            <img src={event.photo_url} className="w-full h-full object-cover" alt="event" />
                            <div className="absolute top-1 right-1 px-1.5 py-0.5 bg-white/90 backdrop-blur rounded text-[8px] font-black uppercase text-blue-600 border border-blue-100">
                                {event.type}
                            </div>
                        </div>
                        <div className="flex-grow min-w-0">
                            <h3 className="text-lg font-black text-gray-900 truncate leading-tight group-hover:text-blue-600 transition-colors">{event.name}</h3>
                            <div className="flex items-center text-[10px] text-gray-400 font-bold uppercase tracking-widest mt-1">
                                <Calendar className="w-3 h-3 mr-1" /> {event.date} • {formatTime24to12(event.time)}
                            </div>
                            <div className="flex items-center space-x-3 mt-2">
                                <span className="text-sm font-black text-emerald-600">{event.price === 0 ? 'FREE' : `$${event.price.toFixed(2)}`}</span>
                                <span className="text-gray-200">|</span>
                                <span className="text-[10px] text-gray-400 font-bold uppercase flex items-center">
                                    <MapPin className="w-3 h-3 mr-1" /> {event.location_name}
                                </span>
                            </div>
                        </div>
                        <div className="flex flex-col space-y-1.5">
                            <button onClick={() => handleDetailsClick(event)} className="p-2.5 bg-gray-50 text-gray-400 rounded-xl hover:bg-blue-50 hover:text-blue-600 transition-all shadow-sm" title="View Details">
                                <Eye className="w-4 h-4" />
                            </button>
                            <button onClick={() => handleEditClick(event)} className="p-2.5 bg-gray-50 text-blue-600 rounded-xl hover:bg-blue-600 hover:text-white transition-all shadow-sm" title="Edit Event">
                                <Edit3 className="w-4 h-4" />
                            </button>
                        </div>
                    </div>
                ))}
            </div>
        </div>
    );

    const renderEditForm = () => (
        <div className="animate-in flex flex-col min-h-screen pb-12 text-left">
            <header className="px-6 pt-12 pb-6 bg-white border-b border-gray-100 sticky top-0 z-30 flex items-center justify-between">
                <div className="flex items-center space-x-4">
                    <button onClick={() => setView('list')} className="p-2.5 bg-gray-50 rounded-2xl text-gray-500 active:scale-90 transition-transform">
                        <ArrowLeft className="w-6 h-6" />
                    </button>
                    <h1 className="text-2xl font-black tracking-tight leading-tight truncate max-w-[200px]">{editingEvent?.name}</h1>
                </div>
                <button 
                    onClick={handleSave}
                    disabled={loading}
                    className="px-6 py-3 bg-blue-600 text-white rounded-2xl font-black text-xs uppercase tracking-widest shadow-xl shadow-blue-100 active:scale-95 transition-all"
                >
                    {loading ? 'Saving...' : 'Update'}
                </button>
            </header>

            <main className="p-6 space-y-6">
                <div className="bg-white p-6 rounded-[32px] shadow-sm border border-gray-100 space-y-5">
                    <div className="flex items-center space-x-2">
                        <Layout className="w-4 h-4 text-blue-600" />
                        <h3 className="text-[10px] font-black text-gray-400 uppercase tracking-widest">Event Information</h3>
                    </div>
                    <div className="space-y-4">
                        <div>
                            <label className="text-[10px] font-black text-gray-400 uppercase ml-1">Event Name</label>
                            <div className="w-full mt-1.5 p-4 bg-gray-100 border-none rounded-2xl text-sm font-bold text-gray-500 select-none">
                                {editingEvent?.name}
                            </div>
                        </div>
                        <div>
                            <label className="text-[10px] font-black text-gray-400 uppercase ml-1">Event Type</label>
                            <select value={editingEvent?.type} onChange={e => setEditingEvent({...editingEvent, type: e.target.value})} className="w-full mt-1.5 p-4 bg-gray-50 border-none rounded-2xl text-sm font-bold outline-none">
                                {EVENT_TYPES.map(t => <option key={t} value={t}>{t}</option>)}
                            </select>
                        </div>
                        <div>
                            <label className="text-[10px] font-black text-gray-400 uppercase ml-1">Description</label>
                            <textarea value={editingEvent?.description} onChange={e => setEditingEvent({...editingEvent, description: e.target.value})} rows="4" className="w-full mt-1.5 p-4 bg-gray-50 border-none rounded-2xl text-sm font-bold resize-none focus:ring-2 focus:ring-blue-500 outline-none" />
                        </div>
                        <div>
                            <label className="text-[10px] font-black text-gray-400 uppercase ml-1">Promo Video URL (Optional)</label>
                            <input type="url" value={editingEvent?.video_url} onChange={e => setEditingEvent({...editingEvent, video_url: e.target.value})} placeholder="https://..." className="w-full mt-1.5 p-4 bg-gray-50 border-none rounded-2xl text-sm font-bold outline-none" />
                        </div>
                    </div>
                </div>

                <div className="bg-white p-6 rounded-[32px] shadow-sm border border-gray-100 space-y-6">
                    <div className="flex items-center space-x-2">
                        <Clock className="w-4 h-4 text-blue-600" />
                        <h3 className="text-[10px] font-black text-gray-400 uppercase tracking-widest">Time & Location</h3>
                    </div>
                    <div className="space-y-4">
                        <div className="grid grid-cols-2 gap-4">
                            <div>
                                <label className="text-[10px] font-black text-gray-400 uppercase ml-1">Date</label>
                                <input type="date" value={editingEvent?.date} onChange={e => setEditingEvent({...editingEvent, date: e.target.value})} className="w-full mt-1.5 p-4 bg-gray-50 border-none rounded-2xl text-sm font-bold outline-none" />
                            </div>
                            <div>
                                <label className="text-[10px] font-black text-gray-400 uppercase ml-1">Time</label>
                                <input type="time" value={editingEvent?.time} onChange={e => setEditingEvent({...editingEvent, time: e.target.value})} className="w-full mt-1.5 p-4 bg-gray-50 border-none rounded-2xl text-sm font-bold outline-none" />
                            </div>
                        </div>
                        <div className="grid grid-cols-2 gap-4">
                            <div>
                                <label className="text-[10px] font-black text-gray-400 uppercase ml-1">Duration</label>
                                <div className="flex mt-1.5 bg-gray-50 rounded-2xl overflow-hidden">
                                    <input type="number" value={editingEvent?.duration_value} onChange={e => setEditingEvent({...editingEvent, duration_value: e.target.value})} className="w-2/3 p-4 bg-transparent border-none text-sm font-bold outline-none" />
                                    <select value={editingEvent?.duration_unit} onChange={e => setEditingEvent({...editingEvent, duration_unit: e.target.value})} className="w-1/3 bg-gray-100 p-2 text-[10px] font-black uppercase outline-none">
                                        <option value="hours">Hrs</option>
                                        <option value="days">Days</option>
                                    </select>
                                </div>
                            </div>
                            <div>
                                <label className="text-[10px] font-black text-gray-400 uppercase ml-1">Total Seats</label>
                                <input type="number" value={editingEvent?.tickets} onChange={e => setEditingEvent({...editingEvent, tickets: e.target.value})} className="w-full mt-1.5 p-4 bg-gray-50 border-none rounded-2xl text-sm font-bold outline-none" />
                            </div>
                        </div>
                        <div>
                            <label className="text-[10px] font-black text-gray-400 uppercase ml-1">Venue Name</label>
                            <input type="text" value={editingEvent?.location_name} onChange={e => setEditingEvent({...editingEvent, location_name: e.target.value})} className="w-full mt-1.5 p-4 bg-gray-50 border-none rounded-2xl text-sm font-bold focus:ring-2 focus:ring-blue-500 outline-none" />
                        </div>
                        <div>
                            <label className="text-[10px] font-black text-gray-400 uppercase ml-1">Google Maps URL</label>
                            <input type="url" value={editingEvent?.location_url} onChange={e => setEditingEvent({...editingEvent, location_url: e.target.value})} className="w-full mt-1.5 p-4 bg-gray-50 border-none rounded-2xl text-sm font-bold focus:ring-2 focus:ring-blue-500 outline-none" />
                        </div>
                    </div>
                </div>

                <div className="bg-white p-6 rounded-[32px] shadow-sm border border-gray-100 space-y-4">
                    <div className="flex items-center space-x-2">
                        <Tag className="w-4 h-4 text-blue-600" />
                        <h3 className="text-[10px] font-black text-gray-400 uppercase tracking-widest">Audience & Price</h3>
                    </div>
                    <div className="grid grid-cols-2 gap-4">
                        <div>
                            <label className="text-[10px] font-black text-gray-400 uppercase ml-1">Price ($)</label>
                            <div className="w-full mt-1.5 p-4 bg-gray-100 border-none rounded-2xl text-sm font-bold text-gray-400 select-none">
                                ${editingEvent?.price.toFixed(2)}
                            </div>
                        </div>
                        <div>
                            <label className="text-[10px] font-black text-gray-400 uppercase ml-1">Age Range</label>
                            <input type="text" value={editingEvent?.age_range} onChange={e => setEditingEvent({...editingEvent, age_range: e.target.value})} className="w-full mt-1.5 p-4 bg-gray-50 border-none rounded-2xl text-sm font-bold outline-none" />
                        </div>
                    </div>
                    <div>
                        <label className="text-[10px] font-black text-gray-400 uppercase ml-1">Primary Audience</label>
                        <select value={editingEvent?.target_audience} onChange={e => setEditingEvent({...editingEvent, target_audience: e.target.value})} className="w-full mt-1.5 p-4 bg-gray-50 border-none rounded-2xl text-sm font-bold outline-none">
                            {AUDIENCES.map(a => <option key={a} value={a}>{a}</option>)}
                        </select>
                    </div>
                </div>
            </main>
        </div>
    );

    const renderDetailsView = () => (
        <div className="animate-in flex flex-col min-h-screen bg-white pb-12 text-left">
            <header className="px-6 pt-12 pb-6 flex items-center justify-between sticky top-0 bg-white/90 backdrop-blur-xl z-30">
                <button onClick={() => setView('list')} className="p-2.5 bg-gray-50 rounded-2xl text-gray-600 active:scale-90 transition-transform">
                    <ChevronLeft className="w-6 h-6" />
                </button>
                <h1 className="text-xl font-black tracking-tight leading-tight">Event Summary</h1>
                <div className="w-10 h-10"></div>
            </header>

            <div className="px-6 space-y-8">
                <div className="relative h-60 rounded-[32px] overflow-hidden shadow-2xl">
                    <img src={editingEvent?.photo_url} className="w-full h-full object-cover" alt="cover" />
                    <div className="absolute inset-0 bg-gradient-to-t from-black/60 to-transparent"></div>
                    <div className="absolute bottom-6 left-6 right-6">
                        <span className="px-3 py-1 bg-rose-600 text-white rounded-lg text-[9px] font-black uppercase tracking-widest">{editingEvent?.type}</span>
                        <h2 className="text-2xl font-black text-white mt-2 leading-tight">{editingEvent?.name}</h2>
                    </div>
                </div>

                <div className="grid grid-cols-2 gap-4">
                    <div className="p-5 bg-gray-50 rounded-3xl flex items-center space-x-4 border border-gray-100">
                        <Calendar className="w-6 h-6 text-rose-500" />
                        <div>
                            <p className="text-[9px] font-black text-gray-400 uppercase tracking-widest leading-none mb-1">Date</p>
                            <p className="text-sm font-black text-gray-900">{editingEvent?.date}</p>
                        </div>
                    </div>
                    <div className="p-5 bg-gray-50 rounded-3xl flex items-center space-x-4 border border-gray-100">
                        <Clock className="w-6 h-6 text-blue-500" />
                        <div>
                            <p className="text-[9px] font-black text-gray-400 uppercase tracking-widest leading-none mb-1">Start Time</p>
                            <p className="text-sm font-black text-gray-900">{formatTime24to12(editingEvent?.time)}</p>
                        </div>
                    </div>
                </div>

                <div className="space-y-4">
                    <h3 className="text-xs font-black text-gray-400 uppercase tracking-[0.2em] ml-1">About the Event</h3>
                    <p className="text-sm text-gray-600 leading-relaxed font-medium bg-gray-50 p-6 rounded-[28px] border border-gray-100">{editingEvent?.description}</p>
                </div>

                <div className="bg-blue-600 p-8 rounded-[32px] text-white space-y-6 shadow-xl shadow-blue-100">
                    <div className="flex justify-between items-center border-b border-white/10 pb-4">
                        <span className="text-[10px] font-black uppercase tracking-widest">Entry Fee</span>
                        <span className="text-3xl font-black">${editingEvent?.price.toFixed(2)}</span>
                    </div>
                    <div className="grid grid-cols-2 gap-6 pt-2">
                        <div>
                            <p className="text-[9px] font-black text-blue-200 uppercase tracking-widest mb-1">Audience</p>
                            <p className="text-xs font-bold">{editingEvent?.target_audience}</p>
                        </div>
                        <div>
                            <p className="text-[9px] font-black text-blue-200 uppercase tracking-widest mb-1">Capacity</p>
                            <p className="text-xs font-bold">{editingEvent?.tickets} Tickets Total</p>
                        </div>
                    </div>
                </div>

                <div className="pt-2 pb-10">
                    <a href={editingEvent?.location_url} target="_blank" rel="noopener noreferrer" className="w-full flex items-center justify-center py-5 bg-gray-900 text-white rounded-[24px] font-black text-sm uppercase tracking-widest active:scale-95 transition-all">
                        <MapPin className="w-5 h-5 mr-3 text-blue-400" /> Open Venue in Maps
                    </a>
                </div>
            </div>
        </div>
    );

    return (
        <div className="max-w-md mx-auto min-h-screen bg-[#F8FAFC] font-sans text-gray-900 relative">
            {view === 'list' && renderList()}
            {view === 'edit' && renderEditForm()}
            {view === 'details' && renderDetailsView()}

            {notification && (
                <div className={`fixed bottom-10 left-1/2 -translate-x-1/2 px-8 py-4 rounded-full text-[10px] font-black shadow-2xl z-[100] animate-bounce flex items-center space-x-2 uppercase tracking-widest ${notification.type === 'error' ? 'bg-red-600' : 'bg-gray-900'} text-white`}>
                    {notification.type === 'success' ? <CheckCircle className="w-4 h-4" /> : <AlertCircle className="w-4 h-4" />}
                    <span>{notification.msg}</span>
                </div>
            )}

            <style>{`
                @keyframes fadeIn { from { opacity: 0; transform: translateY(15px); } to { opacity: 1; transform: translateY(0); } }
                .animate-in { animation: fadeIn 0.4s cubic-bezier(0.16, 1, 0.3, 1) forwards; }
                .no-scrollbar::-webkit-scrollbar { display: none; }
                .no-scrollbar { -ms-overflow-style: none; scrollbar-width: none; }
                .line-clamp-1 { display: -webkit-box; -webkit-line-clamp: 1; -webkit-box-orient: vertical; overflow: hidden; }
            `}</style>
        </div>
    );
}