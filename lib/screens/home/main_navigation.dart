<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Swim 360 App</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <style>
        @import url('https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap');
        body {
            font-family: 'Inter', sans-serif;
            background-color: #f3f4f6; /* Light gray background */
            padding-bottom: 72px; /* Space for fixed bottom navigation */
            min-height: 100vh;
            display: flex;
            flex-direction: column;
            align-items: center;
        }

        /* Generic transition class for page content */
        .page-transition {
            transition: opacity 0.4s ease-out, transform 0.4s ease-out;
            /* Needed for pages to stack and animate correctly within the wrapper */
            position: absolute; 
            top: 0;
            left: 0;
            right: 0;
            padding: 1rem;
            max-width: 420px;
            margin: auto;
        }

        /* Initial state for entering page (hidden below and transparent) */
        .page-hidden {
            opacity: 0;
            transform: translateY(10px);
            pointer-events: none;
        }

        /* Active state for visible page */
        .page-active {
            opacity: 1;
            transform: translateY(0);
            pointer-events: auto;
        }
        
        /* Style for the active nav item */
        .nav-item.active {
            color: #3b82f6;
            font-weight: 600;
        }
        .nav-item.active svg {
            stroke: #3b82f6;
        }
    </style>
</head>
<body class="p-4 pt-8">

    <!-- App Content Wrapper -->
    <div id="app-content-wrapper" class="w-full max-w-md relative min-h-[500px]">
        <!-- Home View -->
        <section id="home-view" class="page-transition page-active">
            <div class="bg-white p-6 rounded-2xl shadow-lg">
                <h1 id="home-title" class="text-3xl font-bold text-blue-600 mb-4 text-center">Home</h1>
                <p id="home-greeting" class="text-gray-700 text-left">Welcome to Swim 360! This is your main dashboard. Check the latest events and marketplace deals.</p>
                <div class="mt-6 p-4 bg-blue-50 rounded-lg">
                    <h3 class="font-semibold text-blue-700">Quick Stats</h3>
                    <p class="text-sm text-gray-600">Total Swims: 45 | Average Speed: 1.5 m/s</p>
                </div>
                <button id="language-toggle-btn" class="mt-6 w-full bg-blue-500 text-white p-3 rounded-full font-semibold hover:bg-blue-600 transition-colors">Toggle Language (العربية)</button>
            </div>
        </section>

        <!-- Events View -->
        <section id="events-view" class="page-transition page-hidden">
            <div class="bg-white p-6 rounded-2xl shadow-lg">
                <h1 id="events-title" class="text-3xl font-bold text-blue-600 mb-4 text-center">Events</h1>
                <p id="events-info" class="text-gray-700 text-left">Discover and register for upcoming swimming competitions and local meetups!</p>
                <ul id="events-list" class="mt-4 space-y-3">
                    <li class="p-3 border-b text-gray-700">Regional Championship - Aug 10th</li>
                    <li class="p-3 border-b text-gray-700">Open Water Fun Swim - Sep 5th</li>
                    <li class="p-3 text-gray-700">Masters Training Session - Every Tuesday</li>
                </ul>
            </div>
        </section>

        <!-- Marketplace View -->
        <section id="marketplace-view" class="page-transition page-hidden">
            <div class="bg-white p-6 rounded-2xl shadow-lg">
                <h1 id="marketplace-title" class="text-3xl font-bold text-blue-600 mb-4 text-center">Marketplace</h1>
                <p id="marketplace-info" class="text-gray-700 text-left">Buy and sell swimming gear, equipment, and training services.</p>
                <div class="grid grid-cols-2 gap-4 mt-4">
                    <div class="border p-3 rounded-lg text-center shadow-sm hover:shadow-md transition">
                        <span class="text-4xl">🏊</span>
                        <p id="item-1" class="text-sm font-medium mt-1">Racing Goggles</p>
                    </div>
                    <div class="border p-3 rounded-lg text-center shadow-sm hover:shadow-md transition">
                        <span class="text-4xl">👟</span>
                        <p id="item-2" class="text-sm font-medium mt-1">Used Fins</p>
                    </div>
                    <div class="border p-3 rounded-lg text-center shadow-sm hover:shadow-md transition">
                        <span class="text-4xl">⏱️</span>
                        <p id="item-3" class="text-sm font-medium mt-1">Stopwatches</p>
                    </div>
                    <div class="border p-3 rounded-lg text-center shadow-sm hover:shadow-md transition">
                        <span class="text-4xl">🧴</span>
                        <p id="item-4" class="text-sm font-medium mt-1">Sunscreen Bulk</p>
                    </div>
                </div>
            </div>
        </section>

        <!-- Profile View -->
        <section id="profile-view" class="page-transition page-hidden">
            <div class="bg-white p-6 rounded-2xl shadow-lg">
                <h1 id="profile-title" class="text-3xl font-bold text-blue-600 mb-4 text-center">Profile</h1>
                <p id="profile-info" class="text-gray-700 text-left">Manage your account details and view your swimming history.</p>
                <ul class="mt-4 space-y-3 p-4 bg-gray-50 rounded-lg">
                    <li id="profile-name" class="text-gray-700 border-b pb-2">Name: John Doe</li>
                    <li id="profile-level" class="text-gray-700 border-b pb-2">Level: Advanced</li>
                    <li id="profile-team" class="text-gray-700">Team: Blue Sharks</li>
                </ul>
            </div>
        </section>
    </div>

    <!-- Mobile Navigation Bar -->
    <nav id="nav-bar" class="fixed bottom-0 left-0 right-0 h-16 bg-white border-t border-gray-200 shadow-xl flex justify-around items-center max-w-md mx-auto rounded-t-xl z-40">
        <!-- Home Link -->
        <a href="#" id="nav-home-link" data-view="home" class="nav-item active flex flex-col items-center text-xs p-2 transition-colors duration-200">
            <!-- Icon: Home (Lucide) -->
            <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="w-6 h-6 mb-1">
                <path d="m3 9 9-7 9 7v11a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2z"/>
                <polyline points="9 22 9 12 15 12 15 22"/>
            </svg>
            <span id="nav-home">Home</span>
        </a>

        <!-- Events Link -->
        <a href="#" id="nav-events-link" data-view="events" class="nav-item flex flex-col items-center text-gray-500 hover:text-blue-500 transition-colors text-xs p-2">
            <!-- Icon: Calendar/Events (Lucide) -->
            <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="w-6 h-6 mb-1">
                <rect width="18" height="18" x="3" y="4" rx="2" ry="2"/>
                <line x1="16" x2="16" y1="2" y2="6"/>
                <line x1="8" x2="8" y1="2" y2="6"/>
                <line x1="3" x2="21" y1="10" y2="10"/>
            </svg>
            <span id="nav-events">Events</span>
        </a>

        <!-- Marketplace Link -->
        <a href="#" id="nav-marketplace-link" data-view="marketplace" class="nav-item flex flex-col items-center text-gray-500 hover:text-blue-500 transition-colors text-xs p-2">
            <!-- Icon: Shopping Cart (Lucide) -->
            <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="w-6 h-6 mb-1">
                <circle cx="8" cy="20.5" r="1"/>
                <circle cx="17" cy="20.5" r="1"/>
                <path d="M7.647 15.932l-3.238-12.951A.5.5 0 0 0 4 3h-1"/>
                <path d="m6.07 14.549 14.28 1.428a.5.5 0 0 0 .584-.367L22 5H5.2"/>
            </svg>
            <span id="nav-marketplace">Marketplace</span>
        </a>

        <!-- Profile Link -->
        <a href="#" id="nav-profile-link" data-view="profile" class="nav-item flex flex-col items-center text-gray-500 hover:text-blue-500 transition-colors text-xs p-2">
            <!-- Icon: User/Profile (Lucide) -->
            <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" class="w-6 h-6 mb-1">
                <path d="M19 21v-2a4 4 0 0 0-4-4H9a4 4 0 0 0-4 4v2"/>
                <circle cx="12" cy="7" r="4"/>
            </svg>
            <span id="nav-profile">Profile</span>
        </a>
    </nav>


    <script>
        // --- TRANSLATION DATA ---
        let currentLang = 'en';
        const translations = {
            en: {
                // View Titles
                homeTitle: "Home",
                eventsTitle: "Events",
                marketplaceTitle: "Marketplace",
                profileTitle: "Profile",

                // Home Content
                homeGreeting: "Welcome to Swim 360! This is your main dashboard. Check the latest events and marketplace deals.",
                statsTitle: "Quick Stats",
                statsContent: "Total Swims: 45 | Average Speed: 1.5 m/s",
                toggleBtn: "Toggle Language (العربية)",

                // Events Content
                eventsInfo: "Discover and register for upcoming swimming competitions and local meetups!",
                event1: "Regional Championship - Aug 10th",
                event2: "Open Water Fun Swim - Sep 5th",
                event3: "Masters Training Session - Every Tuesday",
                
                // Marketplace Content
                marketplaceInfo: "Buy and sell swimming gear, equipment, and training services.",
                item1: "Racing Goggles",
                item2: "Used Fins",
                item3: "Stopwatches",
                item4: "Sunscreen Bulk",

                // Profile Content
                profileInfo: "Manage your account details and view your swimming history.",
                profileName: "Name: John Doe",
                profileLevel: "Level: Advanced",
                profileTeam: "Team: Blue Sharks",
                
                // Navigation
                navHome: "Home",
                navEvents: "Events",
                navMarketplace: "Marketplace",
                navProfile: "Profile",
            },
            ar: {
                // View Titles
                homeTitle: "الرئيسية",
                eventsTitle: "الفعاليات",
                marketplaceTitle: "السوق",
                profileTitle: "الملف الشخصي",

                // Home Content
                homeGreeting: "مرحباً بك في Swim 360! هذه هي لوحة القيادة الرئيسية الخاصة بك. اطلع على أحدث الفعاليات وعروض السوق.",
                statsTitle: "إحصائيات سريعة",
                statsContent: "إجمالي السباحات: $٤٥$ | متوسط السرعة: $١.٥$ متر/ثانية",
                toggleBtn: "تبديل اللغة (English)",

                // Events Content
                eventsInfo: "اكتشف وسجل في مسابقات السباحة القادمة واللقاءات المحلية!",
                event1: "بطولة إقليمية - $١٠$ أغسطس",
                event2: "سباحة ممتعة في المياه المفتوحة - $٥$ سبتمبر",
                event3: "جلسة تدريب للمحترفين - كل ثلاثاء",

                // Marketplace Content
                marketplaceInfo: "قم بشراء وبيع معدات السباحة والمعدات والخدمات التدريبية.",
                item1: "نظارات سباحة للسباق",
                item2: "زعانف مستعملة",
                item3: "ساعات توقيت",
                item4: "كريم واقي من الشمس بالجملة",


                // Profile Content
                profileInfo: "إدارة تفاصيل حسابك وعرض سجل السباحة الخاص بك.",
                profileName: "الاسم: جون دو",
                profileLevel: "المستوى: متقدم",
                profileTeam: "الفريق: أسماك القرش الزرقاء",

                // Navigation
                navHome: "الرئيسية",
                navEvents: "الفعاليات",
                navMarketplace: "السوق",
                navProfile: "الملف الشخصي",
            }
        };

        function updateContent(lang) {
            const t = translations[lang];
            const isRTL = lang === 'ar';
            
            // Set document language and direction
            document.documentElement.lang = lang;
            document.body.style.direction = isRTL ? 'rtl' : 'ltr';

            // Apply text alignments for RTL/LTR
            const alignmentClass = isRTL ? 'text-right' : 'text-left';
            const viewsText = document.querySelectorAll('#app-content-wrapper section p, #app-content-wrapper section li, .bg-blue-50 h3, .bg-blue-50 p');
            viewsText.forEach(el => {
                el.classList.remove('text-left', 'text-right');
                el.classList.add(alignmentClass);
            });
            // Ensure main titles remain centered
            document.querySelectorAll('h1').forEach(h1 => h1.classList.add('text-center'));
            
            // Update all content based on selected language
            document.getElementById('home-title').textContent = t.homeTitle;
            document.getElementById('events-title').textContent = t.eventsTitle;
            document.getElementById('marketplace-title').textContent = t.marketplaceTitle;
            document.getElementById('profile-title').textContent = t.profileTitle;
            
            // Home View
            document.getElementById('home-greeting').textContent = t.homeGreeting;
            document.querySelector('.bg-blue-50 h3').textContent = t.statsTitle;
            document.querySelector('.bg-blue-50 p').textContent = t.statsContent;
            document.getElementById('language-toggle-btn').textContent = t.toggleBtn;

            // Events View
            document.getElementById('events-info').textContent = t.eventsInfo;
            const eventListItems = document.querySelectorAll('#events-list li');
            eventListItems[0].textContent = t.event1;
            eventListItems[1].textContent = t.event2;
            eventListItems[2].textContent = t.event3;

            // Marketplace View
            document.getElementById('marketplace-info').textContent = t.marketplaceInfo;
            document.getElementById('item-1').textContent = t.item1;
            document.getElementById('item-2').textContent = t.item2;
            document.getElementById('item-3').textContent = t.item3;
            document.getElementById('item-4').textContent = t.item4;


            // Profile View
            document.getElementById('profile-info').textContent = t.profileInfo;
            document.getElementById('profile-name').textContent = t.profileName;
            document.getElementById('profile-level').textContent = t.profileLevel;
            document.getElementById('profile-team').textContent = t.profileTeam;

            // Navigation bar
            document.getElementById('nav-home').textContent = t.navHome;
            document.getElementById('nav-events').textContent = t.navEvents;
            document.getElementById('nav-marketplace').textContent = t.navMarketplace;
            document.getElementById('nav-profile').textContent = t.navProfile;

            currentLang = lang;
        }

        /**
         * Handles navigation between different views with a smooth fade-and-slide animation.
         * @param {string} targetView - The data-view name (e.g., 'home', 'events').
         */
        function navigateTo(targetView) {
            const allViews = document.querySelectorAll('.page-transition');
            const targetViewElement = document.getElementById(`${targetView}-view`);
            const navItems = document.querySelectorAll('.nav-item');
            
            // 1. Hide all views and remove active state from nav
            allViews.forEach(view => {
                view.classList.add('page-hidden');
                view.classList.remove('page-active');
            });

            navItems.forEach(item => {
                item.classList.remove('active', 'text-blue-500', 'font-semibold');
                item.classList.add('text-gray-500', 'hover:text-blue-500');
            });
            
            // 2. Set the target view element to the initial hidden state for animation
            targetViewElement.classList.add('page-hidden');
            
            // 3. Update the active navigation item
            const activeNavItem = document.querySelector(`.nav-item[data-view="${targetView}"]`);
            if (activeNavItem) {
                activeNavItem.classList.add('active');
                activeNavItem.classList.remove('text-gray-500', 'hover:text-blue-500');
            }
            
            // 4. Force a repaint/reflow to ensure the hidden state is applied before transition
            // This is a common trick to trigger CSS transitions immediately after state change
            void targetViewElement.offsetWidth; 

            // 5. Apply the active state to start the transition (fade-in/slide-up)
            targetViewElement.classList.remove('page-hidden');
            targetViewElement.classList.add('page-active');
        }

        // Event Listeners for Navigation
        document.addEventListener('DOMContentLoaded', () => {
            // Initial content load (default to English)
            updateContent(currentLang);

            // Setup navigation listeners
            const navLinks = document.querySelectorAll('.nav-item');
            navLinks.forEach(link => {
                link.addEventListener('click', (e) => {
                    e.preventDefault();
                    const view = link.getAttribute('data-view');
                    if (view) {
                        navigateTo(view);
                    }
                });
            });

            // Language Toggle Button Listener
            document.getElementById('language-toggle-btn').addEventListener('click', () => {
                const newLang = currentLang === 'en' ? 'ar' : 'en';
                updateContent(newLang);
            });
            
            // Ensure initial view is Home
            navigateTo('home');
        });
    </script>
</body>
</html>
