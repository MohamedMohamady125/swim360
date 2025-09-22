<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Swim 360 Settings</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <style>
        @import url('https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap');
        body {
            font-family: 'Inter', sans-serif;
            background-color: #3b82f6; /* Blue background */
        }
        .container-card {
            background-color: white;
            border-radius: 2rem;
            box-shadow: 0 4px 10px rgba(0, 0, 0, 0.1);
        }
        .setting-item {
            display: flex;
            align-items: center;
            justify-content: space-between;
            padding: 1.25rem;
            border-bottom: 1px solid #e5e7eb;
        }
        .setting-item:last-child {
            border-bottom: none;
        }
        .toggle-switch {
            position: relative;
            display: inline-block;
            width: 50px;
            height: 28px;
        }
        .toggle-switch input {
            opacity: 0;
            width: 0;
            height: 0;
        }
        .slider {
            position: absolute;
            cursor: pointer;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background-color: #ccc;
            transition: .4s;
            border-radius: 34px;
        }
        .slider:before {
            position: absolute;
            content: "";
            height: 20px;
            width: 20px;
            left: 4px;
            bottom: 4px;
            background-color: white;
            transition: .4s;
            border-radius: 50%;
        }
        input:checked + .slider {
            background-color: #3b82f6;
        }
        input:checked + .slider:before {
            transform: translateX(22px);
        }
        .btn {
            background-color: #3b82f6;
            color: white;
            padding: 0.75rem 1.5rem;
            border-radius: 9999px;
            font-weight: 600;
        }
        .btn:hover {
            background-color: #2563eb;
        }
        .modal {
            transition: all 0.3s ease-in-out;
            transform: scale(0.95);
            opacity: 0;
            pointer-events: none;
        }
        .modal.show {
            transform: scale(1);
            opacity: 1;
            pointer-events: auto;
        }
    </style>
</head>
<body class="flex items-center justify-center min-h-screen p-4">

    <!-- Settings Card -->
    <div class="container-card w-full max-w-sm p-6 space-y-4">
        <h1 id="settings-title" class="text-2xl font-bold text-center text-gray-800 mb-4">Settings</h1>

        <!-- Language Section -->
        <div class="setting-item">
            <label for="language-select" id="language-label" class="text-lg text-gray-700">Language</label>
            <select id="language-select" class="form-select border border-gray-300 rounded-lg p-2">
                <option value="en" selected>English</option>
                <option value="ar">العربية</option>
            </select>
        </div>

        <!-- Notifications Section -->
        <div class="setting-item">
            <span id="notifications-label" class="text-lg text-gray-700">Notifications</span>
            <label class="toggle-switch">
                <input type="checkbox" id="notifications-toggle" checked>
                <span class="slider"></span>
            </label>
        </div>

        <!-- Help & FAQ Section -->
        <div class="setting-item">
            <span id="help-label" class="text-lg text-gray-700">Help & FAQ</span>
            <button id="help-faq-btn" class="text-blue-500 font-semibold hover:underline">View</button>
        </div>

    </div>

    <!-- Help/FAQ Modal -->
    <div id="help-modal" class="modal fixed inset-0 flex items-center justify-center bg-black bg-opacity-50">
        <div class="bg-white rounded-lg p-8 m-4 w-full max-w-md text-gray-800">
            <h2 id="modal-title" class="text-xl font-bold mb-4">Help & FAQ</h2>
            <div id="modal-content" class="space-y-4 text-sm text-gray-600">
                <div>
                    <h3 class="font-semibold text-gray-700">How do I change my language?</h3>
                    <p>Select your preferred language from the dropdown menu on the settings screen.</p>
                </div>
                <div>
                    <h3 class="font-semibold text-gray-700">How do I manage notifications?</h3>
                    <p>You can enable or disable notifications by toggling the switch on the settings screen.</p>
                </div>
                <div>
                    <h3 class="font-semibold text-gray-700">What is Swim 360?</h3>
                    <p>Swim 360 is a community platform for swimmers, coaches, and enthusiasts.</p>
                </div>
            </div>
            <button id="close-modal-btn" class="btn mt-6 w-full text-center">Close</button>
        </div>
    </div>

    <script>
        const notificationsToggle = document.getElementById('notifications-toggle');
        const helpFaqBtn = document.getElementById('help-faq-btn');
        const helpModal = document.getElementById('help-modal');
        const closeModalBtn = document.getElementById('close-modal-btn');
        const languageSelect = document.getElementById('language-select');
        const container = document.querySelector('.container-card');

        const translations = {
            en: {
                title: "Settings",
                languageLabel: "Language",
                notificationsLabel: "Notifications",
                helpLabel: "Help & FAQ",
                viewBtn: "View",
                modalTitle: "Help & FAQ",
                faq1Q: "How do I change my language?",
                faq1A: "Select your preferred language from the dropdown menu on the settings screen.",
                faq2Q: "How do I manage notifications?",
                faq2A: "You can enable or disable notifications by toggling the switch on the settings screen.",
                faq3Q: "What is Swim 360?",
                faq3A: "Swim 360 is a community platform for swimmers, coaches, and enthusiasts.",
                closeBtn: "Close"
            },
            ar: {
                title: "الإعدادات",
                languageLabel: "اللغة",
                notificationsLabel: "الإشعارات",
                helpLabel: "المساعدة والأسئلة الشائعة",
                viewBtn: "عرض",
                modalTitle: "المساعدة والأسئلة الشائعة",
                faq1Q: "كيف يمكنني تغيير اللغة؟",
                faq1A: "اختر لغتك المفضلة من القائمة المنسدلة في شاشة الإعدادات.",
                faq2Q: "كيف أدير الإشعارات؟",
                faq2A: "يمكنك تفعيل أو تعطيل الإشعارات من خلال تبديل المفتاح في شاشة الإعدادات.",
                faq3Q: "ما هو 'Swim 360'؟",
                faq3A: "Swim 360 هي منصة مجتمعية للسباحين والمدربين والمتحمسين.",
                closeBtn: "إغلاق"
            }
        };

        function updateContent(lang) {
            const t = translations[lang];
            const isRTL = lang === 'ar';
            document.documentElement.lang = lang;
            document.body.style.direction = isRTL ? 'rtl' : 'ltr';
            
            document.getElementById('settings-title').textContent = t.title;
            document.getElementById('language-label').textContent = t.languageLabel;
            document.getElementById('notifications-label').textContent = t.notificationsLabel;
            document.getElementById('help-label').textContent = t.helpLabel;
            document.getElementById('help-faq-btn').textContent = t.viewBtn;
            document.getElementById('modal-title').textContent = t.modalTitle;
            document.getElementById('close-modal-btn').textContent = t.closeBtn;
            
            const modalContent = document.getElementById('modal-content');
            modalContent.innerHTML = `
                <div>
                    <h3 class="font-semibold text-gray-700">${t.faq1Q}</h3>
                    <p>${t.faq1A}</p>
                </div>
                <div>
                    <h3 class="font-semibold text-gray-700">${t.faq2Q}</h3>
                    <p>${t.faq2A}</p>
                </div>
                <div>
                    <h3 class="font-semibold text-gray-700">${t.faq3Q}</h3>
                    <p>${t.faq3A}</p>
                </div>
            `;
        }

        // Modal functions
        function showModal() {
            helpModal.classList.add('show');
        }

        function hideModal() {
            helpModal.classList.remove('show');
        }

        // Event Listeners
        languageSelect.addEventListener('change', (e) => {
            updateContent(e.target.value);
        });

        helpFaqBtn.addEventListener('click', showModal);
        closeModalBtn.addEventListener('click', hideModal);

        // Hide modal if user clicks outside of it
        helpModal.addEventListener('click', (event) => {
            if (event.target === helpModal) {
                hideModal();
            }
        });

        // Initial setup
        document.addEventListener('DOMContentLoaded', () => {
            updateContent('en');
        });
    </script>
</body>
</html>
