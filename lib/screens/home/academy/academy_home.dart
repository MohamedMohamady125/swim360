<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Stores Directory and Shopping</title>
    <!-- Tailwind CSS CDN for styling -->
    <script src="https://cdn.tailwindcss.com"></script>
    <style>
        @import url('https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap');
        body {
            font-family: 'Inter', sans-serif;
            background-color: #F7F9FB;
        }
        /* Style for smooth view transitions */
        .view-container {
            animation: fadeIn 0.3s ease-in-out;
        }
        @keyframes fadeIn {
            from { opacity: 0; }
            to { opacity: 1; }
        }
        /* Cart Badge Styling */
        .cart-badge {
            position: absolute;
            top: -4px;
            right: -4px;
            background-color: #ef4444; /* Red */
            color: white;
            font-size: 10px;
            font-weight: bold;
            border-radius: 9999px;
            padding: 2px 6px;
            line-height: 1;
            min-width: 18px;
            text-align: center;
        }
        /* Styling for color swatches */
        .color-swatch {
            width: 32px;
            height: 32px;
            border-radius: 9999px;
            border: 3px solid transparent;
            cursor: pointer;
            transition: transform 0.1s;
        }
        .color-swatch.selected {
            border-color: #3B82F6; /* blue-500 */
            box-shadow: 0 0 0 1px white;
        }
        /* Style for Action Cards */
        .action-card {
            background-color: white;
            border-radius: 12px;
            box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1), 0 2px 4px -2px rgba(0, 0, 0, 0.06);
            transition: all 0.2s;
            cursor: pointer;
            min-height: 110px; /* Ensure consistent height for 3-col grid */
        }
        .action-card:hover {
            box-shadow: 0 10px 15px -3px rgba(0, 0, 0, 0.1), 0 4px 6px -4px rgba(0, 0, 0, 0.05);
            transform: translateY(-2px);
        }
        /* Custom styles for horizontal poster scrolling */
        .poster-scroll {
            -webkit-overflow-scrolling: touch;
            scrollbar-width: none; /* Firefox */
        }
        .poster-scroll::-webkit-scrollbar {
            display: none; /* Chrome, Safari, Opera */
        }
    </style>
</head>
<body class="text-gray-800">

    <div id="app-container" class="max-w-xl mx-auto pb-20">
        <!-- Application views will be injected here -->
    </div>

    <!-- Store Cart FAB (Visible across all Store views) -->
    <button id="cart-fab" title="Shopping Cart" class="fixed bottom-6 right-6 w-16 h-16 bg-blue-600 text-white rounded-full shadow-lg flex items-center justify-center transform hover:scale-110 transition-transform z-40">
        <svg class="w-7 h-7" fill="none" stroke="currentColor" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 3h2l.4 2M7 13h10l4-8H5.4M7 13L5.4 5M7 13l-2.293 2.293c-.63.63-.184 1.707.707 1.707H17m0 0a2 2 0 100 4 2 2 0 000-4zm-8 2a2 2 0 11-4 0 2 2 0 014 0z"></path></svg>
        <span id="cart-count" class="cart-badge">0</span>
    </button>

    <!-- Modals for Cart and Confirmation -->
    <div id="modal-backdrop" class="fixed inset-0 bg-black bg-opacity-50 z-50 hidden"></div>
    <div id="confirm-modal" class="fixed inset-0 flex items-center justify-center z-[52] p-4 hidden">
        <!-- Modal Content injected here -->
    </div>

    <script>
        // --- MOCK DATA ---
        let state = {
            currentView: 'home', // Changed default to 'home'
            selectedStoreId: null,
            selectedCategory: null,
            selectedProductName: null, 
            cart: [],
            productVariants: {
                size: null,
                color: null
            },
            stores: [
                { id: 'store1', name: 'Swim Gear Pro', photo: 'https://placehold.co/100x100/3b82f6/ffffff?text=SGP', location: '15.345, 44.567 (Riyadh)', shipping: true, categories: ['Suits', 'Goggles', 'Training'], mostSold: ['Pro Racing Suit', 'Mirrored Goggles', 'Kickboard Pro'] },
                { id: 'store2', name: 'Aqua Outlet', photo: 'https://placehold.co/100x100/06b6d4/ffffff?text=AO', location: '15.123, 44.789 (Jeddah)', shipping: false, categories: ['Fins', 'Paddles', 'Snorkels'], mostSold: ['Short Blade Fins'] },
                { id: 'store3', name: 'Triathlon Hub', photo: 'https://placehold.co/100x100/ef4444/ffffff?text=TH', location: '15.987, 44.321 (Dammam)', shipping: true, categories: ['Wetsuits', 'Bags', 'Nutrition'], mostSold: [] },
            ],
            storeProducts: { 
                'store1': {
                    'Suits': [
                        { id: 'p1', name: 'Pro Racing Suit', size: '32', price: 150.00, brand: 'Speedo', description: 'Elite FINA-approved suit for competitions. Maximizes hydrodynamics.', photos: ['https://placehold.co/600x600/1e40af/ffffff?text=SUIT+A', 'https://placehold.co/600x600/1e40af/ffffff?text=SUIT+B'], availableSizes: ['28', '30', '32', '34'], availableColors: ['Black', 'Navy', 'Red'], defaultSize: '32', defaultColor: 'Black' }, 
                        { id: 'p2', name: 'Practice Suit', size: '34', price: 45.00, brand: 'Arena', description: 'Durable chlorine-resistant material for daily training sessions.', photos: ['https://placehold.co/600x600/22c55e/ffffff?text=PRAC+A'], availableSizes: ['30', '32', '34', '36'], availableColors: ['Blue', 'Green'], defaultSize: '34', defaultColor: 'Blue' }
                    ],
                    'Goggles': [
                        { id: 'p3', name: 'Mirrored Goggles', size: 'Adjustable', price: 25.00, brand: 'Zoggs', description: 'Mirrored lenses reduce glare for outdoor swimming.', photos: ['https://placehold.co/600x600/f97316/ffffff?text=GOGGLE+A', 'https://placehold.co/600x600/f97316/ffffff?text=GOGGLE+B', 'https://placehold.co/600x600/f97316/ffffff?text=GOGGLE+C'], availableSizes: ['Adjustable'], availableColors: ['Silver', 'Blue Mirror'], defaultSize: 'Adjustable', defaultColor: 'Silver' }
                    ],
                    'Training': [
                        { id: 'p4', name: 'Kickboard Pro', size: 'One Size', price: 12.00, brand: 'FINIS', description: 'Ergonomic shape for natural body position. Lightweight.', photos: ['https://placehold.co/600x600/0f766e/ffffff?text=KCK'], availableSizes: ['One Size'], availableColors: ['Yellow', 'Orange'], defaultSize: 'One Size', defaultColor: 'Yellow' }
                    ]
                },
                'store2': {
                    'Fins': [
                        { id: 'p5', name: 'Short Blade Fins', size: 'Shoe 9', price: 30.00, brand: 'Finis', description: 'Ideal for fast tempo kicking and ankle flexibility.', photos: ['https://placehold.co/600x600/06b6d4/ffffff?text=FINS+1'], availableSizes: ['Shoe 7', 'Shoe 8', 'Shoe 9'], availableColors: ['Blue'], defaultSize: 'Shoe 9', defaultColor: 'Blue' }
                    ]
                }
            }
        };

        let appContainer, cartCountDisplay, backdrop;

        // --- Core App Logic & State Management ---
        function setState(newState) {
            state = { ...state, ...newState };
            renderApp();
        }

        function navigate(view, id = null, category = null, productName = null) {
            // Reset variants when changing product or navigation state
            let variantsReset = { size: null, color: null };

            if (view === 'product-detail') {
                 // Initialize variants based on the product's defaults when entering detail view
                const store = state.stores.find(s => s.id === id);
                const categoryProducts = state.storeProducts[store.id]?.[category] || [];
                const product = categoryProducts.find(p => p.name === productName);
                
                if (product) {
                    variantsReset.size = product.defaultSize || null;
                    variantsReset.color = product.defaultColor || null;
                }
            }
            
            setState({ currentView: view, selectedStoreId: id, selectedCategory: category, selectedProductName: productName, productVariants: variantsReset });
        }
        
        function showSnackbar(message, isError = false) {
            const snackbar = document.createElement('div');
            snackbar.textContent = message;
            snackbar.className = `fixed bottom-6 left-1/2 -translate-x-1/2 px-6 py-3 rounded-lg shadow-lg text-white ${isError ? 'bg-red-500' : 'bg-green-500'} z-[60]`;
            document.body.appendChild(snackbar);
            setTimeout(() => {
                snackbar.remove();
            }, 3000);
        }

        // --- Global Rendering ---
        function renderApp() {
            cartCountDisplay.textContent = state.cart.length;
            
            let content = '';
            let headerTitle = 'Stores';
            let backAction = null;

            switch (state.currentView) {
                case 'home':
                    content = renderHomeView();
                    headerTitle = 'Swim 360 Dashboard';
                    break;
                case 'stores-list':
                    content = renderStoresListView();
                    headerTitle = 'Shops & Retailers';
                    backAction = () => navigate('home');
                    break;
                case 'store-profile':
                    content = renderStoreProfileView();
                    const store = state.stores.find(s => state.selectedStoreId);
                    headerTitle = store ? store.name : 'Store Profile';
                    backAction = () => navigate('stores-list');
                    break;
                case 'store-products':
                    content = renderStoreProductsView();
                    headerTitle = state.selectedCategory ? state.selectedCategory : 'Products';
                    backAction = () => navigate('store-profile', state.selectedStoreId);
                    break;
                case 'product-detail':
                    content = renderProductDetailView();
                    const productStore = state.stores.find(s => state.selectedStoreId);
                    headerTitle = productStore ? productStore.name : 'Product Details';
                    backAction = () => navigate('store-products', state.selectedStoreId, state.selectedCategory);
                    break;
                default:
                    content = renderHomeView();
                    break;
            }
            
            appContainer.innerHTML = renderFullPageLayout(content, headerTitle, backAction);
        }

        // --- Global Layout ---
        function renderFullPageLayout(content, title, backAction) {
            const backButtonHtml = backAction ? `
                <button onclick="(${backAction.toString()})()" class="mr-4 p-2 rounded-full hover:bg-gray-100 transition">
                   <svg class="w-6 h-6 text-gray-700" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 19l-7-7 7-7"></path></svg>
                </button>
            ` : '';

            return `
                <header class="bg-white shadow-md sticky top-0 z-10">
                    <div class="p-4 flex items-center">
                        ${backButtonHtml}
                        <h1 class="text-xl font-bold truncate">${title}</h1>
                    </div>
                </header>
                <div class="view-container">
                    ${content}
                </div>
            `;
        }

        // --- 0. HOME PAGE RENDERER (Role-Based) ---
        function renderHomeView() {
            // Mock getting the saved role from the profile screen
            const mockRole = localStorage.getItem('selectedRole') || 'academy'; // Testing Academy Dashboard
            const userName = 'John Doe';
            const welcomeMessage = `Hello, ${userName}!`;
            let dashboardContent;

            if (mockRole === 'swimmer' || mockRole === 'parent') {
                dashboardContent = renderSwimmerDashboard(welcomeMessage);
            } else if (mockRole === 'clinic' || mockRole === 'coach') {
                 dashboardContent = renderClinicDashboard(welcomeMessage);
            } else if (mockRole === 'event-organizer') {
                 dashboardContent = renderOrganizerDashboard(welcomeMessage);
            } else if (mockRole === 'online-coach') {
                 dashboardContent = renderOnlineCoachDashboard(welcomeMessage);
            } else if (mockRole === 'shop') {
                 dashboardContent = renderShopDashboard(welcomeMessage);
            } else if (mockRole === 'academy') {
                 dashboardContent = renderAcademyDashboard(welcomeMessage);
            } else {
                dashboardContent = `<div class="p-4 pt-12 text-center text-gray-500">Please complete your profile role selection to view your personalized dashboard.</div>`;
            }
            
            return dashboardContent;
        }
        
        function renderSwimmerDashboard(welcomeMessage) {
            return `
                <div class="p-4 md:p-8">
                    <h1 class="text-3xl font-extrabold text-gray-800 mb-2">${welcomeMessage}</h1>
                    <p class="text-gray-500 mb-6">Your dashboard for aquatic success.</p>
                    
                    <!-- NEW: Notifications Banner -->
                    <div class="bg-red-500 rounded-xl shadow-lg p-3 flex justify-between items-center text-white mb-4 cursor-pointer transform hover:scale-[1.005] transition duration-200" onclick="showSnackbar('Navigating to Notifications...', true)">
                        <span class="text-md font-extrabold">NOTIFICATIONS</span>
                        <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 17h5l-1.405-1.405A2.032 2.032 0 0118 14.158V11a6.002 6.002 0 00-4-5.659V5a2 2 0 10-4 0v.341C7.67 6.165 6 8.388 6 11v3.159c0 .538-.214 1.055-.595 1.436L4 17h5m6 0v1a3 3 0 11-6 0v-1m6 0H9"></path></svg>
                    </div>

                    <!-- Top Action Banner (Book Your Court/Session) -->
                    <div class="bg-blue-600 rounded-xl shadow-lg p-6 flex justify-between items-center text-white mb-6 cursor-pointer transform hover:scale-[1.01] transition duration-200" onclick="showSnackbar('Navigating to Booking...', false)">
                        <span class="text-xl font-extrabold">BOOK YOUR SESSION <span class="text-2xl ml-2">&gt;</span></span>
                        <svg class="w-10 h-10" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M20 7l-8-4-8 4m16 0l-8 4m8-4v10a2 2 0 01-2 2H6a2 2 0 01-2-2V7m16 0-8 4m-8-4v10m16 0-8 4"></path></svg>
                    </div>

                    <!-- Three Core Action Cards (My Orders, My Booking, My Programs) -->
                    <div class="grid grid-cols-3 gap-3 mb-8">
                        <button class="action-card p-4 text-center" onclick="showSnackbar('Navigating to My Orders...', false)">
                            <svg class="w-8 h-8 text-blue-600 mx-auto mb-2" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 002 2h2a2 2 0 002-2"></path></svg>
                            <span class="text-sm font-semibold">My Orders</span>
                        </button>
                        <button class="action-card p-4 text-center" onclick="showSnackbar('Navigating to My Bookings...', false)">
                            <svg class="w-8 h-8 text-blue-600 mx-auto mb-2" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z"></path></svg>
                            <span class="text-sm font-semibold">My Booking</span>
                        </button>
                        <button class="action-card p-4 text-center" onclick="showSnackbar('Navigating to My Programs...', false)">
                            <svg class="w-8 h-8 text-blue-600 mx-auto mb-2" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z"></path></svg>
                            <span class="text-sm font-semibold">My Programs</span>
                        </button>
                    </div>

                    <!-- Dynamic Poster/Offers Section (Scrolling Banner) -->
                    <h2 class="text-xl font-bold mb-3">Today's Offers & Events</h2>
                    <div class="flex overflow-x-auto space-x-4 pb-4 poster-scroll">
                        <!-- Poster 1: Featured Event -->
                        <div class="w-64 flex-shrink-0 rounded-xl overflow-hidden shadow-lg border border-gray-200 cursor-pointer" onclick="showSnackbar('Viewing Featured Event: Stroke Clinic', false)">
                            <img src="https://placehold.co/600x350/93c5fd/1e3a8a?text=Stroke+Clinic+Offer" alt="Featured Event Poster" class="w-full h-32 object-cover">
                            <div class="p-3">
                                <p class="font-bold text-lg text-red-700">Create Event</p>
                                <p class="text-sm text-gray-700">Set up a new swim meet or clinic.</p>
                            </div>
                        </div>

                        <!-- Poster 2: Create Offer -->
                        <div class="w-64 flex-shrink-0 rounded-xl overflow-hidden shadow-lg border border-gray-200 cursor-pointer bg-yellow-100" onclick="showSnackbar('Opening Create Offer Form...', false)">
                            <div class="p-3">
                                <p class="font-bold text-lg text-yellow-700">Create Offer</p>
                                <p class="text-sm text-gray-700">Post a discount code or package deal.</p>
                            </div>
                        </div>
                        
                        <!-- Poster 3: Advertise -->
                        <div class="w-64 flex-shrink-0 rounded-xl overflow-hidden shadow-lg border border-gray-200 cursor-pointer bg-green-100" onclick="showSnackbar('Opening Advertising Tools...', false)">
                            <div class="p-3">
                                <p class="font-bold text-lg text-green-700">Advertise</p>
                                <p class="text-sm text-gray-700">Promote your brand to our users.</p>
                            </div>
                        </div>
                    </div>

                </div>
            `;
        }

        function renderClinicDashboard(welcomeMessage) {
            // NOTE: Clinic Dashboard handles the original 4-button requirement
            return `
                <div class="p-4 md:p-8">
                    <h1 class="text-3xl font-extrabold text-gray-800 mb-2">${welcomeMessage}</h1>
                    <p class="text-gray-500 mb-6">Clinic Management Dashboard.</p>
                    
                    <!-- Notifications Banner --><div class="bg-red-500 rounded-xl shadow-lg p-3 flex justify-between items-center text-white mb-4 cursor-pointer transform hover:scale-[1.005] transition duration-200" onclick="showSnackbar('Navigating to Notifications...', true)">
                        <span class="text-md font-extrabold">NOTIFICATIONS</span>
                        <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 17h5l-1.405-1.405A2.032 2.032 0 0118 14.158V11a6.002 6.002 0 00-4-5.659V5a2 2 0 10-4 0v.341C7.67 6.165 6 8.388 6 11v3.159c0 .538-.214 1.055-.595 1.436L4 17h5m6 0v1a3 3 0 11-6 0v-1m6 0H9"></path></svg>
                    </div>

                    <!-- Primary Action Banner: BOOKINGS --><div class="bg-blue-600 rounded-xl shadow-lg p-6 flex justify-between items-center text-white mb-6 cursor-pointer transform hover:scale-[1.01] transition duration-200" onclick="showSnackbar('Navigating to Bookings Overview...', false)">
                        <span class="text-xl font-extrabold">BOOKINGS <span class="text-2xl ml-2">&gt;</span></span>
                         <svg class="w-10 h-10" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z"></path></svg>
                    </div>

                    <!-- Core Action Cards (Matching Image Style) --><div class="grid grid-cols-2 gap-3 mb-8">
                        
                        <!-- 1. Reg. Branch --><button class="action-card p-4 text-center" onclick="showSnackbar('Navigating to Register Branch Form...', false)">
                            <svg class="w-8 h-8 text-blue-600 mx-auto mb-2" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v16m8-8H4M16 11H8m8 4H8"></path></svg>
                            <span class="text-sm font-semibold">Reg. Branch</span>
                        </button>
                        
                        <!-- 2. My Branches --><button class="action-card p-4 text-center" onclick="showSnackbar('Navigating to My Branches...', false)">
                            <svg class="w-8 h-8 text-blue-600 mx-auto mb-2" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 21V5a2 2 0 00-2-2H7a2 2 0 00-2 2v16m14 0h2m-2 0h-5m-9 0H3m2 0h5M9 10h6"></path></svg>
                            <span class="text-sm font-semibold">My Branches</span>
                        </button>
                        
                        <!-- 3. My Services --><button class="action-card p-4 text-center" onclick="showSnackbar('Navigating to My Services...', false)">
                            <svg class="w-8 h-8 text-blue-600 mx-auto mb-2" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 11H5m14 0a2 2 0 012 2v6a2 2 0 01-2 2H5a2 2 0 01-2-2v-6a2 2 0 012-2m14 0V9a2 2 0 00-2-2M5 11V9a2 2 0 012-2m0 0V5a2 2 0 012-2h6a2 2 0 012 2v2M7 7h10"></path></svg>
                            <span class="text-sm font-semibold">My Services</span>
                        </button>

                        <!-- 4. Manual Booking --><button class="action-card p-4 text-center" onclick="showSnackbar('Navigating to Manual Booking Tool...', false)">
                            <svg class="w-8 h-8 text-blue-600 mx-auto mb-2" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z" /><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 12h2.25M17.25 12h2.25M12 15v2.25M12 17.25v2.25M4.75 12h-2.25M2.5 12h-2.25M12 4.75v-2.25M12 2.5v-2.25" /></svg>
                            <span class="text-sm font-semibold">Manual Booking</span>
                        </button>

                    </div>

                    <!-- Dynamic Poster/Offers Section (Scrolling Banner) --><h2 class="text-xl font-bold mb-3">Management Actions</h2>
                    <div class="flex overflow-x-auto space-x-4 pb-4 poster-scroll">
                        <!-- Poster 1: Create Event --><div class="w-64 flex-shrink-0 rounded-xl overflow-hidden shadow-lg border border-gray-200 cursor-pointer bg-red-100" onclick="showSnackbar('Opening Create Event Form...', false)">
                            <div class="p-3">
                                <p class="font-bold text-lg text-red-700">Create Event</p>
                                <p class="text-sm text-gray-700">Set up a new swim meet or clinic.</p>
                            </div>
                        </div>

                        <!-- Poster 2: Create Offer --><div class="w-64 flex-shrink-0 rounded-xl overflow-hidden shadow-lg border border-gray-200 cursor-pointer bg-yellow-100" onclick="showSnackbar('Opening Create Offer Form...', false)">
                            <div class="p-3">
                                <p class="font-bold text-lg text-yellow-700">Create Offer</p>
                                <p class="text-sm text-gray-700">Post a discount code or package deal.</p>
                            </div>
                        </div>
                        
                        <!-- Poster 3: Advertise --><div class="w-64 flex-shrink-0 rounded-xl overflow-hidden shadow-lg border border-gray-200 cursor-pointer bg-green-100" onclick="showSnackbar('Opening Advertising Tools...', false)">
                            <div class="p-3">
                                <p class="font-bold text-lg text-green-700">Advertise</p>
                                <p class="text-sm text-gray-700">Promote your brand to our users.</p>
                            </div>
                        </div>
                    </div>

                </div>
            `;
        }
        
        function renderAcademyDashboard(welcomeMessage) {
             return `
                <div class="p-4 md:p-8">
                    <h1 class="text-3xl font-extrabold text-gray-800 mb-2">${welcomeMessage}</h1>
                    <p class="text-gray-500 mb-6">Academy Management Dashboard.</p>
                    
                    <!-- Notifications Banner --><div class="bg-red-500 rounded-xl shadow-lg p-3 flex justify-between items-center text-white mb-4 cursor-pointer transform hover:scale-[1.005] transition duration-200" onclick="showSnackbar('Navigating to Notifications...', true)">
                        <span class="text-md font-extrabold">NOTIFICATIONS</span>
                        <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 17h5l-1.405-1.405A2.032 2.032 0 0118 14.158V11a6.002 6.002 0 00-4-5.659V5a2 2 0 10-4 0v.341C7.67 6.165 6 8.388 6 11v3.159c0 .538-.214 1.055-.595 1.436L4 17h5m6 0v1a3 3 0 11-6 0v-1m6 0H9"></path></svg>
                    </div>

                    <!-- Primary Action Banner: MY CLIENTS -->
                    <div class="bg-blue-600 rounded-xl shadow-lg p-6 flex justify-between items-center text-white mb-6 cursor-pointer transform hover:scale-[1.01] transition duration-200" onclick="showSnackbar('Navigating to Client Roster...', false)">
                        <span class="text-xl font-extrabold">MY CLIENTS <span class="text-2xl ml-2">&gt;</span></span>
                         <svg class="w-10 h-10" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 20h2a2 2 0 002-2V5a2 2 0 00-2-2H5a2 2 0 00-2 2v13a2 2 0 002 2h2M9 14v6M15 14v6M12 3v18"></path></svg>
                    </div>

                    <!-- Core Action Cards (2x2 Grid) -->
                    <div class="grid grid-cols-2 gap-3 mb-8">
                        
                        <!-- 1. My Programs -->
                        <button class="action-card p-4 text-center" onclick="showSnackbar('Navigating to My Programs List...', false)">
                            <svg class="w-8 h-8 text-blue-600 mx-auto mb-2" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z"></path></svg>
                            <span class="text-sm font-semibold">My Programs</span>
                        </button>
                        
                        <!-- 2. Add Program -->
                        <button class="action-card p-4 text-center" onclick="showSnackbar('Navigating to Add Program Form...', false)">
                            <svg class="w-8 h-8 text-blue-600 mx-auto mb-2" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v16m8-8H4" /></svg>
                            <span class="text-sm font-semibold">Add Program</span>
                        </button>
                        
                        <!-- 3. My Branches -->
                        <button class="action-card p-4 text-center" onclick="showSnackbar('Navigating to My Branches List...', false)">
                            <svg class="w-8 h-8 text-blue-600 mx-auto mb-2" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 21V5a2 2 0 00-2-2H7a2 2 0 00-2 2v16m14 0h2m-2 0h-5m-9 0H3m2 0h5M9 10h6"></path></svg>
                            <span class="text-sm font-semibold">My Branches</span>
                        </button>

                        <!-- 4. Add Branch -->
                         <button class="action-card p-4 text-center" onclick="showSnackbar('Navigating to Add Branch Form...', false)">
                            <svg class="w-8 h-8 text-blue-600 mx-auto mb-2" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v16m8-8H4" /></svg>
                            <span class="text-sm font-semibold">Add Branch</span>
                        </button>
                        
                    </div>

                    <!-- Dynamic Poster/Offers Section (Scrolling Banner) --><h2 class="text-xl font-bold mb-3">Management Actions</h2>
                    <div class="flex overflow-x-auto space-x-4 pb-4 poster-scroll">
                        <!-- Poster 1: Create Event -->
                        <div class="w-64 flex-shrink-0 rounded-xl overflow-hidden shadow-lg border border-gray-200 cursor-pointer bg-red-100" onclick="showSnackbar('Opening Create Event Form...', false)">
                            <div class="p-3">
                                <p class="font-bold text-lg text-red-700">Create Event</p>
                                <p class="text-sm text-gray-700">Set up a new swim meet or clinic.</p>
                            </div>
                        </div>

                        <!-- Poster 2: Create Offer -->
                        <div class="w-64 flex-shrink-0 rounded-xl overflow-hidden shadow-lg border border-gray-200 cursor-pointer bg-yellow-100" onclick="showSnackbar('Opening Create Offer Form...', false)">
                            <div class="p-3">
                                <p class="font-bold text-lg text-yellow-700">Create Offer</p>
                                <p class="text-sm text-gray-700">Post a discount code or package deal.</p>
                            </div>
                        </div>
                        
                        <!-- Poster 3: Advertise -->
                        <div class="w-64 flex-shrink-0 rounded-xl overflow-hidden shadow-lg border border-gray-200 cursor-pointer bg-green-100" onclick="showSnackbar('Opening Advertising Tools...', false)">
                            <div class="p-3">
                                <p class="font-bold text-lg text-green-700">Advertise</p>
                                <p class="text-sm text-gray-700">Promote your brand to our users.</p>
                            </div>
                        </div>
                    </div>

                </div>
            `;
        }

        function renderOnlineCoachDashboard(welcomeMessage) {
             return `
                <div class="p-4 md:p-8">
                    <h1 class="text-3xl font-extrabold text-gray-800 mb-2">${welcomeMessage}</h1>
                    <p class="text-gray-500 mb-6">Online Coach Dashboard.</p>
                    
                    <!-- Notifications Banner --><div class="bg-red-500 rounded-xl shadow-lg p-3 flex justify-between items-center text-white mb-4 cursor-pointer transform hover:scale-[1.005] transition duration-200" onclick="showSnackbar('Navigating to Notifications...', true)">
                        <span class="text-md font-extrabold">NOTIFICATIONS</span>
                        <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 17h5l-1.405-1.405A2.032 2.032 0 0118 14.158V11a6.002 6.002 0 00-4-5.659V5a2 2 0 10-4 0v.341C7.67 6.165 6 8.388 6 11v3.159c0 .538-.214 1.055-.595 1.436L4 17h5m6 0v1a3 3 0 11-6 0v-1m6 0H9"></path></svg>
                    </div>

                    <!-- Primary Action Banner: CREATE PROGRAM --><div class="bg-blue-600 rounded-xl shadow-lg p-6 flex justify-between items-center text-white mb-6 cursor-pointer transform hover:scale-[1.01] transition duration-200" onclick="showSnackbar('Navigating to Create Program Form...', false)">
                        <span class="text-xl font-extrabold">CREATE PROGRAM <span class="text-2xl ml-2">&gt;</span></span>
                         <svg class="w-10 h-10" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M14 2H6a2 2 0 00-2 2v16a2 2 0 002 2h12a2 2 0 002-2V8z" /><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M14 2v6h6" /><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v16m8-8H4" /></svg>
                    </div>

                    <!-- Core Action Cards (2x1 Grid) --><div class="grid grid-cols-2 gap-3 mb-8">
                        
                        <!-- My Programs --><button class="action-card p-4 text-center" onclick="showSnackbar('Navigating to My Programs List...', false)">
                            <svg class="w-8 h-8 text-blue-600 mx-auto mb-2" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z"></path></svg>
                            <span class="text-sm font-semibold">My Programs</span>
                        </button>
                        
                        <!-- My Clients --><button class="action-card p-4 text-center" onclick="showSnackbar('Navigating to Client Roster...', false)">
                            <svg class="w-8 h-8 text-blue-600 mx-auto mb-2" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 20h2a2 2 0 002-2V5a2 2 0 00-2-2H5a2 2 0 00-2 2v13a2 2 0 002 2h2M9 14v6M15 14v6M12 3v18"></path></svg>
                            <span class="text-sm font-semibold">My Clients</span>
                        </button>
                        
                    </div>

                    <!-- Dynamic Poster/Offers Section (Scrolling Banner) --><h2 class="text-xl font-bold mb-3">Promotional Tools</h2>
                    <div class="flex overflow-x-auto space-x-4 pb-4 poster-scroll">
                        <!-- Poster 1: Create Event (Example of secondary creation option) --><div class="w-64 flex-shrink-0 rounded-xl overflow-hidden shadow-lg border border-gray-200 cursor-pointer bg-red-100" onclick="showSnackbar('Opening Create Event Form...', false)">
                            <div class="p-3">
                                <p class="font-bold text-lg text-red-700">Create Event</p>
                                <p class="text-sm text-gray-700">Set up a new swim meet or clinic.</p>
                            </div>
                        </div>

                        <!-- Poster 2: Create Offer --><div class="w-64 flex-shrink-0 rounded-xl overflow-hidden shadow-lg border border-gray-200 cursor-pointer bg-yellow-100" onclick="showSnackbar('Opening Create Offer Form...', false)">
                            <div class="p-3">
                                <p class="font-bold text-lg text-yellow-700">Create Offer</p>
                                <p class="text-sm text-gray-700">Post a discount code or package deal.</p>
                            </div>
                        </div>
                        
                        <!-- Poster 3: Advertise --><div class="w-64 flex-shrink-0 rounded-xl overflow-hidden shadow-lg border border-gray-200 cursor-pointer bg-green-100" onclick="showSnackbar('Opening Advertising Tools...', false)">
                            <div class="p-3">
                                <p class="font-bold text-lg text-green-700">Advertise</p>
                                <p class="text-sm text-gray-700">Promote your brand to our users.</p>
                            </div>
                        </div>
                    </div>

                </div>
            `;
        }

        function renderShopDashboard(welcomeMessage) {
             return `
                <div class="p-4 md:p-8">
                    <h1 class="text-3xl font-extrabold text-gray-800 mb-2">${welcomeMessage}</h1>
                    <p class="text-gray-500 mb-6">Store Management Dashboard.</p>
                    
                    <!-- Notifications Banner -->
                    <div class="bg-red-500 rounded-xl shadow-lg p-3 flex justify-between items-center text-white mb-4 cursor-pointer transform hover:scale-[1.005] transition duration-200" onclick="showSnackbar('Navigating to Notifications...', true)">
                        <span class="text-md font-extrabold">NOTIFICATIONS</span>
                        <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 17h5l-1.405-1.405A2.032 2.032 0 0118 14.158V11a6.002 6.002 0 00-4-5.659V5a2 2 0 10-4 0v.341C7.67 6.165 6 8.388 6 11v3.159c0 .538-.214 1.055-.595 1.436L4 17h5m6 0v1a3 3 0 11-6 0v-1m6 0H9"></path></svg>
                    </div>

                    <!-- Primary Action Banner: MY ORDERS -->
                    <div class="bg-blue-600 rounded-xl shadow-lg p-6 flex justify-between items-center text-white mb-6 cursor-pointer transform hover:scale-[1.01] transition duration-200" onclick="showSnackbar('Navigating to My Orders/Sales...', false)">
                        <span class="text-xl font-extrabold">MY ORDERS <span class="text-2xl ml-2">&gt;</span></span>
                         <svg class="w-10 h-10" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 002 2h2a2 2 0 002-2"></path></svg>
                    </div>

                    <!-- Core Action Cards (2x2 Grid for essential management) -->
                    <div class="grid grid-cols-2 gap-3 mb-8">
                        
                        <!-- 1. My Branches -->
                        <button class="action-card p-4 text-center" onclick="showSnackbar('Navigating to My Branches List...', false)">
                            <svg class="w-8 h-8 text-blue-600 mx-auto mb-2" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 21V5a2 2 0 00-2-2H7a2 2 0 00-2 2v16m14 0h2m-2 0h-5m-9 0H3m2 0h5M9 10h6"></path></svg>
                            <span class="text-sm font-semibold">My Branches</span>
                        </button>
                        
                        <!-- 2. Add Branch -->
                        <button class="action-card p-4 text-center" onclick="showSnackbar('Navigating to Add Branch Form...', false)">
                            <svg class="w-8 h-8 text-blue-600 mx-auto mb-2" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v16m8-8H4" /></svg>
                            <span class="text-sm font-semibold">Add Branch</span>
                        </button>
                        
                        <!-- 3. My Products -->
                        <button class="action-card p-4 text-center" onclick="showSnackbar('Navigating to My Products Inventory...', false)">
                            <svg class="w-8 h-8 text-blue-600 mx-auto mb-2" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2"></path></svg>
                            <span class="text-sm font-semibold">My Products</span>
                        </button>

                        <!-- 4. Add Products (Register Product) -->
                         <button class="action-card p-4 text-center" onclick="showSnackbar('Navigating to Add Products Form...', false)">
                            <svg class="w-8 h-8 text-blue-600 mx-auto mb-2" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v16m8-8H4" /></svg>
                            <span class="text-sm font-semibold">Add Products</span>
                        </button>
                        
                    </div>

                    <!-- Secondary Action Banner: Inventory Management -->
                    <div class="bg-gray-100 rounded-xl p-4 text-center cursor-pointer hover:bg-gray-200 transition duration-200" onclick="showSnackbar('Navigating to Inventory Management...', false)">
                        <span class="text-md font-semibold text-gray-700 flex items-center justify-center">
                            <svg class="w-5 h-5 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M20 7l-8-4-8 4m16 0l-8 4m8-4v10a2 2 0 01-2 2H6a2 2 0 01-2-2V7m16 0-8 4m-8-4v10m16 0-8 4" /></svg>
                            Inventory/Catalog Management
                        </span>
                    </div>

                    <!-- Dynamic Poster/Offers Section (Scrolling Banner) -->
                    <h2 class="text-xl font-bold mb-3 mt-6">Marketing Tools</h2>
                    <div class="flex overflow-x-auto space-x-4 pb-4 poster-scroll">
                        <!-- Poster 1: Create Event -->
                        <div class="w-64 flex-shrink-0 rounded-xl overflow-hidden shadow-lg border border-gray-200 cursor-pointer bg-red-100" onclick="showSnackbar('Opening Create Event Form...', false)">
                            <div class="p-3">
                                <p class="font-bold text-lg text-red-700">Create Event</p>
                                <p class="text-sm text-gray-700">Set up a new swim meet or clinic.</p>
                            </div>
                        </div>

                        <!-- Poster 2: Create Offer -->
                        <div class="w-64 flex-shrink-0 rounded-xl overflow-hidden shadow-lg border border-gray-200 cursor-pointer bg-yellow-100" onclick="showSnackbar('Opening Create Offer Form...', false)">
                            <div class="p-3">
                                <p class="font-bold text-lg text-yellow-700">Create Offer</p>
                                <p class="text-sm text-gray-700">Post a discount code or package deal.</p>
                            </div>
                        </div>
                        
                        <!-- Poster 3: Advertise -->
                        <div class="w-64 flex-shrink-0 rounded-xl overflow-hidden shadow-lg border border-gray-200 cursor-pointer bg-green-100" onclick="showSnackbar('Opening Advertising Tools...', false)">
                            <div class="p-3">
                                <p class="font-bold text-lg text-green-700">Advertise</p>
                                <p class="text-sm text-gray-700">Promote your brand to our users.</p>
                            </div>
                        </div>
                    </div>

                </div>
            `;
        }


        // --- 1. STORES LIST VIEW ---
        function renderStoresListView() {
            const storeCards = state.stores.map(store => `
                <div onclick="navigate('store-profile', '${store.id}')" class="bg-white rounded-xl shadow-lg p-4 flex items-center space-x-4 cursor-pointer hover:shadow-xl transition duration-300">
                    <img src="${store.photo}" alt="${store.name} Logo" class="w-16 h-16 rounded-full object-cover border-2 border-blue-400">
                    <div class="flex-grow">
                        <h3 class="text-xl font-bold text-gray-900">${store.name}</h3>
                        ${store.shipping 
                            ? '<span class="text-sm font-semibold text-green-700">Shipping Available</span>' 
                            : '<span class="text-sm font-semibold text-red-500">Local Pickup Only</span>'
                        }
                    </div>
                    <svg class="w-6 h-6 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7"></path></svg>
                </div>
            `).join('');

            return `
                <div class="p-4 space-y-4">
                    <h1 class="text-3xl font-bold mb-4">Shops & Retailers</h1>
                    <div class="space-y-3">
                        ${storeCards}
                    </div>
                </div>
            `;
        }

        // --- 2. STORE PROFILE VIEW ---

        /**
         * Helper function to find the full product details (including category) from just the product name.
         * This is necessary to construct the correct navigation link.
         */
        function findProductDetails(storeId, productName) {
            const storeProducts = state.storeProducts[storeId];
            if (!storeProducts) return null;

            for (const category in storeProducts) {
                product = storeProducts[category].find(p => p.name === productName);
                if (product) {
                    return { product, category };
                }
            }
                return null;
        }


        function renderStoreProfileView() {
            const store = state.stores.find(s => s.id === state.selectedStoreId);
            if (!store) return `<p class="p-4">Store not found.</p>`;
            
            const mapsQuery = store.location.split('(')[0].trim();
            const mapsLink = `https://www.google.com/maps/search/?api=1&query=${encodeURIComponent(mapsQuery)}`;
            
            // --- MOST SOLD ITEMS (Actionable) ---
            const mostSoldItemsHtml = store.mostSold.map(productName => {
                const details = findProductDetails(store.id, productName);
                if (!details) {
                     return `<span class="bg-gray-100 px-3 py-1 rounded-full text-sm font-medium text-gray-400 cursor-not-allowed">${productName} (Out of Stock)</span>`;
                }
                const product = details.product;

                // Render as a clickable card/button
                return `
                    <button onclick="navigate('product-detail', '${store.id}', '${details.category}', '${product.name}')" 
                            class="flex flex-col items-center p-2 bg-blue-50 hover:bg-blue-100 rounded-lg transition duration-150 shadow-sm w-full">
                        <img src="${product.photos[0]}" alt="${productName}" class="w-16 h-16 object-cover rounded-md mb-1">
                        <span class="text-xs font-medium text-blue-800 text-center line-clamp-2">${productName}</span>
                        <span class="text-xs font-bold text-teal-600">$${product.price.toFixed(2)}</span>
                    </button>
                `;
            }).join('');
            
            const categoryButtons = store.categories.map(cat => `
                <button onclick="navigate('store-products', '${store.id}', '${cat}')" 
                        class="px-4 py-2 bg-blue-500 text-white rounded-lg font-semibold hover:bg-blue-600 transition shadow-md whitespace-nowrap">
                    ${cat}
                </button>
            `).join('');

            return `
                <div class="p-4">
                    <div class="bg-white rounded-xl shadow-lg p-6 mb-6">
                        <div class="flex items-center space-x-4 mb-4 border-b pb-4">
                            <img src="${store.photo}" alt="${store.name} Logo" class="w-20 h-20 rounded-full object-cover border-4 border-blue-500">
                            <div>
                                <h1 class="text-3xl font-bold">${store.name}</h1>
                                ${store.shipping 
                                    ? '<span class="text-sm font-semibold text-green-700">Shipping Available</span>' 
                                    : '<span class="text-sm font-semibold text-red-500">Local Pickup Only</span>'
                                }
                            </div>
                        </div>
                        
                        <div class="mb-6">
                            <a href="${mapsLink}" target="_blank" class="flex items-center text-blue-600 hover:text-blue-800 font-medium">
                                <svg class="w-5 h-5 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17.657 16.657L13.414 20.9a1.998 1.998 0 01-2.828 0l-4.243-4.243a8 8 0 1111.314 0z"></path><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 11a3 3 0 11-6 0 3 3 0 016 0z"></path></svg>
                                View Location on Map
                            </a>
                        </div>
                        
                        <h3 class="text-xl font-bold mb-3">Most Sold Items</h3>
                        <div class="grid grid-cols-3 gap-2 mb-6">
                            ${mostSoldItemsHtml}
                        </div>
                        
                        <h3 class="text-xl font-bold mb-3">Browse Categories</h3>
                        <div class="flex flex-wrap gap-3">
                            ${categoryButtons}
                        </div>
                    </div>
                </div>
            `;
        }

        function renderStoreProductsView() {
            const store = state.stores.find(s => s.id === state.selectedStoreId);
            const products = state.storeProducts[state.selectedCategory] || [];
            
            const productCards = products.map(product => `
                <div class="bg-white rounded-xl shadow-lg p-3 flex items-center space-x-4">
                    <img src="${product.photo}" alt="${product.name}" class="w-16 h-16 object-cover rounded-md flex-shrink-0">
                    <div class="flex-grow">
                        <p class="font-bold text-gray-900">${product.name}</p>
                        <p class="text-sm text-gray-600">Size: ${product.size}</p>
                    </div>
                    <div class="text-right">
                        <p class="font-semibold text-blue-600">$${product.price.toFixed(2)}</p>
                        <button onclick="addToCart('${product.name}', '${store.name}')" class="text-xs bg-teal-500 text-white px-3 py-1 rounded-full hover:bg-teal-600 mt-1">Add to Cart</button>
                    </div>
                </div>
            `).join('');

            return `
                <div class="p-4">
                    <h2 class="text-2xl font-bold mb-4">${store.name} - ${state.selectedCategory}</h2>
                    <div class="space-y-3">
                        ${productCards}
                    </div>
                </div>
            `;
        }

        function addToCart(productName, storeName) {
            const currentCartStore = state.cart.length > 0 ? state.cart[0].storeName : null;

            if (currentCartStore && currentCartStore !== storeName) {
                // Cart reset required
                showConfirmCartReset(productName, storeName);
                return;
            }

            const newItem = { productName, storeName };
            setState({ cart: [...state.cart, newItem] });
            showSnackbar(`Added ${productName} to cart.`);
        }

        function showConfirmCartReset(productName, newStoreName) {
            const oldStoreName = state.cart[0].storeName;
            
            const modal = document.getElementById('confirm-modal');
            const backdrop = document.getElementById('modal-backdrop');
            
            modal.innerHTML = `
                <div class="bg-white p-6 rounded-lg shadow-xl w-full max-w-sm">
                    <h3 class="text-lg font-bold text-red-600">Reset Cart?</h3>
                    <p class="my-4 text-gray-700">Your cart currently contains items from **${oldStoreName}**. Adding an item from **${newStoreName}** requires clearing your current cart.</p>
                    <div class="flex justify-end space-x-2">
                        <button id="cancel-reset" class="px-4 py-2 bg-gray-200 rounded-lg">Cancel</button>
                        <button id="confirm-reset" class="px-4 py-2 bg-red-600 text-white rounded-lg">Reset Cart</button>
                    </div>
                </div>
            `;
            
            backdrop.classList.remove('hidden');
            modal.classList.remove('hidden');

            const closeModal = () => {
                modal.classList.add('hidden');
                backdrop.classList.add('hidden');
            };

            document.getElementById('cancel-reset').onclick = closeModal;
            document.getElementById('confirm-reset').onclick = () => {
                // Reset cart and add new item
                setState({ cart: [{ productName, storeName: newStoreName }] });
                showSnackbar(`Cart reset. Added ${productName} from ${newStoreName}.`);
                closeModal();
            };
            backdrop.onclick = closeModal;
        }

        function showCartModal() {
            const modal = document.getElementById('confirm-modal');
            const backdrop = document.getElementById('modal-backdrop');
            
            const cartListHtml = state.cart.length > 0 
                ? state.cart.map(item => `<li class="flex justify-between border-b pb-1"><span>${item.productName}</span><span class="text-sm text-gray-500">(${item.storeName})</span></li>`).join('')
                : '<p class="text-center text-gray-500 py-4">Your cart is empty.</p>';
            
            const totalItems = state.cart.length;

            modal.innerHTML = `
                <div class="bg-white p-6 rounded-lg shadow-xl w-full max-w-sm">
                    <h3 class="text-xl font-bold mb-4 flex justify-between items-center">
                        Shopping Cart
                        <span class="text-sm bg-blue-100 text-blue-600 px-3 py-1 rounded-full">${totalItems} items</span>
                    </h3>
                    <ul class="space-y-2 mb-6 max-h-60 overflow-y-auto">
                        ${cartListHtml}
                    </ul>
                    <button id="proceed-to-payment" 
                            class="w-full py-3 bg-blue-600 text-white font-semibold rounded-lg ${totalItems === 0 ? 'opacity-50 cursor-not-allowed' : 'hover:bg-blue-700'}"
                            ${totalItems === 0 ? 'disabled' : ''}>
                        Proceed to Payment
                    </button>
                    <button onclick="setState({cart: []}); showSnackbar('Cart cleared.'); showCartModal();" 
                            class="w-full mt-2 py-2 bg-gray-200 text-gray-800 font-semibold rounded-lg hover:bg-gray-300 transition">
                        Clear Cart
                    </button>
                    <button id="close-cart" class="w-full mt-2 text-sm text-gray-600">Close</button>
                </div>
            `;
            
            backdrop.classList.remove('hidden');
            modal.classList.remove('hidden');

            const closeModal = () => {
                modal.classList.add('hidden');
                backdrop.classList.add('hidden');
            };
            
            document.getElementById('close-cart').onclick = closeModal;
            backdrop.onclick = closeModal;
        }

        // --- Academy Dashboard Renderer (NEW LOGIC) ---
        function renderAcademyDashboard(welcomeMessage) {
            return `
                <div class="p-4 md:p-8">
                    <h1 class="text-3xl font-extrabold text-gray-800 mb-2">${welcomeMessage}</h1>
                    <p class="text-gray-500 mb-6">Academy Management Dashboard.</p>
                    
                    <!-- Notifications Banner --><div class="bg-red-500 rounded-xl shadow-lg p-3 flex justify-between items-center text-white mb-4 cursor-pointer transform hover:scale-[1.005] transition duration-200" onclick="showSnackbar('Navigating to Notifications...', true)">
                        <span class="text-md font-extrabold">NOTIFICATIONS</span>
                        <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 17h5l-1.405-1.405A2.032 2.032 0 0118 14.158V11a6.002 6.002 0 00-4-5.659V5a2 2 0 10-4 0v.341C7.67 6.165 6 8.388 6 11v3.159c0 .538-.214 1.055-.595 1.436L4 17h5m6 0v1a3 3 0 11-6 0v-1m6 0H9"></path></svg>
                    </div>

                    <!-- Primary Action Banner: MY CLIENTS -->
                    <div class="bg-blue-600 rounded-xl shadow-lg p-6 flex justify-between items-center text-white mb-6 cursor-pointer transform hover:scale-[1.01] transition duration-200" onclick="showSnackbar('Navigating to Client Roster...', false)">
                        <span class="text-xl font-extrabold">MY CLIENTS <span class="text-2xl ml-2">&gt;</span></span>
                         <svg class="w-10 h-10" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 20h2a2 2 0 002-2V5a2 2 0 00-2-2H5a2 2 0 00-2 2v13a2 2 0 002 2h2M9 14v6M15 14v6M12 3v18"></path></svg>
                    </div>

                    <!-- Core Action Cards (2x2 Grid) --><div class="grid grid-cols-2 gap-3 mb-8">
                        
                        <!-- 1. My Programs --><button class="action-card p-4 text-center" onclick="showSnackbar('Navigating to My Programs List...', false)">
                            <svg class="w-8 h-8 text-blue-600 mx-auto mb-2" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z"></path></svg>
                            <span class="text-sm font-semibold">My Programs</span>
                        </button>
                        
                        <!-- 2. Add Program --><button class="action-card p-4 text-center" onclick="showSnackbar('Navigating to Add Program Form...', false)">
                            <svg class="w-8 h-8 text-blue-600 mx-auto mb-2" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v16m8-8H4" /></svg>
                            <span class="text-sm font-semibold">Add Program</span>
                        </button>
                        
                        <!-- 3. My Branches --><button class="action-card p-4 text-center" onclick="showSnackbar('Navigating to My Branches List...', false)">
                            <svg class="w-8 h-8 text-blue-600 mx-auto mb-2" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 21V5a2 2 0 00-2-2H7a2 2 0 00-2 2v16m14 0h2m-2 0h-5m-9 0H3m2 0h5M9 10h6"></path></svg>
                            <span class="text-sm font-semibold">My Branches</span>
                        </button>

                        <!-- 4. Add Branch -->
                         <button class="action-card p-4 text-center" onclick="showSnackbar('Navigating to Add Branch Form...', false)">
                            <svg class="w-8 h-8 text-blue-600 mx-auto mb-2" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v16m8-8H4" /></svg>
                            <span class="text-sm font-semibold">Add Branch</span>
                        </button>
                        
                    </div>

                    <!-- Dynamic Poster/Offers Section (Scrolling Banner) --><h2 class="text-xl font-bold mb-3">Management Actions</h2>
                    <div class="flex overflow-x-auto space-x-4 pb-4 poster-scroll">
                        <!-- Poster 1: Create Event --><div class="w-64 flex-shrink-0 rounded-xl overflow-hidden shadow-lg border border-gray-200 cursor-pointer bg-red-100" onclick="showSnackbar('Opening Create Event Form...', false)">
                            <div class="p-3">
                                <p class="font-bold text-lg text-red-700">Create Event</p>
                                <p class="text-sm text-gray-700">Set up a new swim meet or clinic.</p>
                            </div>
                        </div>

                        <!-- Poster 2: Create Offer --><div class="w-64 flex-shrink-0 rounded-xl overflow-hidden shadow-lg border border-gray-200 cursor-pointer bg-yellow-100" onclick="showSnackbar('Opening Create Offer Form...', false)">
                            <div class="p-3">
                                <p class="font-bold text-lg text-yellow-700">Create Offer</p>
                                <p class="text-sm text-gray-700">Post a discount code or package deal.</p>
                            </div>
                        </div>
                        
                        <!-- Poster 3: Advertise --><div class="w-64 flex-shrink-0 rounded-xl overflow-hidden shadow-lg border border-gray-200 cursor-pointer bg-green-100" onclick="showSnackbar('Opening Advertising Tools...', false)">
                            <div class="p-3">
                                <p class="font-bold text-lg text-green-700">Advertise</p>
                                <p class="text-sm text-gray-700">Promote your brand to our users.</p>
                            </div>
                        </div>
                    </div>

                </div>
            `;
        }

        function renderOnlineCoachDashboard(welcomeMessage) {
             return `
                <div class="p-4 md:p-8">
                    <h1 class="text-3xl font-extrabold text-gray-800 mb-2">${welcomeMessage}</h1>
                    <p class="text-gray-500 mb-6">Online Coach Dashboard.</p>
                    
                    <!-- Notifications Banner --><div class="bg-red-500 rounded-xl shadow-lg p-3 flex justify-between items-center text-white mb-4 cursor-pointer transform hover:scale-[1.005] transition duration-200" onclick="showSnackbar('Navigating to Notifications...', true)">
                        <span class="text-md font-extrabold">NOTIFICATIONS</span>
                        <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 17h5l-1.405-1.405A2.032 2.032 0 0118 14.158V11a6.002 6.002 0 00-4-5.659V5a2 2 0 10-4 0v.341C7.67 6.165 6 8.388 6 11v3.159c0 .538-.214 1.055-.595 1.436L4 17h5m6 0v1a3 3 0 11-6 0v-1m6 0H9"></path></svg>
                    </div>

                    <!-- Primary Action Banner: CREATE PROGRAM --><div class="bg-blue-600 rounded-xl shadow-lg p-6 flex justify-between items-center text-white mb-6 cursor-pointer transform hover:scale-[1.01] transition duration-200" onclick="showSnackbar('Navigating to Create Program Form...', false)">
                        <span class="text-xl font-extrabold">CREATE PROGRAM <span class="text-2xl ml-2">&gt;</span></span>
                         <svg class="w-10 h-10" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M14 2H6a2 2 0 00-2 2v16a2 2 0 002 2h12a2 2 0 002-2V8z" /><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M14 2v6h6" /><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v16m8-8H4" /></svg>
                    </div>

                    <!-- Core Action Cards (2x1 Grid) --><div class="grid grid-cols-2 gap-3 mb-8">
                        
                        <!-- My Programs --><button class="action-card p-4 text-center" onclick="showSnackbar('Navigating to My Programs List...', false)">
                            <svg class="w-8 h-8 text-blue-600 mx-auto mb-2" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z"></path></svg>
                            <span class="text-sm font-semibold">My Programs</span>
                        </button>
                        
                        <!-- My Clients --><button class="action-card p-4 text-center" onclick="showSnackbar('Navigating to Client Roster...', false)">
                            <svg class="w-8 h-8 text-blue-600 mx-auto mb-2" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 20h2a2 2 0 002-2V5a2 2 0 00-2-2H5a2 2 0 00-2 2v13a2 2 0 002 2h2M9 14v6M15 14v6M12 3v18"></path></svg>
                            <span class="text-sm font-semibold">My Clients</span>
                        </button>
                        
                    </div>

                    <!-- Dynamic Poster/Offers Section (Scrolling Banner) --><h2 class="text-xl font-bold mb-3">Promotional Tools</h2>
                    <div class="flex overflow-x-auto space-x-4 pb-4 poster-scroll">
                        <!-- Poster 1: Create Event (Example of secondary creation option) --><div class="w-64 flex-shrink-0 rounded-xl overflow-hidden shadow-lg border border-gray-200 cursor-pointer bg-red-100" onclick="showSnackbar('Opening Create Event Form...', false)">
                            <div class="p-3">
                                <p class="font-bold text-lg text-red-700">Create Event</p>
                                <p class="text-sm text-gray-700">Set up a new swim meet or clinic.</p>
                            </div>
                        </div>

                        <!-- Poster 2: Create Offer --><div class="w-64 flex-shrink-0 rounded-xl overflow-hidden shadow-lg border border-gray-200 cursor-pointer bg-yellow-100" onclick="showSnackbar('Opening Create Offer Form...', false)">
                            <div class="p-3">
                                <p class="font-bold text-lg text-yellow-700">Create Offer</p>
                                <p class="text-sm text-gray-700">Post a discount code or package deal.</p>
                            </div>
                        </div>
                        
                        <!-- Poster 3: Advertise --><div class="w-64 flex-shrink-0 rounded-xl overflow-hidden shadow-lg border border-gray-200 cursor-pointer bg-green-100" onclick="showSnackbar('Opening Advertising Tools...', false)">
                            <div class="p-3">
                                <p class="font-bold text-lg text-green-700">Advertise</p>
                                <p class="text-sm text-gray-700">Promote your brand to our users.</p>
                            </div>
                        </div>
                    </div>

                </div>
            `;
        }

        function renderShopDashboard(welcomeMessage) {
             return `
                <div class="p-4 md:p-8">
                    <h1 class="text-3xl font-extrabold text-gray-800 mb-2">${welcomeMessage}</h1>
                    <p class="text-gray-500 mb-6">Store Management Dashboard.</p>
                    
                    <!-- Notifications Banner -->
                    <div class="bg-red-500 rounded-xl shadow-lg p-3 flex justify-between items-center text-white mb-4 cursor-pointer transform hover:scale-[1.005] transition duration-200" onclick="showSnackbar('Navigating to Notifications...', true)">
                        <span class="text-md font-extrabold">NOTIFICATIONS</span>
                        <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 17h5l-1.405-1.405A2.032 2.032 0 0118 14.158V11a6.002 6.002 0 00-4-5.659V5a2 2 0 10-4 0v.341C7.67 6.165 6 8.388 6 11v3.159c0 .538-.214 1.055-.595 1.436L4 17h5m6 0v1a3 3 0 11-6 0v-1m6 0H9"></path></svg>
                    </div>

                    <!-- Primary Action Banner: MY ORDERS -->
                    <div class="bg-blue-600 rounded-xl shadow-lg p-6 flex justify-between items-center text-white mb-6 cursor-pointer transform hover:scale-[1.01] transition duration-200" onclick="showSnackbar('Navigating to My Orders/Sales...', false)">
                        <span class="text-xl font-extrabold">MY ORDERS <span class="text-2xl ml-2">&gt;</span></span>
                         <svg class="w-10 h-10" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 002 2h2a2 2 0 002-2"></path></svg>
                    </div>

                    <!-- Core Action Cards (2x2 Grid for essential management) -->
                    <div class="grid grid-cols-2 gap-3 mb-8">
                        
                        <!-- 1. My Branches -->
                        <button class="action-card p-4 text-center" onclick="showSnackbar('Navigating to My Branches List...', false)">
                            <svg class="w-8 h-8 text-blue-600 mx-auto mb-2" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 21V5a2 2 0 00-2-2H7a2 2 0 00-2 2v16m14 0h2m-2 0h-5m-9 0H3m2 0h5M9 10h6"></path></svg>
                            <span class="text-sm font-semibold">My Branches</span>
                        </button>
                        
                        <!-- 2. Add Branch -->
                        <button class="action-card p-4 text-center" onclick="showSnackbar('Navigating to Add Branch Form...', false)">
                            <svg class="w-8 h-8 text-blue-600 mx-auto mb-2" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v16m8-8H4" /></svg>
                            <span class="text-sm font-semibold">Add Branch</span>
                        </button>
                        
                        <!-- 3. My Products -->
                        <button class="action-card p-4 text-center" onclick="showSnackbar('Navigating to My Products Inventory...', false)">
                            <svg class="w-8 h-8 text-blue-600 mx-auto mb-2" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2"></path></svg>
                            <span class="text-sm font-semibold">My Products</span>
                        </button>

                        <!-- 4. Add Products (Register Product) -->
                         <button class="action-card p-4 text-center" onclick="showSnackbar('Navigating to Add Products Form...', false)">
                            <svg class="w-8 h-8 text-blue-600 mx-auto mb-2" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v16m8-8H4" /></svg>
                            <span class="text-sm font-semibold">Add Products</span>
                        </button>
                        
                    </div>

                    <!-- Secondary Action Banner: Inventory Management -->
                    <div class="bg-gray-100 rounded-xl p-4 text-center cursor-pointer hover:bg-gray-200 transition duration-200" onclick="showSnackbar('Navigating to Inventory Management...', false)">
                        <span class="text-md font-semibold text-gray-700 flex items-center justify-center">
                            <svg class="w-5 h-5 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M20 7l-8-4-8 4m16 0l-8 4m8-4v10a2 2 0 01-2 2H6a2 2 0 01-2-2V7m16 0-8 4m-8-4v10m16 0-8 4" /></svg>
                            Inventory/Catalog Management
                        </span>
                    </div>

                    <!-- Dynamic Poster/Offers Section (Scrolling Banner) -->
                    <h2 class="text-xl font-bold mb-3 mt-6">Marketing Tools</h2>
                    <div class="flex overflow-x-auto space-x-4 pb-4 poster-scroll">
                        <!-- Poster 1: Create Event -->
                        <div class="w-64 flex-shrink-0 rounded-xl overflow-hidden shadow-lg border border-gray-200 cursor-pointer bg-red-100" onclick="showSnackbar('Opening Create Event Form...', false)">
                            <div class="p-3">
                                <p class="font-bold text-lg text-red-700">Create Event</p>
                                <p class="text-sm text-gray-700">Set up a new swim meet or clinic.</p>
                            </div>
                        </div>

                        <!-- Poster 2: Create Offer -->
                        <div class="w-64 flex-shrink-0 rounded-xl overflow-hidden shadow-lg border border-gray-200 cursor-pointer bg-yellow-100" onclick="showSnackbar('Opening Create Offer Form...', false)">
                            <div class="p-3">
                                <p class="font-bold text-lg text-yellow-700">Create Offer</p>
                                <p class="text-sm text-gray-700">Post a discount code or package deal.</p>
                            </div>
                        </div>
                        
                        <!-- Poster 3: Advertise -->
                        <div class="w-64 flex-shrink-0 rounded-xl overflow-hidden shadow-lg border border-gray-200 cursor-pointer bg-green-100" onclick="showSnackbar('Opening Advertising Tools...', false)">
                            <div class="p-3">
                                <p class="font-bold text-lg text-green-700">Advertise</p>
                                <p class="text-sm text-gray-700">Promote your brand to our users.</p>
                            </div>
                        </div>
                    </div>

                </div>
            `;
        }


        // --- 1. STORES LIST VIEW ---
        function renderStoresListView() {
            const storeCards = state.stores.map(store => `
                <div onclick="navigate('store-profile', '${store.id}')" class="bg-white rounded-xl shadow-lg p-4 flex items-center space-x-4 cursor-pointer hover:shadow-xl transition duration-300">
                    <img src="${store.photo}" alt="${store.name} Logo" class="w-16 h-16 rounded-full object-cover border-2 border-blue-400">
                    <div class="flex-grow">
                        <h3 class="text-xl font-bold text-gray-900">${store.name}</h3>
                        ${store.shipping 
                            ? '<span class="text-sm font-semibold text-green-700">Shipping Available</span>' 
                            : '<span class="text-sm font-semibold text-red-500">Local Pickup Only</span>'
                        }
                    </div>
                    <svg class="w-6 h-6 text-gray-400" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5l7 7-7 7"></path></svg>
                </div>
            `).join('');

            return `
                <div class="p-4 space-y-4">
                    <h1 class="text-3xl font-bold mb-4">Shops & Retailers</h1>
                    <div class="space-y-3">
                        ${storeCards}
                    </div>
                </div>
            `;
        }

        // --- 2. STORE PROFILE VIEW ---

        /**
         * Helper function to find the full product details (including category) from just the product name.
         * This is necessary to construct the correct navigation link.
         */
        function findProductDetails(storeId, productName) {
            const storeProducts = state.storeProducts[storeId];
            if (!storeProducts) return null;

            for (const category in storeProducts) {
                product = storeProducts[category].find(p => p.name === productName);
                if (product) {
                    return { product, category };
                }
            }
                return null;
        }


        function renderStoreProfileView() {
            const store = state.stores.find(s => s.id === state.selectedStoreId);
            if (!store) return `<p class="p-4">Store not found.</p>`;
            
            const mapsQuery = store.location.split('(')[0].trim();
            const mapsLink = `https://www.google.com/maps/search/?api=1&query=${encodeURIComponent(mapsQuery)}`;
            
            // --- MOST SOLD ITEMS (Actionable) ---
            const mostSoldItemsHtml = store.mostSold.map(productName => {
                const details = findProductDetails(store.id, productName);
                if (!details) {
                     return `<span class="bg-gray-100 px-3 py-1 rounded-full text-sm font-medium text-gray-400 cursor-not-allowed">${productName} (Out of Stock)</span>`;
                }
                const product = details.product;

                // Render as a clickable card/button
                return `
                    <button onclick="navigate('product-detail', '${store.id}', '${details.category}', '${product.name}')" 
                            class="flex flex-col items-center p-2 bg-blue-50 hover:bg-blue-100 rounded-lg transition duration-150 shadow-sm w-full">
                        <img src="${product.photos[0]}" alt="${productName}" class="w-16 h-16 object-cover rounded-md mb-1">
                        <span class="text-xs font-medium text-blue-800 text-center line-clamp-2">${productName}</span>
                        <span class="text-xs font-bold text-teal-600">$${product.price.toFixed(2)}</span>
                    </button>
                `;
            }).join('');
            
            const categoryButtons = store.categories.map(cat => `
                <button onclick="navigate('store-products', '${store.id}', '${cat}')" 
                        class="px-4 py-2 bg-blue-500 text-white rounded-lg font-semibold hover:bg-blue-600 transition shadow-md whitespace-nowrap">
                    ${cat}
                </button>
            `).join('');

            return `
                <div class="p-4">
                    <div class="bg-white rounded-xl shadow-lg p-6 mb-6">
                        <div class="flex items-center space-x-4 mb-4 border-b pb-4">
                            <img src="${store.photo}" alt="${store.name} Logo" class="w-20 h-20 rounded-full object-cover border-4 border-blue-500">
                            <div>
                                <h1 class="text-3xl font-bold">${store.name}</h1>
                                ${store.shipping 
                                    ? '<span class="text-sm font-semibold text-green-700">Shipping Available</span>' 
                                    : '<span class="text-sm font-semibold text-red-500">Local Pickup Only</span>'
                                }
                            </div>
                        </div>
                        
                        <div class="mb-6">
                            <a href="${mapsLink}" target="_blank" class="flex items-center text-blue-600 hover:text-blue-800 font-medium">
                                <svg class="w-5 h-5 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17.657 16.657L13.414 20.9a1.998 1.998 0 01-2.828 0l-4.243-4.243a8 8 0 1111.314 0z"></path><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 11a3 3 0 11-6 0 3 3 0 016 0z"></path></svg>
                                View Location on Map
                            </a>
                        </div>
                        
                        <h3 class="text-xl font-bold mb-3">Most Sold Items</h3>
                        <div class="grid grid-cols-3 gap-2 mb-6">
                            ${mostSoldItemsHtml}
                        </div>
                        
                        <h3 class="text-xl font-bold mb-3">Browse Categories</h3>
                        <div class="flex flex-wrap gap-3">
                            ${categoryButtons}
                        </div>
                    </div>
                </div>
            `;
        }

        function renderStoreProductsView() {
            const store = state.stores.find(s => s.id === state.selectedStoreId);
            const products = state.storeProducts[state.selectedCategory] || [];
            
            const productCards = products.map(product => `
                <div class="bg-white rounded-xl shadow-lg p-3 flex items-center space-x-4">
                    <img src="${product.photo}" alt="${product.name}" class="w-16 h-16 object-cover rounded-md flex-shrink-0">
                    <div class="flex-grow">
                        <p class="font-bold text-gray-900">${product.name}</p>
                        <p class="text-sm text-gray-600">Size: ${product.size}</p>
                    </div>
                    <div class="text-right">
                        <p class="font-semibold text-blue-600">$${product.price.toFixed(2)}</p>
                        <button onclick="addToCart('${product.name}', '${store.name}')" class="text-xs bg-teal-500 text-white px-3 py-1 rounded-full hover:bg-teal-600 mt-1">Add to Cart</button>
                    </div>
                </div>
            `).join('');

            return `
                <div class="p-4">
                    <h2 class="text-2xl font-bold mb-4">${store.name} - ${state.selectedCategory}</h2>
                    <div class="space-y-3">
                        ${productCards}
                    </div>
                </div>
            `;
        }

        function addToCart(productName, storeName) {
            const currentCartStore = state.cart.length > 0 ? state.cart[0].storeName : null;

            if (currentCartStore && currentCartStore !== storeName) {
                // Cart reset required
                showConfirmCartReset(productName, storeName);
                return;
            }

            const newItem = { productName, storeName };
            setState({ cart: [...state.cart, newItem] });
            showSnackbar(`Added ${productName} to cart.`);
        }

        function showConfirmCartReset(productName, newStoreName) {
            const oldStoreName = state.cart[0].storeName;
            
            const modal = document.getElementById('confirm-modal');
            const backdrop = document.getElementById('modal-backdrop');
            
            modal.innerHTML = `
                <div class="bg-white p-6 rounded-lg shadow-xl w-full max-w-sm">
                    <h3 class="text-lg font-bold text-red-600">Reset Cart?</h3>
                    <p class="my-4 text-gray-700">Your cart currently contains items from **${oldStoreName}**. Adding an item from **${newStoreName}** requires clearing your current cart.</p>
                    <div class="flex justify-end space-x-2">
                        <button id="cancel-reset" class="px-4 py-2 bg-gray-200 rounded-lg">Cancel</button>
                        <button id="confirm-reset" class="px-4 py-2 bg-red-600 text-white rounded-lg">Reset Cart</button>
                    </div>
                </div>
            `;
            
            backdrop.classList.remove('hidden');
            modal.classList.remove('hidden');

            const closeModal = () => {
                modal.classList.add('hidden');
                backdrop.classList.add('hidden');
            };

            document.getElementById('cancel-reset').onclick = closeModal;
            document.getElementById('confirm-reset').onclick = () => {
                // Reset cart and add new item
                setState({ cart: [{ productName, storeName: newStoreName }] });
                showSnackbar(`Cart reset. Added ${productName} from ${newStoreName}.`);
                closeModal();
            };
            backdrop.onclick = closeModal;
        }

        function showCartModal() {
            const modal = document.getElementById('confirm-modal');
            const backdrop = document.getElementById('modal-backdrop');
            
            const cartListHtml = state.cart.length > 0 
                ? state.cart.map(item => `<li class="flex justify-between border-b pb-1"><span>${item.productName}</span><span class="text-sm text-gray-500">(${item.storeName})</span></li>`).join('')
                : '<p class="text-center text-gray-500 py-4">Your cart is empty.</p>';
            
            const totalItems = state.cart.length;

            modal.innerHTML = `
                <div class="bg-white p-6 rounded-lg shadow-xl w-full max-w-sm">
                    <h3 class="text-xl font-bold mb-4 flex justify-between items-center">
                        Shopping Cart
                        <span class="text-sm bg-blue-100 text-blue-600 px-3 py-1 rounded-full">${totalItems} items</span>
                    </h3>
                    <ul class="space-y-2 mb-6 max-h-60 overflow-y-auto">
                        ${cartListHtml}
                    </ul>
                    <button id="proceed-to-payment" 
                            class="w-full py-3 bg-blue-600 text-white font-semibold rounded-lg ${totalItems === 0 ? 'opacity-50 cursor-not-allowed' : 'hover:bg-blue-700'}"
                            ${totalItems === 0 ? 'disabled' : ''}>
                        Proceed to Payment
                    </button>
                    <button onclick="setState({cart: []}); showSnackbar('Cart cleared.'); showCartModal();" 
                            class="w-full mt-2 py-2 bg-gray-200 text-gray-800 font-semibold rounded-lg hover:bg-gray-300 transition">
                        Clear Cart
                    </button>
                    <button id="close-cart" class="w-full mt-2 text-sm text-gray-600">Close</button>
                </div>
            `;
            
            backdrop.classList.remove('hidden');
            modal.classList.remove('hidden');

            const closeModal = () => {
                modal.classList.add('hidden');
                backdrop.classList.add('hidden');
            };
            
            document.getElementById('close-cart').onclick = closeModal;
            backdrop.onclick = closeModal;
        }

        // --- Initial Setup ---
        window.onload = () => {
            appContainer = document.getElementById('app-container');
            cartCountDisplay = document.getElementById('cart-fab').querySelector('.cart-badge');
            backdrop = document.getElementById('modal-backdrop');
            document.getElementById('cart-fab').onclick = showCartModal;
            renderApp();
        };
    </script>
</body>
</html>