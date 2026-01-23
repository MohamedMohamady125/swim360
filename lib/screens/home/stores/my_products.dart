import React, { useState, useEffect, useMemo, useRef } from 'react';
import { 
  Plus, UploadCloud, ChevronDown, Check, 
  Layers, Package, Ruler, Palette, Building2, 
  X, Info, ArrowLeft, Camera, Settings,
  AlertCircle, Tag, Percent, Ticket, Edit3,
  MoreHorizontal, Eye, ChevronRight, CheckCircle, Clock, Calendar
} from 'lucide-react';

// --- DATA DEFINITIONS ---
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
const BRANCHES = ["Zamalek Main", "New Cairo Hub", "Alexandria Branch", "Giza Outlet"];

// --- MOCK INVENTORY DATA ---
const INITIAL_PRODUCTS = [
    {
        id: 'p1',
        name: 'Pro Racing Goggles',
        brand: 'Speedo',
        category: 'Goggles',
        price: 49.99,
        description: 'Elite racing goggles with mirrored lenses.',
        selectedSizes: ['ONE SIZE'],
        selectedColors: ['Black', 'Blue', 'Gold'],
        selectedBranches: ["Zamalek Main", "New Cairo Hub"],
        outOfStockBranches: ["Zamalek Main"],
        photo: 'https://images.unsplash.com/photo-1552650272-b8a34e21bc4b?q=80&w=400'
    },
    {
        id: 'p2',
        name: 'Carbon Fiber Jammer',
        brand: 'Arena',
        category: 'Suit',
        price: 280.00,
        description: 'Professional competition suit for high performance.',
        selectedSizes: ['26', '28', '30'],
        selectedColors: ['Black', 'Purple'],
        selectedBranches: ["New Cairo Hub", "Alexandria Branch"],
        outOfStockBranches: [],
        photo: 'https://images.unsplash.com/photo-1606107557195-0e29a4b5b4aa?q=80&w=400'
    }
];

export default function App() {
    const [view, setView] = useState('list'); // 'list' or 'edit'
    const [products, setProducts] = useState(INITIAL_PRODUCTS);
    const [editingProduct, setEditingProduct] = useState(null);
    const [activeModal, setActiveModal] = useState(null); // 'stock', 'discount', 'promo', 'global-promo'
    
    const [loading, setLoading] = useState(false);
    const [notification, setNotification] = useState(null);
    const [isSizeDropdownOpen, setIsSizeDropdownOpen] = useState(false);
    
    // --- UTILITIES ---
    const showNotify = (msg, type = 'success') => {
        setNotification({ msg, type });
        setTimeout(() => setNotification(null), 3000);
    };

    const handleEditProduct = (product) => {
        setEditingProduct({ ...product });
        setView('edit');
    };

    const toggleSize = (size) => {
        const isOneSize = size === 'ONE SIZE' || size === 'OTHER';
        setEditingProduct(prev => {
            if (!prev) return null;
            let newSizes = [...prev.selectedSizes];
            if (newSizes.includes(size)) {
                newSizes = newSizes.filter(s => s !== size);
            } else {
                if (isOneSize) newSizes = [size];
                else {
                    newSizes = newSizes.filter(s => s !== 'ONE SIZE' && s !== 'OTHER');
                    newSizes.push(size);
                }
            }
            return { ...prev, selectedSizes: newSizes };
        });
    };

    // --- VIEW RENDERERS ---

    const renderInventoryList = () => (
        <div className="p-6 space-y-8 animate-in text-left">
            <div className="space-y-1">
                <h1 className="text-3xl font-black text-gray-900 tracking-tight">Inventory</h1>
                <p className="text-sm text-gray-400 font-medium">Manage your products and promotions</p>
            </div>

            {/* Global Promo Banner */}
            <button 
                onClick={() => setActiveModal('global-promo')}
                className="w-full p-4 bg-orange-500 rounded-[20px] shadow-lg shadow-orange-100 flex items-center justify-between group active:scale-[0.98] transition-all"
            >
                <div className="flex items-center space-x-3 text-white">
                    <div className="p-2 bg-white/20 rounded-xl">
                        <Ticket className="w-6 h-6" />
                    </div>
                    <span className="font-black uppercase text-sm tracking-widest">Global Store Promo</span>
                </div>
                <ChevronRight className="w-5 h-5 text-white/60 group-hover:translate-x-1 transition-transform" />
            </button>

            {/* Categorized List */}
            <div className="space-y-10 pb-20">
                {CATEGORIES.map(cat => {
                    const catProds = products.filter(p => p.category === cat);
                    if (catProds.length === 0) return null;

                    return (
                        <div key={cat} className="space-y-4">
                            <h2 className="text-[10px] font-black text-blue-600 uppercase tracking-[0.2em] ml-2 flex items-center">
                                <span className="w-1.5 h-1.5 bg-blue-600 rounded-full mr-2"></span>
                                {cat}
                            </h2>
                            {catProds.map(product => {
                                const isOOS = product.outOfStockBranches.length > 0;
                                const isFullyOOS = product.outOfStockBranches.length === product.selectedBranches.length && product.selectedBranches.length > 0;

                                return (
                                    <div key={product.id} className="bg-white rounded-[32px] border border-gray-100 shadow-sm p-4 flex items-center space-x-4">
                                        <div className="w-24 h-24 rounded-3xl bg-gray-50 overflow-hidden flex-shrink-0">
                                            <img src={product.photo} className="w-full h-full object-cover" alt="item" />
                                        </div>
                                        <div className="flex-grow min-w-0">
                                            <div className="flex items-center space-x-2">
                                                <h3 className="font-black text-gray-900 truncate text-lg leading-tight">{product.name}</h3>
                                                {isFullyOOS ? (
                                                    <span className="px-1.5 py-0.5 bg-red-50 text-red-600 text-[8px] font-black rounded uppercase">OOS</span>
                                                ) : isOOS ? (
                                                    <span className="px-1.5 py-0.5 bg-amber-50 text-amber-600 text-[8px] font-black rounded uppercase">Partial</span>
                                                ) : (
                                                    <span className="px-1.5 py-0.5 bg-emerald-50 text-emerald-600 text-[8px] font-black rounded uppercase">Live</span>
                                                )}
                                            </div>
                                            <p className="text-xs text-gray-400 font-bold uppercase tracking-widest mt-1">{product.brand}</p>
                                            <p className="text-xl font-black text-blue-600 mt-2">${product.price.toFixed(2)}</p>
                                        </div>
                                        
                                        {/* Action Icon Cluster */}
                                        <div className="flex flex-col space-y-2">
                                            <div className="flex space-x-1">
                                                <button onClick={() => handleEditProduct(product)} className="p-2.5 bg-gray-50 text-blue-600 rounded-xl hover:bg-blue-600 hover:text-white transition-all shadow-sm" title="Edit Product">
                                                    <Edit3 className="w-4 h-4" />
                                                </button>
                                                <button onClick={() => { setEditingProduct(product); setActiveModal('stock'); }} className="p-2.5 bg-gray-50 text-red-600 rounded-xl hover:bg-red-600 hover:text-white transition-all shadow-sm" title="Stock Status">
                                                    <AlertCircle className="w-4 h-4" />
                                                </button>
                                            </div>
                                            <div className="flex space-x-1">
                                                <button onClick={() => { setEditingProduct(product); setActiveModal('discount'); }} className="p-2.5 bg-gray-50 text-emerald-600 rounded-xl hover:bg-emerald-600 hover:text-white transition-all shadow-sm" title="Apply Discount">
                                                    <Tag className="w-4 h-4" />
                                                </button>
                                                <button onClick={() => { setEditingProduct(product); setActiveModal('promo'); }} className="p-2.5 bg-gray-50 text-amber-600 rounded-xl hover:bg-amber-600 hover:text-white transition-all shadow-sm" title="Add Promo">
                                                    <Ticket className="w-4 h-4" />
                                                </button>
                                            </div>
                                        </div>
                                    </div>
                                );
                            })}
                        </div>
                    );
                })}
            </div>
        </div>
    );

    const renderEditForm = () => (
        <div className="animate-in flex flex-col min-h-screen pb-12">
            <header className="px-6 pt-12 pb-6 bg-white border-b border-gray-100 sticky top-0 z-30 flex items-center justify-between">
                <div className="flex items-center space-x-4">
                    <button onClick={() => setView('list')} className="p-2.5 bg-gray-50 rounded-2xl text-gray-500 active:scale-90 transition-transform">
                        <ArrowLeft className="w-6 h-6" />
                    </button>
                    <h1 className="text-2xl font-black tracking-tight">{editingProduct?.id ? 'Edit Product' : 'New Product'}</h1>
                </div>
                <button onClick={() => { showNotify("Product information saved!"); setView('list'); }} className="px-6 py-3 bg-blue-600 text-white rounded-2xl font-black text-xs uppercase tracking-widest shadow-xl shadow-blue-100">
                    Save
                </button>
            </header>

            <div className="p-6 space-y-6">
                {/* 1. Base Info */}
                <div className="bg-white p-6 rounded-[32px] shadow-sm border border-gray-100 space-y-5 text-left">
                    <div className="flex items-center space-x-2">
                        <Layers className="w-4 h-4 text-blue-600" />
                        <h3 className="text-[10px] font-black text-gray-400 uppercase tracking-widest">Information</h3>
                    </div>
                    <div className="space-y-4">
                        <div>
                            <label className="text-[10px] font-black text-gray-400 uppercase ml-1">Title</label>
                            <input type="text" value={editingProduct?.name || ''} onChange={e => setEditingProduct({...editingProduct, name: e.target.value})} className="w-full mt-1.5 p-4 bg-gray-50 border-none rounded-2xl text-sm font-bold focus:ring-2 focus:ring-blue-500 outline-none" />
                        </div>
                        <div className="grid grid-cols-2 gap-4">
                            <div>
                                <label className="text-[10px] font-black text-gray-400 uppercase ml-1">Brand</label>
                                <select value={editingProduct?.brand || 'Speedo'} onChange={e => setEditingProduct({...editingProduct, brand: e.target.value})} className="w-full mt-1.5 p-4 bg-gray-50 border-none rounded-2xl text-sm font-bold outline-none">
                                    {BRANDS.map(b => <option key={b}>{b}</option>)}
                                </select>
                            </div>
                            <div>
                                <label className="text-[10px] font-black text-gray-400 uppercase ml-1">Category</label>
                                <select value={editingProduct?.category || 'Suit'} onChange={e => setEditingProduct({...editingProduct, category: e.target.value})} className="w-full mt-1.5 p-4 bg-gray-50 border-none rounded-2xl text-sm font-bold outline-none">
                                    {CATEGORIES.map(c => <option key={c}>{c}</option>)}
                                </select>
                            </div>
                        </div>
                        <div>
                            <label className="text-[10px] font-black text-gray-400 uppercase ml-1">Price ($)</label>
                            <input type="number" value={editingProduct?.price || 0} onChange={e => setEditingProduct({...editingProduct, price: parseFloat(e.target.value) || 0})} className="w-full mt-1.5 p-4 bg-gray-50 border-none rounded-2xl text-sm font-bold outline-none" />
                        </div>
                    </div>
                </div>

                {/* 2. Media Section */}
                <div className="bg-white p-6 rounded-[32px] shadow-sm border border-gray-100 space-y-4 text-left">
                    <div className="flex items-center space-x-2">
                        <Camera className="w-4 h-4 text-blue-600" />
                        <h3 className="text-[10px] font-black text-gray-400 uppercase tracking-widest">Media Gallery</h3>
                    </div>
                    <div className="grid grid-cols-2 gap-3">
                        <div className="p-6 bg-gray-50 rounded-[24px] flex flex-col items-center justify-center border-2 border-dashed border-gray-200 text-gray-400 hover:bg-blue-50 transition-colors cursor-pointer">
                            <Plus className="w-6 h-6 mb-1 text-blue-600" />
                            <span className="text-[8px] font-black uppercase">Add Images</span>
                        </div>
                        <div className="p-6 bg-gray-50 rounded-[24px] flex flex-col items-center justify-center border-2 border-dashed border-gray-200 text-gray-400 cursor-pointer">
                            <Ruler className="w-6 h-6 mb-1" />
                            <span className="text-[8px] font-black uppercase text-center">Size Guide</span>
                        </div>
                    </div>
                </div>

                {/* 3. Variants Section */}
                <div className="bg-white p-6 rounded-[32px] shadow-sm border border-gray-100 space-y-6 text-left">
                    <div className="flex items-center space-x-2">
                        <Palette className="w-4 h-4 text-blue-600" />
                        <h3 className="text-[10px] font-black text-gray-400 uppercase tracking-widest">Variants</h3>
                    </div>

                    <div className="relative">
                        <label className="text-[10px] font-black text-gray-400 uppercase ml-1">Sizes</label>
                        <button 
                            type="button"
                            onClick={() => setIsSizeDropdownOpen(!isSizeDropdownOpen)}
                            className="w-full mt-1.5 p-4 bg-gray-50 border-none rounded-2xl text-sm font-bold flex items-center justify-between transition-all"
                        >
                            <span className={editingProduct?.selectedSizes.length > 0 ? 'text-blue-600' : 'text-gray-400'}>
                                {editingProduct?.selectedSizes.length > 0 ? `${editingProduct.selectedSizes.length} Selected` : 'Choose Sizes'}
                            </span>
                            <ChevronDown className={`w-5 h-5 text-gray-400 transition-transform ${isSizeDropdownOpen ? 'rotate-180' : ''}`} />
                        </button>
                        {isSizeDropdownOpen && (
                            <div className="absolute top-full left-0 right-0 mt-3 bg-white rounded-[24px] shadow-2xl border border-gray-100 z-50 p-4 max-h-60 overflow-y-auto no-scrollbar space-y-2">
                                {SIZES.map(size => {
                                    const isSelected = editingProduct?.selectedSizes.includes(size);
                                    return (
                                        <button key={size} type="button" onClick={() => toggleSize(size)} className={`w-full p-3.5 rounded-xl flex items-center justify-between transition-all ${isSelected ? 'bg-blue-600 text-white' : 'bg-gray-50 text-gray-700'}`}>
                                            <span className="text-xs font-bold uppercase">{size}</span>
                                            <div className={`w-5 h-5 rounded-md flex items-center justify-center border-2 ${isSelected ? 'bg-white border-white' : 'border-gray-200 bg-white'}`}>
                                                {isSelected && <Check className="w-4 h-4 text-blue-600" />}
                                            </div>
                                        </button>
                                    );
                                })}
                            </div>
                        )}
                    </div>

                    <div className="space-y-3">
                        <label className="text-[10px] font-black text-gray-400 uppercase ml-1">Colors</label>
                        <div className="flex flex-wrap gap-4">
                            {COLORS.map(color => {
                                const isSelected = editingProduct?.selectedColors.includes(color.name);
                                return (
                                    <button 
                                        key={color.name} 
                                        type="button" 
                                        onClick={() => setEditingProduct(prev => ({ ...prev, selectedColors: isSelected ? prev.selectedColors.filter(c => c !== color.name) : [...prev.selectedColors, color.name] }))}
                                        className={`w-11 h-11 rounded-full border-4 transition-all relative ${isSelected ? 'border-blue-600 scale-110 shadow-lg' : 'border-white shadow-sm'}`} 
                                        style={{ backgroundColor: color.code }}
                                    >
                                        {isSelected && <Check className="w-5 h-5 text-white absolute inset-0 m-auto" />}
                                    </button>
                                );
                            })}
                        </div>
                    </div>
                </div>

                {/* 4. Branch Distribution */}
                <div className="bg-white p-6 rounded-[32px] shadow-sm border border-gray-100 space-y-4 text-left">
                    <div className="flex items-center space-x-2">
                        <Building2 className="w-4 h-4 text-blue-600" />
                        <h3 className="text-[10px] font-black text-gray-400 uppercase tracking-widest">Branch Allocation</h3>
                    </div>
                    <div className="space-y-2">
                        {BRANCHES.map(branch => {
                            const isAllocated = editingProduct?.selectedBranches.includes(branch);
                            return (
                                <button key={branch} type="button" 
                                    onClick={() => setEditingProduct(prev => ({ ...prev, selectedBranches: isAllocated ? prev.selectedBranches.filter(b => b !== branch) : [...prev.selectedBranches, branch] }))}
                                    className={`w-full p-4 rounded-2xl flex items-center justify-between transition-all border ${isAllocated ? 'bg-blue-50 border-blue-600 ring-2 ring-blue-50' : 'bg-gray-50 border-transparent'}`}
                                >
                                    <span className={`text-sm font-bold ${isAllocated ? 'text-blue-700' : 'text-gray-500'}`}>{branch}</span>
                                    <div className={`w-5 h-5 rounded-full flex items-center justify-center border-2 ${isAllocated ? 'bg-blue-600 border-blue-600' : 'border-gray-200 bg-white'}`}>
                                        {isAllocated && <Check className="w-3.5 h-3.5 text-white" />}
                                    </div>
                                </button>
                            );
                        })}
                    </div>
                </div>
            </div>
        </div>
    );

    // --- MODAL COMPONENTS ---

    const renderActionModal = () => {
        if (!activeModal) return null;

        const onClose = () => { setActiveModal(null); setEditingProduct(null); };

        return (
            <div className="fixed inset-0 z-50 flex items-center justify-center p-6 bg-slate-900/60 backdrop-blur-sm animate-in">
                <div className="bg-white w-full max-w-sm rounded-[40px] p-8 shadow-2xl space-y-6 relative overflow-hidden">
                    <button onClick={onClose} className="absolute top-6 right-6 p-2 bg-gray-50 rounded-full text-gray-400"><X className="w-5 h-5" /></button>
                    
                    {activeModal === 'stock' && (
                        <div className="space-y-6 text-left">
                            <div className="p-3 bg-red-50 text-red-600 rounded-2xl flex items-center space-x-2">
                                <AlertCircle className="w-5 h-5" />
                                <span className="text-[10px] font-black uppercase">Out of Stock Management</span>
                            </div>
                            <h3 className="text-xl font-black text-gray-900 leading-tight">Branch Availability for {editingProduct?.name}</h3>
                            <div className="space-y-2">
                                {editingProduct?.selectedBranches.map(branch => {
                                    const isOOS = editingProduct.outOfStockBranches.includes(branch);
                                    return (
                                        <button key={branch} 
                                            onClick={() => setEditingProduct(prev => ({ ...prev, outOfStockBranches: isOOS ? prev.outOfStockBranches.filter(b => b !== branch) : [...prev.outOfStockBranches, branch] }))}
                                            className={`w-full p-4 rounded-2xl flex items-center justify-between border-2 transition-all ${isOOS ? 'border-red-600 bg-red-50' : 'border-transparent bg-gray-50'}`}
                                        >
                                            <span className="text-sm font-bold text-gray-800">{branch}</span>
                                            <span className={`text-[9px] font-black uppercase px-2 py-0.5 rounded ${isOOS ? 'bg-red-600 text-white' : 'bg-gray-200 text-gray-500'}`}>{isOOS ? 'Out of Stock' : 'Active'}</span>
                                        </button>
                                    );
                                })}
                            </div>
                            <button onClick={() => { showNotify("Stock status synced!"); onClose(); }} className="w-full py-4 bg-red-600 text-white rounded-2xl font-black text-sm uppercase tracking-widest shadow-xl shadow-red-100 mt-4">Confirm Status</button>
                        </div>
                    )}

                    {activeModal === 'discount' && (
                        <div className="space-y-6 text-left">
                            <div className="p-3 bg-emerald-50 text-emerald-600 rounded-2xl flex items-center space-x-2">
                                <Tag className="w-5 h-5" />
                                <span className="text-[10px] font-black uppercase">Fixed Discount Manager</span>
                            </div>
                            <h3 className="text-xl font-black text-gray-900">Set Discount Price</h3>
                            <div className="space-y-4">
                                <div>
                                    <label className="text-[10px] font-black text-gray-400 uppercase ml-1">Discounted Price ($)</label>
                                    <input type="number" placeholder="0.00" className="w-full mt-1 p-4 bg-gray-50 border-none rounded-2xl text-sm font-bold focus:ring-2 focus:ring-emerald-500 outline-none" />
                                </div>
                                <div>
                                    <label className="text-[10px] font-black text-gray-400 uppercase ml-1">Duration (Days)</label>
                                    <input type="number" placeholder="7" className="w-full mt-1 p-4 bg-gray-50 border-none rounded-2xl text-sm font-bold outline-none" />
                                </div>
                            </div>
                            <button onClick={() => { showNotify("Discount applied!"); onClose(); }} className="w-full py-4 bg-emerald-600 text-white rounded-2xl font-black text-sm uppercase tracking-widest shadow-xl shadow-emerald-100">Activate Discount</button>
                        </div>
                    )}

                    {activeModal === 'promo' && (
                        <div className="space-y-6 text-left">
                            <div className="p-3 bg-amber-50 text-amber-600 rounded-2xl flex items-center space-x-2">
                                <Ticket className="w-5 h-5" />
                                <span className="text-[10px] font-black uppercase">Coupon Code Manager</span>
                            </div>
                            <h3 className="text-xl font-black text-gray-900 leading-tight">Create Promo for {editingProduct?.name}</h3>
                            <div className="space-y-4">
                                <div>
                                    <label className="text-[10px] font-black text-gray-400 uppercase ml-1">Code Name</label>
                                    <input type="text" placeholder="e.g. SWIM20" className="w-full mt-1 p-4 bg-gray-50 border-none rounded-2xl text-sm font-bold uppercase outline-none" />
                                </div>
                                <div>
                                    <label className="text-[10px] font-black text-gray-400 uppercase ml-1">Usage Limit (Total times usable)</label>
                                    <input type="number" placeholder="e.g. 100" className="w-full mt-1 p-4 bg-gray-50 border-none rounded-2xl text-sm font-bold outline-none" />
                                </div>
                                <div className="grid grid-cols-2 gap-4">
                                    <div>
                                        <label className="text-[10px] font-black text-gray-400 uppercase ml-1">Expiry Date</label>
                                        <input type="date" className="w-full mt-1 p-4 bg-gray-50 border-none rounded-2xl text-xs font-bold outline-none" />
                                    </div>
                                    <div>
                                        <label className="text-[10px] font-black text-gray-400 uppercase ml-1">Expiry Hour</label>
                                        <input type="time" className="w-full mt-1 p-4 bg-gray-50 border-none rounded-2xl text-xs font-bold outline-none" />
                                    </div>
                                </div>
                            </div>
                            <button onClick={() => { showNotify("Promo code active!"); onClose(); }} className="w-full py-4 bg-amber-500 text-white rounded-2xl font-black text-sm uppercase tracking-widest shadow-xl shadow-amber-100">Publish Code</button>
                        </div>
                    )}

                    {activeModal === 'global-promo' && (
                        <div className="space-y-6 text-left">
                            <div className="p-3 bg-orange-50 text-orange-600 rounded-2xl flex items-center space-x-2">
                                <Percent className="w-5 h-5" />
                                <span className="text-[10px] font-black uppercase">Store-Wide Campaign</span>
                            </div>
                            <h3 className="text-xl font-black text-gray-900 leading-tight">Apply to All Products</h3>
                            <div className="space-y-4">
                                <div>
                                    <label className="text-[10px] font-black text-gray-400 uppercase ml-1">Universal Promo Code</label>
                                    <input type="text" placeholder="SWIM360" className="w-full mt-1 p-4 bg-gray-50 border-none rounded-2xl text-sm font-bold uppercase outline-none" />
                                </div>
                                <div>
                                    <label className="text-[10px] font-black text-gray-400 uppercase ml-1">Usage Limit (Max Redeems)</label>
                                    <input type="number" placeholder="500" className="w-full mt-1 p-4 bg-gray-50 border-none rounded-2xl text-sm font-bold outline-none" />
                                </div>
                                <div className="grid grid-cols-2 gap-4">
                                    <div>
                                        <label className="text-[10px] font-black text-gray-400 uppercase ml-1">Expiry Date</label>
                                        <input type="date" className="w-full mt-1 p-4 bg-gray-50 border-none rounded-2xl text-xs font-bold outline-none" />
                                    </div>
                                    <div>
                                        <label className="text-[10px] font-black text-gray-400 uppercase ml-1">Expiry Hour</label>
                                        <input type="time" className="w-full mt-1 p-4 bg-gray-50 border-none rounded-2xl text-xs font-bold outline-none" />
                                    </div>
                                </div>
                            </div>
                            <button onClick={() => { showNotify("Global promo live!"); onClose(); }} className="w-full py-4 bg-orange-500 text-white rounded-2xl font-black text-sm uppercase tracking-widest shadow-xl shadow-orange-100">Confirm Launch</button>
                        </div>
                    )}
                </div>
            </div>
        );
    };

    if (loading) return <div className="min-h-screen flex items-center justify-center bg-white font-black text-blue-600 animate-pulse">Swim 360</div>;

    return (
        <div className="max-w-md mx-auto min-h-screen bg-[#F8FAFC] font-sans text-gray-900 relative">
            {view === 'list' && renderInventoryList()}
            {view === 'edit' && renderEditForm()}

            {renderActionModal()}

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