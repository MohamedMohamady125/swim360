<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Swim 360 - Welcome</title>
    <!-- Tailwind CSS CDN -->
    <script src="https://cdn.tailwindcss.com"></script>
    <style>
        @import url('https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap');
        
        body {
            font-family: 'Inter', sans-serif;
            background-color: #FFFFFF;
            -webkit-tap-highlight-color: transparent;
        }

        .premium-shadow {
            box-shadow: 0 10px 25px -5px rgba(0, 0, 0, 0.03), 0 8px 10px -6px rgba(0, 0, 0, 0.03);
        }

        .action-card {
            transition: all 0.2s cubic-bezier(0.4, 0, 0.2, 1);
        }

        .action-card:active {
            transform: scale(0.96);
            background-color: #f8fafc;
        }

        .main-banner {
            background: linear-gradient(135deg, #0ea5e9 0%, #3b82f6 100%);
        }
    </style>
</head>
<body class="max-w-md mx-auto min-h-screen">

    <!-- Header Section -->
    <header class="px-6 pt-10 pb-6 flex justify-between items-center bg-white sticky top-0 z-20">
        <div>
            <h1 class="text-2xl font-extrabold text-gray-900 tracking-tight">Hey Yehia 👋</h1>
            <p class="text-sm font-medium text-gray-400 mt-0.5">Ready to dive in?</p>
        </div>
        <div class="flex items-center space-x-3">
            <button class="p-2 bg-gray-50 rounded-full text-gray-600 relative hover:bg-gray-100 transition">
                <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 17h5l-1.405-1.405A2.032 2.032 0 0118 14.158V11a6.002 6.002 0 00-4-5.659V5a2 2 0 10-4 0v.341C7.67 6.165 6 8.388 6 11v3.159c0 .538-.214 1.055-.595 1.436L4 17h5m6 0v1a3 3 0 11-6 0v-1m6 0H9"></path></svg>
                <span class="absolute top-2 right-2.5 w-2 h-2 bg-red-500 rounded-full border-2 border-white"></span>
            </button>
            <div class="w-11 h-11 rounded-full border-2 border-blue-50 overflow-hidden shadow-sm cursor-pointer hover:opacity-90 transition">
                <img src="https://placehold.co/100x100/3b82f6/white?text=Y" alt="Profile">
            </div>
        </div>
    </header>

    <!-- Main Content -->
    <main class="px-6 pb-10 space-y-6">

        <!-- Primary Action: Book Now -->
        <section class="action-card main-banner rounded-[32px] p-8 text-white relative overflow-hidden shadow-xl cursor-pointer" onclick="navigate('booking')">
            <div class="relative z-10">
                <h2 class="text-3xl font-black leading-tight">Book Your<br>Next Session</h2>
                <p class="text-blue-100 text-sm font-medium mt-2 opacity-90">Find a pool or clinic near you</p>
                <div class="mt-6 inline-flex items-center px-5 py-2.5 bg-white text-blue-600 rounded-2xl font-bold text-sm shadow-lg">
                    Book Now
                    <svg class="w-4 h-4 ml-2" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2.5" d="M14 5l7 7m0 0l-7 7m7-7H3"></path></svg>
                </div>
            </div>
            <!-- Decorative SVG Waves -->
            <svg class="absolute bottom-0 right-0 w-48 h-48 opacity-20 -mb-10 -mr-10" viewBox="0 0 200 200" xmlns="http://www.w3.org/2000/svg">
                <path fill="#FFFFFF" d="M44.7,-76.4C58.2,-69.2,70,-58.1,78.9,-44.9C87.8,-31.7,93.8,-15.8,92.5,-0.7C91.3,14.3,82.8,28.7,73.1,41.2C63.5,53.7,52.7,64.4,40.1,71.5C27.5,78.5,13.8,82,0.4,81.4C-13,80.8,-26,76,-38.4,68.8C-50.7,61.6,-62.4,51.9,-71,39.9C-79.6,28,-85.1,14,-86.1,-0.6C-87.1,-15.2,-83.6,-30.3,-75.6,-43.3C-67.6,-56.3,-55.1,-67.2,-41.2,-74.1C-27.4,-81,-13.7,-83.9,0.5,-84.8C14.7,-85.6,29.4,-83.5,44.7,-76.4Z" transform="translate(100 100)" />
            </svg>
        </section>

        <!-- 2x2 Action Grid -->
        <section class="grid grid-cols-2 gap-4">
            <!-- My Bookings -->
            <div class="action-card bg-white border border-gray-50 premium-shadow rounded-[28px] p-5 flex flex-col items-start cursor-pointer" onclick="navigate('my-bookings')">
                <div class="w-12 h-12 bg-blue-50 text-blue-500 rounded-2xl flex items-center justify-center mb-4">
                    <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z"></path></svg>
                </div>
                <h3 class="font-bold text-gray-800 text-lg">My Bookings</h3>
                <p class="text-xs text-gray-400 font-medium mt-1">2 upcoming</p>
            </div>

            <!-- My Programs -->
            <div class="action-card bg-white border border-gray-50 premium-shadow rounded-[28px] p-5 flex flex-col items-start cursor-pointer" onclick="navigate('my-programs')">
                <div class="w-12 h-12 bg-teal-50 text-teal-500 rounded-2xl flex items-center justify-center mb-4">
                    <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4M7.835 4.697a3.42 3.42 0 001.946-3.06 3.5 3.5 0 016.438 0 3.42 3.42 0 001.946 3.06 3.5 3.5 0 011.612 6.21 3.42 3.42 0 000 3.646 3.5 3.5 0 01-1.612 6.21 3.42 3.42 0 00-1.946 3.06 3.5 3.5 0 01-6.438 0 3.42 3.42 0 00-1.946-3.06 3.5 3.5 0 01-1.612-6.21 3.42 3.42 0 000-3.646 3.5 3.5 0 011.612-6.21z"></path></svg>
                </div>
                <h3 class="font-bold text-gray-800 text-lg">My Programs</h3>
                <p class="text-xs text-gray-400 font-medium mt-1">3 Programs</p>
            </div>

            <!-- My Orders -->
            <div class="action-card bg-white border border-gray-50 premium-shadow rounded-[28px] p-5 flex flex-col items-start cursor-pointer" onclick="navigate('my-orders')">
                <div class="w-12 h-12 bg-orange-50 text-orange-500 rounded-2xl flex items-center justify-center mb-4">
                    <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M16 11V7a4 4 0 00-8 0v4M5 9h14l1 12H4L5 9z"></path></svg>
                </div>
                <h3 class="font-bold text-gray-800 text-lg">My Orders</h3>
                <p class="text-xs text-gray-400 font-medium mt-1">2 Orders</p>
            </div>

            <!-- Calendar Access -->
            <div class="action-card bg-white border border-gray-50 premium-shadow rounded-[28px] p-5 flex flex-col items-start cursor-pointer" onclick="navigate('calendar')">
                <div class="w-12 h-12 bg-purple-50 text-purple-500 rounded-2xl flex items-center justify-center mb-4">
                    <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z"></path></svg>
                </div>
                <h3 class="font-bold text-gray-800 text-lg">Calendar</h3>
                <p class="text-xs text-gray-400 font-medium mt-1">Full Schedule</p>
            </div>
        </section>

    </main>

    <script>
        function navigate(view) {
            const snackbar = document.createElement('div');
            snackbar.className = "fixed bottom-10 left-1/2 -translate-x-1/2 bg-gray-900 text-white px-6 py-3 rounded-2xl text-sm font-bold shadow-2xl z-50 animate-bounce";
            snackbar.textContent = `Navigating to ${view.replace('-', ' ')}...`;
            document.body.appendChild(snackbar);
            setTimeout(() => snackbar.remove(), 2500);
        }
    </script>
</body>
</html>