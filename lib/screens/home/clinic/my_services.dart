import React, { useState, useMemo } from 'react';
import { 
  Plus, Search, Edit3, ArrowLeft, X, 
  Check, CheckCircle, AlertCircle, Layers, 
  ClipboardList, DollarSign, Clock, Video,
  Trash2, Image as ImageIcon, Briefcase,
  ChevronRight // تم إضافة الأيقونة المفقودة هنا
} from 'lucide-react';

// --- DATA DEFINITIONS ---
const CATEGORIES = ["Rehabilitation", "Assessment", "Recovery", "Manual Therapy", "Other"];

const INITIAL_SERVICES = [
    { id: 's1', title: 'Initial Assessment & Diagnosis', category: 'Assessment', price: 95.00, duration: '60 min', photo_url: 'https://placehold.co/100x100/3B82F6/ffffff?text=A', description: 'Comprehensive physical and functional assessment to identify the root cause of pain.' },
    { id: 's2', title: 'Post-Injury Rehabilitation', category: 'Rehabilitation', price: 80.00, duration: '45 min', photo_url: 'https://placehold.co/100x100/10B981/ffffff?text=R', description: 'Focused sessions to restore strength and mobility after sports injuries.' },
    { id: 's3', title: 'Manual Therapy & Adjustment', category: 'Manual Therapy', price: 120.00, duration: '60 min', photo_url: 'https://placehold.co/100x100/F97316/ffffff?text=M', description: 'Hands-on techniques for joint and soft tissue mobilization.' }
];

export default function App() {
    const [services, setServices] = useState(INITIAL_SERVICES);
    const [view, setView] = useState('list'); // 'list', 'add', 'edit'
    const [editingService, setEditingService] = useState(null);
    const [searchTerm, setSearchTerm] = useState('');
    const [notification, setNotification] = useState(null);
    
    // تم إضافة حالة loading لتجنب أخطاء المراجع في حال وجود عمليات برمجية سابقة تعتمد عليها
    const [loading, setLoading] = useState(false);

    // --- UTILITIES ---
    const showNotify = (msg, type = 'success') => {
        setNotification({ msg, type });
        setTimeout(() => setNotification(null), 3000);
    };

    const filteredServices = useMemo(() => {
        return services.filter(s => 
            s.title.toLowerCase().includes(searchTerm.toLowerCase()) || 
            s.category.toLowerCase().includes(searchTerm.toLowerCase())
        ).sort((a, b) => a.title.localeCompare(b.title));
    }, [services, searchTerm]);

    const handleAddClick = () => {
        setEditingService({
            title: '',
            category: 'Rehabilitation',
            price: '',
            duration: '60 min',
            description: '',
            video_url: '',
            photo_url: 'https://placehold.co/100x100/2563eb/ffffff?text=+'
        });
        setView('add');
    };

    const handleEditClick = (service) => {
        setEditingService({ ...service });
        setView('edit');
    };

    const handleSave = (e) => {
        e.preventDefault();
        if (!editingService.title || !editingService.price || !editingService.description) {
            showNotify("Please fill in all required fields", "error");
            return;
        }

        if (view === 'add') {
            const newService = { ...editingService, id: 's' + (services.length + 1) };
            setServices([...services, newService]);
            showNotify("Service created successfully!");
        } else {
            setServices(services.map(s => s.id === editingService.id ? editingService : s));
            showNotify("Service updated successfully!");
        }
        setView('list');
    };

    // --- VIEW RENDERERS ---

    const renderList = () => (
        <div className="p-6 space-y-8 animate-in text-left">
            <header className="space-y-1">
                <h1 className="text-3xl font-black text-gray-900 tracking-tight">My Services</h1>
                <p className="text-sm text-gray-400 font-medium">Manage treatments and programs</p>
            </header>

            {/* Add Service Banner */}
            <button 
                onClick={handleAddClick}
                className="w-full p-4 bg-emerald-500 rounded-[24px] shadow-lg shadow-emerald-100 flex items-center justify-between group active:scale-[0.98] transition-all"
            >
                <div className="flex items-center space-x-3 text-white">
                    <div className="p-2 bg-white/20 rounded-xl">
                        <Plus className="w-6 h-6" />
                    </div>
                    <span className="font-black uppercase text-sm tracking-widest">Add New Service</span>
                </div>
                <ChevronRight className="w-5 h-5 text-white/60 group-hover:translate-x-1 transition-transform" />
            </button>

            {/* Search Bar */}
            <div className="relative">
                <Search className="absolute left-4 top-1/2 -translate-y-1/2 w-5 h-5 text-gray-400" />
                <input 
                    type="text" 
                    placeholder="Search treatments..." 
                    value={searchTerm}
                    onChange={(e) => setSearchTerm(e.target.value)}
                    className="w-full pl-12 pr-4 py-4 bg-white border border-gray-100 rounded-2xl text-sm font-bold shadow-sm focus:ring-2 focus:ring-blue-500 outline-none" 
                />
            </div>

            {/* Services List */}
            <div className="space-y-4 pb-20">
                {filteredServices.map(service => (
                    <div key={service.id} className="bg-white rounded-[32px] border border-gray-100 shadow-sm p-4 flex items-center space-x-4 hover:shadow-md transition-all">
                        <div className="w-20 h-20 rounded-2xl bg-gray-50 overflow-hidden flex-shrink-0 border border-gray-50">
                            <img src={service.photo_url} className="w-full h-full object-cover" alt="service" />
                        </div>
                        <div className="flex-grow min-w-0">
                            <h3 className="text-lg font-black text-gray-900 truncate leading-tight">{service.title}</h3>
                            <p className="text-[10px] text-blue-600 font-bold uppercase tracking-widest mt-1">{service.category}</p>
                            <div className="flex items-center space-x-3 mt-2">
                                <span className="text-sm font-black text-emerald-600">${service.price.toFixed(2)}</span>
                                <span className="text-gray-300">|</span>
                                <span className="text-[10px] text-gray-400 font-bold uppercase">{service.duration}</span>
                            </div>
                        </div>
                        <button 
                            onClick={() => handleEditClick(service)}
                            className="p-3 bg-blue-50 text-blue-600 rounded-2xl hover:bg-blue-600 hover:text-white transition-all shadow-sm"
                        >
                            <Edit3 className="w-5 h-5" />
                        </button>
                    </div>
                ))}
                {filteredServices.length === 0 && (
                    <div className="py-20 text-center text-gray-400 italic">
                        No services found...
                    </div>
                )}
            </div>
        </div>
    );

    const renderForm = () => (
        <div className="animate-in flex flex-col min-h-screen pb-12 text-left">
            <header className="px-6 pt-12 pb-6 bg-white border-b border-gray-100 sticky top-0 z-30 flex items-center justify-between">
                <div className="flex items-center space-x-4">
                    <button onClick={() => setView('list')} className="p-2.5 bg-gray-50 rounded-2xl text-gray-500 active:scale-90 transition-transform">
                        <ArrowLeft className="w-6 h-6" />
                    </button>
                    <h1 className="text-2xl font-black tracking-tight leading-tight">{view === 'add' ? 'New Service' : 'Edit Service'}</h1>
                </div>
                <button 
                    onClick={handleSave}
                    className="px-6 py-3 bg-blue-600 text-white rounded-2xl font-black text-xs uppercase tracking-widest shadow-xl shadow-blue-100 active:scale-95 transition-all"
                >
                    Save
                </button>
            </header>

            <main className="p-6 space-y-6">
                {/* 1. Basic Info */}
                <div className="bg-white p-6 rounded-[32px] shadow-sm border border-gray-100 space-y-5">
                    <div className="flex items-center space-x-2">
                        <ClipboardList className="w-4 h-4 text-blue-600" />
                        <h3 className="text-[10px] font-black text-gray-400 uppercase tracking-widest">Service Details</h3>
                    </div>
                    <div className="space-y-4">
                        <div>
                            <label className="text-[10px] font-black text-gray-400 uppercase ml-1">Service Name</label>
                            <input type="text" value={editingService?.title || ''} onChange={e => setEditingService({...editingService, title: e.target.value})} placeholder="e.g. Spine Assessment" className="w-full mt-1.5 p-4 bg-gray-50 border-none rounded-2xl text-sm font-bold focus:ring-2 focus:ring-blue-500 outline-none" />
                        </div>
                        <div>
                            <label className="text-[10px] font-black text-gray-400 uppercase ml-1">Category</label>
                            <select value={editingService?.category || 'Rehabilitation'} onChange={e => setEditingService({...editingService, category: e.target.value})} className="w-full mt-1.5 p-4 bg-gray-50 border-none rounded-2xl text-sm font-bold outline-none">
                                {CATEGORIES.map(c => <option key={c} value={c}>{c}</option>)}
                            </select>
                        </div>
                    </div>
                </div>

                {/* 2. Media */}
                <div className="bg-white p-6 rounded-[32px] shadow-sm border border-gray-100 space-y-5">
                    <div className="flex items-center space-x-2">
                        <ImageIcon className="w-4 h-4 text-blue-600" />
                        <h3 className="text-[10px] font-black text-gray-400 uppercase tracking-widest">Media Gallery</h3>
                    </div>
                    <div className="grid grid-cols-2 gap-3">
                        <div className="p-6 bg-gray-50 rounded-[24px] flex flex-col items-center justify-center border-2 border-dashed border-gray-200 text-gray-400 hover:bg-blue-50 transition-colors cursor-pointer">
                            <Plus className="w-6 h-6 mb-1 text-blue-600" />
                            <span className="text-[8px] font-black uppercase text-center">Add Photo</span>
                        </div>
                        <div className="p-6 bg-gray-50 rounded-[24px] flex flex-col items-center justify-center border-2 border-dashed border-gray-200 text-gray-400">
                            <Video className="w-6 h-6 mb-1" />
                            <span className="text-[8px] font-black uppercase">Intro Video</span>
                        </div>
                    </div>
                    {editingService?.id && (
                        <div>
                            <label className="text-[10px] font-black text-gray-400 uppercase ml-1">Intro Video URL (Optional)</label>
                            <input type="url" value={editingService?.video_url || ''} onChange={e => setEditingService({...editingService, video_url: e.target.value})} placeholder="https://youtube.com/..." className="w-full mt-1.5 p-4 bg-gray-50 border-none rounded-2xl text-sm font-bold outline-none" />
                        </div>
                    )}
                </div>

                {/* 3. Pricing & Logistics */}
                <div className="bg-white p-6 rounded-[32px] shadow-sm border border-gray-100 space-y-5">
                    <div className="flex items-center space-x-2">
                        <DollarSign className="w-4 h-4 text-blue-600" />
                        <h3 className="text-[10px] font-black text-gray-400 uppercase tracking-widest">Pricing & Time</h3>
                    </div>
                    <div className="grid grid-cols-2 gap-4">
                        <div>
                            <label className="text-[10px] font-black text-gray-400 uppercase ml-1">Price ($)</label>
                            <input type="number" value={editingService?.price || 0} onChange={e => setEditingService({...editingService, price: parseFloat(e.target.value) || 0})} className="w-full mt-1.5 p-4 bg-gray-50 border-none rounded-2xl text-sm font-bold outline-none" />
                        </div>
                        <div>
                            <label className="text-[10px] font-black text-gray-400 uppercase ml-1">Duration</label>
                            <input type="text" value={editingService?.duration || ''} onChange={e => setEditingService({...editingService, duration: e.target.value})} placeholder="e.g. 60 min" className="w-full mt-1.5 p-4 bg-gray-50 border-none rounded-2xl text-sm font-bold outline-none" />
                        </div>
                    </div>
                </div>

                {/* 4. Description */}
                <div className="bg-white p-6 rounded-[32px] shadow-sm border border-gray-100 space-y-4">
                    <div className="flex items-center space-x-2">
                        <Briefcase className="w-4 h-4 text-blue-600" />
                        <h3 className="text-[10px] font-black text-gray-400 uppercase tracking-widest">Description</h3>
                    </div>
                    <textarea value={editingService?.description || ''} onChange={e => setEditingService({...editingService, description: e.target.value})} rows="4" placeholder="Describe the treatment benefits and process..." className="w-full p-4 bg-gray-50 border-none rounded-2xl text-sm font-bold resize-none focus:ring-2 focus:ring-blue-500 outline-none" />
                </div>
            </main>
        </div>
    );

    if (loading) return <div className="min-h-screen flex items-center justify-center bg-white font-black text-blue-600 animate-pulse">SWIM 360...</div>;

    return (
        <div className="max-w-md mx-auto min-h-screen bg-[#F8FAFC] font-sans text-gray-900 relative">
            {view === 'list' && renderList()}
            {(view === 'add' || view === 'edit') && renderForm()}

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