<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Swim 360 - Welcome</title>
    <!-- Tailwind CSS CDN -->
    <script src="https://cdn.tailwindcss.com"></script>
    <style>
        @import url('https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800;900&display=swap');
        
        body {
            font-family: 'Inter', sans-serif;
            background-color: #FFFFFF;
            -webkit-tap-highlight-color: transparent;
        }

        .premium-shadow {
            box-shadow: 0 20px 25px -5px rgba(0, 0, 0, 0.05), 0 8px 10px -6px rgba(0, 0, 0, 0.03);
        }

        .action-card {
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
            position: relative;
            overflow: hidden;
        }

        .action-card:active {
            transform: scale(0.96);
        }

        /* Gradient Themes */
        .banner-blue { background: linear-gradient(135deg, #0ea5e9 0%, #2563eb 100%); }
        .card-purple { background: linear-gradient(135deg, #a855f7 0%, #7c3aed 100%); }
        .card-teal { background: linear-gradient(135deg, #14b8a6 0%, #0d9488 100%); }
        .card-orange { background: linear-gradient(135deg, #f97316 0%, #ea580c 100%); }
        .card-red { background: linear-gradient(135deg, #f43f5e 0%, #e11d48 100%); }

        /* Shared Action Button Styles */
        .btn-yellow-action {
            background: linear-gradient(135deg, #fbbf24 0%, #f59e0b 100%);
            box-shadow: 0 4px 15px rgba(245, 158, 11, 0.3);
            border: 1px solid #fcd34d;
        }

        .btn-blue-action {
            background: linear-gradient(135deg, #0ea5e9 0%, #2563eb 100%);
            box-shadow: 0 4px 15px rgba(37, 99, 235, 0.3);
        }

        /* Glassmorphism Chips */
        .action-chip {
            background: rgba(255, 255, 255, 0.2);
            backdrop-filter: blur(10px);
            border: 1px solid rgba(255, 255, 255, 0.3);
        }

        /* Decorative Background Shapes */
        .decor-circle {
            position: absolute;
            border-radius: 50%;
            background: white;
            opacity: 0.1;
            z-index: 0;
        }
    </style>
</head>
<body class="max-w-md mx-auto min-h-screen">

    <!-- Header Section -->
    <header class="px-6 pt-12 pb-6 flex justify-between items-center bg-white sticky top-0 z-20">
        <div>
            <h1 class="text-2xl font-black text-gray-900 tracking-tight">Hey Yehia 👋</h1>
            <p class="text-sm font-medium text-gray-400 mt-0.5">Ready to dive in?</p>
        </div>
        <div class="flex items-center space-x-3">
            <!-- Refined Yellow Notification Button -->
            <button id="notif-btn" onclick="clearNotifications()" class="p-3 btn-yellow-action rounded-2xl text-white relative hover:scale-105 transition-all">
                <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2.5" d="M15 17h5l-1.405-1.405A2.032 2.032 0 0118 14.158V11a6.002 6.002 0 00-4-5.659V5a2 2 0 10-4 0v.341C7.67 6.165 6 8.388 6 11v3.159c0 .538-.214 1.055-.595 1.436L4 17h5m6 0v1a3 3 0 11-6 0v-1m6 0H9"></path></svg>
                <span id="notif-badge" class="absolute top-1 right-1 w-3 h-3 bg-red-500 rounded-full border-2 border-amber-400 animate-pulse"></span>
            </button>
            
            <!-- User Account Button (Unified Blue UI, No Yellow Border) -->
            <button onclick="navigate('profile')" class="p-0.5 btn-blue-action rounded-2xl relative hover:scale-105 transition-all shadow-sm overflow-hidden border-none">
                <div class="w-11 h-11 rounded-[14px] overflow-hidden border-2 border-white/20">
                    <img src="https://placehold.co/100x100/2563eb/white?text=Y" alt="Profile" class="w-full h-full object-cover">
                </div>
            </button>
        </div>
    </header>

    <!-- Main Content -->
    <main class="px-6 pb-10 space-y-6">

        <!-- Primary Action: Book Now -->
        <section class="action-card banner-blue rounded-[32px] p-8 text-white premium-shadow cursor-pointer" onclick="navigate('booking')">
            <div class="relative z-10">
                <h2 class="text-3xl font-black leading-tight">Book Your<br>Next Session</h2>
                <p class="text-blue-100 text-sm font-bold mt-2 opacity-90">Find a pool or clinic</p>
                <div class="mt-6 inline-flex items-center px-5 py-2.5 bg-white text-blue-600 rounded-2xl font-black text-sm shadow-lg">
                    Book Now
                    <svg class="w-4 h-4 ml-2" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="3" d="M14 5l7 7m0 0l-7 7m7-7H3"></path></svg>
                </div>
            </div>
            <!-- Decorative Waves -->
            <svg class="absolute bottom-0 right-0 w-48 h-48 opacity-20 -mb-10 -mr-10" viewBox="0 0 200 200" xmlns="http://www.w3.org/2000/svg">
                <path fill="#FFFFFF" d="M44.7,-76.4C58.2,-69.2,70,-58.1,78.9,-44.9C87.8,-31.7,93.8,-15.8,92.5,-0.7C91.3,14.3,82.8,28.7,73.1,41.2C63.5,53.7,52.7,64.4,40.1,71.5C27.5,78.5,13.8,82,0.4,81.4C-13,80.8,-26,76,-38.4,68.8C-50.7,61.6,-62.4,51.9,-71,39.9C-79.6,28,-85.1,14,-86.1,-0.6C-87.1,-15.2,-83.6,-30.3,-75.6,-43.3C-67.6,-56.3,-55.1,-67.2,-41.2,-74.1C-27.4,-81,-13.7,-83.9,0.5,-84.8C14.7,-85.6,29.4,-83.5,44.7,-76.4Z" transform="translate(100 100)" />
            </svg>
        </section>

        <!-- 2x2 High-Impact Action Grid -->
        <section class="grid grid-cols-2 gap-4">
            
            <!-- My Bookings (Purple) -->
            <div class="action-card card-purple rounded-[30px] p-6 text-white cursor-pointer flex flex-col justify-between aspect-square" onclick="navigate('my-bookings')">
                <div class="decor-circle w-20 h-20 -top-5 -right-5"></div>
                <div class="w-10 h-10 action-chip rounded-xl flex items-center justify-center relative z-10">
                    <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z"></path></svg>
                </div>
                <div class="relative z-10">
                    <h3 class="font-black text-xl leading-tight">My<br>Bookings</h3>
                    <p class="text-[10px] font-black uppercase tracking-widest mt-2 opacity-80">2 Upcoming</p>
                </div>
            </div>

            <!-- My Programs (Teal) -->
            <div class="action-card card-teal rounded-[30px] p-6 text-white cursor-pointer flex flex-col justify-between aspect-square" onclick="navigate('my-programs')">
                <div class="decor-circle w-24 h-24 -bottom-10 -left-5"></div>
                <div class="w-10 h-10 action-chip rounded-xl flex items-center justify-center relative z-10">
                    <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12l2 2 4-4M7.835 4.697a3.42 3.42 0 001.946-3.06 3.5 3.5 0 016.438 0 3.42 3.42 0 001.946 3.06 3.5 3.5 0 011.612 6.21 3.42 3.42 0 000 3.646 3.5 3.5 0 01-1.612 6.21 3.42 3.42 0 00-1.946 3.06 3.5 3.5 0 01-6.438 0 3.42 3.42 0 00-1.946-3.06 3.5 3.5 0 01-1.612-6.21 3.42 3.42 0 000-3.646 3.5 3.5 0 011.612-6.21z"></path></svg>
                </div>
                <div class="relative z-10">
                    <h3 class="font-black text-xl leading-tight">My<br>Programs</h3>
                    <p class="text-[10px] font-black uppercase tracking-widest mt-2 opacity-80">3 Active</p>
                </div>
            </div>

            <!-- My Orders (Orange) -->
            <div class="action-card card-orange rounded-[30px] p-6 text-white cursor-pointer flex flex-col justify-between aspect-square" onclick="navigate('my-orders')">
                <div class="decor-circle w-16 h-16 top-10 -right-8"></div>
                <div class="w-10 h-10 action-chip rounded-xl flex items-center justify-center relative z-10">
                    <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M16 11V7a4 4 0 00-8 0v4M5 9h14l1 12H4L5 9z"></path></svg>
                </div>
                <div class="relative z-10">
                    <h3 class="font-black text-xl leading-tight">My<br>Orders</h3>
                    <p class="text-[10px] font-black uppercase tracking-widest mt-2 opacity-80">2 Orders</p>
                </div>
            </div>

            <!-- Calendar (Red) -->
            <div class="action-card card-red rounded-[30px] p-6 text-white cursor-pointer flex flex-col justify-between aspect-square" onclick="navigate('calendar')">
                <div class="decor-circle w-32 h-32 -top-16 -left-10"></div>
                <div class="w-10 h-10 action-chip rounded-xl flex items-center justify-center relative z-10">
                    <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z"></path></svg>
                </div>
                <div class="relative z-10">
                    <h3 class="font-black text-xl leading-tight">Activity<br>Calendar</h3>
                    <p class="text-[10px] font-black uppercase tracking-widest mt-2 opacity-80">Full View</p>
                </div>
            </div>

        </section>

    </main>

    <script>
        /**
         * Simulates clearing the notification badge
         */
        function clearNotifications() {
            const badge = document.getElementById('notif-badge');
            if (badge) {
                badge.style.display = 'none';
            }
            navigate('notifications');
        }

        function navigate(view) {
            const snackbar = document.createElement('div');
            snackbar.className = "fixed bottom-10 left-1/2 -translate-x-1/2 bg-gray-900/90 backdrop-blur-md text-white px-8 py-4 rounded-[20px] text-sm font-black shadow-2xl z-50 animate-bounce flex items-center";
            snackbar.innerHTML = `
                <span class="mr-3 w-2 h-2 bg-blue-400 rounded-full"></span>
                Diving into ${view.replace('-', ' ').toUpperCase()}...
            `;
            document.body.appendChild(snackbar);
            setTimeout(() => {
                snackbar.style.opacity = '0';
                snackbar.style.transition = 'opacity 0.5s ease';
                setTimeout(() => snackbar.remove(), 500);
            }, 2000);
        }
    </script>
</body>
</html>