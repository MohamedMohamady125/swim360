<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Products Inventory</title>
    <!-- Tailwind CSS CDN for styling -->
    <script src="https://cdn.tailwindcss.com"></script>
    <style>
        @import url('https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap');
        body {
            font-family: 'Inter', sans-serif;
            background-color: #F7F9FB;
        }
        /* Card styling updated for a cleaner, flatter look */
        .card-shadow {
            box-shadow: 0 1px 3px 0 rgba(0, 0, 0, 0.1), 0 1px 2px 0 rgba(0, 0, 0, 0.06);
        }
        .product-card {
            background-color: white;
            border-radius: 10px;
            transition: transform 0.1s, box-shadow 0.1s;
        }
        .product-card:hover {
            transform: translateY(-1px);
            box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1), 0 2px 4px -2px rgba(0, 0, 0, 0.06);
        }
        .modal-content-wrapper {
            background-color: white;
            border-radius: 12px;
            box-shadow: 0 10px 15px -3px rgba(0, 0, 0, 0.1), 0 4px 6px -4px rgba(0, 0, 0, 0.05);
            max-height: 90vh;
            overflow-y: auto;
        }
        /* Input styling for consistency */
        .input-group {
            display: flex;
            align-items: center;
            border: 1px solid #E5E7EB;
            border-radius: 8px;
            padding: 0 12px;
            background-color: #FAFAFA;
        }
        .input-group input, .input-group select, .input-group textarea {
            border: none;
            outline: none;
            padding: 12px 0;
            flex-grow: 1;
            background-color: transparent;
        }
        .input-group-readonly {
            background-color: #E5E7EB;
            cursor: not-allowed;
            color: #6B7280;
        }
        .checklist-group {
            border: 1px solid #E5E7EB;
            border-radius: 8px;
            padding: 1rem;
        }
        /* Product Group Header */
        .category-header {
            font-size: 1.1rem;
            font-weight: 700;
            color: #1F2937;
            padding: 10px 0;
            margin-top: 1.5rem;
            margin-bottom: 0.5rem;
            border-bottom: 1px solid #D1D5DB; 
        }
        .color-swatch-display {
            width: 16px;
            height: 16px;
            border-radius: 9999px;
            display: inline-block;
            margin-right: 0.25rem;
            border: 1px solid #ccc;
        }
        /* Action Button Group */
        .action-btn-group {
            display: flex;
            flex-direction: column;
            gap: 6px;
            align-items: flex-end;
            min-width: 40px;
        }
        .action-icon-button {
            padding: 6px;
            border-radius: 9999px;
            transition: background-color 0.1s;
        }
        .action-icon-button:hover {
            background-color: #F3F4F6;
        }
        /* Global Promo Banner */
        .global-promo-banner {
            background-color: #F97316; /* Orange for urgent promo */
            color: white;
            border-radius: 12px;
            cursor: pointer;
            transition: background-color 0.2s;
        }
        /* Size Checklist Styles */
        .size-tag {
            padding: 0.3rem 0.6rem;
            border-radius: 6px;
            border: 1px solid #D1D5DB;
            background-color: white;
            transition: all 0.1s;
            cursor: pointer;
            font-size: 0.8rem;
            position: relative;
            display: block;
            text-align: center;
        }
        .size-tag input:checked + span {
            background-color: #3B82F6;
            color: white;
            border-color: #3B82F6;
        }
        .size-tag.disabled {
            opacity: 0.5;
            cursor: not-allowed;
            pointer-events: none;
        }
        .color-swatch-box {
            width: 20px;
            height: 20px;
            border-radius: 9999px;
            border: 2px solid white;
            box-shadow: 0 0 0 1px #ccc;
        }
        .color-swatch-label input:checked + .color-swatch-box {
            box-shadow: 0 0 0 2px #3B82F6; /* Blue ring when selected */
        }
    </style>
</head>
<body class="p-4 md:p-8">

    <div class="max-w-xl mx-auto">
        <h1 class="text-3xl font-extrabold text-gray-800 mb-2">My Products Inventory</h1>
        <p class="text-gray-500 mb-6">View, edit, and manage stock variants across all store locations.</p>

        <!-- GLOBAL PROMO BANNER -->
        <div class="global-promo-banner flex items-center justify-center p-3 mb-6 card-shadow" onclick="openGlobalPromoModal()">
             <svg class="w-6 h-6 mr-2" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4l3 3m-3 10a9 9 0 110-18 9 9 0 010 18z" /></svg>
            <span class="text-lg font-extrabold">Add Promo Code for All Orders</span>
        </div>

        <div id="product-list" class="space-y-4">
            <!-- Product Cards will be injected here -->
        </div>
    </div>

    <!-- Modals (Edit, Out of Stock, Discount, Promo Code, Global Promo) -->

    <!-- 1. Edit Modal Structure (Hidden by default) -->
    <div id="edit-modal-overlay" class="fixed inset-0 bg-black bg-opacity-50 z-[99] flex items-center justify-center p-4 hidden">
        <div class="modal-content-wrapper w-full max-w-lg">
            <div class="p-5 border-b flex justify-between items-center sticky top-0 bg-white rounded-t-xl z-10">
                <h3 class="text-2xl font-extrabold text-gray-800">Edit Product: <span id="product-edit-title" class="text-blue-600"></span></h3>
                <button id="close-edit-modal-btn" onclick="closeEditModal()" class="text-gray-500 hover:text-gray-800 transition">
                    <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"></path></svg>
                </button>
            </div>
            <form id="edit-product-form" class="p-5 space-y-6">
                <input type="hidden" id="edit-product-id">
                <!-- Product Identification Card (Editable) -->
                <div class="space-y-6">
                    <h4 class="font-bold text-gray-700">Product Identification</h4>
                    
                    <!-- Product Name -->
                    <div>
                        <label for="edit-name" class="block text-sm font-medium text-gray-700 mb-1">Product Name</label>
                        <div class="input-group">
                            <input type="text" id="edit-name" name="name" required>
                        </div>
                    </div>
                    
                    <!-- Category Dropdown (Editable) -->
                    <div>
                        <label for="edit-category" class="block text-sm font-medium text-gray-700 mb-1">Category</label>
                        <div class="input-group">
                            <select id="edit-category" name="category" required></select>
                        </div>
                    </div>

                    <!-- Brand Dropdown (Editable) -->
                    <div>
                        <label for="edit-brand" class="block text-sm font-medium text-gray-700 mb-1">Brand</label>
                        <div class="input-group">
                            <select id="edit-brand" name="brand" required></select>
                        </div>
                    </div>

                    <!-- Product Description (Editable) -->
                    <div>
                        <label for="edit-description" class="block text-sm font-medium text-gray-700 mb-1">Description</label>
                        <textarea id="edit-description" name="description" rows="3" required
                                  class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-blue-500 focus:border-blue-500 transition duration-150"></textarea>
                    </div>
                </div>

                <!-- Variants & Pricing Card -->
                <div class="space-y-6">
                    <h4 class="font-bold text-gray-700 pt-2 border-t">Variants & Inventory</h4>

                    <!-- Price (READ-ONLY) -->
                    <div>
                        <label class="block text-sm font-medium text-gray-700 mb-1">Price (READ-ONLY)</label>
                        <div class="input-group input-group-readonly">
                            <span class="font-semibold text-gray-600" id="edit-price-display"></span>
                        </div>
                    </div>
                    
                    <!-- Colors (Editable Checklist) -->
                    <div>
                        <label class="block text-sm font-medium text-gray-700 mb-2">Available Colors</label>
                        <div id="edit-color-checklist" class="grid grid-cols-4 sm:grid-cols-5 gap-2"></div>
                    </div>

                    <!-- Sizes (Editable Checklist) -->
                    <div>
                        <label class="block text-sm font-medium text-gray-700 mb-2">Available Sizes</label>
                        <div id="edit-size-checklist" class="grid grid-cols-4 gap-2 checklist-group"></div>
                    </div>

                    <!-- Branches Available (Editable Checklist) -->
                    <div>
                        <h3 class="text-sm font-medium text-gray-700 mb-2">Branches to Stock</h3>
                        <div id="edit-branch-allocation-checklist" class="checklist-group grid grid-cols-2 gap-3"></div>
                    </div>
                </div>

                <!-- Submit Button -->
                <button type="submit" class="w-full py-3 text-white font-semibold rounded-lg shadow-lg bg-blue-600 hover:bg-blue-700 transition">
                    <span id="edit-submit-text">Save Product Changes</span>
                </button>
            </form>
        </div>
    </div>
    
    <!-- 2. Out of Stock Modal -->
    <div id="stock-modal-overlay" class="fixed inset-0 bg-black bg-opacity-50 z-[99] flex items-center justify-center p-4 hidden">
        <div class="modal-content-wrapper w-full max-w-md">
            <div class="p-5 border-b flex justify-between items-center sticky top-0 bg-white rounded-t-xl">
                <h3 class="text-2xl font-extrabold text-gray-800">Mark Out of Stock</h3>
                <button onclick="closeStockModal()" class="text-gray-500 hover:text-gray-800 transition">
                    <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"></path></svg>
                </button>
            </div>
            <form id="stock-form" class="p-5 space-y-6">
                <input type="hidden" id="stock-product-id">
                <p class="text-sm text-gray-600">Select branches where **<span id="stock-product-name" class="font-semibold"></span>** is currently out of stock.</p>

                <div>
                    <h3 class="text-sm font-medium text-red-600 mb-2">Branches Out of Stock</h3>
                    <div id="stock-branch-checklist" class="checklist-group grid grid-cols-2 gap-3"></div>
                </div>

                <button type="submit" class="w-full py-3 text-white font-semibold rounded-lg shadow-lg bg-red-600 hover:bg-red-700 transition">
                    Update Stock Status
                </button>
            </form>
        </div>
    </div>

    <!-- 3. Discount Modal -->
    <div id="discount-modal-overlay" class="fixed inset-0 bg-black bg-opacity-50 z-[99] flex items-center justify-center p-4 hidden">
        <div class="modal-content-wrapper w-full max-w-md">
            <div class="p-5 border-b flex justify-between items-center sticky top-0 bg-white rounded-t-xl">
                <h3 class="text-2xl font-extrabold text-gray-800">Apply Discount</h3>
                <button onclick="closeDiscountModal()" class="text-gray-500 hover:text-gray-800 transition">
                    <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"></path></svg>
                </button>
            </div>
            <form id="discount-form" class="p-5 space-y-6">
                <input type="hidden" id="discount-product-id">
                <p class="text-sm text-gray-600">Original Price: <span id="original-price" class="font-bold"></span></p>

                <!-- Final Price -->
                <div>
                    <label for="final-price" class="block text-sm font-medium text-gray-700 mb-1">Final Price (USD)</label>
                    <div class="input-group">
                        <span class="text-gray-400 font-semibold mr-1">$</span>
                        <input type="number" id="final-price" name="final_price" required min="0" step="0.01">
                    </div>
                </div>

                <!-- Duration -->
                <div>
                    <label for="discount-duration" class="block text-sm font-medium text-gray-700 mb-1">Discount Duration (Days)</label>
                    <div class="input-group">
                        <input type="number" id="discount-duration" name="duration" required min="1" placeholder="e.g., 7">
                    </div>
                </div>

                <button type="submit" class="w-full py-3 text-white font-semibold rounded-lg shadow-lg bg-green-600 hover:bg-green-700 transition">
                    Apply Discount
                </button>
            </form>
        </div>
    </div>

    <!-- 4. Promo Code Modal -->
    <div id="promo-modal-overlay" class="fixed inset-0 bg-black bg-opacity-50 z-[99] flex items-center justify-center p-4 hidden">
        <div class="modal-content-wrapper w-full max-w-md">
            <div class="p-5 border-b flex justify-between items-center sticky top-0 bg-white rounded-t-xl">
                <h3 class="text-2xl font-extrabold text-gray-800">Add Promo Code</h3>
                <button onclick="closePromoModal()" class="text-gray-500 hover:text-gray-800 transition">
                    <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M6 18L18 6M6 6l12 12"></path></svg>
                </button>
            </div>
            <form id="promo-form" class="p-5 space-y-6">
                <input type="hidden" id="promo-product-id">

                <!-- Promo Code -->
                <div>
                    <label for="promo-code" class="block text-sm font-medium text-gray-700 mb-1">Promo Code</label>
                    <div class="input-group">
                        <input type="text" id="promo-code" name="code" required placeholder="e.g., SUMMER20">
                    </div>
                </div>

                <!-- Duration OR Items (Radio Selection) -->
                <div>
                    <label class="block text-sm font-medium text-gray-700 mb-2">Promotion Scope</label>
                    <div class="flex space-x-4">
                        <label class="flex items-center space-x-2">
                            <input type="radio" name="scope_type" value="duration" checked onchange="togglePromoScope(this.value)">
                            <span>Duration (Days)</span>
                        </label>
                        <label class="flex items-center space-x-2">
                            <input type="radio" name="scope_type" value="items" onchange="togglePromoScope(this.value)">
                            <span>Item Limit</span>
                        </label>
                    </div>
                </div>

                <!-- Duration Input (Default) -->
                <div id="scope-duration-field">
                    <label for="promo-duration" class="block text-sm font-medium text-gray-700 mb-1">Duration (Days to end)</label>
                    <div class="input-group">
                        <input type="number" id="promo-duration" name="duration" required min="1" placeholder="e.g., 30">
                    </div>
                </div>
                
                <!-- Item Count Input (Hidden by default) -->
                 <div id="scope-items-field" class="hidden">
                    <label for="promo-items" class="block text-sm font-medium text-gray-700 mb-1">Number of Items</label>
                    <div class="input-group">
                        <input type="number" id="promo-items" name="items" min="1" placeholder="e.g., 50">
                    </div>
                </div>

                <button type="submit" class="w-full py-3 text-white font-semibold rounded-lg shadow-lg bg-yellow-600 hover:bg-yellow-700 transition">
                    Activate Promo Code
                </button>
            </form>
        </div>
    </div>


    <script>
        // MOCK DATA and DEFINITIONS
        const mockBranches = [
            { id: 'b1', name: 'Al Malaz Store (Riyadh)' },
            { id: 'b2', name: 'Red Sea Mall Branch (Jeddah)' },
            { id: 'b3', name: 'Dammam City Center' },
        ];
        
        const mockCategories = ['Cap', 'Goggles', 'Suit', 'Kickboard', 'Paddles', 'Parachute', 'Fins', 'Snorkels', 'Deflectors', 'Apparel', 'Other'];
        
        const mockBrands = ['Speedo', 'Arena', 'TYR', 'FINIS', 'Mizuno', 'De Boer', 'Other'];
        
        const mockColors = [
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

        const mockSizes = ['XS', 'S', 'M', 'L', 'XL', '22', '24', '26', '28', '30', '32', '34', '36', '38', '40', 'ONE SIZE', 'OTHER'];


        // MOCK PRODUCTS CREATED BY THE USER
        let products = [
            { 
                id: 'p1', name: 'Pro Racing Goggles', category: 'Goggles', brand: 'Speedo', price: 39.99, 
                colors: ['Blue', 'Black'], sizes: ['ONE SIZE'], 
                branches: ['b1', 'b2'], out_of_stock_branches: ['b1'],
                photo_url: 'https://placehold.co/100x100/3B82F6/ffffff?text=G1',
                description: 'Anti-fog lens with adjustable nose piece.'
            },
            { 
                id: 'p2', name: 'Carbon Fiber Suit', category: 'Suit', brand: 'Arena', price: 299.99, 
                colors: ['Black', 'Purple'], sizes: ['30', '32', '34'], 
                branches: ['b1'], out_of_stock_branches: [],
                photo_url: 'https://placehold.co/100x100/000000/ffffff?text=S1',
                description: 'FINA approved competition suit for elite swimmers.'
            }
        ];
        
        const editModalOverlay = document.getElementById('edit-modal-overlay');
        const stockModalOverlay = document.getElementById('stock-modal-overlay');
        const discountModalOverlay = document.getElementById('discount-modal-overlay');
        const promoModalOverlay = document.getElementById('promo-modal-overlay');
        const productListContainer = document.getElementById('product-list');
        const editForm = document.getElementById('edit-product-form');
        const stockForm = document.getElementById('stock-form');
        const discountForm = document.getElementById('discount-form');
        const promoForm = document.getElementById('promo-form');

        // --- Utility Functions ---

        function showSnackbar(message, isError = false) {
            const snackbar = document.createElement('div');
            snackbar.textContent = message;
            snackbar.className = `fixed top-4 left-1/2 -translate-x-1/2 px-6 py-3 rounded-lg shadow-lg text-white ${isError ? 'bg-red-500' : 'bg-green-500'} z-[60]`;
            document.body.appendChild(snackbar);
            setTimeout(() => {
                snackbar.remove();
            }, 3000);
        }

        function getColorCode(name) {
            const color = mockColors.find(c => c.name === name);
            return color ? color.code : '#CCCCCC';
        }
        
        // --- PROMO SCOPE LOGIC ---
        
        function togglePromoScope(scopeType) {
            const durationField = document.getElementById('scope-duration-field');
            const itemsField = document.getElementById('scope-items-field');

            if (scopeType === 'duration') {
                durationField.classList.remove('hidden');
                itemsField.classList.add('hidden');
                // Ensure required attributes are set correctly
                document.getElementById('promo-duration').setAttribute('required', true);
                document.getElementById('promo-items').removeAttribute('required');
            } else if (scopeType === 'items') {
                durationField.classList.add('hidden');
                itemsField.classList.remove('hidden');
                document.getElementById('promo-items').setAttribute('required', true);
                document.getElementById('promo-duration').removeAttribute('required');
            }
        }


        // --- Checklists/Dropdown Population Helpers ---

        function populateBranchChecklist(targetElementId, allOptions, selectedValues, namePrefix) {
            const checklistContainer = document.getElementById(targetElementId);
            if (!checklistContainer) return;

            const isStockCheck = namePrefix === 'stock_branch';
            
            checklistContainer.innerHTML = allOptions.map(branch => {
                const isChecked = selectedValues.includes(branch.id);
                // For stock out, we only list branches where the product IS stocked
                const isAvailableBranch = products.find(p => p.id === document.getElementById('stock-product-id')?.value)?.branches.includes(branch.id) || true;


                return `
                    <label class="flex items-center space-x-3 text-sm font-medium text-gray-700">
                        <input type="checkbox" name="${namePrefix}" value="${branch.id}" ${isChecked ? 'checked' : ''} class="h-4 w-4 text-blue-600 border-gray-300 rounded focus:ring-blue-500">
                        <span>${branch.name}</span>
                    </label>
                `;
            }).join('');
        }
        
        function populateEditDropdowns(product) {
            const categorySelect = document.getElementById('edit-category');
            const brandSelect = document.getElementById('edit-brand');
            
            categorySelect.innerHTML = mockCategories.map(cat => `<option value="${cat}" ${cat === product.category ? 'selected' : ''}>${cat}</option>`).join('');
            
            brandSelect.innerHTML = mockBrands.map(brand => `<option value="${brand}" ${brand === product.brand ? 'selected' : ''}>${brand}</option>`).join('');
        }

        function populateEditChecklist(targetElementId, allOptions, selectedValues, type) {
            const checklistContainer = document.getElementById(targetElementId);
            if (!checklistContainer) return;
            
            // Determine structure class
            if (targetElementId.includes('branch')) {
                checklistContainer.className = 'checklist-group grid grid-cols-2 gap-3';
            } else if (targetElementId.includes('color')) {
                 checklistContainer.className = 'grid grid-cols-4 sm:grid-cols-5 gap-2';
            } else if (targetElementId.includes('size')) {
                 checklistContainer.className = 'grid grid-cols-4 gap-2 checklist-group';
            }

            const isOneSizeActiveInProduct = selectedValues.includes('ONE SIZE') || selectedValues.includes('OTHER');


            checklistContainer.innerHTML = allOptions.map(option => {
                const name = typeof option === 'string' ? option : option.name;
                const value = typeof option === 'string' ? option : option.id;
                const isChecked = selectedValues.includes(value || name);

                const isOptionOneSize = name === 'ONE SIZE' || name === 'OTHER';
                const isDisabled = !isOptionOneSize && isOneSizeActiveInProduct;


                if (type === 'color') {
                    const code = getColorCode(name);
                    return `
                        <label class="color-swatch-label space-x-2">
                            <input type="checkbox" name="edit_colors" value="${name}" class="hidden" ${isChecked ? 'checked' : ''}>
                            <div class="color-swatch-box" style="background-color: ${code}; border-color: ${name === 'White' ? '#ccc' : 'white'};"></div>
                            <span class="text-xs text-gray-700">${name}</span>
                        </label>`;
                } else if (type === 'size') {
                     return `
                        <label class="size-tag relative ${isOptionOneSize ? 'one-size-option' : 'standard-size-option'} ${isDisabled ? 'disabled' : ''}">
                            <input type="checkbox" name="edit_sizes" value="${name}" class="hidden" data-size-type="${isOptionOneSize ? 'one' : 'standard'}" ${isChecked ? 'checked' : ''} ${isDisabled ? 'disabled' : ''}>
                            <span class="block">${name}</span>
                        </label>`;
                } else { // Branch Allocation
                    const branchName = option.name;
                    const branchId = option.id;
                    return `
                        <label class="flex items-center space-x-3 text-sm font-medium text-gray-700">
                            <input type="checkbox" name="edit_branches" value="${branchId}" ${selectedValues.includes(branchId) ? 'checked' : ''} class="h-4 w-4 text-blue-600 border-gray-300 rounded focus:ring-blue-500">
                            <span>${branchName}</span>
                        </label>`;
                }
            }).join('');
            
            if (type === 'size') {
                attachSizeExclusionListener(targetElementId);
            }
        }

        function attachSizeExclusionListener(containerId) {
            const sizeCheckboxes = document.querySelectorAll(`#${containerId} input[type="checkbox"]`);
            
            sizeCheckboxes.forEach(checkbox => {
                checkbox.addEventListener('change', function() {
                    const isOneSize = this.getAttribute('data-size-type') === 'one';
                    const isChecked = this.checked;
                    const standardOptions = document.querySelectorAll(`#${containerId} .standard-size-option`);
                    const oneSizeOptions = document.querySelectorAll(`#${containerId} .one-size-option`);
                    
                    if (isOneSize) {
                        standardOptions.forEach(stdLabel => {
                            const stdInput = stdLabel.querySelector('input');
                            if (isChecked) {
                                stdInput.checked = false;
                                stdLabel.classList.add('disabled');
                            } else {
                                stdLabel.classList.remove('disabled');
                            }
                        });
                    } else {
                        if (isChecked) {
                            oneSizeOptions.forEach(oneLabel => {
                                const oneInput = oneLabel.querySelector('input');
                                oneInput.checked = false;
                                oneLabel.classList.add('disabled');
                            });
                        }
                        
                        const anyStandardChecked = Array.from(standardOptions).some(stdLabel => stdLabel.querySelector('input').checked);
                        if (!anyStandardChecked) {
                            oneSizeOptions.forEach(oneLabel => oneLabel.classList.remove('disabled'));
                        }
                    }
                });
            });
        }

        // --- UI Rendering ---

        function renderProductList() {
            if (products.length === 0) {
                 productListContainer.innerHTML = '<p class="text-gray-500 text-center mt-8">No products registered yet.</p>';
                 return;
            }
            
            const productsByCategory = products.reduce((acc, product) => {
                const category = product.category;
                if (!acc[category]) acc[category] = [];
                acc[category].push(product);
                return acc;
            }, {});

            let listHTML = '';

            for (const category in productsByCategory) {
                listHTML += `<div class="category-header">${category} (${productsByCategory[category].length} items)</div>`;
                
                listHTML += productsByCategory[category].map(product => `
                    <div class="product-card p-4 card-shadow flex items-center justify-between space-x-4 mt-2">
                        
                        <!-- Product Info (Clickable for quick view/summary) -->
                        <div class="flex items-center space-x-4 flex-grow cursor-pointer" onclick="openDetailsModal('${product.id}')">
                            <img src="${product.photo_url}" 
                                 alt="${product.name} Cover" 
                                 class="w-16 h-16 object-cover rounded-lg flex-shrink-0 border-2 border-gray-200">
                            
                            <div class="flex-grow">
                                <h3 class="text-lg font-extrabold text-gray-900">${product.name}</h3>
                                <p class="text-xs text-gray-500 mt-0">Brand: ${product.brand} | Variants: ${product.sizes.length} Sizes</p>
                                <p class="text-sm font-semibold text-teal-600 mt-1">$${product.price.toFixed(2)}</p>
                                <p class="text-xs text-gray-500">Colors: ${product.colors.map(c => `<span class="color-swatch-display" style="background-color: ${getColorCode(c)};"></span>`).join('')}</p>
                            </div>
                        </div>

                        <!-- Action Button Group (4 Buttons) -->
                        <div class="action-btn-group">
                            
                            <!-- 1. Edit Details Button (Pen Icon) -->
                            <button onclick="openEditModal('${product.id}')" 
                                    class="action-icon-button text-blue-600" title="Edit Product Details">
                                <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15.232 5.232l3.536 3.536m-2.036-5.036a2.5 2.5 0 113.536 3.536L6.5 21.036H3v-3.536L15.232 5.232z"></path></svg>
                            </button>
                            
                            <!-- 2. Mark Out of Stock Button (Red X Icon) -->
                            <button onclick="openStockModal('${product.id}')" 
                                    class="action-icon-button text-red-600" title="Manage Stock Status">
                                <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M18.364 18.364A9 9 0 005.636 5.636m12.728 12.728A9 9 0 015.636 5.636m12.728 12.728L5.636 5.636"/></svg>
                            </button>
                            
                            <!-- 3. Add Discount Button (Price Tag Icon) -->
                            <button onclick="openDiscountModal('${product.id}')" 
                                    class="action-icon-button text-green-600" title="Apply Fixed Discount">
                                <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M7 7h.01M7 3h5a2 2 0 012 2v10a2 2 0 01-2 2H7a2 2 0 01-2-2V5a2 2 0 012-2zM15 15l4 4m0 0l4-4m-4 4V7"/></svg>
                            </button>
                            
                            <!-- 4. Add Promo Code (Per Product) Button (Coupon Icon) -->
                            <button onclick="openPromoModal('${product.id}')" 
                                    class="action-icon-button text-yellow-600" title="Apply Product-Specific Promo">
                                <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8c1.657 0 3 .895 3 2s-1.343 2-3 2-3-.895-3-2 1.343-2 3-2zM21 12c0 4.418-4.03 8-9 8s-9-3.582-9-8 4.03-8 9-8 9 3.582 9 8z"/></svg>
                            </button>
                            
                        </div>
                    </div>
                `).join('');
            }
            
            productListContainer.innerHTML = listHTML;
        }

        // --- DETAILS MODAL (Quick View) ---
        // Note: This modal is not used for editing, only for displaying all data read-only.
        function openDetailsModal(productId) {
            const product = products.find(p => p.id === productId);
            if (!product) return showSnackbar('Product data not found.', true);

            // Populate the modal with all details (we use the Edit Modal wrapper for consistency)
            document.getElementById('product-edit-title').textContent = product.name;
            
            // Set fields to read-only values
            document.getElementById('edit-name').value = product.name;
            document.getElementById('edit-description').value = product.description;
            document.getElementById('edit-price-display').textContent = `$${product.price.toFixed(2)} (Read-Only)`;
            
            // Set all fields to READONLY for the quick view
            document.getElementById('edit-name').setAttribute('readonly', true);
            document.getElementById('edit-description').setAttribute('readonly', true);
            document.getElementById('edit-category').setAttribute('disabled', true);
            document.getElementById('edit-brand').setAttribute('disabled', true);
            
            // Visually disable the submit button
            document.getElementById('edit-submit-text').textContent = 'View Mode';
            document.querySelector('#edit-product-form button[type="submit"]').classList.add('opacity-50', 'cursor-not-allowed');

            // Open the modal
            openEditModal(productId);
        }

        // --- Edit Modal Logic ---

        function openEditModal(productId) {
            const product = products.find(p => p.id === productId);
            if (!product) return showSnackbar('Product data not found.', true);
            
            // Reset read-only status
            document.getElementById('edit-name').removeAttribute('readonly');
            document.getElementById('edit-description').removeAttribute('readonly');
            document.getElementById('edit-category').removeAttribute('disabled');
            document.getElementById('edit-brand').removeAttribute('disabled');
            document.querySelector('#edit-product-form button[type="submit"]').classList.remove('opacity-50', 'cursor-not-allowed');
            document.getElementById('edit-submit-text').textContent = 'Save Product Changes';

            // 1. Populate Dropdowns (Category/Brand)
            populateEditDropdowns(product);
            
            // 2. Populate Checklists (must be done before setting values)
            populateEditChecklist('edit-branch-allocation-checklist', mockBranches, product.branches, 'branch');
            populateEditChecklist('edit-color-checklist', mockColors.map(c => c.name), product.colors, 'color');
            populateEditChecklist('edit-size-checklist', mockSizes, product.sizes, 'size');
            
            // 3. Populate Simple Fields 
            document.getElementById('product-edit-title').textContent = product.name;
            document.getElementById('edit-product-id').value = product.id;
            
            document.getElementById('edit-name').value = product.name;
            document.getElementById('edit-description').value = product.description;
            document.getElementById('edit-price-display').textContent = `$${product.price.toFixed(2)} (Read-Only)`;

            // 4. Show modal
            editModalOverlay.classList.remove('hidden');
        }

        function closeEditModal() {
            editModalOverlay.classList.add('hidden');
            editForm.reset();
        }

        // --- NEW ACTION MODAL LOGIC (Stock, Discount, Promo) ---

        function openStockModal(productId) {
            const product = products.find(p => p.id === productId);
            if (!product) return showSnackbar('Product data not found.', true);
            
            document.getElementById('stock-product-id').value = productId;
            document.getElementById('stock-product-name').textContent = product.name;
            
            // Populate stock checklist based on which branches currently stock the item AND the current stock status
            const currentStockedBranches = product.branches;
            const currentOutOfStockBranches = product.out_of_stock_branches;

            const stockOptions = mockBranches
                .filter(b => currentStockedBranches.includes(b.id)) // Only show branches where the product IS stocked
                .map(branch => {
                    const isOutOfStock = currentOutOfStockBranches.includes(branch.id);
                    return `
                        <label class="flex items-center space-x-3 text-sm font-medium text-gray-700">
                            <input type="checkbox" name="stock_branch_ids" value="${branch.id}" ${isOutOfStock ? 'checked' : ''} class="h-4 w-4 text-red-600 border-gray-300 rounded focus:ring-red-500">
                            <span>${branch.name} (${isOutOfStock ? 'OOS' : 'In Stock'})</span>
                        </label>
                    `;
                }).join('');

            document.getElementById('stock-branch-checklist').innerHTML = stockOptions;
            stockModalOverlay.classList.remove('hidden');
        }

        function closeStockModal() { stockModalOverlay.classList.add('hidden'); }

        function openDiscountModal(productId) {
            const product = products.find(p => p.id === productId);
            if (!product) return showSnackbar('Product data not found.', true);

            document.getElementById('discount-product-id').value = productId;
            document.getElementById('original-price').textContent = `$${product.price.toFixed(2)}`;
            document.getElementById('discount-modal-overlay').classList.remove('hidden');
        }

        function closeDiscountModal() { discountModalOverlay.classList.add('hidden'); }
        
        // --- PROMO CODE MODAL HANDLER (Combined Logic) ---

        function openPromoModal(productId = null) {
            document.getElementById('promo-product-id').value = productId || 'GLOBAL';
            const scope = productId ? (productId === 'GLOBAL' ? 'GLOBAL' : products.find(p => p.id === productId)?.name) : 'GLOBAL';
            const title = scope === 'GLOBAL' ? 'Add Global Promo Code' : `Add Promo Code for ${scope}`;
            
            document.querySelector('#promo-modal-overlay h3').textContent = title;

            // Reset scope fields and set default selection
            document.getElementById('promo-form').reset();
            togglePromoScope('duration'); // Set default view to Duration

            promoModalOverlay.classList.remove('hidden');
        }

        function closePromoModal() { promoModalOverlay.classList.add('hidden'); }
        
        function openGlobalPromoModal() {
             // This is the banner button on top
             openPromoModal('GLOBAL');
        }

        // --- Action Form Submissions ---

        stockForm.addEventListener('submit', function(event) {
            event.preventDefault();
            const form = event.target;
            const productId = form.elements['stock-product-id'].value;
            const productIndex = products.findIndex(p => p.id === productId);

            const outOfStockBranches = Array.from(form.elements.stock_branch_ids)
                .filter(checkbox => checkbox.checked)
                .map(checkbox => checkbox.value);

            products[productIndex].out_of_stock_branches = outOfStockBranches;

            showSnackbar(`Stock status updated for ${products[productIndex].name}.`, false);
            closeStockModal();
            renderProductList();
        });

        discountForm.addEventListener('submit', function(event) {
            event.preventDefault();
            const form = event.target;
            const finalPrice = parseFloat(form.elements.final_price.value);
            const duration = parseInt(form.elements.duration.value);
            
            // Logic to apply finalPrice/duration to product
            showSnackbar(`Fixed discount of $${finalPrice.toFixed(2)} applied for ${duration} days!`, false);
            closeDiscountModal();
        });

        promoForm.addEventListener('submit', function(event) {
            event.preventDefault();
            const form = event.target;
            const scope = form.elements['promo-product-id'].value;
            const code = form.elements.code.value;
            const scopeType = form.elements.scope_type.value; // 'duration' or 'items'
            
            let value;
            if (scopeType === 'duration') {
                value = form.elements.duration.value + ' days';
            } else {
                value = form.elements.items.value + ' items';
            }
            
            showSnackbar(`Promo code ${code} activated for ${value} on ${scope === 'GLOBAL' ? 'ALL products.' : products.find(p => p.id === scope)?.name}.`, false);
            closePromoModal();
        });


        // --- Initialization ---

        window.onload = () => {
            renderProductList();
            
            // Attach specific listeners for modal handling
            document.getElementById('close-edit-modal-btn').onclick = closeEditModal;
            
            editModalOverlay.onclick = (e) => { if (e.target.id === 'edit-modal-overlay') closeEditModal(); };
            stockModalOverlay.onclick = (e) => { if (e.target.id === 'stock-modal-overlay') closeStockModal(); };
            discountModalOverlay.onclick = (e) => { if (e.target.id === 'discount-modal-overlay') closeDiscountModal(); };
            promoModalOverlay.onclick = (e) => { if (e.target.id === 'promo-modal-overlay') closePromoModal(); };
        };
    </script>
</body>
</html>