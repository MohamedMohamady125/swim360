<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Used Swimming Gear</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <style>
        @import url('https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap');
        body {
            font-family: 'Inter', sans-serif;
            background-color: #F7F9FB;
        }
        /* Simple transition for view switching */
        .view-container {
            animation: fadeIn 0.3s ease-in-out;
        }
        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(10px); }
            to { opacity: 1; transform: translateY(0); }
        }
        /* Style for the filter modal */
        .filter-modal {
            transition: opacity 0.3s ease, visibility 0.3s ease;
        }
    </style>
</head>
<body class="text-gray-800">

    <div id="app-container">
        <!-- Views will be rendered here by JavaScript -->
    </div>

    <!-- Floating Action Buttons -->
    <div id="fab-container" class="fixed bottom-6 right-6 flex flex-col space-y-4 z-40">
        <button id="my-items-fab" title="My Items" class="w-16 h-16 bg-yellow-500 text-white rounded-full shadow-lg flex items-center justify-center transform hover:scale-110 transition-transform">
            <svg class="w-7 h-7" fill="none" stroke="currentColor" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M16 11V7a4 4 0 00-8 0v4M5 9h14l1 12H4L5 9z"></path></svg>
        </button>
        <button id="sell-item-fab" title="Sell Item" class="w-16 h-16 bg-teal-600 text-white rounded-full shadow-lg flex items-center justify-center transform hover:scale-110 transition-transform">
            <svg class="w-8 h-8" fill="none" stroke="currentColor" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 6v6m0 0v6m0-6h6m-6 0H6"></path></svg>
        </button>
    </div>

    <!-- Modals -->
    <div id="modal-backdrop" class="fixed inset-0 bg-black bg-opacity-50 z-50 hidden"></div>
    <div id="filter-modal" class="fixed inset-0 flex items-center justify-center z-[51] p-4 hidden filter-modal">
        <!-- Filter Modal Content will be injected here -->
    </div>
    <!-- FIX: Increased z-index to ensure it appears above other modals -->
    <div id="confirm-modal" class="fixed inset-0 flex items-center justify-center z-[52] p-4 hidden">
        <!-- Confirmation Modal Content will be injected here -->
    </div>

    <script>
        // --- Mock Data and State ---
        const CURRENT_USER_ID = 'user123';
        let state = {
            currentView: 'home',
            selectedItemId: null,
            items: [
                { id: 'item1', title: 'Speedo Fastskin LZR Racer', price: 299.99, photo: 'https://placehold.co/400x300/1e40af/ffffff?text=LZR+Suit', description: 'Elite racing suit, used once. Hydrodynamic compression.', condition: 'Excellent', size: 'M', contact: '966512345678', userId: 'user123', isSold: false, photos: ['https://placehold.co/400x300/1e40af/ffffff?text=LZR+Suit+1', 'https://placehold.co/400x300/1e40af/ffffff?text=LZR+Suit+2'] },
                { id: 'item2', title: 'Zoggs Predator Goggles', price: 15.00, photo: 'https://placehold.co/400x300/06b6d4/ffffff?text=Goggles', description: 'Good condition, anti-fog coating still strong. Blue lenses.', condition: 'Good', size: 'One Size', contact: '966598765432', userId: 'user456', isSold: false, photos: ['https://placehold.co/400x300/06b6d4/ffffff?text=Goggles+1'] },
                { id: 'item3', title: 'Arena Powerfin Pro', price: 35.50, photo: 'https://placehold.co/400x300/0f766e/ffffff?text=Fins', description: 'Size L training fins. Great for leg power and ankle flexibility.', condition: 'Fair', size: 'L', contact: '966511122233', userId: 'user123', isSold: false, photos: ['https://placehold.co/400x300/0f766e/ffffff?text=Fins+1', 'https://placehold.co/400x300/0f766e/ffffff?text=Fins+2', 'https://placehold.co/400x300/0f766e/ffffff?text=Fins+3'] },
                { id: 'item4', title: 'FINIS Snorkel', price: 25.00, photo: 'https://placehold.co/400x300/22c55e/ffffff?text=Snorkel', description: 'Excellent centre-mount snorkel, clear tube. Used lightly.', condition: 'Excellent', size: 'S', contact: '966554433221', userId: 'user789', isSold: true, photos: ['https://placehold.co/400x300/22c55e/ffffff?text=Snorkel+1'] },
                { id: 'item5', title: 'Water Polo Ball', price: 50.00, photo: 'https://placehold.co/400x300/f97316/ffffff?text=Ball', description: 'Official size 5 water polo ball. Barely used.', condition: 'New', size: 'M', contact: '966512345678', userId: 'user123', isSold: false, photos: ['https://placehold.co/400x300/f97316/ffffff?text=Ball+1', 'https://placehold.co/400x300/f97316/ffffff?text=Ball+2'] },
            ],
            filters: {
                searchTerm: "",
                condition: null,
                size: null,
                maxPrice: null,
            }
        };

        const appContainer = document.getElementById('app-container');
        
        // --- Core App Logic ---
        function setState(newState) {
            state = { ...state, ...newState };
            renderApp();
        }

        function navigate(view, itemId = null) {
            setState({ currentView: view, selectedItemId: itemId });
        }
        
        function showSnackbar(message, isError = false) {
            const snackbar = document.createElement('div');
            snackbar.textContent = message;
            snackbar.className = `fixed bottom-6 left-1/2 -translate-x-1/2 px-6 py-3 rounded-lg shadow-lg text-white ${isError ? 'bg-red-500' : 'bg-green-500'}`;
            document.body.appendChild(snackbar);
            setTimeout(() => {
                snackbar.remove();
            }, 3000);
        }

        // --- View Renderers ---
        function renderApp() {
            const fabContainer = document.getElementById('fab-container');
            fabContainer.style.display = state.currentView === 'home' ? 'flex' : 'none';

            switch (state.currentView) {
                case 'details':
                    appContainer.innerHTML = renderItemDetailView();
                    break;
                case 'sell':
                    appContainer.innerHTML = renderSellItemForm();
                    attachSellFormListeners();
                    break;
                case 'my-items':
                    appContainer.innerHTML = renderMyItemsView();
                    break;
                default:
                    appContainer.innerHTML = renderHomeView();
                    attachHomeViewListeners();
                    break;
            }
        }
        
        // --- HOME VIEW ---
        function renderHomeView() {
            const { searchTerm, condition, size, maxPrice } = state.filters;
            
            const filteredItems = state.items.filter(item => {
                if (item.isSold) return false;
                if (searchTerm && !item.title.toLowerCase().includes(searchTerm.toLowerCase())) return false;
                if (condition && item.condition !== condition) return false;
                if (size && item.size !== size) return false;
                if (maxPrice && item.price > maxPrice) return false;
                return true;
            });

            const itemCards = filteredItems.length > 0 ? filteredItems.map(item => `
                <div class="bg-white rounded-xl shadow-lg overflow-hidden transform hover:scale-105 transition-transform duration-200 cursor-pointer" onclick="navigate('details', '${item.id}')">
                    <img src="${item.photo}" alt="${item.title}" class="w-full h-40 object-cover" onerror="this.src='https://placehold.co/400x300/cccccc/ffffff?text=No+Image'">
                    <div class="p-4">
                        <h3 class="font-bold truncate">${item.title}</h3>
                        <p class="text-blue-700 font-semibold text-lg">$${item.price.toFixed(2)}</p>
                    </div>
                </div>
            `).join('') : `<p class="col-span-2 text-center text-gray-500 py-10">No items found.</p>`;
            
            return `
                <div class="view-container">
                    <header class="bg-white shadow-sm sticky top-0 z-10 p-4">
                        <h1 class="text-2xl font-bold text-center">Used Swimming Gear</h1>
                        <div class="mt-4 flex space-x-2">
                            <input id="search-input" type="text" placeholder="Search..." class="flex-grow p-2 border rounded-lg" value="${searchTerm}">
                            <button id="filter-btn" class="p-2 bg-gray-200 rounded-lg">
                                <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 4h18M7 11h10M10 17h4"></path></svg>
                            </button>
                            <button id="reset-filters-btn" class="p-2 bg-gray-200 rounded-lg text-sm">Reset</button>
                        </div>
                    </header>
                    <main class="p-4 grid grid-cols-2 gap-4">
                        ${itemCards}
                    </main>
                </div>
            `;
        }

        function attachHomeViewListeners() {
            document.getElementById('search-input').addEventListener('input', e => {
                setState({ filters: { ...state.filters, searchTerm: e.target.value } });
            });
            document.getElementById('filter-btn').addEventListener('click', showFilterDialog);
            document.getElementById('reset-filters-btn').addEventListener('click', () => {
                setState({ filters: { searchTerm: '', condition: null, size: null, maxPrice: null } });
            });
        }

        function showFilterDialog() {
            const modal = document.getElementById('filter-modal');
            const backdrop = document.getElementById('modal-backdrop');

            const allConditions = ['New', 'Excellent', 'Good', 'Fair'];
            const allSizes = ['XS', 'S', 'M', 'L', 'XL', 'One Size'];

            modal.innerHTML = `
                <div class="bg-white rounded-xl p-6 w-full max-w-md">
                    <h2 class="text-xl font-bold mb-4">Filters</h2>
                    <div class="space-y-4">
                        <select id="filter-condition" class="w-full p-2 border rounded-lg">
                            <option value="">All Conditions</option>
                            ${allConditions.map(c => `<option value="${c}" ${state.filters.condition === c ? 'selected' : ''}>${c}</option>`).join('')}
                        </select>
                        <select id="filter-size" class="w-full p-2 border rounded-lg">
                             <option value="">All Sizes</option>
                            ${allSizes.map(s => `<option value="${s}" ${state.filters.size === s ? 'selected' : ''}>${s}</option>`).join('')}
                        </select>
                        <input id="filter-price" type="number" placeholder="Max Price ($)" class="w-full p-2 border rounded-lg" value="${state.filters.maxPrice || ''}">
                    </div>
                    <div class="mt-6 flex justify-end space-x-2">
                         <button id="cancel-filters" class="px-4 py-2 bg-gray-200 rounded-lg">Cancel</button>
                         <button id="apply-filters" class="px-4 py-2 bg-blue-600 text-white rounded-lg">Apply</button>
                    </div>
                </div>
            `;
            
            backdrop.classList.remove('hidden');
            modal.classList.remove('hidden');

            const closeModal = () => {
                modal.classList.add('hidden');
                backdrop.classList.add('hidden');
            };

            backdrop.onclick = closeModal;
            document.getElementById('cancel-filters').onclick = closeModal;

            document.getElementById('apply-filters').onclick = () => {
                const condition = document.getElementById('filter-condition').value || null;
                const size = document.getElementById('filter-size').value || null;
                const maxPrice = parseFloat(document.getElementById('filter-price').value) || null;
                setState({ filters: { ...state.filters, condition, size, maxPrice } });
                closeModal();
            };
        }

        // --- DETAIL VIEW ---
        function renderItemDetailView() {
            const item = state.items.find(i => i.id === state.selectedItemId);
            if (!item) return `<p>Item not found</p>`;
            
            const whatsappLink = `https://wa.me/${item.contact}?text=${encodeURIComponent(`Is this item still available? (Item: ${item.title})`)}`;

            return `
                <div class="view-container">
                    <header class="bg-white shadow-sm sticky top-0 z-10 p-4 flex items-center">
                        <button onclick="navigate('home')" class="mr-4">
                           <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 19l-7-7 7-7"></path></svg>
                        </button>
                        <h1 class="text-xl font-bold truncate">${item.title}</h1>
                    </header>
                    <main class="p-4">
                        <div class="h-64 w-full mb-4 bg-gray-200 rounded-lg overflow-hidden">
                           <img src="${item.photos[0]}" class="w-full h-full object-cover">
                        </div>
                         <h2 class="text-2xl font-bold">${item.title}</h2>
                        <p class="text-3xl font-bold text-blue-700 my-2">$${item.price.toFixed(2)}</p>
                        <div class="flex space-x-4 my-4">
                            <span class="bg-gray-200 px-3 py-1 rounded-full text-sm">Condition: ${item.condition}</span>
                            <span class="bg-gray-200 px-3 py-1 rounded-full text-sm">Size: ${item.size}</span>
                        </div>
                        <h3 class="font-bold mt-4">Description</h3>
                        <p class="text-gray-700">${item.description}</p>
                         <div class="mt-6">
                            <a href="${whatsappLink}" target="_blank" class="block w-full text-center bg-green-500 text-white p-3 rounded-lg font-semibold">Contact Seller (WhatsApp)</a>
                        </div>
                    </main>
                </div>
            `;
        }

        // --- SELL FORM ---
        function renderSellItemForm() {
            return `
                 <div class="view-container">
                    <header class="bg-white shadow-sm sticky top-0 z-10 p-4 flex items-center">
                        <button onclick="navigate('home')" class="mr-4">
                           <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 19l-7-7 7-7"></path></svg>
                        </button>
                        <h1 class="text-xl font-bold">Sell Your Item</h1>
                    </header>
                    <form id="sell-form" class="p-4 space-y-4">
                        <input name="title" required placeholder="Title" class="w-full p-2 border rounded-lg">
                        <input name="price" required placeholder="Price" type="number" class="w-full p-2 border rounded-lg">
                        <textarea name="description" required placeholder="Description" class="w-full p-2 border rounded-lg"></textarea>
                        <input name="contact" required placeholder="Contact Number" type="tel" class="w-full p-2 border rounded-lg">
                        <select name="condition" class="w-full p-2 border rounded-lg">
                            <option>New</option><option>Excellent</option><option>Good</option><option>Fair</option>
                        </select>
                        <select name="size" class="w-full p-2 border rounded-lg">
                             <option>XS</option><option>S</option><option>M</option><option>L</option><option>XL</option><option>One Size</option>
                        </select>
                        <input type="file" multiple class="w-full">
                        <p class="text-xs text-gray-500">Add up to 10 photos.</p>
                        <button type="submit" class="w-full bg-teal-600 text-white p-3 rounded-lg font-semibold">Post Item</button>
                    </form>
                </div>
            `;
        }

        function attachSellFormListeners() {
            document.getElementById('sell-form').addEventListener('submit', e => {
                e.preventDefault();
                const formData = new FormData(e.target);
                const newItem = {
                    id: `item_${Date.now()}`,
                    title: formData.get('title'),
                    price: parseFloat(formData.get('price')),
                    description: formData.get('description'),
                    contact: formData.get('contact'),
                    condition: formData.get('condition'),
                    size: formData.get('size'),
                    photo: 'https://placehold.co/400x300/cccccc/ffffff?text=New+Item',
                    photos: [],
                    userId: CURRENT_USER_ID,
                    isSold: false
                };
                _postNewItem(newItem);
            });
        }
        
        // --- MY ITEMS VIEW ---
        function renderMyItemsView() {
            const myItems = state.items.filter(i => i.userId === CURRENT_USER_ID);
            const itemsHtml = myItems.length > 0 ? myItems.map(item => {
                const buttonClass = item.isSold ? 'bg-blue-100' : 'bg-green-100';
                const buttonTitle = item.isSold ? 'Mark as Available' : 'Mark as Sold';
                const buttonIcon = item.isSold 
                    ? `<svg class="w-5 h-5 text-blue-600" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 4v5h5"></path><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M20 12A8 8 0 1013.2 5.2"></path></svg>`
                    : `<svg class="w-5 h-5 text-green-600" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7"></path></svg>`;

                return `
                    <div class="p-4 bg-white rounded-lg shadow-md flex justify-between items-center">
                        <div>
                            <p class="font-bold">${item.title}</p>
                            <p class="${item.isSold ? 'text-red-500' : 'text-green-500'}">${item.isSold ? 'Sold' : 'Available'}</p>
                        </div>
                        <div class="flex space-x-2">
                             <button 
                                class="p-2 ${buttonClass} rounded-full" 
                                onclick="toggleSoldStatus('${item.id}')"
                                title="${buttonTitle}">
                                ${buttonIcon}
                             </button>
                            <button class="p-2 bg-red-100 rounded-full" onclick="confirmDelete('${item.id}')"><svg class="w-5 h-5 text-red-600" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 7l-.867 12.142A2 2 0 0116.138 21H7.862a2 2 0 01-1.995-1.858L5 7m5 4v6m4-4v6m1-10V4a1 1 0 00-1-1h-4a1 1 0 00-1 1v3M4 7h16"></path></svg></button>
                        </div>
                    </div>
                `
            }).join('') : '<p class="text-center text-gray-500">You have no posted items.</p>';
            
            return `
                 <div class="view-container">
                    <header class="bg-white shadow-sm sticky top-0 z-10 p-4 flex items-center">
                        <button onclick="navigate('home')" class="mr-4">
                           <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 19l-7-7 7-7"></path></svg>
                        </button>
                        <h1 class="text-xl font-bold">My Posted Items</h1>
                    </header>
                    <main class="p-4 space-y-4">
                        ${itemsHtml}
                    </main>
                </div>
            `;
        }
        
        function confirmDelete(itemId) {
            const modal = document.getElementById('confirm-modal');
            const backdrop = document.getElementById('modal-backdrop');
            
            modal.innerHTML = `
                <div class="bg-white p-6 rounded-lg shadow-xl w-full max-w-sm">
                    <h3 class="text-lg font-bold">Confirm Deletion</h3>
                    <p class="my-4">Are you sure you want to delete this item? This cannot be undone.</p>
                    <div class="flex justify-end space-x-2">
                        <button id="cancel-delete" class="px-4 py-2 bg-gray-200 rounded-lg">Cancel</button>
                        <button id="confirm-delete" class="px-4 py-2 bg-red-600 text-white rounded-lg">Delete</button>
                    </div>
                </div>
            `;
            
            backdrop.classList.remove('hidden');
            modal.classList.remove('hidden');

            const closeModal = () => {
                modal.classList.add('hidden');
                backdrop.classList.add('hidden');
            };

            backdrop.onclick = closeModal;
            document.getElementById('cancel-delete').onclick = closeModal;
            document.getElementById('confirm-delete').onclick = () => {
                _deleteItem(itemId);
                closeModal();
            };
        }
        
        function _deleteItem(itemId) {
            const newItems = state.items.filter(i => i.id !== itemId);
            setState({ items: newItems });
            showSnackbar("Item deleted successfully.");
        }

        function toggleSoldStatus(itemId) {
            const item = state.items.find(i => i.id === itemId);
            if (!item) return;

            const isCurrentlySold = item.isSold;
            const actionText = isCurrentlySold ? "mark as Available" : "mark as Sold";
            
            const modal = document.getElementById('confirm-modal');
            const backdrop = document.getElementById('modal-backdrop');
            
            modal.innerHTML = `
                <div class="bg-white p-6 rounded-lg shadow-xl w-full max-w-sm">
                    <h3 class="text-lg font-bold">Confirm Status Change</h3>
                    <p class="my-4">Are you sure you want to ${actionText} this item?</p>
                    <div class="flex justify-end space-x-2">
                        <button id="cancel-status" class="px-4 py-2 bg-gray-200 rounded-lg">Cancel</button>
                        <button id="confirm-status" class="px-4 py-2 bg-blue-600 text-white rounded-lg">Confirm</button>
                    </div>
                </div>
            `;
            
            backdrop.classList.remove('hidden');
            modal.classList.remove('hidden');

            const closeModal = () => {
                modal.classList.add('hidden');
                backdrop.classList.add('hidden');
            };

            document.getElementById('cancel-status').onclick = closeModal;
            document.getElementById('confirm-status').onclick = () => {
                item.isSold = !isCurrentlySold;
                setState({ items: [...state.items] }); // Trigger re-render
                showSnackbar(`Item marked as ${isCurrentlySold ? 'Available' : 'Sold'}.`);
                closeModal();
            };
            backdrop.onclick = closeModal;
        }


        // --- Initial Setup ---
        document.getElementById('my-items-fab').addEventListener('click', () => navigate('my-items'));
        document.getElementById('sell-item-fab').addEventListener('click', () => navigate('sell'));

        renderApp();
    </script>
</body>
</html>

