import React, { useState, useEffect, useMemo, useRef } from 'react';
import { initializeApp } from 'firebase/app';
import { getAuth, signInAnonymously, signInWithCustomToken, onAuthStateChanged } from 'firebase/auth';
import { getFirestore, doc, addDoc, deleteDoc, onSnapshot, collection, query, Timestamp, setDoc, updateDoc } from 'firebase/firestore';
import { 
  Search, Plus, Trash2, List, MapPin, 
  ChevronLeft, MessageSquare, MessageCircle, 
  ArrowLeft, ChevronRight, Share2, Star,
  ShoppingCart, Store, Tag, Info, Layers, Check, X, Maximize2
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
const STORE_DATA = [
    {
        id: 's1',
        name: 'Swim Gear Pro',
        photo: 'https://placehold.co/100x100/3b82f6/ffffff?text=SGP',
        banner: 'https://images.unsplash.com/photo-1519494026892-80bbd2d6fd0d?auto=format&fit=crop&q=80&w=800',
        location: 'Zamalek, Cairo',
        rating: 4.8,
        categories: ['Suits', 'Goggles', 'Training'],
        mostSold: ['Pro Racing Suit', 'Mirrored Goggles'],
        products: {
            'Suits': [
                { 
                    id: 'p1', 
                    name: 'Pro Racing Suit', 
                    price: 150.00, 
                    brand: 'Speedo', 
                    description: 'Elite FINA-approved suit for competitions. Maximizes hydrodynamics and muscle compression.', 
                    photos: [
                        'https://images.unsplash.com/photo-1552650272-b8a34e21bc4b?auto=format&fit=crop&q=80&w=800',
                        'https://images.unsplash.com/photo-1519494026892-80bbd2d6fd0d?auto=format&fit=crop&q=80&w=800'
                    ],
                    availableSizes: ['24', '26', '28', '30'],
                    availableColors: ['#000000', '#1e40af', '#ef4444'],
                    // Optional Size Guide Photo
                    sizeGuidePhoto: 'https://images.unsplash.com/photo-1581092160562-40aa08e78837?auto=format&fit=crop&q=80&w=800'
                },
                { 
                    id: 'p2', 
                    name: 'Practice Jammer', 
                    price: 45.00, 
                    brand: 'Arena', 
                    description: 'Durable chlorine-resistant material for daily training sessions.', 
                    photos: ['https://images.unsplash.com/photo-1606107557195-0e29a4b5b4aa?auto=format&fit=crop&q=80&w=800'],
                    availableSizes: ['28', '30', '32', '34'],
                    availableColors: ['#000000', '#111827'],
                    sizeGuidePhoto: null // Button will be disabled
                }
            ],
            'Goggles': [
                { 
                    id: 'p3', 
                    name: 'Mirrored Goggles', 
                    price: 25.00, 
                    brand: 'Zoggs', 
                    description: 'Mirrored lenses reduce glare for outdoor swimming. Soft-frame technology for comfort.', 
                    photos: [
                        'https://images.unsplash.com/photo-1552650272-b8a34e21bc4b?auto=format&fit=crop&q=80&w=800',
                        'https://images.unsplash.com/photo-1530549387634-e5a529577059?auto=format&fit=crop&q=80&w=800'
                    ],
                    availableSizes: ['One Size'],
                    availableColors: ['#94a3b8', '#3b82f6', '#ffd700'],
                    sizeGuidePhoto: null
                }
            ],
            'Training': [
                { 
                    id: 'p4', 
                    name: 'Foam Kickboard', 
                    price: 15.00, 
                    brand: 'TYR', 
                    description: 'High-density foam for improved leg strength and focus.', 
                    photos: ['https://images.unsplash.com/photo-1519494026892-80bbd2d6fd0d?auto=format&fit=crop&q=80&w=800'],
                    availableSizes: ['Standard'],
                    availableColors: ['#3b82f6'],
                    sizeGuidePhoto: null
                }
            ]
        }
    }
];

// --- COMPONENTS ---

const PhotoCarousel = ({ photos }) => {
    const [activeIndex, setActiveIndex] = useState(0);
    const scrollRef = useRef(null);

    const handleScroll = (e) => {
        const scrollPos = e.target.scrollLeft;
        const width = e.target.offsetWidth;
        const index = Math.round(scrollPos / width);
        setActiveIndex(index);
    };

    return (
        <div className="relative aspect-square bg-gray-100 overflow-hidden">
            <div 
                ref={scrollRef}
                onScroll={handleScroll}
                className="flex overflow-x-auto snap-x snap-mandatory no-scrollbar h-full scroll-smooth"
            >
                {photos.map((src, i) => (
                    <div key={i} className="flex-shrink-0 w-full h-full snap-center">
                        <img src={src} className="w-full h-full object-cover" alt={`Product ${i}`} />
                    </div>
                ))}
            </div>
            {photos.length > 1 && (
                <div className="absolute bottom-6 left-1/2 -translate-x-1/2 flex space-x-1.5 px-3 py-1.5 bg-black/20 backdrop-blur-md rounded-full z-10">
                    {photos.map((_, i) => (
                        <div key={i} className={`h-1.5 rounded-full transition-all duration-300 ${activeIndex === i ? 'bg-white w-4' : 'bg-white/50 w-1.5'}`} />
                    ))}
                </div>
            )}
        </div>
    );
};

// --- Main App ---
export default function App() {
    const [view, setView] = useState('home'); 
    const [selectedStore, setSelectedStore] = useState(null);
    const [selectedProduct, setSelectedProduct] = useState(null);
    const [cart, setCart] = useState([]);
    
    const [userId, setUserId] = useState(null);
    const [loading, setLoading] = useState(true);
    const [notification, setNotification] = useState(null);

    const [selectedSize, setSelectedSize] = useState(null);
    const [selectedColor, setSelectedColor] = useState(null);

    // Modal state for Size Guide
    const [sizeGuideModalPhoto, setSizeGuideModalPhoto] = useState(null);

    const storeProfileRef = useRef(null);

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

    const showNotify = (msg, type = 'success') => {
        setNotification({ msg, type });
        setTimeout(() => setNotification(null), 3000);
    };

    const addToCart = (product) => {
        if (product.availableSizes && !selectedSize) {
            showNotify("Please select a size", "error");
            return;
        }
        if (product.availableColors && !selectedColor) {
            showNotify("Please select a color", "error");
            return;
        }
        setCart([...cart, { ...product, selectedSize, selectedColor }]);
        showNotify(`Added ${product.name} to basket`);
    };

    const scrollToCategory = (catId) => {
        const element = document.getElementById(`category-section-${catId}`);
        if (element) {
            const yOffset = -60; 
            const y = element.getBoundingClientRect().top + window.pageYOffset + yOffset;
            window.scrollTo({ top: y, behavior: 'smooth' });
        }
    };

    // --- VIEW RENDERERS ---

    const renderStoresList = () => (
        <div className="p-5 space-y-8 animate-in text-left">
            <div className="space-y-1">
                <h1 className="text-3xl font-black text-gray-900 tracking-tight">Marketplace</h1>
                <p className="text-sm text-gray-400 font-medium">Shop official gear from top retailers</p>
            </div>
            
            <div className="space-y-5">
                {STORE_DATA.map(store => (
                    <div key={store.id} 
                         onClick={() => { setSelectedStore(store); setView('store-profile'); }}
                         className="bg-white rounded-[32px] overflow-hidden shadow-xl shadow-gray-200/50 border border-white group active:scale-[0.98] transition-all cursor-pointer">
                        <div className="h-40 bg-gray-100 relative">
                            <img src={store.banner} className="w-full h-full object-cover" alt={store.name} />
                            <div className="absolute inset-0 bg-gradient-to-t from-black/80 via-black/20 to-transparent"></div>
                            <div className="absolute bottom-4 left-5 flex items-center space-x-3">
                                <div className="w-14 h-14 rounded-2xl bg-white p-1 shadow-2xl border-2 border-white/50">
                                    <img src={store.photo} className="w-full h-full object-cover rounded-xl" alt="logo" />
                                </div>
                                <div>
                                    <h3 className="text-white font-black text-xl leading-none">{store.name}</h3>
                                    <div className="flex items-center text-blue-200 text-[10px] font-black uppercase tracking-widest mt-1.5 opacity-90">
                                        <Star className="w-3 h-3 mr-1 text-amber-400 fill-amber-400" /> {store.rating} • {store.location}
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div className="p-5 flex items-center space-x-2 overflow-hidden bg-white">
                            <span className="text-[10px] font-black text-gray-400 uppercase tracking-widest mr-2 flex-shrink-0">Picks:</span>
                            {store.mostSold.map(tag => (
                                <span key={tag} className="px-3 py-1 bg-blue-50 text-blue-600 rounded-lg text-[9px] font-black uppercase whitespace-nowrap">{tag}</span>
                            ))}
                        </div>
                    </div>
                ))}
            </div>
        </div>
    );

    const renderStoreProfile = () => (
        <div ref={storeProfileRef} className="flex flex-col bg-white min-h-screen pb-32 animate-in text-left">
            <div className="relative h-56">
                <img src={selectedStore.banner} className="w-full h-full object-cover" alt="banner" />
                <div className="absolute inset-0 bg-black/40 backdrop-blur-[2px]"></div>
                <button onClick={() => setView('home')} className="absolute top-12 left-5 p-2.5 bg-white/20 backdrop-blur-xl rounded-2xl text-white active:scale-90 transition-transform">
                    <ChevronLeft className="w-6 h-6" />
                </button>
                <div className="absolute -bottom-8 left-8 w-24 h-24 bg-white p-1.5 rounded-[32px] shadow-2xl border-4 border-white">
                    <img src={selectedStore.photo} className="w-full h-full object-cover rounded-[24px]" alt="logo" />
                </div>
            </div>

            <div className="pt-14 px-6 space-y-8">
                <div className="flex justify-between items-start">
                    <div className="space-y-1">
                        <h1 className="text-3xl font-black text-gray-900 tracking-tight leading-none">{selectedStore.name}</h1>
                        <p className="text-sm font-bold text-blue-600 uppercase tracking-widest pt-1 flex items-center">
                            <MapPin className="w-3.5 h-3.5 mr-1.5" /> {selectedStore.location}
                        </p>
                    </div>
                    <div className="bg-emerald-50 px-4 py-2 rounded-2xl flex items-center shadow-sm">
                        <Star className="w-4 h-4 text-emerald-600 fill-emerald-600 mr-1.5" />
                        <span className="text-sm font-black text-emerald-700">{selectedStore.rating}</span>
                    </div>
                </div>

                <div className="flex space-x-2 overflow-x-auto no-scrollbar py-2.5 sticky top-0 bg-white/95 backdrop-blur-md z-10 border-b border-gray-50">
                    {selectedStore.categories.map(cat => (
                        <button 
                            key={cat} 
                            onClick={() => scrollToCategory(cat)}
                            className="px-5 py-2.5 bg-gray-50 border border-gray-100 rounded-2xl text-[10px] font-black uppercase tracking-widest text-gray-500 hover:bg-blue-600 hover:text-white active:scale-95 transition-all whitespace-nowrap"
                        >
                            {cat}
                        </button>
                    ))}
                </div>

                <div className="space-y-10 pb-10">
                    {Object.entries(selectedStore.products).map(([cat, prods]) => (
                        <div key={cat} id={`category-section-${cat}`} className="space-y-4 scroll-mt-20">
                            <h3 className="text-[10px] font-black text-blue-600 uppercase tracking-[0.2em] ml-2 flex items-center">
                                <span className="w-1.5 h-1.5 bg-blue-600 rounded-full mr-2"></span>
                                {cat}
                            </h3>
                            {prods.map(prod => (
                                <div key={prod.id} 
                                     onClick={() => { setSelectedProduct(prod); setSelectedSize(null); setSelectedColor(null); setView('store-product-details'); }}
                                     className="flex items-center p-4 bg-white rounded-[32px] border border-gray-50 shadow-sm hover:shadow-xl transition-all cursor-pointer group">
                                    <div className="w-24 h-24 rounded-3xl bg-gray-100 overflow-hidden mr-4">
                                        <img src={prod.photos[0]} className="w-full h-full object-cover group-hover:scale-110 transition-transform duration-700" alt="product" />
                                    </div>
                                    <div className="flex-grow">
                                        <h4 className="font-black text-gray-900 leading-tight text-lg">{prod.name}</h4>
                                        <p className="text-xs text-gray-400 font-medium line-clamp-1 mt-1">{prod.description}</p>
                                        <p className="text-xl font-black text-blue-600 mt-2">${prod.price}</p>
                                    </div>
                                    <div className="w-10 h-10 rounded-2xl bg-gray-50 text-gray-300 flex items-center justify-center group-hover:bg-blue-600 group-hover:text-white transition-all">
                                        <ChevronRight className="w-6 h-6" />
                                    </div>
                                </div>
                            ))}
                        </div>
                    ))}
                </div>
            </div>
        </div>
    );

    const renderProductDetails = () => (
        <div className="flex flex-col bg-white min-h-screen pb-32 animate-in text-left">
            <div className="relative">
                <button onClick={() => setView('store-profile')} className="absolute top-12 left-5 z-20 p-2.5 bg-black/20 backdrop-blur-xl rounded-2xl text-white active:scale-90 transition-transform">
                    <ChevronLeft className="w-6 h-6" />
                </button>
                <PhotoCarousel photos={selectedProduct.photos} />
            </div>

            <div className="p-7 space-y-8">
                <div className="space-y-2">
                    <span className="px-3 py-1 bg-blue-50 text-blue-600 rounded-lg text-[9px] font-black uppercase tracking-widest">{selectedProduct.brand}</span>
                    <h1 className="text-3xl font-black text-gray-900 tracking-tight leading-tight">{selectedProduct.name}</h1>
                    <p className="text-4xl font-black text-blue-600 pt-2 tracking-tighter">${selectedProduct.price}</p>
                </div>

                {selectedProduct.availableSizes && (
                    <div className="space-y-4">
                        <div className="flex justify-between items-center">
                            <h2 className="text-xs font-black text-gray-400 uppercase tracking-[0.2em]">Select Size</h2>
                            
                            {/* SIZE GUIDE BUTTON: CONDITIONAL LOGIC */}
                            <button 
                                onClick={(e) => {
                                    e.stopPropagation();
                                    if (selectedProduct.sizeGuidePhoto) setSizeGuideModalPhoto(selectedProduct.sizeGuidePhoto);
                                }}
                                disabled={!selectedProduct.sizeGuidePhoto}
                                className={`text-[10px] font-bold underline transition-colors ${selectedProduct.sizeGuidePhoto ? 'text-blue-600 hover:text-blue-800' : 'text-gray-300 cursor-not-allowed'}`}
                            >
                                Size Guide
                            </button>
                        </div>
                        <div className="flex flex-wrap gap-2">
                            {selectedProduct.availableSizes.map(size => (
                                <button 
                                    key={size}
                                    onClick={() => setSelectedSize(size)}
                                    className={`px-6 py-3 rounded-2xl text-sm font-black transition-all ${selectedSize === size ? 'bg-blue-600 text-white shadow-lg shadow-blue-100' : 'bg-gray-50 text-gray-500 hover:bg-gray-100'}`}
                                >
                                    {size}
                                </button>
                            ))}
                        </div>
                    </div>
                )}

                {selectedProduct.availableColors && (
                    <div className="space-y-4">
                        <h2 className="text-xs font-black text-gray-400 uppercase tracking-[0.2em]">Available Colors</h2>
                        <div className="flex flex-wrap gap-4">
                            {selectedProduct.availableColors.map(color => (
                                <button 
                                    key={color}
                                    onClick={() => setSelectedColor(color)}
                                    className={`w-10 h-10 rounded-full border-4 transition-all flex items-center justify-center ${selectedColor === color ? 'border-blue-600 scale-110 shadow-lg' : 'border-transparent'}`}
                                    style={{ backgroundColor: color }}
                                >
                                    {selectedColor === color && <Check className={`w-5 h-5 ${color === '#ffffff' ? 'text-gray-900' : 'text-white'}`} />}
                                </button>
                            ))}
                        </div>
                    </div>
                )}

                <div className="space-y-3 pt-4">
                    <h2 className="text-xs font-black text-gray-400 uppercase tracking-[0.2em]">About this item</h2>
                    <p className="text-sm text-gray-600 leading-relaxed font-medium">{selectedProduct.description}</p>
                </div>
            </div>

            <div className="fixed bottom-0 left-0 right-0 p-8 bg-white/95 backdrop-blur-xl border-t border-gray-100 max-w-md mx-auto rounded-t-[44px] shadow-2xl z-40">
                <button 
                    onClick={() => addToCart(selectedProduct)}
                    className="w-full flex items-center justify-center py-5 bg-blue-600 text-white rounded-[24px] font-black text-sm shadow-xl shadow-blue-100 active:scale-95 transition-all tracking-[0.2em] uppercase">
                    <ShoppingCart className="w-6 h-6 mr-3" />
                    Add to Basket
                </button>
            </div>
        </div>
    );

    if (loading) return <div className="min-h-screen flex items-center justify-center bg-white font-black text-blue-600 animate-pulse uppercase tracking-[0.3em]">Swim 360</div>;

    return (
        <div className="max-w-md mx-auto min-h-screen bg-[#F8FAFC] font-sans text-gray-900 relative selection:bg-blue-100">
            {view === 'home' && renderStoresList()}
            {view === 'store-profile' && renderStoreProfile()}
            {view === 'store-product-details' && renderProductDetails()}

            {cart.length > 0 && view !== 'store-product-details' && (
                <button 
                    onClick={() => showNotify(`Checking out ${cart.length} items...`)} 
                    className="fixed bottom-8 right-6 z-30 flex items-center space-x-3 bg-blue-600 text-white px-7 py-4 rounded-[28px] font-black shadow-2xl active:scale-90 transition-all border-4 border-white/20 uppercase text-xs tracking-widest"
                >
                    <ShoppingCart className="w-6 h-6" /> 
                    <span>Basket ({cart.length})</span>
                </button>
            )}

            {/* SIZE GUIDE MODAL OVERLAY */}
            {sizeGuideModalPhoto && (
                <div className="fixed inset-0 z-[100] flex items-center justify-center p-6 bg-black/90 backdrop-blur-md animate-in">
                    <button 
                        onClick={() => setSizeGuideModalPhoto(null)}
                        className="absolute top-12 right-6 p-3 bg-white/20 rounded-full text-white active:scale-90 transition-transform"
                    >
                        <X className="w-6 h-6" />
                    </button>
                    <div className="w-full max-w-sm space-y-6">
                        <div className="bg-white rounded-[32px] overflow-hidden shadow-2xl relative">
                            <img src={sizeGuideModalPhoto} className="w-full h-auto object-contain" alt="Size Guide" />
                            <div className="p-4 bg-gray-50 flex items-center justify-center">
                                <span className="text-[10px] font-black text-gray-400 uppercase tracking-widest">Pinch to zoom for details</span>
                            </div>
                        </div>
                        <button 
                            onClick={() => setSizeGuideModalPhoto(null)}
                            className="w-full py-4 bg-white text-gray-900 rounded-[20px] font-black text-sm tracking-widest uppercase shadow-xl"
                        >
                            Got it
                        </button>
                    </div>
                </div>
            )}

            {notification && (
                <div className={`fixed bottom-10 left-1/2 -translate-x-1/2 px-8 py-4 rounded-full text-[10px] font-black shadow-2xl z-[100] animate-bounce flex items-center space-x-2 uppercase tracking-widest ${notification.type === 'error' ? 'bg-red-600' : 'bg-gray-900'} text-white`}>
                    <span>{notification.msg}</span>
                </div>
            )}

            <style>{`
                @keyframes fadeIn { from { opacity: 0; transform: translateY(15px); } to { opacity: 1; transform: translateY(0); } }
                .animate-in { animation: fadeIn 0.4s cubic-bezier(0.16, 1, 0.3, 1) forwards; }
                .no-scrollbar::-webkit-scrollbar { display: none; }
                .no-scrollbar { -ms-overflow-style: none; scrollbar-width: none; }
                .line-clamp-1 { display: -webkit-box; -webkit-line-clamp: 1; -webkit-box-orient: vertical; overflow: hidden; }
                .scroll-mt-20 { scroll-margin-top: 80px; }
            `}</style>
        </div>
    );
}