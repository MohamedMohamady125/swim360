<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Add New Product to Inventory</title>
    <!-- Tailwind CSS CDN for styling -->
    <script src="https://cdn.tailwindcss.com"></script>
    <style>
        @import url('https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap');
        body {
            font-family: 'Inter', sans-serif;
            background-color: #F7F9FB;
        }
        /* Custom blue submit button style */
        .btn-submit {
            background-color: #3B82F6; 
            color: white;
            transition: background-color 0.2s, transform 0.2s;
        }
        .btn-submit:hover {
            background-color: #2563EB;
            transform: translateY(-1px);
        }
        .form-card {
            background-color: white;
            border-radius: 12px;
            box-shadow: 0 10px 15px -3px rgba(0, 0, 0, 0.1), 0 4px 6px -4px rgba(0, 0, 0, 0.05);
            padding: 1.5rem;
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
        .input-group:focus-within {
            border-color: #3B82F6;
            box-shadow: 0 0 0 1px #3B82F6;
            background-color: white;
        }
        .input-group input, .input-group select, .input-group textarea {
            border: none;
            outline: none;
            padding: 12px 0;
            flex-grow: 1;
            background-color: transparent;
        }
        .checklist-group {
            border: 1px solid #E5E7EB;
            border-radius: 8px;
            padding: 1rem;
        }
        /* Color Swatch Styling */
        .color-swatch-label {
            display: flex;
            align-items: center;
            padding: 0.5rem;
            border-radius: 4px;
            cursor: pointer;
            transition: background-color 0.2s;
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
        /* Style for the Sizes Checklist */
        .size-tag {
            padding: 0.3rem 0.6rem; /* Made padding smaller for a thinner look */
            border-radius: 6px;
            border: 1px solid #D1D5DB;
            background-color: white;
            transition: all 0.1s;
            cursor: pointer;
            font-size: 0.8rem; /* Slightly smaller font */
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
    </style>
</head>
<body class="p-4 md:p-8">

    <div class="max-w-xl mx-auto">
        <h1 class="text-3xl font-extrabold text-gray-800 mb-2">Add New Product</h1>
        <p class="text-gray-500 mb-8">Define details, variants, and branch allocation for your new retail product.</p>

        <form id="product-form" class="space-y-6">
            
            <!-- Product Identification Card -->
            <div class="form-card space-y-6">
                <h3 class="text-xl font-bold text-gray-800 mb-4 border-b pb-2">Product Identification</h3>
                
                <!-- Product Name -->
                <div>
                    <label for="product-name" class="block text-sm font-medium text-gray-700 mb-1">Product Name</label>
                    <div class="input-group">
                        <svg class="w-5 h-5 text-gray-400 mr-3" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z"></path></svg>
                        <input type="text" id="product-name" name="name" required placeholder="e.g., Pro Racing Goggles">
                    </div>
                </div>
                
                <!-- Category Dropdown (Granular) -->
                <div>
                    <label for="product-category" class="block text-sm font-medium text-gray-700 mb-1">Category</label>
                    <div class="input-group">
                        <svg class="w-5 h-5 text-gray-400 mr-3" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10.325 4.317c.426-1.756 2.924-1.756 3.35 0a1.724 1.724 0 002.573 1.066c1.543-.94 3.31.826 2.37 2.37a1.724 1.724 0 001.065 2.572c1.756.426 1.756 2.924 0 3.35a1.724 1.724 0 00-1.066 2.573c.94 1.543-.826 3.31-2.37 2.37a1.724 1.724 0 00-2.572 1.065c-.426 1.756-2.924 1.756-3.35 0a1.724 1.724 0 00-2.573-1.066c-1.543.94-3.31-.826-2.37-2.37a1.724 1.724 0 00-1.065-2.572c-1.756-.426-1.756-2.924 0-3.35a1.724 1.724 0 001.066-2.573c-.94-1.543.826-3.31 2.37-2.37a1.724 1.724 0 002.572-1.065z"></path><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z"></path></svg>
                        <select id="product-category" name="category" required>
                            <option value="" disabled selected>Select Product Category</option>
                            <option value="cap">Cap</option>
                            <option value="goggles">Goggles</option>
                            <option value="suit">Suit</option>
                            <option value="kickboard">Kickboard</option>
                            <option value="paddles">Paddles</option>
                            <option value="parachute">Parachute</option>
                            <option value="fins">Fins</option>
                            <option value="snorkels">Snorkels</option>
                            <option value="deflectors">Deflectors</option>
                            <option value="apparel">Apparel (Non-Suit)</option>
                            <option value="other">Other</option>
                        </select>
                    </div>
                </div>

                <!-- Brand Dropdown -->
                <div>
                    <label for="product-brand" class="block text-sm font-medium text-gray-700 mb-1">Brand</label>
                    <div class="input-group">
                        <svg class="w-5 h-5 text-gray-400 mr-3" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 15l-2 5L9 9l11 4L5 13l2 5z"></path></svg>
                        <select id="product-brand" name="brand" required>
                            <option value="" disabled selected>Select Brand</option>
                            <option value="speedo">Speedo</option>
                            <option value="arena">Arena</option>
                            <option value="tyr">TYR</option>
                            <option value="finis">FINIS</option>
                            <option value="mizuno">Mizuno</option>
                            <option value="de_boer">De Boer</option>
                            <option value="other">Other</option>
                        </select>
                    </div>
                </div>

                <!-- Product Description -->
                <div>
                    <label for="product-description" class="block text-sm font-medium text-gray-700 mb-1">Description</label>
                    <textarea id="product-description" name="description" rows="3" required
                              class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-blue-500 focus:border-blue-500 transition duration-150"
                              placeholder="Brief description of material, fit, and use."></textarea>
                </div>

                <!-- Product Photo Upload (Up to 10 photos) -->
                <div>
                    <label for="product-photo" class="block text-sm font-medium text-gray-700 mb-1">Product Photos (Max 10)</label>
                    <div class="input-group">
                        <svg class="w-5 h-5 text-gray-400 mr-3" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 16l4.586-4.586a2 2 0 012.828 0L16 16m-2-2l1.586-1.586a2 2 0 012.828 0L20 14m-6-6h.01M6 20h12a2 2 0 002-2V6a2 2 0 00-2-2H6a2 2 0 00-2 2v12a2 2 0 002 2z"></path></svg>
                        <input type="file" id="product-photo" name="photo" accept="image/*" multiple max="10" required class="w-full">
                    </div>
                </div>
            </div>

            <!-- Variants & Pricing Card -->
            <div class="form-card space-y-6">
                <h3 class="text-xl font-bold text-gray-800 mb-4 border-b pb-2">Variants & Inventory</h3>

                <!-- Price -->
                <div>
                    <label for="product-price" class="block text-sm font-medium text-gray-700 mb-1">Price (USD)</label>
                    <div class="input-group">
                        <span class="text-gray-400 font-semibold mr-1">$</span>
                        <input type="number" id="product-price" name="price" required min="1" step="0.01" placeholder="39.99">
                    </div>
                </div>
                
                <!-- Colors (Visual Checklist) -->
                <div>
                    <label class="block text-sm font-medium text-gray-700 mb-2">Available Colors</label>
                    <div id="color-allocation-checklist" class="flex flex-wrap gap-4">
                        <!-- Colors populated by JS -->
                    </div>
                </div>

                <!-- Sizes (Checklist with Exclusion Logic) -->
                <div>
                    <label for="product-sizes" class="block text-sm font-medium text-gray-700 mb-2">Available Sizes</label>
                    <div id="size-allocation-checklist" class="flex flex-wrap gap-2 checklist-group">
                        <!-- Sizes populated by JS -->
                    </div>
                </div>

                <!-- Branches Available (Checklist) -->
                <div>
                    <h3 class="text-sm font-medium text-gray-700 mb-2">Branches to Stock</h3>
                    <div id="branch-allocation-checklist" class="checklist-group grid grid-cols-2 gap-3">
                        <!-- Branches populated by JS -->
                    </div>
                </div>
            </div>

            <!-- Submit Button -->
            <button type="submit" class="w-full py-3 text-white font-semibold rounded-lg shadow-lg btn-submit">
                <span id="submit-text">Register Product</span>
            </button>
            
        </form>
    </div>

    <script>
        // MOCK DATA for existing branches, colors, and sizes
        const mockBranches = [
            { id: 'b1', name: 'Al Malaz Store (Riyadh)' },
            { id: 'b2', name: 'Red Sea Mall Branch (Jeddah)' },
            { id: 'b3', name: 'Dammam City Center' },
        ];
        
        // FINAL COLOR PALETTE
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

        // FINAL SIZE LIST
        const mockSizes = ['XS', 'S', 'M', 'L', 'XL', '22', '24', '26', '28', '30', '32', '34', '36', '38', '40', 'ONE SIZE', 'OTHER'];


        // --- Utility Functions ---

        function showSnackbar(message, isError = false) {
            const snackbar = document.createElement('div');
            snackbar.textContent = message;
            snackbar.className = `fixed bottom-6 left-1/2 -translate-x-1/2 px-6 py-3 rounded-lg shadow-lg text-white ${isError ? 'bg-red-500' : 'bg-green-500'} z-[60]`;
            document.body.appendChild(snackbar);
            setTimeout(() => {
                snackbar.remove();
            }, 3000);
        }

        // --- Checklists Population ---

        function populateBranchChecklist() {
            const checklistContainer = document.getElementById('branch-allocation-checklist');
            if (!checklistContainer) return;

            checklistContainer.innerHTML = mockBranches.map(branch => `
                <label class="flex items-center space-x-3 text-sm font-medium text-gray-700">
                    <input type="checkbox" name="branch_allocation" value="${branch.id}" class="h-4 w-4 text-blue-600 border-gray-300 rounded focus:ring-blue-500">
                    <span>${branch.name}</span>
                </label>
            `).join('');
        }

        function populateColorChecklist() {
            const checklistContainer = document.getElementById('color-allocation-checklist');
            if (!checklistContainer) return;

            // Display 5 columns for better layout
            checklistContainer.className = 'grid grid-cols-4 sm:grid-cols-5 gap-2';

            checklistContainer.innerHTML = mockColors.map(color => `
                <label class="color-swatch-label space-x-2">
                    <input type="checkbox" name="product_colors" value="${color.name}" class="hidden">
                    <div class="color-swatch-box" style="background-color: ${color.code}; border-color: ${color.name === 'White' ? '#ccc' : 'white'};"></div>
                    <span class="text-xs text-gray-700">${color.name}</span>
                </label>
            `).join('');
        }
        
        function populateSizeChecklist() {
            const checklistContainer = document.getElementById('size-allocation-checklist');
            if (!checklistContainer) return;

            // Use a grid layout for better spacing and visibility
            checklistContainer.className = 'grid grid-cols-4 gap-2 checklist-group';

            checklistContainer.innerHTML = mockSizes.map(size => {
                const isOneSize = size === 'ONE SIZE' || size === 'OTHER';
                return `
                    <label class="size-tag relative ${isOneSize ? 'one-size-option' : 'standard-size-option'}">
                        <input type="checkbox" name="product_sizes" value="${size}" class="hidden" data-size-type="${isOneSize ? 'one' : 'standard'}">
                        <span class="block">${size}</span>
                    </label>
                `;
            }).join('');
            
            // Attach exclusion logic listener
            attachSizeExclusionListener();
        }

        function attachSizeExclusionListener() {
            const sizeCheckboxes = document.querySelectorAll('#size-allocation-checklist input[type="checkbox"]');
            
            sizeCheckboxes.forEach(checkbox => {
                checkbox.addEventListener('change', function() {
                    const isOneSize = this.getAttribute('data-size-type') === 'one';
                    const isChecked = this.checked;
                    const standardOptions = document.querySelectorAll('.standard-size-option');
                    const oneSizeOptions = document.querySelectorAll('.one-size-option');
                    
                    if (isOneSize) {
                        // If ONE SIZE or OTHER is checked, disable and uncheck all standard options
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
                        // If any standard size is checked, disable and uncheck all 'one-size-option' options
                        if (isChecked) {
                            oneSizeOptions.forEach(oneLabel => {
                                const oneInput = oneLabel.querySelector('input');
                                oneInput.checked = false;
                                oneLabel.classList.add('disabled');
                            });
                        }
                        
                        // If NO standard sizes are checked, re-enable 'one-size-option' options
                        const anyStandardChecked = Array.from(standardOptions).some(stdLabel => stdLabel.querySelector('input').checked);
                        if (!anyStandardChecked) {
                            oneSizeOptions.forEach(oneLabel => oneLabel.classList.remove('disabled'));
                        }
                    }
                });
            });
        }
        
        // --- Searchable Modal Logic ---

        function openSearchableModal(type) {
            currentSearchType = type;
            const modal = document.getElementById('searchable-modal-overlay');
            const title = document.getElementById('searchable-modal-title');
            
            title.textContent = `Select ${type.charAt(0).toUpperCase() + type.slice(1)}`;
            document.getElementById('searchable-input').value = '';

            modal.classList.remove('hidden');
            filterSearchableOptions();
        }

        function closeSearchableModal() {
            document.getElementById('searchable-modal-overlay').classList.add('hidden');
        }

        function filterSearchableOptions() {
            const query = document.getElementById('searchable-input').value.toLowerCase();
            const listContainer = document.getElementById('searchable-options-list');
            
            const options = currentSearchType === 'category' ? mockCategories : mockBrands;
            
            listContainer.innerHTML = options
                .filter(opt => opt.label.toLowerCase().includes(query))
                .map(opt => `
                    <div class="searchable-option" data-value="${opt.value}" onclick="selectSearchableOption('${opt.value}', '${opt.label}')">
                        ${opt.label}
                    </div>
                `).join('');
        }

        function selectSearchableOption(value, label) {
            if (currentSearchType === 'category') {
                document.getElementById('product-category-display').value = label;
                document.getElementById('product-category').value = value;
            } else if (currentSearchType === 'brand') {
                document.getElementById('product-brand-display').value = label;
                document.getElementById('product-brand').value = value;
            }
            closeSearchableModal();
        }

        // --- Form Submission Logic ---

        document.getElementById('product-form').addEventListener('submit', function(event) {
            event.preventDefault();
            
            const form = event.target;
            
            // Collect all necessary values (including the hidden ones from searchable modals)
            const selectedBranches = Array.from(form.elements.branch_allocation)
                .filter(checkbox => checkbox.checked)
                .map(checkbox => checkbox.value);
            
            const selectedColors = Array.from(form.elements.product_colors)
                .filter(checkbox => checkbox.checked)
                .map(checkbox => checkbox.value);

            const selectedSizes = Array.from(form.elements.product_sizes)
                .filter(checkbox => checkbox.checked)
                .map(checkbox => checkbox.value);

            if (selectedBranches.length === 0 || selectedColors.length === 0 || selectedSizes.length === 0) {
                 showSnackbar("Please complete all required variant selections (Branch, Color, Size).", true);
                 return;
            }
            
            if (!form.elements.category_value.value || !form.elements.brand_value.value) {
                 showSnackbar("Please select a Category and Brand.", true);
                 return;
            }


            const data = {
                name: form.elements.name.value,
                category: form.elements.category_value.value,
                brand: form.elements.brand_value.value,
                description: form.elements.description.value,
                price: parseFloat(form.elements.price.value),
                colors: selectedColors,
                sizes: selectedSizes,
                branches_allocated: selectedBranches,
                photo_count: form.elements.photo.files.length, // Count of photos
            };

            console.log("New Product Registration Data:", data);
            
            // Show success message (Mock behavior)
            const submitButton = document.getElementById('submit-text');
            submitButton.textContent = 'Registering...';
            
            setTimeout(() => {
                submitButton.textContent = 'Product Registered!';
                showSnackbar(`Product "${data.name}" registered successfully to ${data.branches_allocated.length} branches.`, false);
                
                // Reset form
                setTimeout(() => {
                    submitButton.textContent = 'Register Product';
                    form.reset();
                    // Re-initialize dynamic lists
                    populateBranchChecklist();
                    populateColorChecklist();
                    populateSizeChecklist(); 
                }, 2000);
            }, 1000);
        });

        // --- Initialization ---

        window.onload = () => {
            populateBranchChecklist();
            populateColorChecklist();
            populateSizeChecklist();
        };
    </script>
</body>
</html>