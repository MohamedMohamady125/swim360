import React, { useState, useEffect, useRef } from 'react';
import { 
  Plus, UploadCloud, ChevronDown, Check, 
  Layers, Package, Ruler, Palette, Building2, 
  X, Info, ArrowLeft, Camera
} from 'lucide-react';

// --- DATA DEFINITIONS ---
const BRANDS = ["Speedo", "Arena", "TYR", "Finis", "Mizuno", "MP Michael Phelps", "Zoggs", "Aqua Sphere", "Other"];
const CATEGORIES = ["Cap", "Goggles", "Suit", "Kickboard", "Paddles", "Parachute", "Fins", "Snorkels", "Deflectors", "Apparel", "Other"];
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

export default function App() {
    const [notification, setNotification] = useState(null);
    const [isSizeDropdownOpen, setIsSizeDropdownOpen] = useState(false);
    
    // Form State
    const [form, setForm] = useState({
        name: '',
        price: '',
        brand: 'Speedo',
        category: 'Suit',
        description: '',
        selectedSizes: [],
        selectedColors: [],
        selectedBranches: [],
        photos: [],
        sizeGuide: null
    });

    // --- UTILITIES ---
    const showNotify = (msg, type = 'success') => {
        setNotification({ msg, type });
        setTimeout(() => setNotification(null), 3000);
    };

    const toggleSize = (size) => {
        const isOneSize = size === 'ONE SIZE' || size === 'OTHER';
        setForm(prev => {
            let newSizes = [...prev.selectedSizes];
            if (newSizes.includes(size)) {
                newSizes = newSizes.filter(s => s !== size);
            } else {
                if (isOneSize) {
                    newSizes = [size]; // Clear others if one-size/other is picked
                } else {
                    newSizes = newSizes.filter(s => s !== 'ONE SIZE' && s !== 'OTHER');
                    newSizes.push(size);
                }
            }
            return { ...prev, selectedSizes: newSizes };
        });
    };

    const toggleColor = (colorName) => {
        setForm(prev => {
            const newColors = prev.selectedColors.includes(colorName)
                ? prev.selectedColors.filter(c => c !== colorName)
                : [...prev.selectedColors, colorName];
            return { ...prev, selectedColors: newColors };
        });
    };

    const toggleBranch = (branch) => {
        setForm(prev => {
            const newBranches = prev.selectedBranches.includes(branch)
                ? prev.selectedBranches.filter(b => b !== branch)
                : [...prev.selectedBranches, branch];
            return { ...prev, selectedBranches: newBranches };
        });
    };

    const handleSubmit = (e) => {
        e.preventDefault();
        if (!form.name || !form.price || form.selectedSizes.length === 0 || form.selectedColors.length === 0) {
            showNotify("Please complete all required fields and variants", "error");
            return;
        }
        showNotify("Product Published Successfully!");
        // Reset Logic or redirection would go here
    };

    return (
        <div className="max-w-md mx-auto min-h-screen bg-[#F8FAFC] font-sans text-gray-900 pb-12">
            
            {/* Header */}
            <header className="px-6 pt-12 pb-6 bg-white border-b border-gray-100 sticky top-0 z-30">
                <div className="flex items-center justify-between">
                    <div className="flex items-center space-x-3">
                        <div className="p-2.5 bg-blue-600 rounded-2xl text-white shadow-lg shadow-blue-100">
                            <Plus className="w-6 h-6" />
                        </div>
                        <div>
                            <h1 className="text-2xl font-black tracking-tight">Add Product</h1>
                            <p className="text-[10px] font-bold text-gray-400 uppercase tracking-widest mt-0.5">Official Inventory</p>
                        </div>
                    </div>
                    <button onClick={() => window.history.back()} className="p-2 text-gray-400 hover:text-gray-600 transition-colors">
                        <X className="w-6 h-6" />
                    </button>
                </div>
            </header>

            <main className="p-6 space-y-6 animate-in">
                <form onSubmit={handleSubmit} className="space-y-6">
                    
                    {/* 1. Identification Section */}
                    <div className="bg-white p-6 rounded-[32px] shadow-sm border border-gray-100 space-y-5">
                        <div className="flex items-center space-x-2 mb-2">
                            <Layers className="w-4 h-4 text-blue-600" />
                            <h3 className="text-xs font-black text-gray-400 uppercase tracking-widest">General Information</h3>
                        </div>

                        <div className="space-y-4 text-left">
                            <div>
                                <label className="text-[10px] font-black text-gray-400 uppercase ml-1">Product Title</label>
                                <input 
                                    type="text" 
                                    required
                                    placeholder="e.g. FINA Competition Suit" 
                                    value={form.name} 
                                    onChange={e => setForm({...form, name: e.target.value})}
                                    className="w-full mt-2 p-4 bg-gray-50 border-none rounded-2xl text-sm font-bold focus:ring-2 focus:ring-blue-500 outline-none" 
                                />
                            </div>
                            
                            <div className="grid grid-cols-2 gap-4">
                                <div>
                                    <label className="text-[10px] font-black text-gray-400 uppercase ml-1">Brand</label>
                                    <select 
                                        value={form.brand} 
                                        onChange={e => setForm({...form, brand: e.target.value})}
                                        className="w-full mt-2 p-4 bg-gray-50 border-none rounded-2xl text-sm font-bold outline-none"
                                    >
                                        {BRANDS.map(b => <option key={b}>{b}</option>)}
                                    </select>
                                </div>
                                <div>
                                    <label className="text-[10px] font-black text-gray-400 uppercase ml-1">Category</label>
                                    <select 
                                        value={form.category} 
                                        onChange={e => setForm({...form, category: e.target.value})}
                                        className="w-full mt-2 p-4 bg-gray-50 border-none rounded-2xl text-sm font-bold outline-none"
                                    >
                                        {CATEGORIES.map(c => <option key={c}>{c}</option>)}
                                    </select>
                                </div>
                            </div>

                            <div>
                                <label className="text-[10px] font-black text-gray-400 uppercase ml-1">Base Price ($)</label>
                                <input 
                                    type="number" 
                                    required
                                    step="0.01"
                                    placeholder="0.00" 
                                    value={form.price} 
                                    onChange={e => setForm({...form, price: e.target.value})}
                                    className="w-full mt-2 p-4 bg-gray-50 border-none rounded-2xl text-sm font-bold outline-none" 
                                />
                            </div>

                            <div>
                                <label className="text-[10px] font-black text-gray-400 uppercase ml-1">Description</label>
                                <textarea 
                                    required
                                    placeholder="Enter materials, features, and care instructions..." 
                                    rows="4" 
                                    value={form.description} 
                                    onChange={e => setForm({...form, description: e.target.value})}
                                    className="w-full mt-2 p-4 bg-gray-50 border-none rounded-2xl text-sm font-bold resize-none focus:ring-2 focus:ring-blue-500 outline-none" 
                                />
                            </div>
                        </div>
                    </div>

                    {/* 2. Media Section */}
                    <div className="bg-white p-6 rounded-[32px] shadow-sm border border-gray-100 space-y-4">
                        <div className="flex items-center space-x-2 mb-2">
                            <Camera className="w-4 h-4 text-blue-600" />
                            <h3 className="text-xs font-black text-gray-400 uppercase tracking-widest">Media Gallery</h3>
                        </div>
                        <div className="grid grid-cols-2 gap-3">
                            <div className="p-8 bg-gray-50 rounded-[28px] flex flex-col items-center justify-center border-2 border-dashed border-gray-200 text-gray-400 cursor-pointer hover:bg-blue-50 transition-colors">
                                <Plus className="w-6 h-6 mb-1 text-blue-600" />
                                <span className="text-[8px] font-black uppercase text-center">Add Photos<br/>(Max 10)</span>
                            </div>
                            <div className={`p-8 rounded-[28px] flex flex-col items-center justify-center border-2 border-dashed transition-colors cursor-pointer ${form.sizeGuide ? 'bg-blue-50 border-blue-600 text-blue-600' : 'bg-gray-50 border-gray-200 text-gray-400'}`}>
                                <Ruler className="w-6 h-6 mb-1" />
                                <span className="text-[8px] font-black uppercase">Size Guide<br/>(Optional)</span>
                            </div>
                        </div>
                    </div>

                    {/* 3. Variants Section */}
                    <div className="bg-white p-6 rounded-[32px] shadow-sm border border-gray-100 space-y-6">
                        <div className="flex items-center space-x-2 mb-2">
                            <Palette className="w-4 h-4 text-blue-600" />
                            <h3 className="text-xs font-black text-gray-400 uppercase tracking-widest">Variants</h3>
                        </div>

                        {/* CUSTOM SIZE DROPDOWN WITH CHECKBOXES */}
                        <div className="relative text-left">
                            <label className="text-[10px] font-black text-gray-400 uppercase ml-1">Available Sizes</label>
                            <button 
                                type="button"
                                onClick={() => setIsSizeDropdownOpen(!isSizeDropdownOpen)}
                                className="w-full mt-2 p-4 bg-gray-50 border-none rounded-2xl text-sm font-bold flex items-center justify-between group active:bg-gray-100 transition-all"
                            >
                                <span className={form.selectedSizes.length > 0 ? 'text-blue-600' : 'text-gray-400'}>
                                    {form.selectedSizes.length > 0 
                                        ? `${form.selectedSizes.length} Sizes Selected` 
                                        : 'Choose Sizes'}
                                </span>
                                <ChevronDown className={`w-5 h-5 text-gray-400 transition-transform ${isSizeDropdownOpen ? 'rotate-180' : ''}`} />
                            </button>

                            {isSizeDropdownOpen && (
                                <div className="absolute top-full left-0 right-0 mt-3 bg-white rounded-[24px] shadow-2xl border border-gray-100 z-50 p-4 max-h-60 overflow-y-auto no-scrollbar space-y-2">
                                    {SIZES.map(size => {
                                        const isOneSize = size === 'ONE SIZE' || size === 'OTHER';
                                        const isDisabled = !isOneSize && (form.selectedSizes.includes('ONE SIZE') || form.selectedSizes.includes('OTHER'));
                                        
                                        return (
                                            <button 
                                                key={size}
                                                type="button"
                                                disabled={isDisabled}
                                                onClick={() => toggleSize(size)}
                                                className={`w-full p-3.5 rounded-xl flex items-center justify-between transition-all ${form.selectedSizes.includes(size) ? 'bg-blue-600 text-white shadow-lg' : 'bg-gray-50 text-gray-700'} ${isDisabled ? 'opacity-30 cursor-not-allowed' : ''}`}
                                            >
                                                <span className="text-xs font-bold uppercase">{size}</span>
                                                <div className={`w-5 h-5 rounded-md flex items-center justify-center border-2 ${form.selectedSizes.includes(size) ? 'bg-white border-white' : 'border-gray-200 bg-white'}`}>
                                                    {form.selectedSizes.includes(size) && <Check className="w-4 h-4 text-blue-600" />}
                                                </div>
                                            </button>
                                        );
                                    })}
                                </div>
                            )}
                        </div>

                        {/* Colors Picker */}
                        <div className="space-y-4 pt-2 text-left">
                            <label className="text-[10px] font-black text-gray-400 uppercase ml-1">Color Palette</label>
                            <div className="flex flex-wrap gap-4">
                                {COLORS.map(color => (
                                    <button 
                                        key={color.name}
                                        type="button"
                                        onClick={() => toggleColor(color.name)}
                                        className={`w-11 h-11 rounded-full border-4 transition-all relative ${form.selectedColors.includes(color.name) ? 'border-blue-600 scale-110 shadow-lg' : 'border-white shadow-sm'}`}
                                        style={{ backgroundColor: color.code }}
                                    >
                                        {form.selectedColors.includes(color.name) && <Check className="w-5 h-5 text-white absolute inset-0 m-auto" />}
                                    </button>
                                ))}
                            </div>
                        </div>
                    </div>

                    {/* 4. Branch Allocation Section */}
                    <div className="bg-white p-6 rounded-[32px] shadow-sm border border-gray-100 space-y-4 text-left">
                        <div className="flex items-center space-x-2 mb-2">
                            <Building2 className="w-4 h-4 text-blue-600" />
                            <h3 className="text-xs font-black text-gray-400 uppercase tracking-widest">Branch Stock Allocation</h3>
                        </div>
                        <div className="space-y-2">
                            {BRANCHES.map(branch => (
                                <button 
                                    key={branch}
                                    type="button"
                                    onClick={() => toggleBranch(branch)}
                                    className={`w-full p-4 rounded-2xl flex items-center justify-between transition-all border ${form.selectedBranches.includes(branch) ? 'bg-blue-50 border-blue-600 ring-2 ring-blue-50' : 'bg-gray-50 border-transparent'}`}
                                >
                                    <span className={`text-sm font-bold ${form.selectedBranches.includes(branch) ? 'text-blue-700' : 'text-gray-500'}`}>{branch}</span>
                                    <div className={`w-5 h-5 rounded-full flex items-center justify-center border-2 ${form.selectedBranches.includes(branch) ? 'bg-blue-600 border-blue-600' : 'border-gray-200 bg-white'}`}>
                                        {form.selectedBranches.includes(branch) && <Check className="w-3.5 h-3.5 text-white" />}
                                    </div>
                                </button>
                            ))}
                        </div>
                    </div>

                    {/* Submit Button */}
                    <div className="pt-4">
                        <button 
                            type="submit" 
                            className="w-full py-5 bg-blue-600 text-white rounded-[24px] font-black text-sm shadow-xl active:scale-95 transition-all uppercase tracking-[0.2em]"
                        >
                            Publish to Inventory
                        </button>
                    </div>
                </form>
            </main>

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
            `}</style>
        </div>
    );
}