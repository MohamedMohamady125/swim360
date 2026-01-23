import React, { useState, useEffect, useMemo, useRef } from 'react';
import { 
  Plus, Calendar, ChevronDown, Check, 
  Building2, X, Info, ArrowLeft, ArrowRight,
  ShieldOff, RotateCcw, CheckCircle, AlertCircle,
  Clock, Layers, MapPin, Activity, ChevronLeft, ChevronRight
} from 'lucide-react';

// --- DATA DEFINITIONS ---
const MOCK_DATA = {
    branches: [
        { id: 'b1', name: 'Family Park Clinic', beds: 3, open: 8, close: 17, city: 'Riyadh' },
        { id: 'b2', name: 'Jeddah Coastal Center', beds: 2, open: 9, close: 18, city: 'Jeddah' }
    ],
    // Initial Admin Blocked Slots (RED)
    blockedSlots: {
        'b1': {
            '2026-01-23': { 'Bed-1': ['10:00', '11:00'], 'Bed-3': ['14:00'] },
            '2026-01-25': { 'Bed-2': ['13:00'] }
        },
    },
    // Client Booked Slots (GREEN) - Usually immutable by Admin here
    bookedSlots: {
        'b1': {
            '2026-01-23': { 'Bed-2': ['09:00'] },
            '2026-01-24': { 'Bed-1': ['16:00'] }
        }
    }
};

export default function App() {
    const [selectedDate, setSelectedDate] = useState(new Date(2026, 0, 23)); 
    const [selectedBranchId, setSelectedBranchId] = useState('b1');
    const [selectedSlots, setSelectedSlots] = useState([]); // Array of {bedId, time}
    const [isDragging, setIsDragging] = useState(false);
    const [dragStartSlot, setDragStartSlot] = useState(null);
    
    // Manage blocked slots in local state for immediate UI feedback
    const [localBlockedSlots, setLocalBlockedSlots] = useState(MOCK_DATA.blockedSlots);
    
    const [notification, setNotification] = useState(null);
    const [loading, setLoading] = useState(false);

    // --- UTILITIES ---
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
        return date.toLocaleDateString('en-US', { weekday: 'short', day: 'numeric', month: 'short' });
    };

    const formatTime24to12 = (hr24) => {
        const hr = parseInt(hr24);
        const ampm = hr >= 12 ? 'PM' : 'AM';
        const displayHr = hr % 12 || 12;
        return `${String(displayHr).padStart(2, '0')}:00 ${ampm}`;
    };

    const timeSlots = useMemo(() => {
        return Array.from({ length: 24 }, (_, i) => `${String(i).padStart(2, '0')}:00`);
    }, []);

    const selectedBranch = useMemo(() => {
        return MOCK_DATA.branches.find(b => b.id === selectedBranchId);
    }, [selectedBranchId]);

    const bedIds = useMemo(() => {
        return Array.from({ length: selectedBranch.beds }, (_, i) => `Bed-${i + 1}`);
    }, [selectedBranch]);

    // --- LOGIC ---
    const changeDate = (date) => {
        setSelectedDate(date);
        setSelectedSlots([]);
    };

    const changeWeek = (direction) => {
        const newDate = new Date(selectedDate);
        newDate.setDate(selectedDate.getDate() + (direction * 7));
        setSelectedDate(newDate);
        setSelectedSlots([]);
    };

    const handleMouseDown = (bedId, time, type) => {
        if (type === 'unavailable' || type === 'booked') return;
        setIsDragging(true);
        setDragStartSlot({ bedId, time });
        setSelectedSlots([{ bedId, time }]);
    };

    const handleMouseEnter = (bedId, time, type) => {
        if (!isDragging || type === 'unavailable' || type === 'booked') return;
        if (bedId !== dragStartSlot.bedId) return;

        const startIdx = timeSlots.indexOf(dragStartSlot.time);
        const currentIdx = timeSlots.indexOf(time);
        const minIdx = Math.min(startIdx, currentIdx);
        const maxIdx = Math.max(startIdx, currentIdx);

        const newSelection = [];
        for (let i = minIdx; i <= maxIdx; i++) {
            const t = timeSlots[i];
            const dateKey = formatDateStr(selectedDate);
            const isBooked = MOCK_DATA.bookedSlots[selectedBranchId]?.[dateKey]?.[bedId]?.includes(t);
            const isOut = i < selectedBranch.open || i >= selectedBranch.close;
            
            if (!isBooked && !isOut) {
                newSelection.push({ bedId, time: t });
            }
        }
        setSelectedSlots(newSelection);
    };

    const handleMouseUp = () => {
        setIsDragging(false);
    };

    // ACTION: BLOCK SLOTS (Turn Red)
    const handleBlock = () => {
        if (selectedSlots.length === 0) return;
        
        const dateKey = formatDateStr(selectedDate);
        const updatedBlocked = { ...localBlockedSlots };
        
        if (!updatedBlocked[selectedBranchId]) updatedBlocked[selectedBranchId] = {};
        if (!updatedBlocked[selectedBranchId][dateKey]) updatedBlocked[selectedBranchId][dateKey] = {};

        selectedSlots.forEach(slot => {
            if (!updatedBlocked[selectedBranchId][dateKey][slot.bedId]) {
                updatedBlocked[selectedBranchId][dateKey][slot.bedId] = [];
            }
            if (!updatedBlocked[selectedBranchId][dateKey][slot.bedId].includes(slot.time)) {
                updatedBlocked[selectedBranchId][dateKey][slot.bedId].push(slot.time);
            }
        });

        setLocalBlockedSlots(updatedBlocked);
        showNotify(`${selectedSlots.length} slots blocked (Red)`, 'error');
        setSelectedSlots([]);
    };

    // ACTION: FREE UP SLOTS (Turn White)
    const handleFree = () => {
        if (selectedSlots.length === 0) return;
        
        const dateKey = formatDateStr(selectedDate);
        const updatedBlocked = { ...localBlockedSlots };
        
        if (updatedBlocked[selectedBranchId] && updatedBlocked[selectedBranchId][dateKey]) {
            selectedSlots.forEach(slot => {
                if (updatedBlocked[selectedBranchId][dateKey][slot.bedId]) {
                    updatedBlocked[selectedBranchId][dateKey][slot.bedId] = 
                        updatedBlocked[selectedBranchId][dateKey][slot.bedId].filter(t => t !== slot.time);
                }
            });
        }

        setLocalBlockedSlots(updatedBlocked);
        showNotify(`${selectedSlots.length} slots freed up (White)`);
        setSelectedSlots([]);
    };

    // --- RENDERERS ---

    const renderDayIterator = () => {
        const days = [];
        const startOfWeek = new Date(selectedDate);
        startOfWeek.setDate(selectedDate.getDate() - selectedDate.getDay()); // Go to Sunday

        for (let i = 0; i < 7; i++) {
            const day = new Date(startOfWeek);
            day.setDate(startOfWeek.getDate() + i);
            const isSelected = formatDateStr(day) === formatDateStr(selectedDate);
            days.push(
                <button 
                    key={i}
                    onClick={() => changeDate(day)}
                    className={`flex-1 flex flex-col items-center py-3 rounded-2xl transition-all duration-300 ${isSelected ? 'bg-blue-600 text-white shadow-lg shadow-blue-100' : 'bg-gray-50 text-gray-400 hover:bg-gray-100'}`}
                >
                    <span className="text-[10px] font-black uppercase tracking-widest">{day.toLocaleDateString('en-US', { weekday: 'short' })}</span>
                    <span className="text-sm font-black mt-1">{day.getDate()}</span>
                </button>
            );
        }
        return (
            <div className="space-y-4">
                <div className="flex items-center justify-between px-1">
                    <button onClick={() => changeWeek(-1)} className="p-2 bg-gray-50 rounded-xl text-gray-400 hover:text-blue-600 transition-colors">
                        <ChevronLeft className="w-5 h-5" />
                    </button>
                    <span className="text-xs font-black text-gray-800 uppercase tracking-widest">
                        {selectedDate.toLocaleDateString('en-US', { month: 'long', year: 'numeric' })}
                    </span>
                    <button onClick={() => changeWeek(1)} className="p-2 bg-gray-50 rounded-xl text-gray-400 hover:text-blue-600 transition-colors">
                        <ChevronRight className="w-5 h-5" />
                    </button>
                </div>
                <div className="flex space-x-2">{days}</div>
            </div>
        );
    };

    const renderGrid = () => {
        const dateKey = formatDateStr(selectedDate);
        const branchBlocked = localBlockedSlots[selectedBranchId]?.[dateKey] || {};
        const branchBooked = MOCK_DATA.bookedSlots[selectedBranchId]?.[dateKey] || {};

        return (
            <div className="bg-white rounded-[32px] border border-gray-100 shadow-sm overflow-hidden flex flex-col">
                <div className="flex border-b border-gray-50 bg-gray-50/50">
                    <div className="w-20 p-3 text-[10px] font-black text-gray-400 uppercase border-r border-gray-100">Time</div>
                    {bedIds.map(bed => (
                        <div key={bed} className="flex-1 p-3 text-[10px] font-black text-gray-600 uppercase text-center border-r border-gray-100 last:border-0">{bed.replace('-', ' ')}</div>
                    ))}
                </div>

                <div className="overflow-y-auto max-h-[420px] no-scrollbar select-none" onMouseLeave={handleMouseUp}>
                    {timeSlots.map(time => {
                        const hour = parseInt(time.split(':')[0]);
                        const isOutside = hour < selectedBranch.open || hour >= selectedBranch.close;

                        return (
                            <div key={time} className="flex border-b border-gray-50 last:border-0">
                                <div className="w-20 p-2 text-[10px] font-bold text-gray-400 text-center border-r border-gray-100 bg-gray-50/30">
                                    {formatTime24to12(time)}
                                </div>
                                {bedIds.map(bed => {
                                    const isBooked = branchBooked[bed]?.includes(time);
                                    const isBlocked = branchBlocked[bed]?.includes(time);
                                    const isSelected = selectedSlots.some(s => s.bedId === bed && s.time === time);

                                    let status = 'available';
                                    if (isOutside) status = 'unavailable';
                                    else if (isSelected) status = 'selected';
                                    else if (isBooked) status = 'booked';
                                    else if (isBlocked) status = 'blocked';

                                    return (
                                        <div 
                                            key={bed}
                                            onMouseDown={() => handleMouseDown(bed, time, status)}
                                            onMouseEnter={() => handleMouseEnter(bed, time, status)}
                                            onMouseUp={handleMouseUp}
                                            className={`flex-1 h-11 border-r border-gray-50 last:border-0 transition-all duration-150 relative
                                                ${status === 'unavailable' ? 'bg-gray-100/50 cursor-not-allowed opacity-40' : ''}
                                                ${status === 'available' ? 'bg-white cursor-pointer hover:bg-blue-50/30' : ''}
                                                ${status === 'selected' ? 'bg-blue-500 shadow-inner' : ''}
                                                ${status === 'booked' ? 'bg-emerald-500 cursor-not-allowed' : ''}
                                                ${status === 'blocked' ? 'bg-rose-500' : ''}
                                            `}
                                        >
                                            {status === 'booked' && <Check className="w-3 h-3 text-white absolute inset-0 m-auto opacity-40" />}
                                            {status === 'blocked' && <ShieldOff className="w-4 h-4 text-white absolute inset-0 m-auto opacity-40" />}
                                        </div>
                                    );
                                })}
                            </div>
                        );
                    })}
                </div>
            </div>
        );
    };

    if (loading) return <div className="min-h-screen flex items-center justify-center bg-white font-black text-blue-600 animate-pulse">SWIM 360</div>;

    return (
        <div className="max-w-md mx-auto min-h-screen bg-[#F8FAFC] font-sans text-gray-900 relative">
            
            {/* Header */}
            <header className="px-6 pt-12 pb-6 bg-white border-b border-gray-100 sticky top-0 z-30">
                <div className="flex items-center justify-between text-left">
                    <div className="flex items-center space-x-3">
                        <div className="p-2.5 bg-blue-600 rounded-2xl text-white shadow-lg shadow-blue-100">
                            <Calendar className="w-6 h-6" />
                        </div>
                        <div>
                            <h1 className="text-2xl font-black tracking-tight leading-none">Availability</h1>
                            <p className="text-[10px] font-bold text-gray-400 uppercase tracking-widest mt-1.5">Branch Capacity Management</p>
                        </div>
                    </div>
                    <button onClick={() => window.history.back()} className="p-2 text-gray-400 active:scale-90 transition-transform"><X className="w-6 h-6" /></button>
                </div>
            </header>

            <main className="p-6 space-y-6 animate-in">
                
                {/* Branch Selection & Date Card */}
                <div className="bg-white p-6 rounded-[32px] shadow-sm border border-gray-100 space-y-6">
                    <div className="space-y-2 text-left">
                        <label className="text-[10px] font-black text-gray-400 uppercase ml-1 block">Active Branch</label>
                        <div className="flex items-center bg-gray-50 rounded-2xl px-4 py-1 border border-transparent focus-within:border-blue-500 transition-all">
                            <Building2 className="w-5 h-5 text-gray-400 mr-3" />
                            <select 
                                value={selectedBranchId}
                                onChange={(e) => setSelectedBranchId(e.target.value)}
                                className="flex-1 bg-transparent py-4 text-sm font-bold outline-none appearance-none"
                            >
                                {MOCK_DATA.branches.map(b => <option key={b.id} value={b.id}>{b.name}</option>)}
                            </select>
                            <ChevronDown className="w-4 h-4 text-gray-400 ml-2" />
                        </div>
                    </div>

                    {renderDayIterator()}
                    
                    <div className="pt-2 flex items-center justify-center space-x-4 text-[10px] font-black text-gray-400 uppercase tracking-tighter">
                        <span className="flex items-center"><Clock className="w-3 h-3 mr-1" /> {selectedBranch.open}:00 - {selectedBranch.close}:00</span>
                        <span className="flex items-center"><Layers className="w-3 h-3 mr-1" /> {selectedBranch.beds} Beds Total</span>
                    </div>
                </div>

                {/* Legend Chips */}
                <div className="flex space-x-3 overflow-x-auto no-scrollbar py-1">
                    <div className="flex items-center space-x-1.5 px-3 py-1.5 bg-white rounded-full border border-gray-100 flex-shrink-0">
                        <div className="w-2.5 h-2.5 rounded-full bg-white border border-gray-300"></div>
                        <span className="text-[9px] font-black text-gray-500 uppercase">Free</span>
                    </div>
                    <div className="flex items-center space-x-1.5 px-3 py-1.5 bg-white rounded-full border border-gray-100 flex-shrink-0">
                        <div className="w-2.5 h-2.5 rounded-full bg-emerald-500"></div>
                        <span className="text-[9px] font-black text-gray-500 uppercase">Booked</span>
                    </div>
                    <div className="flex items-center space-x-1.5 px-3 py-1.5 bg-white rounded-full border border-gray-100 flex-shrink-0">
                        <div className="w-2.5 h-2.5 rounded-full bg-rose-500"></div>
                        <span className="text-[9px] font-black text-gray-500 uppercase">Blocked</span>
                    </div>
                    <div className="flex items-center space-x-1.5 px-3 py-1.5 bg-white rounded-full border border-gray-100 flex-shrink-0">
                        <div className="w-2.5 h-2.5 rounded-full bg-gray-200"></div>
                        <span className="text-[9px] font-black text-gray-500 uppercase">Closed</span>
                    </div>
                </div>

                {/* Interactive Grid */}
                {renderGrid()}

                {/* Actions Footer */}
                <div className="grid grid-cols-2 gap-4">
                    <button 
                        onClick={handleBlock}
                        disabled={selectedSlots.length === 0}
                        className={`py-5 rounded-[24px] font-black text-xs uppercase tracking-[0.2em] shadow-xl transition-all flex items-center justify-center space-x-2
                        ${selectedSlots.length > 0 ? 'bg-rose-500 text-white shadow-rose-100 active:scale-95' : 'bg-gray-100 text-gray-300 cursor-not-allowed'}`}
                    >
                        <ShieldOff className="w-5 h-5" /> <span>Block</span>
                    </button>
                    <button 
                        onClick={handleFree}
                        disabled={selectedSlots.length === 0}
                        className={`py-5 rounded-[24px] font-black text-xs uppercase tracking-[0.2em] shadow-xl transition-all flex items-center justify-center space-x-2
                        ${selectedSlots.length > 0 ? 'bg-blue-600 text-white shadow-blue-100 active:scale-95' : 'bg-gray-100 text-gray-300 cursor-not-allowed'}`}
                    >
                        <RotateCcw className="w-5 h-5" /> <span>Free Up</span>
                    </button>
                </div>

                {selectedSlots.length > 0 && (
                    <div className="flex items-center justify-center space-x-2 text-blue-600 animate-pulse">
                        <Info className="w-4 h-4" />
                        <span className="text-[10px] font-black uppercase tracking-widest">{selectedSlots.length} Slots Selected</span>
                    </div>
                )}
            </main>

            {notification && (
                <div className={`fixed bottom-10 left-1/2 -translate-x-1/2 px-8 py-4 rounded-full text-[10px] font-black shadow-2xl z-[100] animate-bounce flex items-center space-x-2 uppercase tracking-widest ${notification.type === 'error' ? 'bg-red-600' : 'bg-gray-900'} text-white`}>
                    <CheckCircle className="w-4 h-4" />
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