import React, { useState, useEffect, useRef } from 'react';
import { 
  Plus, MapPin, Phone, Clock, Truck, 
  ChevronDown, Check, X, ArrowLeft, 
  Building2, Navigation, Smartphone,
  CheckCircle, AlertCircle, Edit3, Globe
} from 'lucide-react';

// --- DATA DEFINITIONS ---
const GOVERNORATES = ["Cairo", "Giza", "Alexandria", "Dakahlia", "Red Sea", "Beheira", "Fayoum", "Gharbia", "Ismailia", "Luxor", "Matrouh", "Minya", "Monufia", "New Valley", "North Sinai", "Port Said", "Qalyubia", "Qena", "Sharqia", "Sohag", "South Sinai", "Suez"];

const DELIVERY_OPTIONS = [
    { id: 'pickup-only', label: 'Pickup Only' },
    { id: 'governorate-delivery', label: 'Governorate Delivery' },
    { id: 'national-delivery', label: 'National Delivery' },
    { id: 'international-delivery', label: 'International Delivery' }
];

// --- MOCK DATA ---
const INITIAL_BRANCHES = [
    { 
        id: 'b1', 
        location_name: 'Al Malaz Store', 
        governorate: 'Cairo',
        city: 'Nasr City', 
        location_url: 'https://maps.google.com/malaz',
        branch_phone: '+201001234567',
        opening_hour: '08', opening_minute: '00', opening_ampm: 'AM',
        closing_hour: '05', closing_minute: '00', closing_ampm: 'PM',
        delivery_options: ['pickup-only', 'governorate-delivery'] 
    },
    { 
        id: 'b2', 
        location_name: 'Red Sea Mall Branch', 
        governorate: 'Red Sea',
        city: 'Hurghada', 
        location_url: 'https://maps.google.com/redsea',
        branch_phone: '+201119998888',
        opening_hour: '10', opening_minute: '00', opening_ampm: 'AM',
        closing_hour: '10', closing_minute: '00', closing_ampm: 'PM',
        delivery_options: ['pickup-only', 'national-delivery'] 
    }
];

export default function App() {
    const [branches, setBranches] = useState(INITIAL_BRANCHES);
    const [view, setView] = useState('list'); // 'list' or 'edit'
    const [editingBranch, setEditingBranch] = useState(null);
    const [notification, setNotification] = useState(null);
    const [loading, setLoading] = useState(false);

    // --- UTILITIES ---
    const showNotify = (msg, type = 'success') => {
        setNotification({ msg, type });
        setTimeout(() => setNotification(null), 3000);
    };

    const handleEditClick = (branch) => {
        setEditingBranch({ ...branch });
        setView('edit');
    };

    const toggleDeliveryOption = (optionId) => {
        setEditingBranch(prev => {
            const currentOptions = prev.delivery_options || [];
            const newOptions = currentOptions.includes(optionId)
                ? currentOptions.filter(id => id !== optionId)
                : [...currentOptions, optionId];
            return { ...prev, delivery_options: newOptions };
        });
    };

    const handleSave = (e) => {
        e.preventDefault();
        // Simple time validation logic
        const openTotal = (parseInt(editingBranch.opening_hour) % 12 + (editingBranch.opening_ampm === 'PM' ? 12 : 0)) * 60 + parseInt(editingBranch.opening_minute);
        const closeTotal = (parseInt(editingBranch.closing_hour) % 12 + (editingBranch.closing_ampm === 'PM' ? 12 : 0)) * 60 + parseInt(editingBranch.closing_minute);

        if (closeTotal <= openTotal) {
            showNotify("Closing time must be after opening time", "error");
            return;
        }

        if (editingBranch.delivery_options.length === 0) {
            showNotify("Please select at least one delivery option", "error");
            return;
        }

        setLoading(true);
        setTimeout(() => {
            setBranches(prev => prev.map(b => b.id === editingBranch.id ? editingBranch : b));
            setLoading(false);
            showNotify("Branch updated successfully!");
            setView('list');
        }, 1000);
    };

    // --- COMPONENTS ---

    const TimeSelector = ({ label, prefix }) => (
        <div className="space-y-2">
            <label className="text-[10px] font-black text-gray-400 uppercase ml-1">{label}</label>
            <div className="flex space-x-2">
                <select 
                    value={editingBranch[`${prefix}_hour`]} 
                    onChange={e => setEditingBranch({...editingBranch, [`${prefix}_hour`]: e.target.value})}
                    className="flex-1 p-3 bg-gray-50 border-none rounded-xl text-xs font-bold outline-none focus:ring-2 focus:ring-blue-500"
                >
                    {Array.from({length: 12}, (_, i) => String(i + 1).padStart(2, '0')).map(h => <option key={h} value={h}>{h}</option>)}
                </select>
                <select 
                    value={editingBranch[`${prefix}_minute`]} 
                    onChange={e => setEditingBranch({...editingBranch, [`${prefix}_minute`]: e.target.value})}
                    className="flex-1 p-3 bg-gray-50 border-none rounded-xl text-xs font-bold outline-none focus:ring-2 focus:ring-blue-500"
                >
                    {["00", "15", "30", "45"].map(m => <option key={m} value={m}>{m}</option>)}
                </select>
                <select 
                    value={editingBranch[`${prefix}_ampm`]} 
                    onChange={e => setEditingBranch({...editingBranch, [`${prefix}_ampm`]: e.target.value})}
                    className="w-16 p-3 bg-gray-50 border-none rounded-xl text-xs font-bold outline-none focus:ring-2 focus:ring-blue-500"
                >
                    <option value="AM">AM</option>
                    <option value="PM">PM</option>
                </select>
            </div>
        </div>
    );

    const renderList = () => (
        <div className="p-6 space-y-8 animate-in text-left">
            <div className="space-y-1">
                <h1 className="text-3xl font-black text-gray-900 tracking-tight">My Branches</h1>
                <p className="text-sm text-gray-400 font-medium">Manage and monitor your retail outlets</p>
            </div>

            <div className="space-y-4">
                {branches.map(branch => (
                    <div key={branch.id} className="bg-white rounded-[32px] border border-gray-100 shadow-sm p-6 flex items-center justify-between group active:scale-[0.99] transition-all">
                        <div className="flex-grow min-w-0">
                            <h3 className="text-lg font-black text-gray-900 truncate">{branch.location_name}</h3>
                            <p className="text-xs text-blue-600 font-bold uppercase tracking-widest mt-1 flex items-center">
                                <MapPin className="w-3 h-3 mr-1" /> {branch.city}, {branch.governorate}
                            </p>
                            <div className="flex items-center space-x-4 mt-3">
                                <div className="flex items-center text-[10px] text-gray-400 font-bold uppercase tracking-tight">
                                    <Clock className="w-3 h-3 mr-1" /> {branch.opening_hour}:{branch.opening_minute} {branch.opening_ampm} - {branch.closing_hour}:{branch.closing_minute} {branch.closing_ampm}
                                </div>
                                <div className="flex items-center text-[10px] text-gray-400 font-bold uppercase tracking-tight">
                                    <Smartphone className="w-3 h-3 mr-1" /> {branch.branch_phone}
                                </div>
                            </div>
                        </div>
                        <button 
                            onClick={() => handleEditClick(branch)}
                            className="p-3 bg-blue-50 text-blue-600 rounded-2xl hover:bg-blue-600 hover:text-white transition-all shadow-sm flex-shrink-0 ml-4"
                        >
                            <Edit3 className="w-5 h-5" />
                        </button>
                    </div>
                ))}
            </div>
        </div>
    );

    const renderEdit = () => (
        <div className="animate-in flex flex-col min-h-screen pb-12 text-left">
            <header className="px-6 pt-12 pb-6 bg-white border-b border-gray-100 sticky top-0 z-30 flex items-center justify-between">
                <div className="flex items-center space-x-4">
                    <button onClick={() => setView('list')} className="p-2.5 bg-gray-50 rounded-2xl text-gray-500 active:scale-90 transition-transform">
                        <ArrowLeft className="w-6 h-6" />
                    </button>
                    <h1 className="text-2xl font-black tracking-tight leading-tight">Edit Branch</h1>
                </div>
                <button 
                    onClick={handleSave}
                    disabled={loading}
                    className="px-6 py-3 bg-blue-600 text-white rounded-2xl font-black text-xs uppercase tracking-widest shadow-xl shadow-blue-100 active:scale-95 transition-all"
                >
                    {loading ? 'Saving...' : 'Save'}
                </button>
            </header>

            <main className="p-6 space-y-6">
                {/* 1. Location Details */}
                <div className="bg-white p-6 rounded-[32px] shadow-sm border border-gray-100 space-y-5">
                    <div className="flex items-center space-x-2">
                        <Navigation className="w-4 h-4 text-blue-600" />
                        <h3 className="text-[10px] font-black text-gray-400 uppercase tracking-widest">Location Details</h3>
                    </div>
                    <div className="space-y-4">
                        <div>
                            <label className="text-[10px] font-black text-gray-400 uppercase ml-1">Governorate</label>
                            <select 
                                value={editingBranch.governorate} 
                                onChange={e => setEditingBranch({...editingBranch, governorate: e.target.value})}
                                className="w-full mt-1.5 p-4 bg-gray-50 border-none rounded-2xl text-sm font-bold outline-none"
                            >
                                {GOVERNORATES.map(g => <option key={g} value={g}>{g}</option>)}
                            </select>
                        </div>
                        <div>
                            <label className="text-[10px] font-black text-gray-400 uppercase ml-1">City</label>
                            <input type="text" value={editingBranch.city} onChange={e => setEditingBranch({...editingBranch, city: e.target.value})} className="w-full mt-1.5 p-4 bg-gray-50 border-none rounded-2xl text-sm font-bold focus:ring-2 focus:ring-blue-500 outline-none" />
                        </div>
                        <div>
                            <label className="text-[10px] font-black text-gray-400 uppercase ml-1">Store Location Name</label>
                            <input type="text" value={editingBranch.location_name} onChange={e => setEditingBranch({...editingBranch, location_name: e.target.value})} className="w-full mt-1.5 p-4 bg-gray-50 border-none rounded-2xl text-sm font-bold focus:ring-2 focus:ring-blue-500 outline-none" />
                        </div>
                        <div>
                            <label className="text-[10px] font-black text-gray-400 uppercase ml-1">Google Maps URL</label>
                            <input type="url" value={editingBranch.location_url} onChange={e => setEditingBranch({...editingBranch, location_url: e.target.value})} className="w-full mt-1.5 p-4 bg-gray-50 border-none rounded-2xl text-sm font-bold focus:ring-2 focus:ring-blue-500 outline-none" />
                        </div>
                    </div>
                </div>

                {/* 2. Operations */}
                <div className="bg-white p-6 rounded-[32px] shadow-sm border border-gray-100 space-y-6">
                    <div className="flex items-center space-x-2">
                        <Clock className="w-4 h-4 text-blue-600" />
                        <h3 className="text-[10px] font-black text-gray-400 uppercase tracking-widest">Operations</h3>
                    </div>
                    <div className="space-y-5">
                        <div>
                            <label className="text-[10px] font-black text-gray-400 uppercase ml-1">Branch Phone Number</label>
                            <input type="tel" value={editingBranch.branch_phone} onChange={e => setEditingBranch({...editingBranch, branch_phone: e.target.value})} className="w-full mt-1.5 p-4 bg-gray-50 border-none rounded-2xl text-sm font-bold focus:ring-2 focus:ring-blue-500 outline-none" />
                        </div>
                        <div className="grid grid-cols-1 gap-4 pt-2">
                            <TimeSelector label="Opening Time" prefix="opening" />
                            <TimeSelector label="Closing Time" prefix="closing" />
                        </div>
                    </div>
                </div>

                {/* 3. Delivery Options */}
                <div className="bg-white p-6 rounded-[32px] shadow-sm border border-gray-100 space-y-4">
                    <div className="flex items-center space-x-2">
                        <Truck className="w-4 h-4 text-blue-600" />
                        <h3 className="text-[10px] font-black text-gray-400 uppercase tracking-widest">Fulfillment Options</h3>
                    </div>
                    <div className="grid grid-cols-1 gap-2">
                        {DELIVERY_OPTIONS.map(option => {
                            const isSelected = editingBranch.delivery_options.includes(option.id);
                            return (
                                <button 
                                    key={option.id}
                                    type="button"
                                    onClick={() => toggleDeliveryOption(option.id)}
                                    className={`w-full p-4 rounded-2xl flex items-center justify-between transition-all border ${isSelected ? 'bg-blue-50 border-blue-600 ring-2 ring-blue-50' : 'bg-gray-50 border-transparent'}`}
                                >
                                    <span className={`text-sm font-bold ${isSelected ? 'text-blue-700' : 'text-gray-500'}`}>{option.label}</span>
                                    <div className={`w-5 h-5 rounded-full flex items-center justify-center border-2 ${isSelected ? 'bg-blue-600 border-blue-600' : 'border-gray-200 bg-white'}`}>
                                        {isSelected && <Check className="w-3.5 h-3.5 text-white" />}
                                    </div>
                                </button>
                            );
                        })}
                    </div>
                </div>
            </main>
        </div>
    );

    return (
        <div className="max-w-md mx-auto min-h-screen bg-[#F8FAFC] font-sans text-gray-900 relative">
            {view === 'list' && renderList()}
            {view === 'edit' && renderEdit()}

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