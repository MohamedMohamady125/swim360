<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Swim 360 - My Calendar</title>
    <!-- Tailwind CSS CDN -->
    <script src="https://cdn.tailwindcss.com"></script>
    <style>
        @import url('https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800;900&display=swap');
        
        body {
            font-family: 'Inter', sans-serif;
            background-color: #FFFFFF;
            -webkit-tap-highlight-color: transparent;
            color: #0f172a;
        }

        .premium-shadow {
            box-shadow: 0 10px 30px -5px rgba(0, 0, 0, 0.04), 0 8px 12px -6px rgba(0, 0, 0, 0.02);
        }

        .calendar-day {
            aspect-ratio: 1 / 1.1;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            border-radius: 16px;
            font-size: 0.85rem;
            font-weight: 700;
            transition: all 0.2s cubic-bezier(0.4, 0, 0.2, 1);
            position: relative;
            cursor: pointer;
        }

        .calendar-day:hover:not(.empty) {
            background-color: #f8fafc;
        }

        .calendar-day.active {
            background-color: #0f172a;
            color: white;
            box-shadow: 0 10px 15px -3px rgba(15, 23, 42, 0.2);
        }

        /* Activity Dots */
        .dot { width: 5px; height: 5px; border-radius: 50%; margin: 0 1px; }
        .dot-academy { background-color: #2563eb; }
        .dot-clinic { background-color: #10b981; }
        .dot-event { background-color: #ef4444; }
        .dot-order { background-color: #f97316; }
        .dot-online { background-color: #8b5cf6; } /* New Purple Color */

        /* Modal Micro-animations */
        .modal-overlay {
            background-color: rgba(15, 23, 42, 0.4);
            backdrop-filter: blur(8px);
            transition: opacity 0.3s ease;
        }

        .modal-sheet {
            transition: transform 0.4s cubic-bezier(0.32, 0.72, 0, 1);
        }

        /* Timeline in Modal */
        .timeline-item {
            position: relative;
            padding-left: 28px;
        }

        .timeline-item::before {
            content: '';
            position: absolute;
            left: 0;
            top: 8px;
            bottom: -24px;
            width: 2px;
            background-color: #f1f5f9;
        }

        .timeline-item:last-child::before { display: none; }

        .timeline-marker {
            position: absolute;
            left: -4px;
            top: 8px;
            width: 10px;
            height: 10px;
            border-radius: 50%;
            border: 2px solid white;
            z-index: 1;
        }

        .marker-academy { background-color: #2563eb; box-shadow: 0 0 0 4px rgba(37, 99, 235, 0.1); }
        .marker-clinic { background-color: #10b981; box-shadow: 0 0 0 4px rgba(16, 185, 129, 0.1); }
        .marker-event { background-color: #ef4444; box-shadow: 0 0 0 4px rgba(239, 68, 68, 0.1); }
        .marker-order { background-color: #f97316; box-shadow: 0 0 0 4px rgba(249, 115, 22, 0.1); }
        .marker-online { background-color: #8b5cf6; box-shadow: 0 0 0 4px rgba(139, 92, 246, 0.1); }

        .hide-scrollbar::-webkit-scrollbar { display: none; }
        .hide-scrollbar { -ms-overflow-style: none; scrollbar-width: none; }
    </style>
</head>
<body class="max-w-md mx-auto min-h-screen pb-10 bg-white">

    <!-- Premium Header -->
    <header class="px-6 pt-12 pb-6 flex items-center justify-between sticky top-0 bg-white z-30 border-b border-slate-50">
        <div class="flex items-center space-x-4">
            <button onclick="window.history.back()" class="p-2 -ml-2 hover:bg-slate-50 rounded-full transition text-slate-800">
                <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2.5" d="M15 19l-7-7 7-7"></path></svg>
            </button>
            <h1 class="text-2xl font-black text-slate-900 tracking-tight">Calendar</h1>
        </div>
        
        <!-- Month Navigator -->
        <div class="flex items-center space-x-4 bg-slate-50 px-4 py-2 rounded-2xl border border-slate-100">
            <span class="text-xs font-black text-slate-900 uppercase tracking-wider min-w-[80px] text-center" id="current-month-display">Oct 2025</span>
            <div class="flex items-center border-l border-slate-200 pl-4 space-x-2">
                <button id="prev-btn" onclick="changeMonth(-1)" class="text-slate-300 cursor-not-allowed" disabled>
                    <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="3" d="M15 19l-7-7 7-7"></path></svg>
                </button>
                <button id="next-btn" onclick="changeMonth(1)" class="text-blue-600 hover:scale-110 transition-transform">
                    <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="3" d="M9 5l7 7-7 7"></path></svg>
                </button>
            </div>
        </div>
    </header>

    <main class="py-6">
        
        <!-- Month Grid View -->
        <section class="px-6 mb-10">
            <div class="grid grid-cols-7 gap-1 mb-4">
                <div class="text-[10px] font-black text-slate-300 uppercase text-center">Sun</div>
                <div class="text-[10px] font-black text-slate-300 uppercase text-center">Mon</div>
                <div class="text-[10px] font-black text-slate-300 uppercase text-center">Tue</div>
                <div class="text-[10px] font-black text-slate-300 uppercase text-center">Wed</div>
                <div class="text-[10px] font-black text-slate-300 uppercase text-center">Thu</div>
                <div class="text-[10px] font-black text-slate-300 uppercase text-center">Fri</div>
                <div class="text-[10px] font-black text-slate-300 uppercase text-center">Sat</div>
            </div>

            <div class="grid grid-cols-7 gap-1" id="calendar-grid">
                <!-- Grid items injected by JS -->
            </div>
        </section>

        <!-- Color Legend -->
        <section class="px-8 flex justify-between items-center mb-10 overflow-x-auto hide-scrollbar space-x-6">
            <div class="flex items-center space-x-2 flex-shrink-0">
                <div class="w-2.5 h-2.5 rounded-full bg-blue-600"></div>
                <span class="text-[10px] font-black text-slate-400 uppercase tracking-widest">Academy</span>
            </div>
            <div class="flex items-center space-x-2 flex-shrink-0">
                <div class="w-2.5 h-2.5 rounded-full bg-emerald-500"></div>
                <span class="text-[10px] font-black text-slate-400 uppercase tracking-widest">Clinic</span>
            </div>
            <div class="flex items-center space-x-2 flex-shrink-0">
                <div class="w-2.5 h-2.5 rounded-full bg-rose-500"></div>
                <span class="text-[10px] font-black text-slate-400 uppercase tracking-widest">Events</span>
            </div>
            <div class="flex items-center space-x-2 flex-shrink-0">
                <div class="w-2.5 h-2.5 rounded-full bg-purple-500"></div>
                <span class="text-[10px] font-black text-slate-400 uppercase tracking-widest">Online</span>
            </div>
            <div class="flex items-center space-x-2 flex-shrink-0">
                <div class="w-2.5 h-2.5 rounded-full bg-orange-500"></div>
                <span class="text-[10px] font-black text-slate-400 uppercase tracking-widest">Orders</span>
            </div>
        </section>

        <div class="px-10 text-center">
            <p class="text-xs text-slate-300 font-medium italic">Tap any date with markers to view your daily agenda.</p>
        </div>

    </main>

    <!-- Daily Agenda Modal (Bottom Sheet) -->
    <div id="modal-overlay" class="fixed inset-0 z-50 modal-overlay hidden flex items-end justify-center" onclick="closeModal()">
        <div id="modal-content" class="bg-white w-full max-w-md rounded-t-[40px] p-8 shadow-2xl modal-sheet translate-y-full" onclick="event.stopPropagation()">
            <div class="w-12 h-1.5 bg-slate-100 rounded-full mx-auto mb-8"></div>
            
            <div class="flex justify-between items-center mb-8">
                <div>
                    <h2 class="text-2xl font-black text-slate-900 tracking-tight" id="modal-date-title">Friday, 24 Oct</h2>
                    <p class="text-sm font-bold text-blue-600" id="modal-subtitle">Your Schedule</p>
                </div>
                <div class="bg-blue-50 text-blue-600 px-4 py-2 rounded-2xl text-xs font-black" id="modal-count">1 Activity</div>
            </div>

            <div id="modal-agenda-list" class="space-y-8 pb-6">
                <!-- Timeline items injected here -->
            </div>

            <button onclick="closeModal()" class="w-full py-5 bg-slate-900 text-white rounded-[24px] font-black shadow-xl active:scale-95 transition-transform mt-4">
                Close Agenda
            </button>
        </div>
    </div>

    <script>
        // --- MOCK DATA ACROSS MONTHS ---
        const activityData = {
            '2025-9-1': [{ time: '05:00 PM', title: 'Beginner Level 1', type: 'academy', provider: 'Blue Wave Academy' }],
            '2025-9-3': [{ time: '04:00 PM', title: 'Physiotherapy Assessment', type: 'clinic', provider: 'AquaHealth Clinic' }],
            '2025-9-6': [{ time: '11:00 AM', title: 'Dryland Technique Analysis', type: 'online', provider: 'Coach Mike (Zoom)' }],
            '2025-9-8': [
                { time: '05:00 PM', title: 'Beginner Level 1', type: 'academy', provider: 'Blue Wave Academy' },
                { time: '02:00 PM', title: 'Goggles Delivered', type: 'order', provider: 'Swim Pro Store' }
            ],
            '2025-9-12': [{ time: '06:00 PM', title: 'Nutrition Webinar', type: 'online', provider: 'Dr. Sarah Wilson' }],
            '2025-9-15': [{ time: '09:00 AM', title: 'Regional Swim Meet', type: 'event', provider: 'Swim Federation' }],
            '2025-9-24': [{ time: '04:00 PM', title: 'Physiotherapy Recovery', type: 'clinic', provider: 'AquaHealth Clinic' }],
            // Next Month (Nov)
            '2025-10-5': [{ time: '05:30 PM', title: 'Intermediate Squad', type: 'academy', provider: 'Elite Academy' }],
            '2025-10-10': [{ time: '04:00 PM', title: 'Virtual Stroke Review', type: 'online', provider: 'Coach Elena' }],
            '2025-10-12': [{ time: '10:00 AM', title: 'Stroke Clinic', type: 'event', provider: 'Coach Michael' }],
            '2025-10-20': [{ time: '03:00 PM', title: 'Order: Fins & Cap', type: 'order', provider: 'Marketplace' }]
        };

        let currentMonth = 9; // October (0-indexed in JS, but 9 here for mock matching)
        let currentYear = 2025;
        const startMonth = 9;
        const startYear = 2025;

        const monthNames = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"];

        function renderCalendar() {
            const grid = document.getElementById('calendar-grid');
            const monthDisplay = document.getElementById('current-month-display');
            const prevBtn = document.getElementById('prev-btn');
            
            grid.innerHTML = '';
            monthDisplay.textContent = `${monthNames[currentMonth].substring(0,3)} ${currentYear}`;

            // Handle navigation restrictions
            if (currentYear === startYear && currentMonth === startMonth) {
                prevBtn.classList.add('text-slate-200', 'cursor-not-allowed');
                prevBtn.disabled = true;
            } else {
                prevBtn.classList.remove('text-slate-200', 'cursor-not-allowed');
                prevBtn.disabled = false;
                prevBtn.classList.add('text-blue-600');
            }

            const firstDay = new Date(currentYear, currentMonth, 1).getDay();
            const daysInMonth = new Date(currentYear, currentMonth + 1, 0).getDate();

            // Padding for start of month
            for (let i = 0; i < firstDay; i++) {
                grid.innerHTML += '<div class="calendar-day empty"></div>';
            }

            // Days
            for (let day = 1; day <= daysInMonth; day++) {
                const dateKey = `${currentYear}-${currentMonth}-${day}`;
                const dayActivities = activityData[dateKey] || [];
                
                let dotsHtml = '';
                if (dayActivities.length > 0) {
                    dotsHtml = '<div class="flex mt-1">';
                    const uniqueTypes = [...new Set(dayActivities.map(a => a.type))];
                    uniqueTypes.forEach(type => {
                        dotsHtml += `<div class="dot dot-${type}"></div>`;
                    });
                    dotsHtml += '</div>';
                }

                grid.innerHTML += `
                    <div class="calendar-day" onclick="openDayAgenda(${day})">
                        ${day}
                        ${dotsHtml}
                    </div>
                `;
            }
        }

        function changeMonth(dir) {
            currentMonth += dir;
            if (currentMonth > 11) {
                currentMonth = 0;
                currentYear++;
            } else if (currentMonth < 0) {
                currentMonth = 11;
                currentYear--;
            }
            renderCalendar();
        }

        function openDayAgenda(day) {
            const dateKey = `${currentYear}-${currentMonth}-${day}`;
            const dayActivities = activityData[dateKey] || [];
            
            const overlay = document.getElementById('modal-overlay');
            const content = document.getElementById('modal-content');
            const title = document.getElementById('modal-date-title');
            const countLabel = document.getElementById('modal-count');
            const list = document.getElementById('modal-agenda-list');

            const fullDate = new Date(currentYear, currentMonth, day);
            const dayName = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"][fullDate.getDay()];
            
            title.textContent = `${dayName}, ${day} ${monthNames[currentMonth].substring(0,3)}`;
            countLabel.textContent = dayActivities.length === 1 ? '1 Activity' : `${dayActivities.length} Activities`;

            if (dayActivities.length === 0) {
                list.innerHTML = `
                    <div class="py-12 text-center">
                        <div class="w-16 h-16 bg-slate-50 rounded-full flex items-center justify-center mx-auto mb-4 text-slate-200">
                             <svg class="w-8 h-8" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M8 7V3m8 4V3m-9 8h10M5 21h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v12a2 2 0 002 2z"></path></svg>
                        </div>
                        <p class="text-slate-400 font-bold">Free Day</p>
                        <p class="text-xs text-slate-300 mt-1">No sessions or deliveries scheduled.</p>
                    </div>
                `;
            } else {
                list.innerHTML = dayActivities.map(act => `
                    <div class="timeline-item">
                        <div class="timeline-marker marker-${act.type}"></div>
                        <div class="flex justify-between items-start">
                            <div class="space-y-0.5">
                                <p class="text-[10px] font-black text-slate-400 uppercase tracking-widest">${act.time}</p>
                                <h3 class="text-lg font-black text-slate-900 leading-tight">${act.title}</h3>
                                <p class="text-xs font-bold text-blue-600 uppercase tracking-tight">${act.provider}</p>
                            </div>
                            <div class="p-2 bg-slate-50 text-slate-300 rounded-xl">
                                <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2.5" d="M9 5l7 7-7 7"></path></svg>
                            </div>
                        </div>
                    </div>
                `).join('');
            }

            overlay.classList.remove('hidden');
            setTimeout(() => {
                content.classList.remove('translate-y-full');
            }, 10);
        }

        function closeModal() {
            const overlay = document.getElementById('modal-overlay');
            const content = document.getElementById('modal-content');
            
            content.classList.add('translate-y-full');
            setTimeout(() => {
                overlay.classList.add('hidden');
            }, 400);
        }

        // --- INIT ---
        window.onload = renderCalendar;
    </script>
</body>
</html>