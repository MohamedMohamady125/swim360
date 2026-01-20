import React, { useState, useMemo } from 'react';
import { 
  Bell, ChevronLeft, CheckCheck, Trash2, 
  Package, Trophy, GraduationCap, Hospital, 
  Video, MessageCircle, Clock, MoreHorizontal,
  ChevronRight, Sparkles, Filter, X
} from 'lucide-react';

// --- MOCK DATA: NOTIFICATIONS ---
const INITIAL_NOTIFICATIONS = [
    {
        id: 'n1',
        type: 'order',
        title: 'Order Out for Delivery',
        message: 'Your Pro Racing Goggles are on the way! Estimated arrival by 6:00 PM today.',
        time: '2m ago',
        isRead: false,
        icon: Package,
        color: '#f97316'
    },
    {
        id: 'n2',
        type: 'academy',
        title: 'Academy Class Reminder',
        message: 'Friendly reminder: Your Intermediate Squad session at Fifth Settlement Branch starts in 2 hours.',
        time: '1h ago',
        isRead: false,
        icon: GraduationCap,
        color: '#2563eb'
    },
    {
        id: 'n3',
        type: 'online',
        title: 'New Coaching Content',
        message: 'Coach Michael Thorne just uploaded "Week 4: Advanced Breathing" to your Mastery Program.',
        time: '3h ago',
        isRead: true,
        icon: Video,
        color: '#7c3aed'
    },
    {
        id: 'n4',
        type: 'event',
        title: 'Event Result Published',
        message: 'The official times for the Regional Championship 2026 are now available. Check your placement!',
        time: 'Yesterday',
        isRead: true,
        icon: Trophy,
        color: '#e11d48'
    },
    {
        id: 'n5',
        type: 'clinic',
        title: 'Clinic Recovery Tip',
        message: 'Maximize your hydrotherapy results by staying hydrated. Read Dr. Samy’s new recovery guide.',
        time: '2 days ago',
        isRead: true,
        icon: Hospital,
        color: '#10b981'
    }
];

export default function App() {
    const [notifications, setNotifications] = useState(INITIAL_NOTIFICATIONS);
    const [filter, setFilter] = useState('all');
    const [selectedNotif, setSelectedNotif] = useState(null);

    // --- LOGIC ---

    const filteredNotifs = useMemo(() => {
        if (filter === 'all') return notifications;
        if (filter === 'unread') return notifications.filter(n => !n.isRead);
        if (filter === 'orders') return notifications.filter(n => n.type === 'order');
        if (filter === 'bookings') {
            // Consolidate Academy, Clinic, and Event types into "Bookings"
            return notifications.filter(n => ['academy', 'clinic', 'event'].includes(n.type));
        }
        return notifications;
    }, [notifications, filter]);

    const markAsRead = (id) => {
        setNotifications(notifications.map(n => n.id === id ? { ...n, isRead: true } : n));
        showSnackbar("Marked as read");
    };

    const markAllAsRead = () => {
        setNotifications(notifications.map(n => ({ ...n, isRead: true })));
        showSnackbar("All notifications marked as read");
    };

    const deleteNotif = (id, e) => {
        e.stopPropagation();
        setNotifications(notifications.filter(n => n.id !== id));
        showSnackbar("Notification removed");
    };

    const showSnackbar = (msg) => {
        const sn = document.createElement('div');
        sn.className = "fixed bottom-10 left-1/2 -translate-x-1/2 bg-slate-900 text-white px-8 py-4 rounded-[24px] text-sm font-black shadow-2xl z-[100] animate-bounce";
        sn.textContent = msg;
        document.body.appendChild(sn);
        setTimeout(() => sn.remove(), 2000);
    };

    const unreadCount = notifications.filter(n => !n.isRead).length;

    // --- RENDERERS ---

    const NotificationItem = ({ notif }) => (
        <div 
            onClick={() => { setSelectedNotif(notif); markAsRead(notif.id); }}
            className={`relative p-5 rounded-[28px] border transition-all duration-300 cursor-pointer active:scale-[0.98] flex items-start space-x-4 
            ${notif.isRead ? 'bg-white border-slate-50 opacity-80' : 'bg-white border-blue-100 shadow-lg shadow-blue-50/50 ring-1 ring-blue-50'}`}
        >
            {/* Category Icon */}
            <div className="relative flex-shrink-0">
                <div 
                    className="w-12 h-12 rounded-2xl flex items-center justify-center shadow-inner"
                    style={{ backgroundColor: `${notif.color}15`, color: notif.color }}
                >
                    {React.createElement(notif.icon, { className: "w-6 h-6" })}
                </div>
                {!notif.isRead && (
                    <span className="absolute -top-1 -right-1 w-3.5 h-3.5 bg-blue-600 rounded-full border-2 border-white animate-pulse"></span>
                )}
            </div>

            {/* Content */}
            <div className="flex-grow min-w-0">
                <div className="flex justify-between items-start">
                    <h3 className={`text-sm font-black leading-tight truncate ${notif.isRead ? 'text-slate-600' : 'text-slate-900'}`}>
                        {notif.title}
                    </h3>
                    <span className="text-[9px] font-bold text-slate-400 uppercase tracking-tighter ml-2 whitespace-nowrap pt-0.5">
                        {notif.time}
                    </span>
                </div>
                <p className={`text-xs mt-1.5 leading-relaxed line-clamp-2 ${notif.isRead ? 'text-slate-400 font-medium' : 'text-slate-500 font-semibold'}`}>
                    {notif.message}
                </p>
            </div>

            {/* Delete Simulation */}
            <button 
                onClick={(e) => deleteNotif(notif.id, e)}
                className="p-2 text-slate-200 hover:text-rose-500 transition-colors self-center"
            >
                <Trash2 className="w-4 h-4" />
            </button>
        </div>
    );

    return (
        <div className="max-w-md mx-auto min-h-screen bg-[#FBFDFF] font-sans">
            
            {/* Sticky Header */}
            <header className="px-6 pt-12 pb-6 flex items-center justify-between bg-white/90 backdrop-blur-xl border-b border-slate-50 sticky top-0 z-40">
                <div className="flex items-center space-x-4">
                    <button onClick={() => window.history.back()} className="p-2.5 bg-slate-50 rounded-2xl text-slate-600 active:scale-90 transition-transform">
                        <ChevronLeft className="w-6 h-6" />
                    </button>
                    <div>
                        <h1 className="text-2xl font-black text-slate-900 tracking-tight leading-none">Notifications</h1>
                        {unreadCount > 0 && (
                            <p className="text-[10px] font-black text-blue-600 uppercase tracking-widest mt-1.5">
                                {unreadCount} New Update{unreadCount > 1 ? 's' : ''}
                            </p>
                        )}
                    </div>
                </div>
                <button 
                    onClick={markAllAsRead}
                    className="p-3 bg-blue-50 text-blue-600 rounded-2xl active:scale-95 transition-all"
                    title="Mark all as read"
                >
                    <CheckCheck className="w-6 h-6" />
                </button>
            </header>

            <main className="px-5 py-6">
                
                {/* Simplified Filter Tabs */}
                <div className="flex space-x-2 overflow-x-auto no-scrollbar pb-6">
                    {['all', 'unread', 'bookings', 'orders'].map(f => (
                        <button 
                            key={f}
                            onClick={() => setFilter(f)}
                            className={`px-6 py-2.5 rounded-xl text-[10px] font-black uppercase tracking-widest transition-all whitespace-nowrap
                            ${filter === f ? 'bg-slate-900 text-white shadow-xl' : 'bg-white text-slate-400 border border-slate-100'}`}
                        >
                            {f}
                        </button>
                    ))}
                </div>

                {/* List Container */}
                <div className="space-y-4 pb-10">
                    {filteredNotifs.length > 0 ? (
                        <>
                            <div className="px-1 flex items-center justify-between mb-2">
                                <span className="text-[10px] font-black text-slate-300 uppercase tracking-[0.2em]">Recents</span>
                                <div className="h-px bg-slate-100 flex-grow ml-4"></div>
                            </div>
                            {filteredNotifs.map(notif => (
                                <NotificationItem key={notif.id} notif={notif} />
                            ))}
                        </>
                    ) : (
                        <div className="py-20 text-center animate-in">
                            <div className="w-24 h-24 bg-slate-50 rounded-[40px] flex items-center justify-center mx-auto mb-6 text-slate-200">
                                <Bell className="w-12 h-12" />
                            </div>
                            <h3 className="text-xl font-black text-slate-900">No updates found</h3>
                            <p className="text-sm text-slate-400 font-medium px-10 mt-2">
                                We'll notify you here when there are updates to your {filter !== 'all' ? filter : 'account'}.
                            </p>
                        </div>
                    )}
                </div>
            </main>

            {/* DETAIL MODAL (Bottom Sheet) */}
            {selectedNotif && (
                <div className="fixed inset-0 z-50 flex items-end justify-center px-4 pb-10">
                    <div 
                        className="absolute inset-0 bg-slate-900/60 backdrop-blur-sm transition-opacity duration-300"
                        onClick={() => setSelectedNotif(null)}
                    ></div>
                    <div className="bg-white w-full max-w-sm rounded-t-[40px] p-8 shadow-2xl z-10 animate-in relative overflow-hidden">
                        <div className="absolute -top-10 -right-10 opacity-[0.03] scale-[4]">
                            {React.createElement(selectedNotif.icon)}
                        </div>

                        <div className="flex justify-between items-start mb-8 relative">
                            <div 
                                className="w-16 h-16 rounded-[22px] flex items-center justify-center shadow-lg"
                                style={{ backgroundColor: `${selectedNotif.color}15`, color: selectedNotif.color }}
                            >
                                {React.createElement(selectedNotif.icon, { className: "w-8 h-8" })}
                            </div>
                            <button onClick={() => setSelectedNotif(null)} className="p-2 bg-slate-50 rounded-full text-slate-400">
                                <X className="w-5 h-5" />
                            </button>
                        </div>

                        <div className="space-y-4">
                            <div>
                                <p className="text-[10px] font-black text-blue-600 uppercase tracking-widest mb-2">Notification Detail</p>
                                <h2 className="text-2xl font-black text-slate-900 leading-tight">{selectedNotif.title}</h2>
                            </div>
                            <p className="text-sm text-slate-500 font-medium leading-relaxed">
                                {selectedNotif.message}
                            </p>
                            <div className="flex items-center space-x-2 text-[10px] font-black text-slate-300 uppercase tracking-widest pt-2">
                                <Clock className="w-3.5 h-3.5" />
                                <span>Received {selectedNotif.time}</span>
                            </div>
                        </div>

                        <div className="pt-8 space-y-3">
                            <button 
                                onClick={() => { showSnackbar("Redirecting..."); setSelectedNotif(null); }}
                                className="w-full py-4 bg-slate-900 text-white rounded-[20px] font-black shadow-xl active:scale-95 transition"
                            >
                                View Related Activity
                            </button>
                            <button 
                                onClick={() => setSelectedNotif(null)}
                                className="w-full py-4 text-slate-400 font-bold hover:text-slate-600 transition-colors"
                            >
                                Dismiss
                            </button>
                        </div>
                    </div>
                </div>
            )}

            <style>{`
                @keyframes fadeIn { from { opacity: 0; transform: translateY(20px); } to { opacity: 1; transform: translateY(0); } }
                .animate-in { animation: fadeIn 0.5s cubic-bezier(0.16, 1, 0.3, 1) forwards; }
                .no-scrollbar::-webkit-scrollbar { display: none; }
                .no-scrollbar { -ms-overflow-style: none; scrollbar-width: none; }
                .line-clamp-2 { display: -webkit-box; -webkit-line-clamp: 2; -webkit-box-orient: vertical; overflow: hidden; }
            `}</style>
        </div>
    );
}