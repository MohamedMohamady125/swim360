import React, { useState, useEffect, useMemo, useRef } from 'react';
import { initializeApp } from 'firebase/app';
import { getAuth, signInAnonymously, signInWithCustomToken, onAuthStateChanged } from 'firebase/auth';
import { getFirestore, doc, addDoc, deleteDoc, onSnapshot, collection, query, Timestamp, updateDoc } from 'firebase/firestore';
import { 
  Search, Plus, Trash2, List, Phone, 
  UploadCloud, X, CheckCircle, MapPin, 
  ChevronLeft, MessageSquare, MessageCircle, 
  ArrowLeft, ChevronRight, Share2, Star
} from 'lucide-react';

// --- Global Context/Setup ---
const appId = typeof __app_id !== 'undefined' ? __app_id : 'default-app-id';
const firebaseConfig = typeof __firebase_config !== 'undefined' ? JSON.parse(__firebase_config) : {};
const initialAuthToken = typeof __initial_auth_token !== 'undefined' ? __initial_auth_token : null;

let app, db, auth;
if (Object.keys(firebaseConfig).length) {
    app = initializeApp(firebaseConfig);
    db = getFirestore(app);
    auth = getAuth(app);
}

const PUBLIC_COLLECTION_PATH = `artifacts/${appId}/public/data/usedItems`;

// --- DATA DEFINITIONS ---
const GOVERNORATES = ["Cairo", "Giza", "Alexandria", "Dakahlia", "Red Sea", "Beheira", "Fayoum", "Gharbia", "Ismailia", "Luxor", "Matrouh", "Minya", "Monufia", "New Valley", "North Sinai", "Port Said", "Qalyubia", "Qena", "Sharqia", "Sohag", "South Sinai", "Suez"];
const BRANDS = ["Speedo", "Arena", "TYR", "Finis", "Mizuno", "MP Michael Phelps", "Zoggs", "Aqua Sphere", "Other"];
const SIZES = ["Adult (One Size)", "Youth (One Size)", "Small (S)", "Medium (M)", "Large (L)", "XL", "22", "24", "26", "28", "30", "32", "34", "36"];

// --- Mock Data ---
const GLOBAL_TEST_ITEMS = [
    {
        id: 'test-1',
        title: 'Speedo Fastskin LZR Pure Intent',
        description: 'Used for one championship only. Perfect compression and water repellency.',
        condition: 'Excellent',
        governorate: 'Cairo',
        brand: 'Speedo',
        size: '26',
        price: 320.00,
        contactNumber: '1234567890',
        photos: [
            'https://images.unsplash.com/photo-1552650272-b8a34e21bc4b?q=80&w=800&auto=format&fit=crop',
            'https://images.unsplash.com/photo-1519494026892-80bbd2d6fd0d?q=80&w=800&auto=format&fit=crop'
        ],
        postedBy: 'system',
        status: 'available',
        createdAt: Timestamp.now()
    },
    {
        id: 'test-2',
        title: 'Arena Powerfin Pro - Black/Gold',
        description: 'Elite training fins. Brand new, never used in water.',
        condition: 'New',
        governorate: 'Alexandria',
        brand: 'Arena',
        size: 'Large',
        price: 75.00,
        contactNumber: '9876543210',
        photos: ['https://images.unsplash.com/photo-1606107557195-0e29a4b5b4aa?q=80&w=800&auto=format&fit=crop'],
        postedBy: 'user-456',
        status: 'available',
        createdAt: Timestamp.now()
    }
];

// --- Custom Sub-Components ---

const PhotoCarousel = ({ photos }) => {
    const [index, setIndex] = useState(0);
    const scrollRef = useRef(null);

    const handleScroll = (e) => {
        const scrollPos = e.target.scrollLeft;
        const width = e.target.offsetWidth;
        const newIndex = Math.round(scrollPos / width);
        setIndex(newIndex);
    };

    return (
        <div className="relative aspect-square bg-gray-100 overflow-hidden">
            <div 
                ref={scrollRef}
                onScroll={handleScroll}
                className="flex overflow-x-auto snap-x snap-mandatory no-scrollbar h-full"
            >
                {photos.map((src, i) => (
                    <div key={i} className="flex-shrink-0 w-full h-full snap-center">
                        <img src={src} className="w-full h-full object-cover" alt={`Product ${i}`} />
                    </div>
                ))}
            </div>
            {photos.length > 1 && (
                <div className="absolute bottom-4 left-1/2 -translate-x-1/2 flex space-x-1.5 px-3 py-1.5 bg-black/20 backdrop-blur-md rounded-full">
                    {photos.map((_, i) => (
                        <div key={i} className={`w-1.5 h-1.5 rounded-full transition-all ${index === i ? 'bg-white w-4' : 'bg-white/50'}`} />
                    ))}
                </div>
            )}
        </div>
    );
};

// --- Main App ---
export default function App() {
    const [view, setView] = useState('home'); 
    const [items, setItems] = useState([]);
    const [selectedItem, setSelectedItem] = useState(null);
    const [userId, setUserId] = useState(null);
    const [loading, setLoading] = useState(true);
    const [notification, setNotification] = useState(null);

    const [searchTerm, setSearchTerm] = useState('');
    const [activeFilter, setActiveFilter] = useState('All');

    const [sellForm, setSellForm] = useState({ 
        title: '', price: '', description: '', governorate: 'Cairo', 
        condition: 'New', size: 'Medium (M)', brand: 'Speedo', contactNumber: '' 
    });

    useEffect(() => {
        if (!auth) return;
        const initAuth = async () => {
            if (initialAuthToken) await signInWithCustomToken(auth, initialAuthToken);
            else await signInAnonymously(auth);
        };
        const unsubscribe = onAuthStateChanged(auth, (user) => {
            setUserId(user ? user.uid : null);
            setLoading(false);
        });
        initAuth();
        return () => unsubscribe();
    }, []);

    useEffect(() => {
        if (!db || !userId) return;
        const unsubscribe = onSnapshot(collection(db, PUBLIC_COLLECTION_PATH), (snapshot) => {
            const fetched = snapshot.docs.map(doc => ({ id: doc.id, ...doc.data() }));
            
            // Generate some mock items specific to the CURRENT USER for the demo
            const myMockItems = [
                {
                    id: 'my-mock-1',
                    title: 'Your Pro Training Snorkel',
                    description: 'This is a mock item assigned to your account to test "Your Listings". Excellent condition.',
                    condition: 'Excellent',
                    governorate: 'Cairo',
                    brand: 'Finis',
                    size: 'Adult (One Size)',
                    price: 25.00,
                    contactNumber: '0100000000',
                    photos: ['https://images.unsplash.com/photo-1544923246-77307dd654ca?q=80&w=800&auto=format&fit=crop'],
                    postedBy: userId, // Assigned to you
                    status: 'available',
                    createdAt: Timestamp.now()
                },
                {
                    id: 'my-mock-2',
                    title: 'Your Elite Kickboard (Blue)',
                    description: 'Used for one season. Minor wear on edges but perfect for drill work.',
                    condition: 'Good',
                    governorate: 'Giza',
                    brand: 'Arena',
                    size: 'Standard',
                    price: 15.00,
                    contactNumber: '0100000000',
                    photos: ['https://images.unsplash.com/photo-1519494026892-80bbd2d6fd0d?q=80&w=800&auto=format&fit=crop'],
                    postedBy: userId, // Assigned to you
                    status: 'available',
                    createdAt: Timestamp.now()
                }
            ];

            setItems([...GLOBAL_TEST_ITEMS, ...myMockItems, ...fetched]);
        });
        return () => unsubscribe();
    }, [userId]);

    const showNotify = (msg, type = 'success') => {
        setNotification({ msg, type });
        setTimeout(() => setNotification(null), 3000);
    };

    const handlePost = async () => {
        if (!sellForm.title || !sellForm.price || !sellForm.contactNumber) {
            showNotify("Please fill in required fields", "error");
            return;
        }
        try {
            await addDoc(collection(db, PUBLIC_COLLECTION_PATH), {
                ...sellForm,
                price: parseFloat(sellForm.price),
                photos: ['https://images.unsplash.com/photo-1552650272-b8a34e21bc4b?q=80&w=800&auto=format&fit=crop'],
                postedBy: userId,
                status: 'available',
                createdAt: Timestamp.now()
            });
            showNotify("Listing published!");
            setView('home');
        } catch (e) { showNotify("Error posting item", 'error'); }
    };

    const handleMarkSold = async (id) => {
        // If it's a local mock item, we just update state for the demo
        if (id.startsWith('my-mock')) {
            setItems(items.map(i => i.id === id ? { ...i, status: 'sold' } : i));
            showNotify("Marked as sold");
            return;
        }
        try {
            await updateDoc(doc(db, PUBLIC_COLLECTION_PATH, id), { status: 'sold' });
            showNotify("Marked as sold");
        } catch (e) { showNotify("Error updating item", 'error'); }
    };

    const handleDelete = async (id) => {
        // If it's a local mock item, we just update state for the demo
        if (id.startsWith('my-mock')) {
            setItems(items.filter(i => i.id !== id));
            showNotify("Item removed");
            return;
        }
        try {
            await deleteDoc(doc(db, PUBLIC_COLLECTION_PATH, id));
            showNotify("Item removed");
        } catch (e) { showNotify("Error deleting item", 'error'); }
    };

    const filteredItems = useMemo(() => {
        return items.filter(item => {
            const matchesSearch = item.title.toLowerCase().includes(searchTerm.toLowerCase());
            const matchesCategory = activeFilter === 'All' || item.condition === activeFilter;
            return matchesSearch && matchesCategory && item.status === 'available';
        }).sort((a, b) => (b.createdAt?.toMillis() || 0) - (a.createdAt?.toMillis() || 0));
    }, [items, searchTerm, activeFilter]);

    const myItems = useMemo(() => items.filter(i => i.postedBy === userId), [items, userId]);

    // --- RENDERING ---

    const renderHome = () => (
        <div className="flex flex-col animate-in">
            <div className="sticky top-0 z-20 bg-white border-b border-gray-100 p-4 pb-2 space-y-4">
                <div className="flex items-center justify-between">
                    <h1 className="text-2xl font-black text-gray-900 tracking-tight">Marketplace</h1>
                    <button onClick={() => setView('my-items')} className="p-2.5 bg-gray-50 rounded-full text-gray-700 active:scale-90 transition-transform">
                        <List className="w-6 h-6" />
                    </button>
                </div>
                <div className="relative">
                    <Search className="absolute left-3 top-1/2 -translate-y-1/2 w-5 h-5 text-gray-400" />
                    <input 
                        type="text" 
                        placeholder="Search items, brands, or cities..." 
                        value={searchTerm}
                        onChange={(e) => setSearchTerm(e.target.value)}
                        className="w-full bg-gray-100 border-none rounded-full py-2.5 pl-10 pr-4 text-sm focus:ring-2 focus:ring-blue-500 transition-all outline-none"
                    />
                </div>
                <div className="flex space-x-2 overflow-x-auto no-scrollbar pb-2">
                    {['All', 'New', 'Excellent', 'Good'].map(cat => (
                        <button key={cat} onClick={() => setActiveFilter(cat)} className={`px-4 py-1.5 rounded-full text-xs font-bold whitespace-nowrap transition-all ${activeFilter === cat ? 'bg-blue-600 text-white shadow-lg' : 'bg-gray-100 text-gray-600'}`}>{cat}</button>
                    ))}
                </div>
            </div>

            <div className="p-2 grid grid-cols-2 gap-2 pb-24">
                {filteredItems.map(item => (
                    <div key={item.id} className="bg-white rounded-lg overflow-hidden group cursor-pointer active:opacity-80 transition-all shadow-sm"
                         onClick={() => { setSelectedItem(item); setView('details'); }}>
                        <div className="aspect-square relative overflow-hidden bg-gray-100">
                            <img src={item.photos[0]} alt={item.title} className="w-full h-full object-cover transition-transform group-hover:scale-105 duration-700" />
                        </div>
                        <div className="p-2.5 space-y-0.5 text-left">
                            <p className="text-sm font-black text-gray-900">${item.price}</p>
                            <h3 className="text-xs text-gray-700 line-clamp-1 font-medium">{item.title}</h3>
                            <div className="flex items-center text-[9px] text-gray-400 font-bold uppercase tracking-tighter">
                                <MapPin className="w-2.5 h-2.5 mr-1" /> {item.governorate}
                            </div>
                        </div>
                    </div>
                ))}
            </div>
        </div>
    );

    const renderDetails = () => (
        <div className="flex flex-col bg-white min-h-screen pb-24 animate-in">
            <div className="relative">
                <button onClick={() => setView('home')} className="absolute top-10 left-4 z-10 p-2.5 bg-black/30 backdrop-blur rounded-full text-white active:scale-90 transition-transform">
                    <ChevronLeft className="w-6 h-6" />
                </button>
                <PhotoCarousel photos={selectedItem.photos} />
            </div>

            <div className="p-6 space-y-8 text-left">
                <div className="space-y-4">
                    <div className="space-y-1">
                        <h1 className="text-2xl font-black text-gray-900 tracking-tight leading-tight">{selectedItem.title}</h1>
                        <p className="text-3xl font-black text-blue-600">${selectedItem.price}</p>
                    </div>
                    
                    <div className="flex flex-wrap gap-2 pt-2">
                        <div className="px-4 py-2 bg-blue-50 border border-blue-100 rounded-2xl flex items-center text-blue-700">
                            <MapPin className="w-4 h-4 mr-2" />
                            <span className="text-xs font-black uppercase tracking-widest">{selectedItem.governorate}</span>
                        </div>
                        <div className="px-4 py-2 bg-gray-50 border border-gray-100 rounded-2xl flex items-center text-gray-600">
                            <Star className="w-4 h-4 mr-2" />
                            <span className="text-xs font-black uppercase tracking-widest">{selectedItem.condition}</span>
                        </div>
                    </div>
                </div>

                <div className="grid grid-cols-2 gap-4 border-y border-gray-50 py-6">
                    <div>
                        <p className="text-[10px] font-black text-gray-400 uppercase tracking-widest mb-1">Brand</p>
                        <p className="text-sm font-bold text-gray-900">{selectedItem.brand}</p>
                    </div>
                    <div>
                        <p className="text-[10px] font-black text-gray-400 uppercase tracking-widest mb-1">Size</p>
                        <p className="text-sm font-bold text-gray-900">{selectedItem.size}</p>
                    </div>
                </div>

                <div className="space-y-3">
                    <h2 className="text-sm font-black text-gray-400 uppercase tracking-[0.2em]">Description</h2>
                    <p className="text-sm text-gray-600 leading-relaxed font-medium">{selectedItem.description}</p>
                </div>

                <div className="fixed bottom-0 left-0 right-0 p-6 bg-white/95 backdrop-blur border-t border-gray-100 max-w-md mx-auto rounded-t-[32px] shadow-2xl z-40">
                    <a href={`https://wa.me/${selectedItem.contactNumber}`} target="_blank" className="w-full flex items-center justify-center py-4 bg-[#25D366] text-white rounded-2xl font-black text-sm shadow-xl hover:brightness-110 transition-all tracking-widest">
                        <MessageCircle className="w-6 h-6 mr-2" />
                        MESSAGE SELLER
                    </a>
                </div>
            </div>
        </div>
    );

    const renderSell = () => (
        <div className="p-6 animate-in space-y-8 pb-32 text-left">
            <div className="flex items-center space-x-4">
                <button onClick={() => setView('home')} className="p-2.5 bg-gray-100 rounded-2xl active:scale-90 transition-transform"><ArrowLeft className="w-6 h-6" /></button>
                <h2 className="text-3xl font-black text-gray-900 tracking-tight">New Listing</h2>
            </div>

            <div className="space-y-6 bg-white p-6 rounded-[32px] shadow-sm border border-gray-100">
                <div className="space-y-6">
                    <div className="p-8 bg-gray-50 rounded-3xl flex flex-col items-center justify-center border-2 border-dashed border-gray-200 text-gray-400 cursor-pointer hover:border-blue-300 transition-colors">
                        <UploadCloud className="w-10 h-10 mb-2 text-blue-500" />
                        <span className="text-[10px] font-black uppercase tracking-widest text-center">Add Photos<br/><span className="lowercase font-medium opacity-60">Maximum 10 images</span></span>
                    </div>

                    <div className="space-y-5">
                        <div>
                            <label className="text-[10px] font-black text-gray-400 uppercase ml-1">What are you selling?</label>
                            <input type="text" placeholder="Title" value={sellForm.title} onChange={e => setSellForm({...sellForm, title: e.target.value})} className="w-full mt-2 p-4 bg-gray-50 border-none rounded-2xl text-sm font-bold focus:ring-2 focus:ring-blue-500 outline-none" />
                        </div>
                        
                        <div className="grid grid-cols-2 gap-4">
                            <div>
                                <label className="text-[10px] font-black text-gray-400 uppercase ml-1">Price ($)</label>
                                <input type="number" placeholder="Amount" value={sellForm.price} onChange={e => setSellForm({...sellForm, price: e.target.value})} className="w-full mt-2 p-4 bg-gray-50 border-none rounded-2xl text-sm font-bold focus:ring-2 focus:ring-blue-500 outline-none" />
                            </div>
                            <div>
                                <label className="text-[10px] font-black text-gray-400 uppercase ml-1">Condition</label>
                                <select value={sellForm.condition} onChange={e => setSellForm({...sellForm, condition: e.target.value})} className="w-full mt-2 p-4 bg-gray-50 border-none rounded-2xl text-sm font-bold focus:ring-2 focus:ring-blue-500 outline-none">
                                    <option>New</option><option>Excellent</option><option>Good</option><option>Fair</option>
                                </select>
                            </div>
                        </div>

                        <div>
                            <label className="text-[10px] font-black text-gray-400 uppercase ml-1">Governorate</label>
                            <select value={sellForm.governorate} onChange={e => setSellForm({...sellForm, governorate: e.target.value})} className="w-full mt-2 p-4 bg-gray-50 border-none rounded-2xl text-sm font-bold focus:ring-2 focus:ring-blue-500 outline-none">
                                {GOVERNORATES.map(g => <option key={g}>{g}</option>)}
                            </select>
                        </div>

                        <div className="grid grid-cols-2 gap-4">
                            <div>
                                <label className="text-[10px] font-black text-gray-400 uppercase ml-1">Brand</label>
                                <select value={sellForm.brand} onChange={e => setSellForm({...sellForm, brand: e.target.value})} className="w-full mt-2 p-4 bg-gray-50 border-none rounded-2xl text-sm font-bold focus:ring-2 focus:ring-blue-500 outline-none">
                                    {BRANDS.map(b => <option key={b}>{b}</option>)}
                                </select>
                            </div>
                            <div>
                                <label className="text-[10px] font-black text-gray-400 uppercase ml-1">Size</label>
                                <select value={sellForm.size} onChange={e => setSellForm({...sellForm, size: e.target.value})} className="w-full mt-2 p-4 bg-gray-50 border-none rounded-2xl text-sm font-bold focus:ring-2 focus:ring-blue-500 outline-none">
                                    {SIZES.map(s => <option key={s}>{s}</option>)}
                                </select>
                            </div>
                        </div>

                        <div>
                            <label className="text-[10px] font-black text-gray-400 uppercase ml-1">WhatsApp Number</label>
                            <input type="tel" placeholder="+20" value={sellForm.contactNumber} onChange={e => setSellForm({...sellForm, contactNumber: e.target.value})} className="w-full mt-2 p-4 bg-gray-50 border-none rounded-2xl text-sm font-bold focus:ring-2 focus:ring-blue-500 outline-none" />
                        </div>

                        <div>
                            <label className="text-[10px] font-black text-gray-400 uppercase ml-1">Description</label>
                            <textarea placeholder="Describe the condition, usage, and special features..." rows="4" value={sellForm.description} onChange={e => setSellForm({...sellForm, description: e.target.value})} className="w-full mt-2 p-4 bg-gray-50 border-none rounded-2xl text-sm font-bold resize-none focus:ring-2 focus:ring-blue-500 outline-none" />
                        </div>
                    </div>
                </div>
            </div>

            <button onClick={handlePost} className="w-full py-5 bg-blue-600 text-white rounded-[24px] font-black text-sm shadow-xl active:scale-95 transition-all uppercase tracking-widest">Publish Listing</button>
        </div>
    );

    const renderMyItems = () => (
        <div className="p-6 animate-in space-y-8 text-left pb-24">
            <div className="flex items-center space-x-4">
                <button onClick={() => setView('home')} className="p-2.5 bg-gray-100 rounded-2xl active:scale-90 transition-transform"><ChevronLeft className="w-6 h-6" /></button>
                <h2 className="text-3xl font-black text-gray-900 tracking-tight">Your Listings</h2>
            </div>
            <div className="space-y-4">
                {myItems.map(item => (
                    <div key={item.id} className="bg-white p-5 rounded-[32px] shadow-lg border border-gray-50 flex items-center space-x-4">
                        <img src={item.photos[0]} className="w-20 h-20 rounded-2xl object-cover shadow-sm" />
                        <div className="flex-grow min-w-0">
                            <h3 className="font-black text-gray-900 truncate leading-tight">{item.title}</h3>
                            <p className="text-blue-600 font-bold text-sm mt-1">${item.price}</p>
                            <span className={`text-[9px] font-black uppercase px-2 py-0.5 rounded-full mt-2 inline-block ${item.status === 'sold' ? 'bg-red-50 text-red-600' : 'bg-emerald-50 text-emerald-600'}`}>{item.status}</span>
                        </div>
                        <div className="flex flex-col space-y-2">
                            {item.status !== 'sold' && (
                                <button onClick={() => handleMarkSold(item.id)} className="p-3 bg-emerald-50 text-emerald-600 rounded-2xl active:scale-90 transition-transform shadow-sm"><CheckCircle className="w-5 h-5" /></button>
                            )}
                            <button onClick={() => handleDelete(item.id)} className="p-3 bg-rose-50 text-rose-600 rounded-2xl active:scale-90 transition-transform shadow-sm"><Trash2 className="w-5 h-5" /></button>
                        </div>
                    </div>
                ))}
            </div>
        </div>
    );

    if (loading) return <div className="min-h-screen flex items-center justify-center bg-white font-black text-blue-600 animate-pulse uppercase tracking-[0.3em]">Swim 360</div>;

    return (
        <div className="max-w-md mx-auto min-h-screen bg-[#F8FAFC] font-sans text-gray-900 relative selection:bg-blue-100">
            {view === 'home' && renderHome()}
            {view === 'details' && renderDetails()}
            {view === 'sell' && renderSell()}
            {view === 'my-items' && renderMyItems()}

            {view === 'home' && (
                <button onClick={() => setView('sell')} className="fixed bottom-8 right-6 z-30 flex items-center space-x-2 bg-blue-600 text-white px-7 py-4 rounded-[28px] font-black shadow-2xl active:scale-90 transition-all border-4 border-white/20 uppercase text-xs tracking-widest">
                    <Plus className="w-6 h-6" /> <span>Sell</span>
                </button>
            )}

            {notification && (
                <div className={`fixed bottom-10 left-1/2 -translate-x-1/2 px-8 py-4 rounded-full text-[10px] font-black shadow-2xl z-[100] animate-bounce flex items-center space-x-2 uppercase tracking-widest ${notification.type === 'error' ? 'bg-red-600' : 'bg-gray-900'} text-white`}>
                    <span>{notification.msg}</span>
                </div>
            )}

            <style>{`
                @keyframes fadeIn { from { opacity: 0; transform: translateY(10px); } to { opacity: 1; transform: translateY(0); } }
                .animate-in { animation: fadeIn 0.4s cubic-bezier(0.16, 1, 0.3, 1) forwards; }
                .no-scrollbar::-webkit-scrollbar { display: none; }
                .no-scrollbar { -ms-overflow-style: none; scrollbar-width: none; }
            `}</style>
        </div>
    );
}