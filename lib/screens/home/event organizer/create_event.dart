import React, { useState, useEffect } from 'react';
import { 
  Plus, Calendar, ChevronDown, Check, 
  Building2, X, Info, ArrowLeft, ArrowRight,
  ShieldOff, RotateCcw, CheckCircle, AlertCircle,
  Clock, Layers, MapPin, Activity, Video, 
  Tag, Users, DollarSign, Camera, Globe, 
  Trophy, UserCheck, Navigation, Layout
} from 'lucide-react';

// --- الثوابت والقوائم ---
const EVENT_TYPES = ["Championship", "Clinic", "Seminar", "Zoom Meeting", "Fun Swim", "Training", "Other"];
const AUDIENCES = ["Swimmers", "Nutritionists", "Doctors", "Parents", "Coaches", "Other"];

export default function App() {
    const [notification, setNotification] = useState(null);
    const [loading, setLoading] = useState(false);

    // حالة النموذج لإنشاء الفعالية (مطابقة تماماً لما يراه المستخدم)
    const [form, setForm] = useState({
        name: '',
        type: 'Championship',
        description: '',
        date: '',
        time: '',
        duration_value: '',
        duration_unit: 'hours',
        tickets: '',
        location_name: '',
        location_url: '',
        price: '',
        age_range: '',
        target_audience: 'Swimmers',
        video_url: '' // رابط نصي فقط
    });

    // --- أدوات مساعدة ---
    const showNotify = (msg, type = 'success') => {
        setNotification({ msg, type });
        setTimeout(() => setNotification(null), 3000);
    };

    const handleSubmit = (e) => {
        e.preventDefault();
        
        // التحقق من صحة البيانات الأساسية
        if (!form.name || !form.price || !form.location_name || !form.tickets) {
            showNotify("Please fill in all required fields.", "error");
            return;
        }

        setLoading(true);
        // محاكاة عملية الحفظ
        setTimeout(() => {
            setLoading(false);
            showNotify("Event Published Successfully!");
            console.log("Event Data Published:", form);
            // إعادة ضبط النموذج
            setForm({
                name: '', type: 'Championship', description: '', date: '', time: '',
                duration_value: '', duration_unit: 'hours', tickets: '',
                location_name: '', location_url: '', price: '', age_range: '',
                target_audience: 'Swimmers', video_url: ''
            });
        }, 1500);
    };

    return (
        <div className="max-w-md mx-auto min-h-screen bg-[#F8FAFC] font-sans text-gray-900 pb-12">
            
            {/* Header */}
            <header className="px-6 pt-12 pb-6 bg-white border-b border-gray-100 sticky top-0 z-30">
                <div className="flex items-center justify-between text-left">
                    <div className="flex items-center space-x-3">
                        <div className="p-2.5 bg-blue-600 rounded-2xl text-white shadow-lg shadow-blue-100">
                            <Plus className="w-6 h-6" />
                        </div>
                        <div>
                            <h1 className="text-2xl font-black tracking-tight">Post Event</h1>
                            <p className="text-[10px] font-bold text-gray-400 uppercase tracking-widest mt-0.5">New Listing</p>
                        </div>
                    </div>
                    <button onClick={() => window.history.back()} className="p-2 text-gray-400 active:scale-90 transition-transform">
                        <X className="w-6 h-6" />
                    </button>
                </div>
            </header>

            <main className="p-6 space-y-6 animate-in">
                <form onSubmit={handleSubmit} className="space-y-6">
                    
                    {/* 1. Event Details & Media Section */}
                    <div className="bg-white p-6 rounded-[32px] shadow-sm border border-gray-100 space-y-5 text-left">
                        <div className="flex items-center space-x-2 mb-2">
                            <Layout className="w-4 h-4 text-blue-600" />
                            <h3 className="text-xs font-black text-gray-400 uppercase tracking-widest">Details & Media</h3>
                        </div>

                        <div className="space-y-4">
                            <div>
                                <label className="text-[10px] font-black text-gray-400 uppercase ml-1">Event Name</label>
                                <input 
                                    type="text" 
                                    required
                                    placeholder="e.g. Regional Championship 2026" 
                                    value={form.name} 
                                    onChange={e => setForm({...form, name: e.target.value})}
                                    className="w-full mt-1.5 p-4 bg-gray-50 border-none rounded-2xl text-sm font-bold focus:ring-2 focus:ring-blue-500 outline-none" 
                                />
                            </div>

                            <div>
                                <label className="text-[10px] font-black text-gray-400 uppercase ml-1">Event Type</label>
                                <div className="relative">
                                    <select 
                                        value={form.type} 
                                        onChange={e => setForm({...form, type: e.target.value})}
                                        className="w-full mt-1.5 p-4 bg-gray-50 border-none rounded-2xl text-sm font-bold outline-none appearance-none cursor-pointer"
                                    >
                                        {EVENT_TYPES.map(t => <option key={t} value={t}>{t}</option>)}
                                    </select>
                                    <ChevronDown className="absolute right-4 top-1/2 -translate-y-1/2 w-4 h-4 text-gray-400 pointer-events-none" />
                                </div>
                            </div>

                            <div>
                                <label className="text-[10px] font-black text-gray-400 uppercase ml-1">Cover Photo</label>
                                <div className="p-8 bg-gray-50 rounded-[24px] flex flex-col items-center justify-center border-2 border-dashed border-gray-200 text-gray-400 cursor-pointer hover:bg-blue-50 transition-colors mt-1.5">
                                    <Camera className="w-8 h-8 mb-2 text-blue-500" />
                                    <span className="text-[10px] font-black uppercase">Upload Image</span>
                                </div>
                            </div>

                            <div>
                                <label className="text-[10px] font-black text-gray-400 uppercase ml-1">Promo Video URL</label>
                                <div className="relative">
                                    <Video className="absolute left-4 top-1/2 -translate-y-1/2 w-4 h-4 text-gray-300" />
                                    <input 
                                        type="url" 
                                        placeholder="Paste YouTube or Vimeo link..." 
                                        value={form.video_url} 
                                        onChange={e => setForm({...form, video_url: e.target.value})}
                                        className="w-full mt-1.5 pl-11 p-4 bg-gray-50 border-none rounded-2xl text-sm font-bold focus:ring-2 focus:ring-blue-500 outline-none" 
                                    />
                                </div>
                            </div>

                            <div>
                                <label className="text-[10px] font-black text-gray-400 uppercase ml-1">Detailed Description</label>
                                <textarea 
                                    required
                                    placeholder="Outline the schedule, importance, and requirements..." 
                                    rows="4" 
                                    value={form.description} 
                                    onChange={e => setForm({...form, description: e.target.value})}
                                    className="w-full mt-1.5 p-4 bg-gray-50 border-none rounded-2xl text-sm font-bold resize-none focus:ring-2 focus:ring-blue-500 outline-none" 
                                />
                            </div>
                        </div>
                    </div>

                    {/* 2. Time, Location & Capacity Section */}
                    <div className="bg-white p-6 rounded-[32px] shadow-sm border border-gray-100 space-y-6 text-left">
                        <div className="flex items-center space-x-2 mb-2">
                            <Clock className="w-4 h-4 text-blue-600" />
                            <h3 className="text-xs font-black text-gray-400 uppercase tracking-widest">Time & Location</h3>
                        </div>

                        <div className="space-y-4">
                            <div className="grid grid-cols-2 gap-4">
                                <div>
                                    <label className="text-[10px] font-black text-gray-400 uppercase ml-1">Event Date</label>
                                    <input type="date" required value={form.date} onChange={e => setForm({...form, date: e.target.value})} className="w-full mt-1.5 p-4 bg-gray-50 border-none rounded-2xl text-sm font-bold outline-none" />
                                </div>
                                <div>
                                    <label className="text-[10px] font-black text-gray-400 uppercase ml-1">Start Time</label>
                                    <input type="time" required value={form.time} onChange={e => setForm({...form, time: e.target.value})} className="w-full mt-1.5 p-4 bg-gray-50 border-none rounded-2xl text-sm font-bold outline-none" />
                                </div>
                            </div>

                            <div className="grid grid-cols-2 gap-4">
                                <div>
                                    <label className="text-[10px] font-black text-gray-400 uppercase ml-1">Duration</label>
                                    <div className="flex mt-1.5 bg-gray-50 rounded-2xl overflow-hidden">
                                        <input type="number" required placeholder="3" value={form.duration_value} onChange={e => setForm({...form, duration_value: e.target.value})} className="w-2/3 p-4 bg-transparent border-none text-sm font-bold outline-none" />
                                        <select value={form.duration_unit} onChange={e => setForm({...form, duration_unit: e.target.value})} className="w-1/3 bg-gray-100 p-2 text-[10px] font-black uppercase outline-none">
                                            <option value="hours">Hrs</option>
                                            <option value="days">Days</option>
                                            <option value="mins">Mins</option>
                                        </select>
                                    </div>
                                </div>
                                <div>
                                    <label className="text-[10px] font-black text-gray-400 uppercase ml-1">Total Seats</label>
                                    <div className="relative mt-1.5">
                                        <Layers className="absolute left-4 top-1/2 -translate-y-1/2 w-4 h-4 text-gray-300" />
                                        <input type="number" required placeholder="100" value={form.tickets} onChange={e => setForm({...form, tickets: e.target.value})} className="w-full pl-11 p-4 bg-gray-50 border-none rounded-2xl text-sm font-bold outline-none" />
                                    </div>
                                </div>
                            </div>

                            <div>
                                <label className="text-[10px] font-black text-gray-400 uppercase ml-1">Venue Name</label>
                                <input type="text" required placeholder="e.g. Central Pool (NYC)" value={form.location_name} onChange={e => setForm({...form, location_name: e.target.value})} className="w-full mt-1.5 p-4 bg-gray-50 border-none rounded-2xl text-sm font-bold focus:ring-2 focus:ring-blue-500 outline-none" />
                            </div>

                            <div>
                                <label className="text-[10px] font-black text-gray-400 uppercase ml-1">Google Maps URL (Venue)</label>
                                <div className="relative mt-1.5">
                                    <Navigation className="absolute left-4 top-1/2 -translate-y-1/2 w-4 h-4 text-gray-300" />
                                    <input type="url" required placeholder="https://maps.app.goo.gl/..." value={form.location_url} onChange={e => setForm({...form, location_url: e.target.value})} className="w-full pl-11 p-4 bg-gray-50 border-none rounded-2xl text-sm font-bold focus:ring-2 focus:ring-blue-500 outline-none" />
                                </div>
                            </div>
                        </div>
                    </div>

                    {/* 3. Audience & Pricing Section */}
                    <div className="bg-white p-6 rounded-[32px] shadow-sm border border-gray-100 space-y-4 text-left">
                        <div className="flex items-center space-x-2 mb-2">
                            <Tag className="w-4 h-4 text-blue-600" />
                            <h3 className="text-xs font-black text-gray-400 uppercase tracking-widest">Audience & Price</h3>
                        </div>
                        
                        <div className="grid grid-cols-2 gap-4">
                            <div>
                                <label className="text-[10px] font-black text-gray-400 uppercase ml-1">Ticket Price ($)</label>
                                <div className="relative mt-1.5">
                                    <DollarSign className="absolute left-4 top-1/2 -translate-y-1/2 w-4 h-4 text-blue-600" />
                                    <input type="number" required min="0" step="0.01" placeholder="45.00" value={form.price} onChange={e => setForm({...form, price: e.target.value})} className="w-full pl-11 p-4 bg-gray-50 border-none rounded-2xl text-sm font-bold outline-none" />
                                </div>
                            </div>
                            <div>
                                <label className="text-[10px] font-black text-gray-400 uppercase ml-1">Age Range</label>
                                <input type="text" placeholder="e.g. 12-18 or All Ages" value={form.age_range} onChange={e => setForm({...form, age_range: e.target.value})} className="w-full mt-1.5 p-4 bg-gray-50 border-none rounded-2xl text-sm font-bold outline-none" />
                            </div>
                        </div>

                        <div>
                            <label className="text-[10px] font-black text-gray-400 uppercase ml-1">Primary Audience</label>
                            <div className="relative mt-1.5">
                                <Users className="absolute left-4 top-1/2 -translate-y-1/2 w-4 h-4 text-gray-300" />
                                <select 
                                    value={form.target_audience} 
                                    onChange={e => setForm({...form, target_audience: e.target.value})}
                                    className="w-full pl-11 p-4 bg-gray-50 border-none rounded-2xl text-sm font-bold outline-none appearance-none cursor-pointer"
                                >
                                    {AUDIENCES.map(a => <option key={a} value={a}>{a}</option>)}
                                </select>
                                <ChevronDown className="absolute right-4 top-1/2 -translate-y-1/2 w-4 h-4 text-gray-400 pointer-events-none" />
                            </div>
                        </div>
                    </div>

                    {/* Submit Button */}
                    <div className="pt-4">
                        <button 
                            type="submit" 
                            disabled={loading}
                            className={`w-full py-5 bg-rose-600 text-white rounded-[24px] font-black text-sm shadow-xl active:scale-95 transition-all uppercase tracking-[0.2em] ${loading ? 'opacity-50 cursor-not-allowed' : 'hover:brightness-110 shadow-rose-100'}`}
                        >
                            {loading ? 'Publishing...' : 'Publish Event'}
                        </button>
                    </div>
                </form>
            </main>

            {/* نظام التنبيهات */}
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
                .line-clamp-2 { display: -webkit-box; -webkit-line-clamp: 2; -webkit-box-orient: vertical; overflow: hidden; }
            `}</style>
        </div>
    );
}