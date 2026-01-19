<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Swim 360 Academy Dashboard</title>
    <!-- Tailwind CSS CDN for styling -->
    <script src="https://cdn.tailwindcss.com"></script>
    <style>
        @import url('https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap');
        body {
            font-family: 'Inter', sans-serif;
            background-color: #F7F9FB;
        }
        .view-container {
            animation: fadeIn 0.3s ease-in-out;
        }
        @keyframes fadeIn {
            from { opacity: 0; }
            to { opacity: 1; }
        }
        .action-card {
            background-color: white;
            border-radius: 12px;
            box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1), 0 2px 4px -2px rgba(0, 0, 0, 0.06);
            transition: all 0.2s;
            cursor: pointer;
            min-height: 110px;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
        }
        .action-card:hover {
            box-shadow: 0 10px 15px -3px rgba(0, 0, 0, 0.1), 0 4px 6px -4px rgba(0, 0, 0, 0.05);
            transform: translateY(-2px);
        }
        .poster-scroll {
            -webkit-overflow-scrolling: touch;
            scrollbar-width: none;
        }
        .poster-scroll::-webkit-scrollbar {
            display: none;
        }
    </style>
</head>
<body class="text-gray-800">

    <div id="app-container" class="max-w-xl mx-auto pb-20">
        <header class="bg-white shadow-md sticky top-0 z-10">
            <div class="p-4 flex items-center">
                <h1 class="text-xl font-bold truncate">Academy Dashboard</h1>
            </div>
        </header>

        <main class="view-container p-4 md:p-8">
            <h1 class="text-3xl font-extrabold text-gray-800 mb-2">Hello, Academy Manager!</h1>
            <p class="text-gray-500 mb-6">Coordinate your swimmers, coaches, and programs from one place.</p>
            
            <!-- Notifications Banner -->
            <div class="bg-red-500 rounded-xl shadow-lg p-3 flex justify-between items-center text-white mb-4 cursor-pointer transform hover:scale-[1.005] transition duration-200" onclick="showAction('Notifications')">
                <span class="text-md font-extrabold uppercase">Notifications</span>
                <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 17h5l-1.405-1.405A2.032 2.032 0 0118 14.158V11a6.002 6.002 0 00-4-5.659V5a2 2 0 10-4 0v.341C7.67 6.165 6 8.388 6 11v3.159c0 .538-.214 1.055-.595 1.436L4 17h5m6 0v1a3 3 0 11-6 0v-1m6 0H9"></path></svg>
            </div>

            <!-- Primary Action Banner: MY SWIMMERS -->
            <div class="bg-blue-600 rounded-xl shadow-lg p-6 flex justify-between items-center text-white mb-6 cursor-pointer transform hover:scale-[1.01] transition duration-200" onclick="showAction('My Swimmers')">
                <span class="text-xl font-extrabold uppercase">My Swimmers <span class="text-2xl ml-2">&gt;</span></span>
                <svg class="w-10 h-10" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4.354a4 4 0 110 5.292M15 21H3v-1a6 6 0 0112 0v1zm0 0h6v-1a6 6 0 00-9-5.197M13 7a4 4 0 11-8 0 4 4 0 018 0z"></path></svg>
            </div>

            <!-- 2x3 Grid of Action Buttons -->
            <div class="grid grid-cols-2 gap-3 mb-8">
                
                <!-- 1. Add Program -->
                <button class="action-card p-4 text-center" onclick="showAction('Add Program')">
                    <svg class="w-8 h-8 text-blue-600 mb-2" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 9v3m0 0v3m0-3h3m-3 0H9m12 0a9 9 0 11-18 0 9 9 0 0118 0z"></path></svg>
                    <span class="text-sm font-semibold">Add Program</span>
                </button>
                
                <!-- 2. My Programs -->
                <button class="action-card p-4 text-center" onclick="showAction('My Programs')">
                    <svg class="w-8 h-8 text-blue-600 mb-2" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 002 2h2a2 2 0 002-2"></path></svg>
                    <span class="text-sm font-semibold">My Programs</span>
                </button>
                
                <!-- 3. Groups & Schedule -->
                <button class="action-card p-4 text-center" onclick="showAction('Groups & Schedule')">
                    <svg class="w-8 h-8 text-blue-600 mb-2" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z"></path></svg>
                    <span class="text-sm font-semibold">Groups & Schedule</span>
                </button>

                <!-- 4. Add Branch -->
                 <button class="action-card p-4 text-center" onclick="showAction('Add Branch')">
                    <svg class="w-8 h-8 text-blue-600 mb-2" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17.657 16.657L13.414 20.9a1.998 1.998 0 01-2.828 0l-4.243-4.243a8 8 0 1111.314 0z"></path><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 11a3 3 0 11-6 0 3 3 0 016 0z"></path></svg>
                    <span class="text-sm font-semibold">Add Branch</span>
                </button>

                <!-- 5. My Branches -->
                <button class="action-card p-4 text-center" onclick="showAction('My Branches')">
                    <svg class="w-8 h-8 text-blue-600 mb-2" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 21V5a2 2 0 00-2-2H7a2 2 0 00-2 2v16m14 0h2m-2 0h-5m-9 0H3m2 0h5M9 10h6"></path></svg>
                    <span class="text-sm font-semibold">My Branches</span>
                </button>

                <!-- 6. Coaches -->
                <button class="action-card p-4 text-center" onclick="showAction('Coaches')">
                    <svg class="w-8 h-8 text-blue-600 mb-2" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M16 7a4 4 0 11-8 0 4 4 0 018 0zM12 14a7 7 0 00-7 7h14a7 7 0 00-7-7z"></path></svg>
                    <span class="text-sm font-semibold">Coaches</span>
                </button>
                
            </div>

            <!-- Management Tools (Scrolling Banner) -->
            <h2 class="text-xl font-bold mb-3">Management Tools</h2>
            <div class="flex overflow-x-auto space-x-4 pb-4 poster-scroll">
                <!-- Tool 1 -->
                <div class="w-64 flex-shrink-0 rounded-xl overflow-hidden shadow-lg border border-gray-200 cursor-pointer bg-red-100" onclick="showAction('Create Event')">
                    <div class="p-3">
                        <p class="font-bold text-lg text-red-700">Create Event</p>
                        <p class="text-sm text-gray-700">Set up a new swim meet or clinic.</p>
                    </div>
                </div>

                <!-- Tool 2 -->
                <div class="w-64 flex-shrink-0 rounded-xl overflow-hidden shadow-lg border border-gray-200 cursor-pointer bg-yellow-100" onclick="showAction('Create Offer')">
                    <div class="p-3">
                        <p class="font-bold text-lg text-yellow-700">Create Offer</p>
                        <p class="text-sm text-gray-700">Post a discount code or package deal.</p>
                    </div>
                </div>
                
                <!-- Tool 3 -->
                <div class="w-64 flex-shrink-0 rounded-xl overflow-hidden shadow-lg border border-gray-200 cursor-pointer bg-green-100" onclick="showAction('Advertise')">
                    <div class="p-3">
                        <p class="font-bold text-lg text-green-700">Advertise</p>
                        <p class="text-sm text-gray-700">Promote your brand to our users.</p>
                    </div>
                </div>
            </div>
        </main>
    </div>

    <!-- Feedback Snackbar -->
    <div id="snackbar" class="fixed bottom-6 left-1/2 -translate-x-1/2 px-6 py-3 rounded-lg shadow-lg text-white opacity-0 transition-opacity duration-300 pointer-events-none z-50"></div>

    <script>
        function showAction(name) {
            const isError = name === 'Notifications';
            const snackbar = document.getElementById('snackbar');
            snackbar.textContent = `Navigating to ${name}...`;
            snackbar.className = `fixed bottom-6 left-1/2 -translate-x-1/2 px-6 py-3 rounded-lg shadow-lg text-white z-50 transition-opacity duration-300 ${isError ? 'bg-red-500' : 'bg-blue-600'}`;
            snackbar.style.opacity = '1';
            setTimeout(() => {
                snackbar.style.opacity = '0';
            }, 3000);
        }
    </script>
</body>
</html>