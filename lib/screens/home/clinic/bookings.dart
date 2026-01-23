import React, { useState, useEffect, useMemo, useRef } from 'react';
import { 
  ChevronLeft, Building2, Calendar, X, 
  CheckCircle, AlertCircle, MessageCircle, 
  Smartphone, Clock, User, Trash2, Eye, 
  ChevronRight, ArrowLeft, ArrowRight,
  Activity, Layers, Truck // تم إضافة الأيقونات المفقودة هنا
} from 'lucide-react';

// --- تعريف البيانات التجريبية ---
const MOCK_DATA = {
    branches: [
        { id: 'b1', name: 'Family Park Clinic', beds: 3, open: 8, close: 17, city: 'Riyadh' },
        { id: 'b2', name: 'Jeddah Coastal Center', beds: 2, open: 9, close: 18, city: 'Jeddah' }
    ],
    // مواعيد محجوزة (باللون الأخضر)
    bookedSlots: {
        'b1': {
            '2025-12-01': [ 
                { time: '09:00', bed: 'Bed-2', client: 'Ahmed Sami', age: 30, service: 'Initial Assessment', phone: '0501234567' },
                { time: '14:00', bed: 'Bed-1', client: 'Fatima Khalid', age: 45, service: 'Post-Injury Rehab', phone: '0551122334' }
            ],
            '2025-12-02': [ 
                { time: '16:00', bed: 'Bed-3', client: 'Laila Ali', age: 22, service: 'Hydrotherapy Session', phone: '0559876543' }
            ]
        }
    }
};

export default function App() {
    const [selectedDate, setSelectedDate] = useState(new Date(2025, 11, 1)); 
    const [selectedBranchId, setSelectedBranchId] = useState('b1');
    const [view, setView] = useState('list');
    const [activeModal, setActiveModal] = useState(null); // 'details', 'confirm-cancel'
    const [selectedBooking, setSelectedBooking] = useState(null);
    const [notification, setNotification] = useState(null);
    const [loading, setLoading] = useState(false);

    // --- أدوات مساعدة ---
    const showNotify = (msg, type = 'success') => {
        setNotification({ msg, type });
        setTimeout(() => setNotification(null), 3000);
    };

    const formatDateStr = (date) => {
        const yyyy = date.getFullYear();
        const mm = String(date.getMonth() + 1).padStart(2, '0');
        const dd = String(date.getDate()).padStart(2, '0');
        return `${yyyy}-${mm}-${dd}`;
    };

    const getDisplayDate = (date) => {
        return date.toLocaleDateString('en-US', { weekday: 'short', day: 'numeric', month: 'short', year: 'numeric' });
    };

    const formatTime24to12 = (time24) => {
        const [hr24, min] = time24.split(':');
        let hr = parseInt(hr24);
        const ampm = hr >= 12 ? 'PM' : 'AM';
        hr = hr % 12 || 12;
        return `${String(hr).padStart(2, '0')}:${min} ${ampm}`;
    };

    // --- المنطق البرمجي ---
    const currentBookings = useMemo(() => {
        const dateKey = formatDateStr(selectedDate);
        const branchBookings = MOCK_DATA.bookedSlots[selectedBranchId]?.[dateKey] || [];
        
        // تجميع الحجوزات حسب الوقت
        const grouped = branchBookings.reduce((acc, booking) => {
            if (!acc[booking.time]) acc[booking.time] = [];
            acc[booking.time].push(booking);
            return acc;
        }, {});

        return Object.keys(grouped).sort().map(time => ({
            time,
            bookings: grouped[time]
        }));
    }, [selectedDate, selectedBranchId]);

    const changeDate = (days) => {
        const newDate = new Date(selectedDate);
        newDate.setDate(newDate.getDate() + days);
        setSelectedDate(newDate);
    };

    const handleCancelBooking = () => {
        showNotify(`Booking for ${selectedBooking.client} cancelled successfully`, 'error');
        setActiveModal(null);
        setSelectedBooking(null);
    };

    // --- واجهات العرض ---

    const renderBookingsManagement = () => (
        <div className="p-6 space-y-6 animate-in text-left">
            <header className="space-y-1">
                <h1 className="text-3xl font-black text-gray-900 tracking-tight">Bookings</h1>
                <p className="text-sm text-gray-400 font-medium">Coordinate client sessions and resources</p>
            </header>

            {/* بطاقة اختيار الفرع والتاريخ */}
            <div className="bg-white p-5 rounded-[32px] border border-gray-100 shadow-sm space-y-5">
                <div className="space-y-2">
                    <label className="text-[10px] font-black text-gray-400 uppercase ml-1 block">Active Branch</label>
                    <div className="flex items-center bg-gray-50 rounded-2xl px-4 py-1 border border-transparent focus-within:border-blue-500 transition-all">
                        <Building2 className="w-5 h-5 text-gray-400 mr-3" />
                        <select 
                            value={selectedBranchId}
                            onChange={(e) => setSelectedBranchId(e.target.value)}
                            className="flex-1 bg-transparent py-3.5 text-sm font-bold outline-none"
                        >
                            {MOCK_DATA.branches.map(b => <option key={b.id} value={b.id}>{b.name}</option>)}
                        </select>
                    </div>
                </div>

                <div className="flex items-center justify-between bg-blue-50 rounded-2xl p-2">
                    <button onClick={() => changeDate(-1)} className="p-3 bg-white rounded-xl text-blue-600 shadow-sm active:scale-90 transition-transform">
                        <ArrowLeft className="w-5 h-5" />
                    </button>
                    <div className="text-center">
                        <p className="text-[10px] font-black text-blue-400 uppercase tracking-widest">Schedule for</p>
                        <p className="text-sm font-black text-blue-900">{getDisplayDate(selectedDate)}</p>
                    </div>
                    <button onClick={() => changeDate(1)} className="p-3 bg-white rounded-xl text-blue-600 shadow-sm active:scale-90 transition-transform">
                        <ArrowRight className="w-5 h-5" />
                    </button>
                </div>
            </div>

            {/* قائمة الحجوزات */}
            <div className="space-y-8 pb-20">
                {currentBookings.length > 0 ? (
                    currentBookings.map(group => (
                        <div key={group.time} className="space-y-3">
                            <div className="flex items-center space-x-3 px-2">
                                <div className="h-px bg-gray-100 flex-grow"></div>
                                <span className="text-[10px] font-black text-gray-400 uppercase tracking-[0.2em] whitespace-nowrap">
                                    {formatTime24to12(group.time)}
                                </span>
                                <div className="h-px bg-gray-100 flex-grow"></div>
                            </div>
                            
                            {group.bookings.map((booking, idx) => (
                                <div key={idx} className="bg-white rounded-[28px] border border-gray-100 shadow-sm p-5 flex items-center justify-between border-l-8 border-l-emerald-500 hover:shadow-md transition-all">
                                    <div className="flex-grow min-w-0">
                                        <h3 className="font-black text-gray-900 truncate text-lg">{booking.client}</h3>
                                        <p className="text-[10px] font-bold text-blue-600 uppercase tracking-widest mt-1 flex items-center">
                                            <Activity className="w-3 h-3 mr-1.5" /> {booking.service}
                                        </p>
                                        <div className="flex items-center space-x-3 mt-3 text-[10px] text-gray-400 font-bold uppercase">
                                            <span className="flex items-center"><Layers className="w-3 h-3 mr-1" /> {booking.bed}</span>
                                            <span className="flex items-center"><User className="w-3 h-3 mr-1" /> Age: {booking.age}</span>
                                        </div>
                                    </div>
                                    <button 
                                        onClick={() => { setSelectedBooking(booking); setActiveModal('details'); }}
                                        className="p-3 bg-gray-50 text-blue-600 rounded-2xl hover:bg-blue-600 hover:text-white transition-all shadow-sm flex-shrink-0 ml-4"
                                    >
                                        <Eye className="w-5 h-5" />
                                    </button>
                                </div>
                            ))}
                        </div>
                    ))
                ) : (
                    <div className="py-20 text-center animate-in">
                        <div className="w-20 h-20 bg-gray-50 rounded-[40px] flex items-center justify-center mx-auto mb-4 text-gray-300">
                            <Calendar className="w-10 h-10" />
                        </div>
                        <p className="text-sm font-bold text-gray-400 uppercase tracking-widest">No Bookings Scheduled</p>
                    </div>
                )}
            </div>
        </div>
    );

    const renderModals = () => {
        if (!activeModal || !selectedBooking) return null;

        return (
            <div className="fixed inset-0 z-50 flex items-center justify-center p-6 bg-slate-900/60 backdrop-blur-sm animate-in">
                <div className="bg-white w-full max-w-sm rounded-[40px] p-8 shadow-2xl space-y-6 relative overflow-hidden">
                    <button onClick={() => setActiveModal(null)} className="absolute top-6 right-6 p-2 bg-gray-50 rounded-full text-gray-400"><X className="w-5 h-5" /></button>
                    
                    {activeModal === 'details' && (
                        <div className="space-y-6 text-left">
                            <div className="text-center pb-2">
                                <div className="w-20 h-20 bg-blue-50 text-blue-600 rounded-[30px] flex items-center justify-center mx-auto mb-4">
                                    <User className="w-10 h-10" />
                                </div>
                                <h3 className="text-2xl font-black text-gray-900 tracking-tight">{selectedBooking.client}</h3>
                                <p className="text-sm font-bold text-blue-600 uppercase tracking-widest mt-1">{selectedBooking.service}</p>
                            </div>

                            <div className="p-5 bg-gray-50 rounded-3xl border border-gray-100 space-y-3">
                                <div className="flex justify-between items-center">
                                    <span className="text-[10px] font-black text-gray-400 uppercase">Appointment</span>
                                    <span className="text-xs font-bold text-gray-800">{formatTime24to12(selectedBooking.time)}</span>
                                </div>
                                <div className="flex justify-between items-center">
                                    <span className="text-[10px] font-black text-gray-400 uppercase">Assigned Bed</span>
                                    <span className="text-xs font-bold text-gray-800">{selectedBooking.bed}</span>
                                </div>
                                <div className="flex justify-between items-center">
                                    <span className="text-[10px] font-black text-gray-400 uppercase">Age Group</span>
                                    <span className="text-xs font-bold text-gray-800">{selectedBooking.age} Years</span>
                                </div>
                            </div>

                            <div className="pt-2 space-y-3">
                                <a 
                                    href={`https://wa.me/${selectedBooking.phone.replace('+', '')}`} 
                                    target="_blank" 
                                    className="w-full flex items-center justify-center py-4 bg-[#25D366] text-white rounded-2xl font-black text-sm uppercase tracking-widest shadow-xl active:scale-95 transition-all"
                                >
                                    <MessageCircle className="w-5 h-5 mr-2" /> WhatsApp Chat
                                </a>
                                <button 
                                    onClick={() => setActiveModal('confirm-cancel')}
                                    className="w-full py-4 text-red-500 font-black text-xs uppercase tracking-widest hover:bg-red-50 transition-colors rounded-2xl"
                                >
                                    Cancel Booking
                                </button>
                            </div>
                        </div>
                    )}

                    {activeModal === 'confirm-cancel' && (
                        <div className="space-y-6 text-center py-4">
                            <div className="w-20 h-20 bg-red-50 text-red-600 rounded-[30px] flex items-center justify-center mx-auto">
                                <AlertCircle className="w-10 h-10" />
                            </div>
                            <div className="space-y-2">
                                <h3 className="text-2xl font-black text-gray-900 tracking-tight">Confirm Deletion</h3>
                                <p className="text-sm text-gray-500 px-4">Are you sure you want to cancel the booking for <span className="text-gray-900 font-bold">{selectedBooking.client}</span>?</p>
                            </div>
                            <div className="flex flex-col space-y-3 pt-2">
                                <button onClick={handleCancelBooking} className="w-full py-4 bg-red-600 text-white rounded-2xl font-black text-sm uppercase tracking-widest shadow-xl">Yes, Cancel Booking</button>
                                <button onClick={() => setActiveModal('details')} className="w-full py-4 text-gray-400 font-bold text-sm">Keep Booking</button>
                            </div>
                        </div>
                    )}
                </div>
            </div>
        );
    };

    if (loading) return <div className="min-h-screen flex items-center justify-center bg-white font-black text-blue-600 animate-pulse uppercase tracking-[0.3em]">Swim 360</div>;

    return (
        <div className="max-w-md mx-auto min-h-screen bg-[#F8FAFC] font-sans text-gray-900 relative">
            
            {/* عرض واجهة إدارة الحجوزات */}
            {renderBookingsManagement()}

            {/* عرض النوافذ المنبثقة */}
            {renderModals()}

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