import React, { useState, useEffect, useCallback, useMemo } from 'react';
import { initializeApp } from 'firebase/app';
import { getAuth, signInAnonymously, signInWithCustomToken, onAuthStateChanged } from 'firebase/auth';
import { getFirestore, doc, addDoc, deleteDoc, onSnapshot, collection, query, where, Timestamp, setDoc, updateDoc } from 'firebase/firestore';
import { Search, Filter, Plus, Home, Trash2, List, Phone, UploadCloud, X, Waves, CheckCircle } from 'lucide-react';

// --- Global Context/Setup (Mandatory Canvas Variables) ---
const appId = typeof __app_id !== 'undefined' ? __app_id : 'default-app-id';
const firebaseConfig = typeof __firebase_config !== 'undefined' ? JSON.parse(__firebase_config) : {};
const initialAuthToken = typeof __initial_auth_token !== 'undefined' ? __initial_auth_token : null;

// Helper to safely initialize Firebase
let app, db, auth;
if (Object.keys(firebaseConfig).length) {
    app = initializeApp(firebaseConfig);
    db = getFirestore(app);
    auth = getAuth(app);
    // setLogLevel('debug'); // Uncomment to see Firebase logs
}

// --- Constants ---
const PUBLIC_COLLECTION_PATH = `artifacts/${appId}/public/data/usedItems`;

// --- TEST DATA (Swimming Context) ---
const TEST_ITEMS = [
    {
        id: 'test-1',
        title: 'New Racing Goggles (Anti-Fog)',
        description: 'Brand new, never used FINA-approved racing goggles. Excellent peripheral vision and UV protection. Comes with three nose pieces.',
        condition: 'New',
        size: 'Adjustable',
        price: 35.99,
        contactNumber: '1234567890',
        photos: ['https://placehold.co/600x600/10b981/ffffff?text=GOGGLES'],
        postedBy: 'test-user-1',
        status: 'available',
        createdAt: Timestamp.fromDate(new Date(Date.now() - 86400000))
    },
    {
        id: 'test-2',
        title: 'Children\'s Mermaid Swim Fin',
        description: 'Monofin suitable for kids aged 8-12. Great for pool practice and building leg strength. Used only a few times, excellent condition.',
        condition: 'Used - Excellent',
        size: 'Youth (8-12)',
        price: 20.00,
        contactNumber: '9876543210',
        photos: ['https://placehold.co/600x600/6366f9/ffffff?text=SWIM+FIN'],
        postedBy: 'test-user-2',
        status: 'available',
        createdAt: Timestamp.fromDate(new Date(Date.now() - 172800000))
    },
];

// Custom Modal Component to replace alert/confirm
const CustomModal = ({ title, message, isOpen, onClose, onConfirm }) => {
    if (!isOpen) return null;

    return (
        <div className="fixed inset-0 bg-gray-900 bg-opacity-70 flex items-center justify-center p-4 z-50 transition-opacity duration-300">
            <div className="bg-white rounded-xl shadow-2xl w-full max-w-sm p-6 transform transition-all duration-300 scale-100">
                <h3 className="text-xl font-bold text-gray-900 mb-3">{title}</h3>
                <p className="text-gray-600 mb-6">{message}</p>
                <div className="flex justify-end space-x-3">
                    {onConfirm && (
                        <button
                            onClick={onConfirm}
                            className="px-4 py-2 bg-red-600 text-white font-semibold rounded-lg hover:bg-red-700 transition duration-150 shadow-md"
                        >
                            Confirm
                        </button>
                    )}
                    <button
                        onClick={onClose}
                        className={`px-4 py-2 font-semibold rounded-lg transition duration-150 shadow-md ${onConfirm ? 'bg-gray-200 text-gray-800 hover:bg-gray-300' : 'bg-emerald-600 text-white hover:bg-emerald-700'}`}
                    >
                        {onConfirm ? 'Cancel' : 'Close'}
                    </button>
                </div>
            </div>
        </div>
    );
};

// --- App Component ---
export default function App() {
    const [view, setView] = useState('home'); // 'home', 'details', 'sell', 'my-items'
    const [items, setItems] = useState([]);
    const [myItems, setMyItems] = useState([]);
    const [selectedItem, setSelectedItem] = useState(null);
    const [isAuthReady, setIsAuthReady] = useState(false);
    const [userId, setUserId] = useState(null);
    const [loading, setLoading] = useState(true);

    // Filter/Search State
    const [searchTerm, setSearchTerm] = useState('');
    const [filters, setFilters] = useState({ size: '', condition: '', maxPrice: '' });
    const [showFilters, setShowFilters] = useState(false);

    // Modal State
    const [isModalOpen, setIsModalOpen] = useState(false);
    const [modalConfig, setModalConfig] = useState({});

    // 1. Firebase Initialization and Authentication
    useEffect(() => {
        if (!auth) {
            console.error("Firebase Auth not initialized.");
            setLoading(false);
            return;
        }

        const initializeAuth = async () => {
            try {
                if (initialAuthToken) {
                    await signInWithCustomToken(auth, initialAuthToken);
                } else {
                    await signInAnonymously(auth);
                }
            } catch (error) {
                console.error("Firebase Auth error:", error);
            }
        };

        const unsubscribe = onAuthStateChanged(auth, (user) => {
            setUserId(user ? user.uid : null);
            setIsAuthReady(true);
            setLoading(false);
        });

        initializeAuth();
        return () => unsubscribe();
    }, []);

    // 2. Fetch All Items (Public Collection)
    useEffect(() => {
        if (!db || !isAuthReady) return;

        const itemsRef = collection(db, PUBLIC_COLLECTION_PATH);
        // Using onSnapshot to listen for real-time changes
        const unsubscribe = onSnapshot(itemsRef, (snapshot) => {
            const fetchedItems = snapshot.docs.map(doc => ({
                id: doc.id,
                ...doc.data()
            }));

            // Merge test items with fetched items, prioritizing fetched items if IDs collide
            const allItems = [...TEST_ITEMS.filter(testItem => !fetchedItems.find(f => f.id === testItem.id)), ...fetchedItems];
            
            setItems(allItems);
        }, (error) => {
            console.error("Error fetching items, falling back to test data:", error);
            setItems(TEST_ITEMS);
        });

        return () => unsubscribe();
    }, [db, isAuthReady]);

    // 3. Filter My Items (Logic remains dependent on items and userId)
    useEffect(() => {
        if (!userId) {
            setMyItems([]);
            return;
        }
        // Filter the public items array for 'My Items' view
        const userItems = items.filter(item => item.postedBy === userId);
        setMyItems(userItems);
    }, [items, userId]);

    // 4. Handle Deletion
    const handleDelete = (itemId) => {
        // Prevent deletion of test items
        if (itemId.startsWith('test-')) {
            setModalConfig({ title: "Error", message: "Cannot delete built-in test items.", onClose: () => setIsModalOpen(false) });
            setIsModalOpen(true);
            return;
        }

        setModalConfig({
            title: "Confirm Deletion",
            message: "Are you sure you want to delete this item? This action cannot be undone.",
            onConfirm: async () => {
                setIsModalOpen(false);
                if (!db) return;

                try {
                    await deleteDoc(doc(db, PUBLIC_COLLECTION_PATH, itemId));
                } catch (error) {
                    console.error("Error deleting item:", error);
                    setModalConfig({ title: "Error", message: "Failed to delete item. Please try again.", onClose: () => setIsModalModal(false) });
                    setIsModalOpen(true);
                }
            },
            onClose: () => setIsModalOpen(false)
        });
        setIsModalOpen(true);
    };

    // 5. Handle Mark as Sold (NEW)
    const handleMarkAsSold = (itemId) => {
        setModalConfig({
            title: "Mark as Sold",
            message: "Confirm marking this item as 'Sold'. It will still appear in your list but will be marked as unavailable.",
            onConfirm: async () => {
                setIsModalOpen(false);
                if (!db) return;

                try {
                    const itemRef = doc(db, PUBLIC_COLLECTION_PATH, itemId);
                    await updateDoc(itemRef, { status: 'sold' });
                } catch (error) {
                    console.error("Error updating item status:", error);
                    setModalConfig({ title: "Error", message: "Failed to update item status. Please try again.", onClose: () => setIsModalOpen(false) });
                    setIsModalOpen(true);
                }
            },
            onClose: () => setIsModalOpen(false)
        });
        setIsModalOpen(true);
    };

    // 6. Filtered Items Logic (Client-Side filtering)
    const filteredItems = useMemo(() => {
        let currentItems = items.filter(item => item.status !== 'sold'); // Only show available items in the main feed

        // Apply Search Term (Title or Description)
        if (searchTerm) {
            const lowerSearch = searchTerm.toLowerCase();
            currentItems = currentItems.filter(item =>
                item.title.toLowerCase().includes(lowerSearch) ||
                item.description.toLowerCase().includes(lowerSearch)
            );
        }

        // Apply Filters
        if (filters.condition) {
            currentItems = currentItems.filter(item => item.condition === filters.condition);
        }
        if (filters.size) {
            currentItems = currentItems.filter(item => item.size === filters.size);
        }
        if (filters.maxPrice) {
            const max = parseFloat(filters.maxPrice);
            if (!isNaN(max) && max > 0) {
                currentItems = currentItems.filter(item => item.price <= max);
            }
        }

        // Sort by creation date (newest first)
        return currentItems.sort((a, b) => (b.createdAt?.toDate() || 0) - (a.createdAt?.toDate() || 0));
    }, [items, searchTerm, filters]);

    // 7. WhatsApp Link Generator
    const generateWhatsAppLink = (item) => {
        const message = `Is this item still available? Regarding the item: ${item.title}`;
        return `https://wa.me/${item.contactNumber}?text=${encodeURIComponent(message)}`;
    };
    
    // --- Sub-Components (Views) ---

    // Item Card Component (Square Shape Update retained)
    const ItemCard = ({ item }) => (
        <div className="bg-white rounded-xl shadow-lg hover:shadow-xl transition-shadow duration-300 flex flex-col overflow-hidden transform hover:scale-[1.02] cursor-pointer"
             onClick={() => { setSelectedItem(item); setView('details'); }}>
            {/* Aspect Ratio 1:1 for the photo */}
            <div className="w-full aspect-square bg-gray-100 overflow-hidden relative">
                <img
                    src={item.photos[0] || "https://placehold.co/600x600/10b981/ffffff?text=SWIM+ITEM"}
                    alt={item.title}
                    className="w-full h-full object-cover"
                    onError={(e) => { e.target.onerror = null; e.target.src = "https://placehold.co/600x600/10b981/ffffff?text=SWIM+ITEM"; }}
                />
            </div>
            <div className="p-4 flex flex-col flex-grow">
                <h3 className="text-lg font-semibold text-gray-900 truncate mb-1">{item.title}</h3>
                <p className="text-xl font-bold text-emerald-600 mb-3">${item.price.toFixed(2)}</p>
                <button
                    onClick={(e) => { e.stopPropagation(); setSelectedItem(item); setView('details'); }}
                    className="mt-auto bg-emerald-500 text-white py-2 rounded-lg font-medium hover:bg-emerald-600 transition duration-150 shadow-md"
                >
                    See More
                </button>
            </div>
        </div>
    );

    // Home View Component (Swimming Filter Update retained)
    const HomeView = () => {
        const allConditions = Array.from(new Set(items.map(i => i.condition))).filter(Boolean);
        const uniqueSizes = Array.from(new Set(items.map(i => i.size))).filter(Boolean);
        const commonSizes = ['S', 'M', 'L', 'XL', 'Adjustable', 'Shoe Size 7', 'Shoe Size 10', 'Youth'];
        const allSizes = Array.from(new Set([...commonSizes, ...uniqueSizes])).sort();

        return (
            <div className="p-4 md:p-8">
                <h1 className="text-3xl font-extrabold text-gray-900 mb-6 text-center flex items-center justify-center">
                    <Waves className="h-8 w-8 text-blue-500 mr-2" />
                    Used Swimming Gear
                </h1>

                {/* Search Bar */}
                <div className="flex flex-col md:flex-row items-stretch md:items-center space-y-3 md:space-y-0 md:space-x-3 mb-6 bg-white p-4 rounded-xl shadow-md">
                    <div className="relative flex-grow">
                        <input
                            type="text"
                            placeholder="Search goggles, fins, swimsuits..."
                            value={searchTerm}
                            onChange={(e) => setSearchTerm(e.target.value)}
                            className="w-full pl-10 pr-4 py-3 border border-gray-300 rounded-lg focus:ring-emerald-500 focus:border-emerald-500 transition duration-150"
                        />
                        <Search className="absolute left-3 top-1/2 transform -translate-y-1/2 h-5 w-5 text-gray-400" />
                    </div>
                    <button
                        onClick={() => setShowFilters(!showFilters)}
                        className="flex items-center justify-center p-3 bg-gray-100 text-gray-700 rounded-lg hover:bg-gray-200 transition duration-150 shadow-sm"
                    >
                        <Filter className="h-5 w-5 mr-2" />
                        {showFilters ? 'Hide Filters' : 'Show Filters'}
                    </button>
                </div>

                {/* Filter Section (Collapsible) */}
                <div className={`transition-all duration-300 overflow-hidden ${showFilters ? 'max-h-96 opacity-100 mb-6' : 'max-h-0 opacity-0 mb-0'}`}>
                    <div className="grid grid-cols-1 sm:grid-cols-3 gap-4 bg-white p-4 rounded-xl shadow-md border border-gray-100">
                        {/* Condition Filter */}
                        <select
                            value={filters.condition}
                            onChange={(e) => setFilters(f => ({ ...f, condition: e.target.value }))}
                            className="p-3 border border-gray-300 rounded-lg focus:ring-emerald-500 focus:border-emerald-500"
                        >
                            <option value="">Filter by Condition (All)</option>
                            {allConditions.map(c => <option key={c} value={c}>{c}</option>)}
                        </select>

                        {/* Size Filter */}
                        <select
                            value={filters.size}
                            onChange={(e) => setFilters(f => ({ ...f, size: e.target.value }))}
                            className="p-3 border border-gray-300 rounded-lg focus:ring-emerald-500 focus:border-emerald-500"
                        >
                            <option value="">Filter by Size (All)</option>
                            {allSizes.map(s => <option key={s} value={s}>{s}</option>)}
                        </select>

                        {/* Price Filter */}
                        <input
                            type="number"
                            placeholder="Max Price (USD)"
                            value={filters.maxPrice}
                            onChange={(e) => setFilters(f => ({ ...f, maxPrice: e.target.value }))}
                            className="p-3 border border-gray-300 rounded-lg focus:ring-emerald-500 focus:border-emerald-500"
                        />
                    </div>
                </div>

                {/* Item Grid */}
                {loading ? (
                    <div className="text-center py-12 text-gray-500">Loading items...</div>
                ) : filteredItems.length === 0 ? (
                    <div className="text-center py-12 text-gray-500 bg-white p-8 rounded-xl shadow-lg">
                        No items match your search criteria.
                    </div>
                ) : (
                    <div className="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-6">
                        {filteredItems.map(item => (
                            <ItemCard key={item.id} item={item} />
                        ))}
                    </div>
                )}
            </div>
        );
    };

    // Item Detail View Component (Multi-Photo Display NEW)
    const ItemDetailView = ({ item }) => {
        const [mainPhoto, setMainPhoto] = useState(item.photos[0] || "https://placehold.co/600x600/10b981/ffffff?text=SWIM+ITEM");
        
        useEffect(() => {
            // Ensure main photo is reset if the item changes
            setMainPhoto(item.photos[0] || "https://placehold.co/600x600/10b981/ffffff?text=SWIM+ITEM");
        }, [item]);

        return (
            <div className="p-4 md:p-8 max-w-4xl mx-auto">
                <button
                    onClick={() => setView('home')}
                    className="mb-6 flex items-center text-emerald-600 hover:text-emerald-800 transition duration-150 font-semibold"
                >
                    <Home className="h-5 w-5 mr-2" /> Back to Listings
                </button>

                <div className="bg-white rounded-xl shadow-2xl overflow-hidden p-6 md:p-8">
                    <h1 className="text-3xl md:text-4xl font-extrabold text-gray-900 mb-6">{item.title}</h1>

                    {/* Main Photo */}
                    <div className="w-full aspect-[4/3] bg-gray-100 overflow-hidden mb-4 rounded-xl shadow-lg">
                        <img
                            src={mainPhoto}
                            alt={item.title}
                            className="w-full h-full object-cover"
                            onError={(e) => { e.target.onerror = null; e.target.src = "https://placehold.co/800x600/ef4444/ffffff?text=Load+Error"; }}
                        />
                    </div>

                    {/* Thumbnail Gallery (Up to 10 photos) */}
                    {item.photos && item.photos.length > 0 && (
                        <div className="grid grid-cols-5 sm:grid-cols-7 md:grid-cols-10 gap-2 mb-8">
                            {item.photos.slice(0, 10).map((photoBase64, index) => (
                                <button
                                    key={index}
                                    onClick={() => setMainPhoto(photoBase64)}
                                    className={`relative aspect-square rounded-lg overflow-hidden transition duration-150 transform hover:scale-105 ${photoBase64 === mainPhoto ? 'ring-4 ring-emerald-500' : 'ring-1 ring-gray-300'}`}
                                >
                                    <img
                                        src={photoBase64}
                                        alt={`Thumbnail ${index + 1}`}
                                        className="w-full h-full object-cover"
                                        onError={(e) => { e.target.onerror = null; e.target.src = "https://placehold.co/60x60/ef4444/ffffff?text=Err"; }}
                                    />
                                </button>
                            ))}
                        </div>
                    )}


                    <div className="grid grid-cols-1 md:grid-cols-3 gap-6 mb-8 items-center bg-emerald-50 p-4 rounded-xl border-l-4 border-emerald-600">
                        <div>
                            <p className="text-sm font-medium text-gray-600">Price</p>
                            <p className="text-3xl font-bold text-emerald-700">${item.price.toFixed(2)}</p>
                        </div>
                        <div>
                            <p className="text-sm font-medium text-gray-600">Condition</p>
                            <p className="text-lg font-semibold text-gray-900">{item.condition}</p>
                        </div>
                        <div>
                            <p className="text-sm font-medium text-gray-600">Size</p>
                            <p className="text-lg font-semibold text-gray-900">{item.size || 'N/A'}</p>
                        </div>
                    </div>

                    <h2 className="text-2xl font-bold text-gray-900 mb-3 border-b pb-2">Description</h2>
                    <p className="text-gray-700 mb-8 whitespace-pre-wrap">{item.description}</p>

                    {/* Contact Seller Button (WhatsApp) */}
                    <a
                        href={generateWhatsAppLink(item)}
                        target="_blank"
                        rel="noopener noreferrer"
                        className="w-full flex items-center justify-center py-3 bg-green-600 text-white font-bold rounded-lg text-lg hover:bg-green-700 transition duration-150 shadow-lg"
                    >
                        <Phone className="h-6 w-6 mr-3" />
                        Contact Seller (WhatsApp)
                    </a>
                    <p className="mt-2 text-center text-sm text-gray-500">Contact Number: {item.contactNumber}</p>
                </div>
            </div>
        );
    };

    // Sell Item Form Component
    const SellItemForm = () => {
        const [formData, setFormData] = useState({
            title: '',
            description: '',
            condition: 'Used - Good',
            size: '',
            price: '',
            contactNumber: '',
            status: 'available' // New default status
        });
        const [photosBase64, setPhotosBase64] = useState([]);
        const [isSubmitting, setIsSubmitting] = useState(false);

        const conditions = ['New', 'Used - Like New', 'Used - Excellent', 'Used - Good', 'Used - Fair', 'For Parts'];

        const handleChange = (e) => {
            const { name, value } = e.target;
            setFormData(f => ({ ...f, [name]: value }));
        };
        
        // --- Photo Upload Handler (Converts File to Base64) ---
        const handleImageUpload = async (e) => {
            const files = Array.from(e.target.files).slice(0, 10); // Limit to 10 files
            
            if (files.length === 0) return;

            const base64Promises = files.map(file => {
                return new Promise((resolve, reject) => {
                    // Check file size (5MB limit per image)
                    if (file.size > 1024 * 1024 * 5) { 
                        console.warn(`File ${file.name} is too large and will be skipped.`);
                        return resolve(null);
                    }
                    const reader = new FileReader();
                    reader.onload = () => resolve(reader.result);
                    reader.onerror = error => {
                        console.error("Error reading file:", error);
                        reject(null);
                    };
                    reader.readAsDataURL(file); // Converts file to data:image/png;base64,...
                });
            });

            const newBase64Photos = (await Promise.all(base64Promises)).filter(b => b);
            
            // Only take up to 10 total photos
            setPhotosBase64(prev => [...prev, ...newBase64Photos].slice(0, 10));

            e.target.value = null; 
        };

        const handleRemovePhoto = (index) => {
            setPhotosBase64(prev => prev.filter((_, i) => i !== index));
        };
        // --- End Photo Upload Handler ---


        const handleSubmit = async (e) => {
            e.preventDefault();
            if (!db || !userId) {
                setModalConfig({ title: "Error", message: "User not authenticated or database not ready.", onClose: () => setIsModalOpen(false) });
                setIsModalOpen(true);
                return;
            }

            // Simple validation
            if (!formData.title || !formData.price || !formData.contactNumber || !formData.description) {
                setModalConfig({ title: "Validation Error", message: "Title, Price, Contact, and Description are required.", onClose: () => setIsModalOpen(false) });
                setIsModalOpen(true);
                return;
            }
            if (photosBase64.length === 0) {
                 setModalConfig({ title: "Validation Error", message: "Please upload at least one photo.", onClose: () => setIsModalOpen(false) });
                setIsModalOpen(true);
                return;
            }


            setIsSubmitting(true);
            try {
                const itemData = {
                    title: formData.title,
                    description: formData.description,
                    condition: formData.condition,
                    size: formData.size,
                    price: parseFloat(formData.price),
                    contactNumber: formData.contactNumber,
                    photos: photosBase64, 
                    postedBy: userId, 
                    status: 'available', // Explicitly set status
                    createdAt: Timestamp.now()
                };

                await addDoc(collection(db, PUBLIC_COLLECTION_PATH), itemData);

                // FIX: Redirect to 'MY ITEMS' view immediately upon successful post
                setModalConfig({ 
                    title: "Success!", 
                    message: "Your item has been posted! Check 'MY ITEMS'.", 
                    onClose: () => { 
                        setView('my-items'); 
                        setIsModalOpen(false); 
                    } 
                });
                setIsModalOpen(true);

            } catch (error) {
                console.error("Error adding document: ", error);
                setModalConfig({ title: "Error", message: "Failed to post item. Check the console for details. (Is the photo data too large?)", onClose: () => setIsModalOpen(false) });
                setIsModalOpen(true);
            } finally {
                setIsSubmitting(false);
            }
        };

        return (
            <div className="p-4 md:p-8 max-w-3xl mx-auto">
                <button
                    onClick={() => setView('home')}
                    className="mb-6 flex items-center text-emerald-600 hover:text-emerald-800 transition duration-150 font-semibold"
                >
                    <Home className="h-5 w-5 mr-2" /> Back to Listings
                </button>
                <div className="bg-white rounded-xl shadow-2xl p-6 md:p-8">
                    <h1 className="text-3xl font-extrabold text-gray-900 mb-8">Sell Your Swimming Gear</h1>
                    <form onSubmit={handleSubmit} className="space-y-6">
                        {/* Title & Price */}
                        <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                            <div>
                                <label className="block text-sm font-medium text-gray-700 mb-1">Title</label>
                                <input
                                    type="text"
                                    name="title"
                                    value={formData.title}
                                    onChange={handleChange}
                                    placeholder="e.g., Speedo Team Suit"
                                    className="w-full p-3 border border-gray-300 rounded-lg focus:ring-emerald-500 focus:border-emerald-500"
                                    required
                                />
                            </div>
                            <div>
                                <label className="block text-sm font-medium text-gray-700 mb-1">Price ($)</label>
                                <input
                                    type="number"
                                    name="price"
                                    value={formData.price}
                                    onChange={handleChange}
                                    min="0"
                                    step="0.01"
                                    className="w-full p-3 border border-gray-300 rounded-lg focus:ring-emerald-500 focus:border-emerald-500"
                                    required
                                />
                            </div>
                        </div>

                        {/* Condition & Size */}
                        <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                            <div>
                                <label className="block text-sm font-medium text-gray-700 mb-1">Condition</label>
                                <select
                                    name="condition"
                                    value={formData.condition}
                                    onChange={handleChange}
                                    className="w-full p-3 border border-gray-300 rounded-lg focus:ring-emerald-500 focus:border-emerald-500"
                                >
                                    {conditions.map(c => <option key={c} value={c}>{c}</option>)}
                                </select>
                            </div>
                            <div>
                                <label className="block text-sm font-medium text-gray-700 mb-1">Size (e.g., M, 32, Adjustable)</label>
                                <input
                                    type="text"
                                    name="size"
                                    value={formData.size}
                                    onChange={handleChange}
                                    placeholder="e.g. 32 (waist), L (suit), Adjustable"
                                    className="w-full p-3 border border-gray-300 rounded-lg focus:ring-emerald-500 focus:border-emerald-500"
                                />
                            </div>
                        </div>

                        {/* Contact & Description */}
                        <div>
                            <label className="block text-sm font-medium text-gray-700 mb-1">Contact Number (WhatsApp/Phone)</label>
                            <input
                                type="text"
                                name="contactNumber"
                                value={formData.contactNumber}
                                onChange={handleChange}
                                placeholder="e.g., 1234567890 (for WhatsApp link)"
                                className="w-full p-3 border border-gray-300 rounded-lg focus:ring-emerald-500 focus:border-emerald-500"
                                required
                            />
                        </div>

                        <div>
                            <label className="block text-sm font-medium text-gray-700 mb-1">Description</label>
                            <textarea
                                name="description"
                                value={formData.description}
                                onChange={handleChange}
                                rows="4"
                                placeholder="Describe your item in detail (e.g., color, brand, why you are selling)..."
                                className="w-full p-3 border border-gray-300 rounded-lg focus:ring-emerald-500 focus:border-emerald-500"
                                required
                            />
                        </div>

                        {/* Photo Upload Input and Preview */}
                        <h3 className="text-xl font-bold text-gray-900 pt-4 border-t mt-6">Photos ({photosBase64.length}/10)</h3>
                        <label className="flex items-center justify-center p-4 border-2 border-dashed border-gray-300 rounded-lg cursor-pointer bg-gray-50 hover:bg-gray-100 transition duration-150">
                            <UploadCloud className="h-6 w-6 text-emerald-600 mr-2" />
                            <span className="text-gray-700 font-semibold">Select up to 10 Images (Base64 conversion used)</span>
                            <input
                                type="file"
                                accept="image/*"
                                multiple
                                onChange={handleImageUpload}
                                className="hidden"
                                disabled={photosBase64.length >= 10}
                            />
                        </label>
                        <p className="text-xs text-gray-500 mt-1">Note: Use small images; large files may exceed the 1MB Firestore document limit.</p>

                        {/* Image Previews */}
                        {photosBase64.length > 0 && (
                            <div className="grid grid-cols-3 sm:grid-cols-5 gap-3 mt-4">
                                {photosBase64.map((photoBase64, index) => (
                                    <div key={index} className="relative aspect-square rounded-lg overflow-hidden shadow-md">
                                        <img src={photoBase64} alt={`Preview ${index}`} className="w-full h-full object-cover" />
                                        <button
                                            type="button"
                                            onClick={() => handleRemovePhoto(index)}
                                            className="absolute top-1 right-1 p-1 bg-red-600 text-white rounded-full hover:bg-red-700 transition z-10"
                                        >
                                            <X className="w-4 h-4" />
                                        </button>
                                    </div>
                                ))}
                            </div>
                        )}

                        {/* Submit */}
                        <button
                            type="submit"
                            disabled={isSubmitting || photosBase64.length === 0}
                            className={`w-full py-3 mt-8 font-bold text-white rounded-lg transition duration-150 shadow-lg ${isSubmitting || photosBase64.length === 0 ? 'bg-emerald-400 cursor-not-allowed' : 'bg-emerald-600 hover:bg-emerald-700'}`}
                        >
                            {isSubmitting ? 'Posting...' : 'SELL ITEM'}
                        </button>
                    </form>
                </div>
            </div>
        );
    };

    // My Items View Component (Delete/Mark as Sold NEW)
    const MyItemsView = () => (
        <div className="p-4 md:p-8 max-w-4xl mx-auto">
            <button
                onClick={() => setView('home')}
                className="mb-6 flex items-center text-emerald-600 hover:text-emerald-800 transition duration-150 font-semibold"
            >
                <Home className="h-5 w-5 mr-2" /> Back to Listings
            </button>
            <h1 className="text-3xl font-extrabold text-gray-900 mb-6">My Posted Swimming Gear</h1>
            <p className="text-sm text-gray-500 mb-4">Your User ID: <span className="font-mono text-xs text-gray-700 p-1 bg-gray-100 rounded">{userId || 'Loading...'}</span></p>

            <div className="bg-white rounded-xl shadow-2xl p-6 md:p-8">
                {myItems.length === 0 ? (
                    <div className="text-center py-10 text-gray-500">
                        You have not posted any items yet.
                        <button onClick={() => setView('sell')} className="mt-4 block mx-auto text-emerald-600 hover:text-emerald-800 font-semibold">
                            Start Selling Now
                        </button>
                    </div>
                ) : (
                    <ul className="space-y-4">
                        {myItems.sort((a, b) => (b.createdAt?.toDate() || 0) - (a.createdAt?.toDate() || 0)).map(item => (
                            <li key={item.id} className="flex flex-col sm:flex-row items-start sm:items-center justify-between p-4 border border-gray-100 rounded-lg shadow-sm hover:bg-gray-50 transition duration-150">
                                
                                {/* Item Info */}
                                <div className="flex items-start space-x-4 min-w-0 flex-grow w-full sm:w-auto mb-3 sm:mb-0">
                                    <img
                                        src={item.photos[0] || "https://placehold.co/60x60/10b981/ffffff?text=Item"}
                                        alt={item.title}
                                        className="w-16 h-16 aspect-square object-cover rounded-md flex-shrink-0"
                                        onError={(e) => { e.target.onerror = null; e.target.src = "https://placehold.co/60x60/10b981/ffffff?text=Item"; }}
                                    />
                                    <div className="min-w-0">
                                        <p className="font-semibold text-gray-900 truncate">{item.title}</p>
                                        <p className="text-sm text-emerald-600 font-medium">${item.price.toFixed(2)}</p>
                                        <span className={`text-xs font-bold px-2 py-0.5 rounded-full mt-1 inline-block ${item.status === 'sold' ? 'bg-red-100 text-red-700' : 'bg-green-100 text-green-700'}`}>
                                            {item.status.toUpperCase()}
                                        </span>
                                    </div>
                                </div>
                                
                                {/* Actions */}
                                <div className="flex space-x-2 w-full sm:w-auto justify-end sm:justify-start">
                                    <button
                                        onClick={() => { setSelectedItem(item); setView('details'); }}
                                        className="p-2 text-sm bg-gray-200 text-gray-700 rounded-full hover:bg-gray-300 transition duration-150"
                                    >
                                        <List className="h-5 w-5" />
                                    </button>
                                    
                                    {/* Mark as Sold button (only for available items) */}
                                    {item.status !== 'sold' && (
                                        <button
                                            onClick={() => handleMarkAsSold(item.id)}
                                            className="p-2 bg-blue-100 text-blue-600 rounded-full hover:bg-blue-200 transition duration-150"
                                            disabled={item.id.startsWith('test-')}
                                        >
                                            <CheckCircle className="h-5 w-5" />
                                        </button>
                                    )}

                                    <button
                                        onClick={() => handleDelete(item.id)}
                                        className="p-2 bg-red-100 text-red-600 rounded-full hover:bg-red-200 transition duration-150"
                                        disabled={item.id.startsWith('test-')}
                                    >
                                        <Trash2 className="h-5 w-5" />
                                    </button>
                                </div>
                            </li>
                        ))}
                    </ul>
                )}
            </div>
        </div>
    );

    // Main Renderer
    const renderView = () => {
        if (!isAuthReady) {
            return (
                <div className="flex items-center justify-center min-h-screen bg-gray-50">
                    <div className="text-center text-lg font-medium text-gray-600">Initializing Application...</div>
                </div>
            );
        }

        switch (view) {
            case 'details':
                return selectedItem ? <ItemDetailView item={selectedItem} /> : <HomeView />;
            case 'sell':
                return <SellItemForm />;
            case 'my-items':
                return <MyItemsView />;
            case 'home':
            default:
                return <HomeView />;
        }
    };

    return (
        <div className="min-h-screen bg-gray-50 font-sans">
            <style>{`
                /* Inter Font */
                @import url('https://fonts.googleapis.com/css2?family=Inter:wght@100..900&display=swap');
                * { font-family: 'Inter', sans-serif; }
            `}</style>
            <CustomModal
                title={modalConfig.title}
                message={modalConfig.message}
                isOpen={isModalOpen}
                onClose={modalConfig.onClose}
                onConfirm={modalConfig.onConfirm}
            />

            {/* Main Content */}
            <main className="pb-24">
                {renderView()}
            </main>

            {/* Floating Action Buttons */}
            <div className="fixed bottom-4 right-4 flex flex-col space-y-4 z-40">
                {/* My Items Button */}
                <button
                    onClick={() => setView('my-items')}
                    className="p-4 bg-blue-600 text-white rounded-full shadow-xl hover:bg-blue-700 transition duration-300 transform hover:scale-105"
                    aria-label="My Items"
                >
                    <List className="h-6 w-6" />
                </button>
                {/* Sell Item Button */}
                <button
                    onClick={() => setView('sell')}
                    className="p-4 bg-emerald-600 text-white rounded-full shadow-xl hover:bg-emerald-700 transition duration-300 transform hover:scale-105 flex items-center justify-center space-x-2 text-base font-semibold"
                    aria-label="Sell Item"
                >
                    <Plus className="h-6 w-6" />
                </button>
            </div>
        </div>
    );
}
