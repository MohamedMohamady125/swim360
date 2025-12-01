<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Create New Program</title>
    <!-- Tailwind CSS CDN for styling -->
    <script src="https://cdn.tailwindcss.com"></script>
    <style>
        @import url('https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap');
        body {
            font-family: 'Inter', sans-serif;
            background-color: #F7F9FB;
        }
        /* Custom green submit button style (matching the Submit button in the provided UI) */
        .btn-submit {
            background-color: #4CAF50; /* Green shade */
            color: white;
            transition: background-color 0.2s, transform 0.2s;
        }
        .btn-submit:hover {
            background-color: #45A049;
            transform: translateY(-1px);
        }
        .form-card {
            background-color: white;
            border-radius: 12px;
            box-shadow: 0 10px 15px -3px rgba(0, 0, 0, 0.1), 0 4px 6px -4px rgba(0, 0, 0, 0.05);
            padding: 1.5rem;
        }
        /* Style similar to the clean list items in the provided UI screenshots */
        .input-group {
            display: flex;
            align-items: center;
            border: 1px solid #E5E7EB; /* Light grey border */
            border-radius: 8px;
            padding: 0 12px;
            background-color: #FAFAFA; /* Very light background for contrast */
            transition: border-color 0.2s, box-shadow 0.2s;
            width: 100%; /* Ensure full width when not in a grid */
        }
        .input-group:focus-within {
            border-color: #3B82F6;
            box-shadow: 0 0 0 1px #3B82F6;
            background-color: white;
        }
        .input-group input, .input-group textarea, .input-group select {
            border: none;
            outline: none;
            padding: 12px 0; /* Increased vertical padding for space */
            flex-grow: 1;
            background-color: transparent;
        }
        /* Specific styling for the Duration split inputs */
        .duration-input input {
            border-right: 1px solid #E5E7EB;
            padding-right: 12px;
        }
        .duration-input select {
            padding-left: 12px;
            width: auto;
            flex-grow: 0;
            cursor: pointer;
        }
        .file-upload-box {
            position: relative;
            border: 2px dashed #D1D5DB;
            background-color: #F9FAFB;
            transition: border-color 0.2s;
        }
        .file-upload-box:hover {
            border-color: #60A5FA;
        }
    </style>
</head>
<body class="p-4 md:p-8">

    <div class="max-w-xl mx-auto">
        <h1 class="text-3xl font-extrabold text-gray-800 mb-2">Build New Program</h1>
        <p class="text-gray-500 mb-8">Define the curriculum, media, and pricing for your professional online coaching service.</p>

        <form id="program-form" class="space-y-6">
            
            <!-- Program Details Card -->
            <div class="form-card space-y-6">
                <h3 class="text-xl font-bold text-gray-800 mb-4 border-b pb-2">Program Details</h3>
                
                <!-- Program Title -->
                <div>
                    <label for="program-title" class="block text-sm font-medium text-gray-700 mb-1">Program Title</label>
                    <div class="input-group">
                        <svg class="w-5 h-5 text-gray-400 mr-3" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z"></path></svg>
                        <input type="text" id="program-title" name="title" required
                               placeholder="e.g., Elite Performance Coaching">
                    </div>
                </div>

                <!-- Delivery Method -->
                <div>
                    <label for="program-type" class="block text-sm font-medium text-gray-700 mb-1">Delivery Method</label>
                    <div class="input-group">
                        <svg class="w-5 h-5 text-gray-400 mr-3" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10.325 4.317c.426-1.756 2.924-1.756 3.35 0a1.724 1.724 0 002.573 1.066c1.543-.94 3.31.826 2.37 2.37a1.724 1.724 0 001.065 2.572c1.756.426 1.756 2.924 0 3.35a1.724 1.724 0 00-1.066 2.573c.94 1.543-.826 3.31-2.37 2.37a1.724 1.724 0 00-2.572 1.065c-.426 1.756-2.924 1.756-3.35 0a1.724 1.724 0 00-2.573-1.066c-1.543.94-3.31-.826-2.37-2.37a1.724 1.724 0 00-1.065-2.572c-1.756-.426-1.756-2.924 0-3.35a1.724 1.724 0 001.066-2.573c-.94-1.543.826-3.31 2.37-2.37a1.724 1.724 0 002.572-1.065z"></path><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z"></path></svg>
                        <select id="program-type" name="type" required>
                            <option value="live">Live / Scheduled Sessions</option>
                            <option value="self-paced">Self-Paced (Video/Content Only)</option>
                            <option value="hybrid">Hybrid (Content + Check-ins)</option>
                        </select>
                    </div>
                </div>
            </div>

            <!-- Media & Description Card -->
            <div class="form-card space-y-6">
                <h3 class="text-xl font-bold text-gray-800 mb-4 border-b pb-2">Media & Description</h3>

                <!-- Cover Photo Upload (Required) -->
                <div>
                    <label for="cover-photo" class="block text-sm font-medium text-gray-700 mb-1">Cover Photo (Required)</label>
                    <div class="file-upload-box flex flex-col items-center justify-center p-6 rounded-lg text-gray-500">
                        <svg class="w-8 h-8 mb-2" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 16l4.586-4.586a2 2 0 012.828 0L16 16m-2-2l1.586-1.586a2 2 0 012.828 0L20 14m-6-6h.01M6 20h12a2 2 0 002-2V6a2 2 0 00-2-2H6a2 2 0 00-2 2v12a2 2 0 002 2z"></path></svg>
                        <p class="text-sm font-medium">Upload Image</p>
                        <p id="cover-file-name" class="text-xs mt-1 text-gray-400">No file selected.</p>
                        
                        <!-- Actual file input must be transparent and cover the box -->
                        <input type="file" id="cover-photo" name="cover_photo" accept="image/*" required
                               class="absolute inset-0 opacity-0 cursor-pointer w-full h-full">
                    </div>
                </div>

                <!-- Intro Video URL (Optional) -->
                <div>
                    <label for="intro-video-url" class="block text-sm font-medium text-gray-700 mb-1">Intro Video URL (Optional)</label>
                    <div class="input-group">
                         <svg class="w-5 h-5 text-gray-400 mr-3" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 10l4.553-2.276A1 1 0 0121 8.618v6.764a1 1 0 01-1.447.894L15 14M5 18h8a2 2 0 002-2V8a2 2 0 00-2-2H5a2 2 0 00-2 2v8a2 2 0 002 2z"></path></svg>
                         <input type="url" id="intro-video-url" name="intro_video_url"
                               placeholder="e.g., https://youtube.com/watch?v=...">
                    </div>
                    <p class="text-xs text-gray-500 mt-1">Embed videos from YouTube or Vimeo by pasting the share URL.</p>
                </div>

                <!-- Detailed Description -->
                <div>
                    <label for="program-description" class="block text-sm font-medium text-gray-700 mb-1">Detailed Description</label>
                    <textarea id="program-description" name="description" rows="4" required
                              class="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-blue-500 focus:border-blue-500 transition duration-150"
                              placeholder="Outline the goals, weekly workload, and target audience."></textarea>
                </div>
            </div>


            <!-- Pricing & Duration Card -->
            <div class="form-card">
                <h3 class="text-xl font-bold text-gray-800 mb-4 border-b pb-2">Pricing & Duration</h3>
                
                <div class="grid grid-cols-1 sm:grid-cols-2 gap-4">
                    
                    <!-- Price -->
                    <div>
                        <label for="program-price" class="block text-sm font-medium text-gray-700 mb-1">Price (USD)</label>
                        <div class="input-group">
                            <span class="text-gray-400 font-semibold mr-1">$</span>
                            <input type="number" id="program-price" name="price" required min="1" step="0.01"
                                   placeholder="199.99">
                        </div>
                    </div>

                    <!-- Duration (Split Input) -->
                    <div>
                        <label for="duration-value" class="block text-sm font-medium text-gray-700 mb-1">Program Duration</label>
                        <div class="input-group p-0 duration-input">
                            <svg class="w-5 h-5 text-gray-400 ml-3" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z"></path></svg>
                            <input type="number" id="duration-value" name="duration_value" required min="1"
                                   placeholder="e.g., 12" class="w-2/3">
                            <select id="duration-unit" name="duration_unit" class="w-1/3">
                                <option value="weeks">Weeks</option>
                                <option value="sessions">Sessions</option>
                                <option value="days">Days</option>
                                <option value="months">Months</option>
                            </select>
                        </div>
                    </div>
                    
                    <!-- End Date (Optional) -->
                    <div class="col-span-2">
                        <label for="program-end-date" class="block text-sm font-medium text-gray-700 mb-1">Program End Date (Optional)</label>
                         <div class="input-group">
                            <svg class="w-5 h-5 text-gray-400 mr-3" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z"></path></svg>
                            <input type="date" id="program-end-date" name="end_date">
                        </div>
                        <p class="text-xs text-gray-500 mt-1">If the program has a fixed end date (e.g., a specific camp). Otherwise, leave blank.</p>
                    </div>
                    
                    <!-- Max Participants -->
                    <div class="col-span-2">
                        <label for="program-max-participants" class="block text-sm font-medium text-gray-700 mb-1">Maximum Participants (Optional)</label>
                        <div class="input-group">
                            <svg class="w-5 h-5 text-gray-400 mr-3" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 20h2a2 2 0 002-2V5a2 2 0 00-2-2H5a2 2 0 00-2 2v13a2 2 0 002 2h2M9 14v6M15 14v6M12 3v18"></path></svg>
                            <input type="number" id="program-max-participants" name="max_participants" min="1"
                                   placeholder="e.g., 20 (Leave blank for unlimited)">
                        </div>
                    </div>
                </div>
            </div>

            <!-- Submit Button -->
            <button type="submit" class="w-full py-3 text-white font-semibold rounded-lg shadow-lg btn-submit">
                <span id="submit-text">Publish Program</span>
            </button>
            
        </form>
    </div>

    <script>
        // Helper function for displaying file names
        function updateFileName(inputId, nameDisplayId) {
            const input = document.getElementById(inputId);
            const nameDisplay = document.getElementById(nameDisplayId);
            if (input.files && input.files.length > 0) {
                nameDisplay.textContent = `File Selected: ${input.files[0].name}`;
                nameDisplay.classList.remove('text-gray-400');
                nameDisplay.classList.add('text-green-600');
            } else {
                nameDisplay.textContent = 'No file selected.';
                nameDisplay.classList.remove('text-green-600');
                nameDisplay.classList.add('text-gray-400');
            }
        }

        // Attach listener for file input changes (Cover Photo)
        document.getElementById('cover-photo').addEventListener('change', () => updateFileName('cover-photo', 'cover-file-name'));
        

        document.getElementById('program-form').addEventListener('submit', function(event) {
            event.preventDefault();
            
            const form = event.target;
            const data = {
                title: form.elements.title.value,
                description: form.elements.description.value,
                type: form.elements.type.value,
                price: parseFloat(form.elements.price.value),
                duration_value: parseInt(form.elements.duration_value.value),
                duration_unit: form.elements.duration_unit.value,
                end_date: form.elements.end_date.value || null, // Capture optional end date
                max_participants: form.elements.max_participants.value ? parseInt(form.elements.max_participants.value) : null,
                cover_photo: form.elements.cover_photo.files.length > 0 ? form.elements.cover_photo.files[0].name : null,
                intro_video_url: form.elements.intro_video_url.value // Now collecting the URL
            };

            // Basic validation: End date validation (If provided, must be greater than today)
            if (data.end_date) {
                const today = new Date();
                today.setHours(0,0,0,0);
                const endDate = new Date(data.end_date);

                if (endDate < today) {
                    showSnackbar("Error: End Date cannot be in the past.", true);
                    return;
                }
            }
            
            console.log("New Program Data:", data);
            
            // Show success message (Mock behavior)
            const submitButton = document.getElementById('submit-text');
            submitButton.textContent = 'Publishing...';
            
            setTimeout(() => {
                submitButton.textContent = 'Program Published!';
                showSnackbar(`Successfully created program: ${data.title}`, false);
                
                // Reset button text after delay
                setTimeout(() => {
                    submitButton.textContent = 'Publish Program';
                    form.reset();
                    // Manually reset file name display
                    document.getElementById('cover-file-name').textContent = 'No file selected.';
                }, 2000);
            }, 1000);
        });
        
        // Helper function (already defined, but included for completeness)
        function showSnackbar(message, isError = false) {
            const snackbar = document.createElement('div');
            snackbar.textContent = message;
            snackbar.className = `fixed bottom-6 left-1/2 -translate-x-1/2 px-6 py-3 rounded-lg shadow-lg text-white ${isError ? 'bg-red-500' : 'bg-green-500'} z-[60]`;
            document.body.appendChild(snackbar);
            setTimeout(() => {
                snackbar.remove();
            }, 3000);
        }
    </script>
</body>
</html>