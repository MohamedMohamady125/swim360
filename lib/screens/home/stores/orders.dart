import React, { useState, useEffect, useMemo, useRef } from 'react';
import { 
  Plus, UploadCloud, ChevronDown, Check, 
  Layers, Package, Ruler, Palette, Building2, 
  X, Info, ArrowLeft, Camera, Settings,
  AlertCircle, Tag, Percent, Ticket, Edit3,
  MoreHorizontal, Eye, ChevronRight, CheckCircle,
  Phone, MapPin, Truck, Search, Calendar, MessageCircle,
  XCircle, Archive, Smartphone, Clock // أضفت Smartphone و Clock هنا
} from 'lucide-react';

// --- DATA DEFINITIONS ---
const GOVERNORATES = ["Cairo", "Giza", "Alexandria", "Dakahlia", "Red Sea", "Beheira", "Fayoum", "Gharbia", "Ismailia", "Luxor", "Matrouh", "Minya", "Monufia", "New Valley", "North Sinai", "Port Said", "Qalyubia", "Qena", "Sharqia", "Sohag", "South Sinai", "Suez"];
const BRANDS = ["Speedo", "Arena", "TYR", "Finis", "Mizuno", "MP Michael Phelps", "Zoggs", "Aqua Sphere", "Other"];
const CATEGORIES = ["Cap", "Goggles", "Suit", "Kickboard", "Paddles", "Fins", "Snorkels", "Other"];
const SIZES = ["XS", "S", "M", "L", "XL", "22", "24", "26", "28", "30", "32", "34", "36", "38", "40", "ONE SIZE", "OTHER"];
const COLORS = [
    { name: 'Red', code: '#EF4444' },
    { name: 'Blue', code: '#3B82F6' },
    { name: 'Yellow', code: '#FACC15' },
    { name: 'Orange', code: '#F97316' },
    { name: 'Gold', code: '#FFD700' },
    { name: 'Green', code: '#10B981' },
    { name: 'Black', code: '#000000' },
    { name: 'White', code: '#FFFFFF' },
    { name: 'Pink', code: '#EC4899' },
    { name: 'Purple', code: '#8B5CF6' }
];
const BRANCHES = [
    { id: 'b1', name: 'Zamalek Main' },
    { id: 'b2', name: 'New Cairo Hub' },
    { id: 'b3', name: 'Alexandria Branch' },
    { id: 'b4', name: 'Giza Outlet' }
];

// --- MOCK ORDERS DATA ---
const INITIAL_ORDERS = [
    { 
        id: 1001, status: 'requested', customer_name: 'Liam Davies', phone: '+201001234567', branch_id: 'b1',
        location: 'Zamalek, Cairo', delivery_type: 'National Delivery',
        items: [
            {name: 'Pro Goggles', qty: 1, category: 'Goggles', brand: 'Speedo', size: 'ONE SIZE', color: 'Blue'}, 
            {name: 'Swim Cap', qty: 2, category: 'Cap', brand: 'TYR', size: 'M', color: 'Black'}
        ],
        createdAt: new Date(Date.now() - 3600000) 
    },
    { 
        id: 1002, status: 'confirmed', customer_name: 'Olivia Martin', phone: '+201119998888', branch_id: 'b2',
        location: 'Rehab City, Cairo', delivery_type: 'Governorate Delivery',
        items: [
            {name: 'Carbon Suit', qty: 1, category: 'Suit', brand: 'Arena', size: '32', color: 'Purple'}
        ],
        delivery_date: '2026-01-25',
        createdAt: new Date(Date.now() - 86400000)
    }
];

export default function App() {
    const [view, setView] = useState('orders'); // 'inventory', 'edit', 'orders'
    const [orders, setOrders] = useState(INITIAL_ORDERS);
    const [orderTab, setOrderTab] = useState('requested'); // 'requested', 'confirmed', 'delivered'
    const [branchFilter, setBranchFilter] = useState('all');
    const [orderSearch, setOrderSearch] = useState('');
    
    const [activeModal, setActiveModal] = useState(null); // 'delivery', 'reject', 'contact', 'details', 'confirm-delivered'
    const [selectedOrder, setSelectedOrder] = useState(null);
    const [notification, setNotification] = useState(null);

    // تم الإصلاح: تعريف حالة loading المفقودة
    const [loading, setLoading] = useState(false);

    // Modal Specific States
    const [deliveryDate, setDeliveryDate] = useState('');
    const [rejectionReason, setRejectionReason] = useState('');

    // --- UTILITIES ---
    const showNotify = (msg, type = 'success') => {
        setNotification({ msg, type });
        setTimeout(() => setNotification(null), 3000);
    };

    // --- ORDER LOGIC ---
    const filteredOrders = useMemo(() => {
        const now = new Date().getTime();
        const fourteenDays = 14 * 24 * 60 * 60 * 1000;

        return orders.filter(order => {
            // Archival Logic: Remove delivered orders older than 14 days
            if (order.status === 'delivered' && order.delivered_on) {
                if ((now - new Date(order.delivered_on).getTime()) > fourteenDays) return false;
            }

            const matchesStatus = order.status === orderTab;
            const matchesBranch = branchFilter === 'all' || order.branch_id === branchFilter;
            const matchesSearch = orderSearch === '' || order.id.toString().includes(orderSearch);

            return matchesStatus && matchesBranch && matchesSearch;
        }).sort((a, b) => b.id - a.id);
    }, [orders, orderTab, branchFilter, orderSearch]);

    const handleConfirmOrder = (e) => {
        e.preventDefault();
        setOrders(prev => prev.map(o => o.id === selectedOrder.id ? { ...o, status: 'confirmed', delivery_date: deliveryDate } : o));
        showNotify(`Order #${selectedOrder.id} confirmed for ${deliveryDate}`);
        setActiveModal(null);
        setOrderTab('confirmed');
    };

    const handleRejectOrder = (e) => {
        e.preventDefault();
        setOrders(prev => prev.filter(o => o.id !== selectedOrder.id));
        showNotify(`Order #${selectedOrder.id} rejected: ${rejectionReason}`, 'error');
        setActiveModal(null);
    };

    const handleMarkDelivered = () => {
        setOrders(prev => prev.map(o => o.id === selectedOrder.id ? { ...o, status: 'delivered', delivered_on: new Date().toISOString().split('T')[0] } : o));
        showNotify(`Order #${selectedOrder.id} archived as delivered`);
        setActiveModal(null);
        setOrderTab('delivered');
    };

    // --- VIEW RENDERERS ---

    const renderOrderManagement = () => (
        <div className="p-6 space-y-6 animate-in text-left">
            <header className="space-y-1">
                <h1 className="text-3xl font-black text-gray-900 tracking-tight">Order Management</h1>
                <p className="text-sm text-gray-400 font-medium">Process and track your store sales</p>
            </header>

            {/* Branch Filter & Tabs */}
            <div className="space-y-4">
                <div className="bg-white p-4 rounded-[24px] border border-gray-100 shadow-sm">
                    <label className="text-[10px] font-black text-gray-400 uppercase ml-1 mb-2 block">Store Branch</label>
                    <div className="flex items-center bg-gray-50 rounded-xl px-4 py-1">
                        <Building2 className="w-4 h-4 text-gray-400 mr-3" />
                        <select 
                            value={branchFilter}
                            onChange={(e) => setBranchFilter(e.target.value)}
                            className="flex-1 bg-transparent py-3 text-sm font-bold outline-none"
                        >
                            <option value="all">All Branches</option>
                            {BRANCHES.map(b => <option key={b.id} value={b.id}>{b.name}</option>)}
                        </select>
                    </div>
                </div>

                <div className="flex bg-white p-1.5 rounded-[20px] shadow-sm border border-gray-100">
                    {['requested', 'confirmed', 'delivered'].map(tab => (
                        <button 
                            key={tab}
                            onClick={() => setOrderTab(tab)}
                            className={`flex-1 py-3 rounded-xl text-[10px] font-black uppercase tracking-widest transition-all ${orderTab === tab ? 'bg-blue-600 text-white shadow-lg' : 'text-gray-400 hover:bg-gray-50'}`}
                        >
                            {tab === 'delivered' ? 'Archive' : tab}
                        </button>
                    ))}
                </div>
            </div>

            {/* Search (Only for confirmed/delivered) */}
            {(orderTab === 'confirmed' || orderTab === 'delivered') && (
                <div className="relative animate-in">
                    <Search className="absolute left-4 top-1/2 -translate-y-1/2 w-4 h-4 text-gray-400" />
                    <input 
                        type="number" 
                        placeholder="Search order number..." 
                        value={orderSearch}
                        onChange={(e) => setOrderSearch(e.target.value)}
                        className="w-full pl-11 p-4 bg-white border border-gray-100 rounded-2xl text-sm font-bold shadow-sm focus:ring-2 focus:ring-blue-500 outline-none"
                    />
                </div>
            )}

            {/* Orders List */}
            <div className="space-y-4 pb-20">
                {filteredOrders.map(order => (
                    <div key={order.id} className="bg-white rounded-[32px] border border-gray-100 shadow-sm p-6 space-y-4 border-l-8 transition-all hover:shadow-md" style={{ borderColor: orderTab === 'requested' ? '#f59e0b' : orderTab === 'confirmed' ? '#10b981' : '#3b82f6' }}>
                        <div className="flex justify-between items-start">
                            <div>
                                <h3 className="text-xl font-black text-gray-900 leading-none">Order #{order.id}</h3>
                                <p className="text-[10px] font-bold text-gray-400 uppercase tracking-widest mt-2">{order.delivery_type}</p>
                            </div>
                            <button 
                                onClick={() => { setSelectedOrder(order); setActiveModal('details'); }}
                                className="p-2.5 bg-gray-50 text-blue-600 rounded-xl hover:bg-blue-500 hover:text-white transition-all shadow-sm"
                            >
                                <Eye className="w-5 h-5" />
                            </button>
                        </div>

                        <div className="space-y-2">
                            <div className="flex items-center text-sm font-bold text-gray-700">
                                <Package className="w-4 h-4 mr-2 text-gray-300" />
                                {order.items.length} Items ({order.items.map(i => i.name).join(', ')})
                            </div>
                            <div className="flex items-center text-sm font-bold text-gray-700">
                                <MapPin className="w-4 h-4 mr-2 text-gray-300" />
                                {order.location}
                            </div>
                            {order.delivery_date && (
                                <div className="flex items-center text-sm font-bold text-emerald-600">
                                    <Clock className="w-4 h-4 mr-2" />
                                    Expected: {order.delivery_date}
                                </div>
                            )}
                        </div>

                        <div className="flex justify-end space-x-2 pt-2">
                            {order.status === 'requested' && (
                                <>
                                    <button onClick={() => { setSelectedOrder(order); setRejectionReason(''); setActiveModal('reject'); }} className="px-5 py-2.5 bg-red-50 text-red-600 rounded-xl text-[10px] font-black uppercase tracking-widest hover:bg-red-600 hover:text-white transition-all">Reject</button>
                                    <button onClick={() => { setSelectedOrder(order); setDeliveryDate(''); setActiveModal('delivery'); }} className="px-5 py-2.5 bg-blue-600 text-white rounded-xl text-[10px] font-black uppercase tracking-widest shadow-lg shadow-blue-100 hover:brightness-110 transition-all">Confirm</button>
                                </>
                            )}
                            {order.status === 'confirmed' && (
                                <>
                                    <button onClick={() => { setSelectedOrder(order); setActiveModal('contact'); }} className="px-5 py-2.5 bg-emerald-50 text-emerald-600 rounded-xl text-[10px] font-black uppercase tracking-widest flex items-center"><MessageCircle className="w-3.5 h-3.5 mr-1.5" /> Contact</button>
                                    <button onClick={() => { setSelectedOrder(order); setActiveModal('confirm-delivered'); }} className="px-5 py-2.5 bg-blue-600 text-white rounded-xl text-[10px] font-black uppercase tracking-widest shadow-lg shadow-blue-100 flex items-center"><CheckCircle className="w-3.5 h-3.5 mr-1.5" /> Delivered</button>
                                </>
                            )}
                            {order.status === 'delivered' && (
                                <button onClick={() => { setSelectedOrder(order); setActiveModal('contact'); }} className="px-5 py-2.5 bg-gray-100 text-gray-500 rounded-xl text-[10px] font-black uppercase tracking-widest flex items-center"><MessageCircle className="w-3.5 h-3.5 mr-1.5" /> Contact History</button>
                            )}
                        </div>
                    </div>
                ))}
            </div>
        </div>
    );

    const renderModals = () => {
        if (!activeModal || !selectedOrder) return null;

        const onClose = () => setActiveModal(null);

        return (
            <div className="fixed inset-0 z-50 flex items-center justify-center p-6 bg-slate-900/60 backdrop-blur-sm animate-in">
                <div className="bg-white w-full max-w-sm rounded-[40px] p-8 shadow-2xl space-y-6 relative overflow-hidden">
                    <button onClick={onClose} className="absolute top-6 right-6 p-2 bg-gray-50 rounded-full text-gray-400"><X className="w-5 h-5" /></button>
                    
                    {activeModal === 'delivery' && (
                        <form onSubmit={handleConfirmOrder} className="space-y-6 text-left">
                            <h3 className="text-2xl font-black text-gray-900 leading-tight">Set Delivery Date</h3>
                            <p className="text-sm text-gray-500">Provide an estimated arrival date for Order #{selectedOrder.id}.</p>
                            <div className="input-group">
                                <Calendar className="w-5 h-5 text-blue-600 mr-3" />
                                <input 
                                    type="date" 
                                    required 
                                    min={new Date().toISOString().split('T')[0]}
                                    value={deliveryDate} 
                                    onChange={e => setDeliveryDate(e.target.value)} 
                                    className="flex-1 bg-transparent py-3 text-sm font-bold outline-none" 
                                />
                            </div>
                            <button type="submit" className="w-full py-4 bg-blue-600 text-white rounded-2xl font-black text-sm uppercase tracking-widest shadow-xl">Confirm Shipment</button>
                        </form>
                    )}

                    {activeModal === 'reject' && (
                        <form onSubmit={handleRejectOrder} className="space-y-6 text-left">
                            <h3 className="text-2xl font-black text-red-600 leading-tight">Reject Order</h3>
                            <p className="text-sm text-gray-500">Please select a reason for declining Order #{selectedOrder.id}.</p>
                            <div className="input-group">
                                <AlertCircle className="w-5 h-5 text-red-600 mr-3" />
                                <select 
                                    required 
                                    value={rejectionReason} 
                                    onChange={e => setRejectionReason(e.target.value)} 
                                    className="flex-1 bg-transparent py-3 text-sm font-bold outline-none"
                                >
                                    <option value="">Choose Reason</option>
                                    <option value="Out of Stock">Item Out of Stock</option>
                                    <option value="Location unreachable">Location Unreachable</option>
                                    <option value="Duplicate Order">Duplicate Order</option>
                                </select>
                            </div>
                            <button type="submit" className="w-full py-4 bg-red-600 text-white rounded-2xl font-black text-sm uppercase tracking-widest shadow-xl">Confirm Rejection</button>
                        </form>
                    )}

                    {activeModal === 'details' && (
                        <div className="space-y-6 text-left">
                            <div className="flex justify-between items-center border-b border-gray-100 pb-4">
                                <h3 className="text-2xl font-black text-gray-900">Order Items</h3>
                                <span className="bg-blue-50 text-blue-600 px-3 py-1 rounded-full text-[10px] font-black uppercase">#{selectedOrder.id}</span>
                            </div>
                            <div className="space-y-4 max-h-60 overflow-y-auto no-scrollbar">
                                {selectedOrder.items.map((item, idx) => (
                                    <div key={idx} className="p-4 bg-gray-50 rounded-2xl border border-gray-100">
                                        <p className="text-sm font-black text-gray-900">{item.name} <span className="text-blue-600">x{item.qty}</span></p>
                                        <p className="text-[10px] text-gray-400 font-bold uppercase mt-1">{item.brand} | {item.size} | {item.color}</p>
                                    </div>
                                ))}
                            </div>
                            <div className="pt-4 border-t border-gray-100 flex items-center justify-between">
                                <p className="text-xs font-bold text-gray-400 uppercase">Customer</p>
                                <p className="text-sm font-black text-gray-900">{selectedOrder.customer_name}</p>
                            </div>
                        </div>
                    )}

                    {activeModal === 'contact' && (
                        <div className="space-y-6 text-center">
                            <div className="w-20 h-20 bg-emerald-50 text-emerald-600 rounded-3xl flex items-center justify-center mx-auto">
                                <MessageCircle className="w-10 h-10" />
                            </div>
                            <div>
                                <h3 className="text-2xl font-black text-gray-900 leading-tight">Chat with Customer</h3>
                                <p className="text-sm text-gray-500 mt-2">Connect via WhatsApp for Order #{selectedOrder.id}</p>
                            </div>
                            <a 
                                href={`https://wa.me/${selectedOrder.phone.replace('+', '')}`} 
                                target="_blank" 
                                className="w-full flex items-center justify-center py-4 bg-[#25D366] text-white rounded-2xl font-black text-sm uppercase tracking-widest shadow-xl active:scale-95 transition-all"
                            >
                                <Smartphone className="w-5 h-5 mr-3" /> Start WhatsApp Chat
                            </a>
                        </div>
                    )}

                    {activeModal === 'confirm-delivered' && (
                        <div className="space-y-6 text-center">
                            <div className="w-20 h-20 bg-blue-50 text-blue-600 rounded-3xl flex items-center justify-center mx-auto">
                                <Truck className="w-10 h-10" />
                            </div>
                            <div>
                                <h3 className="text-2xl font-black text-gray-900 leading-tight">Confirm Delivery</h3>
                                <p className="text-sm text-gray-500 mt-2">Mark Order #{selectedOrder.id} as completed? It will move to Archive for 14 days.</p>
                            </div>
                            <button 
                                onClick={handleMarkDelivered}
                                className="w-full py-4 bg-blue-600 text-white rounded-2xl font-black text-sm uppercase tracking-widest shadow-xl shadow-blue-100"
                            >
                                Yes, It's Delivered
                            </button>
                        </div>
                    )}
                </div>
            </div>
        );
    };

    if (loading) return <div className="min-h-screen flex items-center justify-center bg-white font-black text-blue-600 animate-pulse uppercase tracking-[0.3em]">Swim 360</div>;

    return (
        <div className="max-w-md mx-auto min-h-screen bg-[#F8FAFC] font-sans text-gray-900 relative">
            
            {renderOrderManagement()}

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
                .input-group {
                    display: flex;
                    align-items: center;
                    border: 1px solid #E5E7EB;
                    border-radius: 16px;
                    padding: 0 16px;
                    background-color: #FAFAFA;
                    transition: all 0.2s;
                }
                .input-group:focus-within {
                    border-color: #3B82F6;
                    background-color: white;
                    box-shadow: 0 0 0 4px rgba(59, 130, 246, 0.05);
                }
            `}</style>
        </div>
    );
}