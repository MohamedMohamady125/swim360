import React, { useState, useMemo, useEffect } from 'react';
import { 
  ChevronLeft, Building2, Calendar, X, 
  CheckCircle, AlertCircle, MessageCircle, 
  Smartphone, Clock, User, Trash2, Eye, 
  ChevronRight, ArrowLeft, ArrowRight,
  Search, Users, Ticket, Tag, Layout, MoreHorizontal,
  Trophy, FileText, Download // تم إضافة أيقونات إضافية
} from 'lucide-react';

// --- DATA DEFINITIONS ---
const MOCK_DATA = {
    events: [
        { id: 'e1', name: 'Regional Championship 2026', date: 'Jan 23, 2026' },
        { id: 'e2', name: 'Masters Training Clinic', date: 'Dec 01, 2025' },
    ],
    attendees: {
        'e1': [
            { id: 'a1', name: 'Liam Davies', age: 15, phone: '+201001234567', ticket: 'VIP Access', avatar: 'L' },
            { id: 'a2', name: 'Olivia Martinez', age: 40, phone: '+201112223334', ticket: 'General Entry', avatar: 'O' },
            { id: 'a3', name: 'Ethan Wilson', age: 28, phone: '+201223334445', ticket: 'Athlete Pass', avatar: 'E' },
        ],
        'e2': [
            { id: 'a4', name: 'Ava Brown', age: 32, phone: '+201556667778', ticket: 'Clinic Pass', avatar: 'A' },
            { id: 'a5', name: 'Noah Taylor', age: 55, phone: '+201009998887', ticket: 'Coach Pass', avatar: 'N' },
        ]
    }
};

export default function App() {
    const [selectedEventId, setSelectedEventId] = useState('e1');
    const [searchTerm, setSearchTerm] = useState('');
    const [activeModal, setActiveModal] = useState(null); // 'details'
    const [selectedAttendee, setSelectedAttendee] = useState(null);
    const [notification, setNotification] = useState(null);

    // --- PDF EXPORT LOGIC ---
    // Dynamically load jsPDF scripts
    useEffect(() => {
        const script1 = document.createElement("script");
        script1.src = "https://cdnjs.cloudflare.com/ajax/libs/jspdf/2.5.1/jspdf.umd.min.js";
        script1.async = true;
        document.body.appendChild(script1);

        const script2 = document.createElement("script");
        script2.src = "https://cdnjs.cloudflare.com/ajax/libs/jspdf-autotable/3.5.25/jspdf.plugin.autotable.min.js";
        script2.async = true;
        document.body.appendChild(script2);

        return () => {
            document.body.removeChild(script1);
            document.body.removeChild(script2);
        };
    }, []);

    const exportToPDF = () => {
        if (!window.jspdf) {
            showNotify("PDF libraries are still loading. Please wait...", "error");
            return;
        }

        const { jsPDF } = window.jspdf;
        const doc = new jsPDF();
        const event = MOCK_DATA.events.find(e => e.id === selectedEventId);
        const roster = MOCK_DATA.attendees[selectedEventId] || [];

        // Title and Header
        doc.setFontSize(20);
        doc.setTextColor(37, 99, 235); // Blue-600
        doc.text("Swim 360 - Attendee Roster", 14, 22);
        
        doc.setFontSize(12);
        doc.setTextColor(100, 116, 139); // Slate-500
        doc.text(`Event: ${event.name}`, 14, 32);
        doc.text(`Date: ${event.date}`, 14, 38);
        doc.text(`Generated on: ${new Date().toLocaleDateString()}`, 14, 44);

        // Table Data
        const tableColumn = ["ID", "Name", "Age", "Ticket Type", "Phone"];
        const tableRows = roster.map(a => [
            a.id,
            a.name,
            a.age,
            a.ticket,
            a.phone
        ]);

        doc.autoTable({
            head: [tableColumn],
            body: tableRows,
            startY: 55,
            theme: 'striped',
            headStyles: { fillColor: [37, 99, 235], textColor: 255, fontStyle: 'bold' },
            alternateRowStyles: { fillColor: [248, 250, 252] },
            margin: { top: 55 },
        });

        doc.save(`${event.name.replace(/\s+/g, '_')}_Attendees.pdf`);
        showNotify("PDF Downloaded Successfully!");
    };

    // --- UTILITIES ---
    const showNotify = (msg, type = 'success') => {
        setNotification({ msg, type });
        setTimeout(() => setNotification(null), 3000);
    };

    const selectedEvent = useMemo(() => {
        return MOCK_DATA.events.find(e => e.id === selectedEventId);
    }, [selectedEventId]);

    const filteredAttendees = useMemo(() => {
        const roster = MOCK_DATA.attendees[selectedEventId] || [];
        return roster.filter(a => 
            a.name.toLowerCase().includes(searchTerm.toLowerCase())
        );
    }, [selectedEventId, searchTerm]);

    // --- RENDERERS ---

    const renderHeader = () => (
        <header className="bg-white/90 backdrop-blur-md px-6 pt-12 pb-5 flex items-center justify-between sticky top-0 z-30 border-b border-gray-50">
            <div className="flex items-center space-x-4">
                <button onClick={() => window.history.back()} className="p-2.5 rounded-2xl transition-all border bg-white border-gray-100 text-gray-900 shadow-sm active:scale-90 hover:bg-gray-50">
                    <ChevronLeft className="w-6 h-6" />
                </button>
                <div className="text-left">
                    <h1 className="text-2xl font-black text-gray-900 tracking-tight leading-none">Attendees</h1>
                    <p className="text-[10px] font-bold text-gray-400 uppercase tracking-widest mt-1">Roster Management</p>
                </div>
            </div>
            <div className="w-11 h-11 rounded-2xl bg-rose-50 flex items-center justify-center text-rose-600 border border-rose-100 shadow-inner">
                <Trophy className="w-6 h-6" />
            </div>
        </header>
    );

    const renderFilters = () => (
        <div className="bg-white p-6 rounded-[32px] border border-gray-100 shadow-sm space-y-5">
            <div className="space-y-2 text-left">
                <div className="flex justify-between items-end mb-1">
                    <label className="text-[10px] font-black text-gray-400 uppercase ml-1 block tracking-widest">Selected Event</label>
                    {/* DOWNLOAD PDF BUTTON */}
                    <button 
                        onClick={exportToPDF}
                        className="text-[10px] font-black text-blue-600 uppercase tracking-widest hover:underline flex items-center bg-blue-50 px-2 py-1 rounded-lg transition-colors"
                    >
                        <Download className="w-3 h-3 mr-1" /> Download as PDF
                    </button>
                </div>
                <div className="flex items-center bg-gray-50 rounded-2xl px-4 py-1 border border-transparent focus-within:border-rose-500 transition-all">
                    <Trophy className="w-5 h-5 text-gray-400 mr-3" />
                    <select 
                        value={selectedEventId}
                        onChange={(e) => { setSelectedEventId(e.target.value); setSearchTerm(''); }}
                        className="flex-1 bg-transparent py-3.5 text-sm font-bold outline-none appearance-none"
                    >
                        {MOCK_DATA.events.map(e => <option key={e.id} value={e.id}>{e.name}</option>)}
                    </select>
                    <ChevronDown className="w-4 h-4 text-gray-400" />
                </div>
            </div>

            <div className="relative">
                <Search className="absolute left-4 top-1/2 -translate-y-1/2 w-4 h-4 text-gray-400" />
                <input 
                    type="text" 
                    placeholder="Search attendee name..." 
                    value={searchTerm}
                    onChange={(e) => setSearchTerm(e.target.value)}
                    className="w-full pl-11 pr-4 py-4 bg-gray-50 border-none rounded-2xl text-sm font-bold focus:ring-2 focus:ring-rose-500 outline-none"
                />
            </div>
        </div>
    );

    const renderList = () => (
        <div className="space-y-4 pb-20">
            <div className="px-2 flex items-center justify-between">
                <span className="text-[10px] font-black text-gray-300 uppercase tracking-[0.2em]">{filteredAttendees.length} Registered</span>
                <div className="h-px bg-gray-100 flex-grow ml-4"></div>
            </div>

            {filteredAttendees.length > 0 ? (
                filteredAttendees.map(attendee => (
                    <div 
                        key={attendee.id} 
                        className="bg-white rounded-[32px] border border-gray-100 shadow-sm p-4 flex items-center space-x-4 hover:shadow-md transition-all active:scale-[0.99] cursor-pointer"
                        onClick={() => { setSelectedAttendee(attendee); setActiveModal('details'); }}
                    >
                        <div className="w-14 h-14 rounded-2xl bg-rose-50 flex items-center justify-center text-rose-600 font-black text-xl border border-rose-100 shadow-sm">
                            {attendee.avatar}
                        </div>
                        <div className="flex-grow text-left">
                            <h3 className="font-black text-gray-900 leading-tight">{attendee.name}</h3>
                            <div className="flex items-center mt-1 text-[10px] font-bold text-blue-600 uppercase tracking-widest">
                                <Ticket className="w-3 h-3 mr-1.5" /> {attendee.ticket}
                            </div>
                        </div>
                        <div className="p-2.5 bg-gray-50 text-gray-300 rounded-xl group-hover:text-rose-600 transition-colors">
                            <Eye className="w-5 h-5" />
                        </div>
                    </div>
                ))
            ) : (
                <div className="py-20 text-center animate-in">
                    <div className="w-20 h-20 bg-gray-50 rounded-[40px] flex items-center justify-center mx-auto mb-4 text-gray-200 shadow-inner">
                        <Users className="w-10 h-10" />
                    </div>
                    <p className="text-sm font-bold text-gray-400 uppercase tracking-widest">No matching attendees</p>
                </div>
            )}
        </div>
    );

    const renderDetailsModal = () => {
        if (!activeModal || !selectedAttendee) return null;

        return (
            <div className="fixed inset-0 z-50 flex items-end justify-center px-4 pb-10">
                <div 
                    className="absolute inset-0 bg-slate-900/60 backdrop-blur-sm transition-opacity"
                    onClick={() => setActiveModal(null)}
                ></div>
                <div className="bg-white w-full max-w-sm rounded-t-[40px] p-8 shadow-2xl z-10 animate-in relative overflow-hidden">
                    <button onClick={() => setActiveModal(null)} className="absolute top-6 right-6 p-2 bg-gray-50 rounded-full text-gray-400 active:scale-90 transition-transform"><X className="w-5 h-5" /></button>
                    
                    <div className="text-center space-y-2">
                        <div className="w-20 h-20 bg-rose-50 text-rose-600 rounded-[30px] flex items-center justify-center mx-auto mb-4 border border-rose-100 shadow-sm">
                            <User className="w-10 h-10" />
                        </div>
                        <h3 className="text-2xl font-black text-gray-900 tracking-tight leading-none">{selectedAttendee.name}</h3>
                        <p className="text-xs font-bold text-gray-400 uppercase tracking-widest mt-1">{selectedEvent?.name}</p>
                    </div>

                    <div className="p-6 bg-gray-50 rounded-3xl border border-gray-100 space-y-4 text-left shadow-inner mt-6">
                        <div className="flex justify-between items-center">
                            <span className="text-[10px] font-black text-gray-400 uppercase tracking-widest">Age</span>
                            <span className="text-xs font-bold text-gray-800">{selectedAttendee.age} Years</span>
                        </div>
                        <div className="h-px bg-gray-200/50"></div>
                        <div className="flex justify-between items-center">
                            <span className="text-[10px] font-black text-gray-400 uppercase tracking-widest">Ticket Type</span>
                            <span className="text-xs font-bold text-rose-600">{selectedAttendee.ticket}</span>
                        </div>
                    </div>

                    <div className="pt-6 space-y-3">
                        <a 
                            href={`https://wa.me/${selectedAttendee.phone.replace(/\+/g, '')}`} 
                            target="_blank" 
                            rel="noopener noreferrer"
                            className="w-full flex items-center justify-center py-5 bg-[#25D366] text-white rounded-[24px] font-black text-sm uppercase tracking-widest shadow-xl active:scale-95 transition-all shadow-[#25D366]/20"
                        >
                            <MessageCircle className="w-6 h-6 mr-3" /> WhatsApp Chat
                        </a>
                        <button 
                            onClick={() => setActiveModal(null)}
                            className="w-full py-4 text-gray-400 font-bold text-sm hover:text-gray-600 transition-colors"
                        >
                            Dismiss
                        </button>
                    </div>
                </div>
            </div>
        );
    };

    return (
        <div className="max-w-md mx-auto min-h-screen bg-[#F8FAFC] font-sans text-gray-900 relative">
            {renderHeader()}

            <main className="p-6 space-y-6 animate-in">
                {renderFilters()}
                {renderList()}
            </main>

            {renderDetailsModal()}

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

// --- HELPER COMPONENTS ---
function ChevronDown({ className }) {
    return (
        <svg className={className} fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path strokeLinecap="round" strokeLinejoin="round" strokeWidth="2.5" d="M19 9l-7 7-7-7" />
        </svg>
    );
}