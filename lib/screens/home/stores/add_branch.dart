import React, { useState, useEffect, useRef } from 'react';
import { 
  Plus, MapPin, Phone, Clock, Truck, 
  ChevronDown, Check, X, ArrowLeft, 
  Building2, Globe, Navigation, Smartphone,
  CheckCircle, AlertCircle
} from 'lucide-react';

// --- DATA DEFINITIONS ---
const GOVERNORATES = ["Cairo", "Giza", "Alexandria", "Dakahlia", "Red Sea", "Beheira", "Fayoum", "Gharbia", "Ismailia", "Luxor", "Matrouh", "Minya", "Monufia", "New Valley", "North Sinai", "Port Said", "Qalyubia", "Qena", "Sharqia", "Sohag", "South Sinai", "Suez"];

export default function App() {
    const [notification, setNotification] = useState(null);
    const [loading, setLoading] = useState(false);

    // Form State for Branch Registration
    const [form, setForm] = useState({
        governorate: 'Cairo',
        city: '',
        location_name: '',
        location_url: '',
        branch_phone: '',
        opening_hour: '08',
        opening_minute: '00',
        opening_ampm: 'AM',
        closing_hour: '05',
        closing_minute: '00',
        closing_ampm: 'PM',
        delivery_time_range: ''
    });

    // --- UTILITIES ---
    const showNotify = (msg, type = 'success') => {
        setNotification({ msg, type });
        setTimeout(() => setNotification(null), 3000);
    };

    const handleSubmit = (e) => {
        e.preventDefault();
        
        // Basic validation for delivery range pattern (e.g., 3 or 3-5)
        const rangePattern = /^\d+(-\d+)?$/;
        if (!rangePattern.test(form.delivery_time_range)) {
            showNotify("Please enter a valid range (e.g. 3 or 3-5)", "error");
            return;
        }

        if (!form.city || !form.location_name || !form.branch_phone) {
            showNotify("Please fill in all required fields", "error");
            return;
        }

        setLoading(true);
        // Simulate API Call
        setTimeout(() => {
            setLoading(false);
            showNotify("Branch Registered Successfully!");
            // Reset logic or navigation can happen here
        }, 1500);
    };

    const TimeSelector = ({ label, prefix }) => (
        <div className="space-y-2">
            <label className="text-[10px] font-black text-gray-400 uppercase ml-1">{label}</label>
            <div className="flex space-x-2">
                <select 
                    value={form[`${prefix}_hour`]} 
                    onChange={e => setForm({...form, [`${prefix}_hour`]: e.target.value})}
                    className="flex-1 p-3 bg-gray-50 border-none rounded-xl text-xs font-bold outline-none focus:ring-2 focus:ring-blue-500"
                >
                    {Array.from({length: 12}, (_, i) => String(i + 1).padStart(2, '0')).map(h => <option key={h} value={h}>{h}</option>)}
                </select>
                <select 
                    value={form[`${prefix}_minute`]} 
                    onChange={e => setForm({...form, [`${prefix}_minute`]: e.target.value})}
                    className="flex-1 p-3 bg-gray-50 border-none rounded-xl text-xs font-bold outline-none focus:ring-2 focus:ring-blue-500"
                >
                    {["00", "15", "30", "45"].map(m => <option key={m} value={m}>{m}</option>)}
                </select>
                <select 
                    value={form[`${prefix}_ampm`]} 
                    onChange={e => setForm({...form, [`${prefix}_ampm`]: e.target.value})}
                    className="w-16 p-3 bg-gray-50 border-none rounded-xl text-xs font-bold outline-none focus:ring-2 focus:ring-blue-500"
                >
                    <option value="AM">AM</option>
                    <option value="PM">PM</option>
                </select>
            </div>
        </div>
    );

    return (
        <div className="max-w-md mx-auto min-h-screen bg-[#F8FAFC] font-sans text-gray-900 pb-12">
            
            {/* Header */}
            <header className="px-6 pt-12 pb-6 bg-white border-b border-gray-100 sticky top-0 z-30">
                <div className="flex items-center justify-between">
                    <div className="flex items-center space-x-3 text-left">
                        <div className="p-2.5 bg-blue-600 rounded-2xl text-white shadow-lg shadow-blue-100">
                            <Building2 className="w-6 h-6" />
                        </div>
                        <div>
                            <h1 className="text-2xl font-black tracking-tight">Register Branch</h1>
                            <p className="text-[10px] font-bold text-gray-400 uppercase tracking-widest mt-0.5">Store Expansion</p>
                        </div>
                    </div>
                    <button onClick={() => window.history.back()} className="p-2 text-gray-400 hover:text-gray-600 transition-colors">
                        <X className="w-6 h-6" />
                    </button>
                </div>
            </header>

            <main className="p-6 space-y-6 animate-in">
                <form onSubmit={handleSubmit} className="space-y-6">
                    
                    {/* 1. Location Information Section */}
                    <div className="bg-white p-6 rounded-[32px] shadow-sm border border-gray-100 space-y-5 text-left">
                        <div className="flex items-center space-x-2 mb-2">
                            <MapPin className="w-4 h-4 text-blue-600" />
                            <h3 className="text-xs font-black text-gray-400 uppercase tracking-widest">Location Details</h3>
                        </div>

                        <div className="space-y-4">
                            <div>
                                <label className="text-[10px] font-black text-gray-400 uppercase ml-1">Governorate</label>
                                <select 
                                    value={form.governorate} 
                                    onChange={e => setForm({...form, governorate: e.target.value})}
                                    className="w-full mt-1.5 p-4 bg-gray-50 border-none rounded-2xl text-sm font-bold focus:ring-2 focus:ring-blue-500 outline-none"
                                >
                                    {GOVERNORATES.map(g => <option key={g} value={g}>{g}</option>)}
                                </select>
                            </div>

                            <div>
                                <label className="text-[10px] font-black text-gray-400 uppercase ml-1">City</label>
                                <input 
                                    type="text" 
                                    required
                                    placeholder="e.g. Maadi or Nasr City" 
                                    value={form.city} 
                                    onChange={e => setForm({...form, city: e.target.value})}
                                    className="w-full mt-1.5 p-4 bg-gray-50 border-none rounded-2xl text-sm font-bold focus:ring-2 focus:ring-blue-500 outline-none" 
                                />
                            </div>

                            <div>
                                <label className="text-[10px] font-black text-gray-400 uppercase ml-1">Store Location Name</label>
                                <input 
                                    type="text" 
                                    required
                                    placeholder="e.g. Red Sea Mall Branch" 
                                    value={form.location_name} 
                                    onChange={e => setForm({...form, location_name: e.target.value})}
                                    className="w-full mt-1.5 p-4 bg-gray-50 border-none rounded-2xl text-sm font-bold focus:ring-2 focus:ring-blue-500 outline-none" 
                                />
                            </div>

                            <div>
                                <label className="text-[10px] font-black text-gray-400 uppercase ml-1">Google Maps URL</label>
                                <div className="relative">
                                    <Navigation className="absolute left-4 top-1/2 -translate-y-1/2 w-4 h-4 text-gray-300" />
                                    <input 
                                        type="url" 
                                        required
                                        placeholder="Paste link here..." 
                                        value={form.location_url} 
                                        onChange={e => setForm({...form, location_url: e.target.value})}
                                        className="w-full pl-11 p-4 bg-gray-50 border-none rounded-2xl text-sm font-bold focus:ring-2 focus:ring-blue-500 outline-none" 
                                    />
                                </div>
                            </div>
                        </div>
                    </div>

                    {/* 2. Contact & Hours Section */}
                    <div className="bg-white p-6 rounded-[32px] shadow-sm border border-gray-100 space-y-6 text-left">
                        <div className="flex items-center space-x-2 mb-2">
                            <Clock className="w-4 h-4 text-blue-600" />
                            <h3 className="text-xs font-black text-gray-400 uppercase tracking-widest">Operations</h3>
                        </div>

                        <div className="space-y-4">
                            <div>
                                <label className="text-[10px] font-black text-gray-400 uppercase ml-1">Branch Phone Number</label>
                                <div className="relative">
                                    <Smartphone className="absolute left-4 top-1/2 -translate-y-1/2 w-4 h-4 text-gray-300" />
                                    <input 
                                        type="tel" 
                                        required
                                        placeholder="+20" 
                                        value={form.branch_phone} 
                                        onChange={e => setForm({...form, branch_phone: e.target.value})}
                                        className="w-full pl-11 p-4 bg-gray-50 border-none rounded-2xl text-sm font-bold focus:ring-2 focus:ring-blue-500 outline-none" 
                                    />
                                </div>
                            </div>

                            <div className="grid grid-cols-1 gap-4 pt-2">
                                <TimeSelector label="Opening Time" prefix="opening" />
                                <TimeSelector label="Closing Time" prefix="closing" />
                            </div>
                        </div>
                    </div>

                    {/* 3. Fulfillment Section */}
                    <div className="bg-white p-6 rounded-[32px] shadow-sm border border-gray-100 space-y-4 text-left">
                        <div className="flex items-center space-x-2 mb-2">
                            <Truck className="w-4 h-4 text-blue-600" />
                            <h3 className="text-xs font-black text-gray-400 uppercase tracking-widest">Fulfillment</h3>
                        </div>
                        
                        <div>
                            <label className="text-[10px] font-black text-gray-400 uppercase ml-1">Delivery Time Range (Days)</label>
                            <input 
                                type="text" 
                                required
                                placeholder="e.g. 3 or 3-5" 
                                value={form.delivery_time_range} 
                                onChange={e => setForm({...form, delivery_time_range: e.target.value})}
                                className="w-full mt-1.5 p-4 bg-gray-50 border-none rounded-2xl text-sm font-bold focus:ring-2 focus:ring-blue-500 outline-none" 
                            />
                            <p className="text-[9px] text-gray-400 font-bold mt-2 px-1">Accepts a single number or a range separated by a hyphen.</p>
                        </div>
                    </div>

                    {/* Submit Button */}
                    <div className="pt-4">
                        <button 
                            type="submit" 
                            disabled={loading}
                            className={`w-full py-5 bg-blue-600 text-white rounded-[24px] font-black text-sm shadow-xl active:scale-95 transition-all uppercase tracking-[0.2em] ${loading ? 'opacity-50 cursor-not-allowed' : 'hover:brightness-110'}`}
                        >
                            {loading ? 'Registering...' : 'Register Branch'}
                        </button>
                    </div>
                </form>
            </main>

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
            `}</style>
        </div>
    );
}