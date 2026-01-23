<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;700;900&display=swap" rel="stylesheet">
    <title>Swim 360 - My Orders</title>
    <style>
        body { font-family: 'Inter', sans-serif; background-color: #F8FAFC; color: #0F172A; }
        @keyframes fadeIn { from { opacity: 0; transform: translateY(10px); } to { opacity: 1; transform: translateY(0); } }
        .animate-in { animation: fadeIn 0.4s cubic-bezier(0.16, 1, 0.3, 1) forwards; }
        .no-scrollbar::-webkit-scrollbar { display: none; }
        
        .tab-btn { position: relative; transition: all 0.3s ease; }
        .tab-btn.active { color: #2563eb; }
        .tab-btn.active::after {
            content: ''; position: absolute; bottom: 0; left: 50%;
            transform: translateX(-50%); width: 20px; height: 4px;
            background-color: #2563eb; border-radius: 99px;
        }

        .preview-stack img {
            width: 44px; height: 44px; border-radius: 14px;
            object-fit: cover; border: 3px solid white;
            background-color: #F1F5F9; margin-right: -14px;
            box-shadow: 4px 0 10px rgba(0,0,0,0.08);
        }
        
        .shadow-blueprint { box-shadow: 0 20px 25px -5px rgba(0, 0, 0, 0.05), 0 10px 10px -5px rgba(0, 0, 0, 0.02); }
    </style>
</head>
<body class="no-scrollbar">

    <div class="max-w-md mx-auto min-h-screen relative flex flex-col">
        
        <header class="bg-white/90 backdrop-blur-md px-6 pt-12 pb-5 flex items-center justify-between sticky top-0 z-30 border-b border-gray-50 text-left">
            <div class="flex items-center space-x-4">
                <button onclick="window.history.back()" class="p-2.5 rounded-2xl border border-gray-100 bg-white text-gray-900 shadow-sm active:scale-90 transition-all">
                    <svg xmlns="http://www.w3.org/2000/svg" class="w-6 h-6" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2.5"><polyline points="15 18 9 12 15 6"></polyline></svg>
                </button>
                <div>
                    <h1 class="text-2xl font-black text-gray-900 tracking-tight uppercase leading-none italic">Orders</h1>
                    <p class="text-[10px] font-black text-gray-400 uppercase tracking-[0.2em] mt-1.5">Purchase History</p>
                </div>
            </div>
            <div class="w-11 h-11 rounded-2xl bg-blue-50 flex items-center justify-center text-blue-600 border border-blue-100 shadow-inner">
                <svg xmlns="http://www.w3.org/2000/svg" class="w-6 h-6" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2.5"><path d="M6 2 3 6v14a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2V6l-3-4Z"></path><path d="M3 6h18"></path><path d="M16 10a4 4 0 0 1-8 0"></path></svg>
            </div>
        </header>

        <nav class="flex bg-white px-8 border-b border-gray-50 sticky top-[74px] z-20">
            <button id="tab-ongoing" onclick="switchTab('ongoing')" class="tab-btn active py-5 text-[10px] font-black uppercase tracking-[0.2em] text-gray-400 mr-8">Current</button>
            <button id="tab-history" onclick="switchTab('history')" class="tab-btn py-5 text-[10px] font-black uppercase tracking-[0.2em] text-gray-400">Archived</button>
        </nav>

        <main id="orders-container" class="p-6 space-y-5 animate-in text-left">
            </main>

        <div id="modal-overlay" class="fixed inset-0 z-50 flex items-end justify-center bg-slate-900/60 backdrop-blur-sm hidden transition-opacity" onclick="closeModal()">
            <div class="bg-white w-full max-w-md rounded-t-[44px] p-10 shadow-2xl animate-in relative" onclick="event.stopPropagation()">
                <div class="w-12 h-1.5 bg-gray-100 rounded-full mx-auto mb-10 shadow-inner"></div>
                <div id="modal-content" class="space-y-8 text-left">
                    </div>
            </div>
        </div>
    </div>

    <script>
        const myOrders = [
            { id: 'ORD-8821', status: 'SHIPPING', total: 52.49, date: 'Oct 20, 2025', est: 'Oct 24, 2025', ongoing: true,
              items: [{ name: 'Pro Racing Goggles', img: 'https://images.unsplash.com/photo-1552650272-b8a34e21bc4b?w=200', price: 39.99 },
                      { name: 'Silicone Cap', img: 'https://images.unsplash.com/photo-1606107557195-0e29a4b5b4aa?w=200', price: 12.50 }] },
            { id: 'ORD-7742', status: 'PROCESSING', total: 120.00, date: 'Oct 21, 2025', est: 'Oct 28, 2025', ongoing: true,
              items: [{ name: 'Carbon Fins', img: 'https://images.unsplash.com/photo-1620311316023-f38b4f177894?w=200', price: 120.00 }] },
            { id: 'ORD-5510', status: 'DELIVERED', total: 30.00, date: 'Sep 12, 2025', est: 'Completed', ongoing: false,
              items: [{ name: 'Kickboard', img: 'https://images.unsplash.com/photo-1563290615-ef6652494f61?w=200', price: 25.00 }] }
        ];

        let currentTab = 'ongoing';

        function switchTab(tab) {
            currentTab = tab;
            document.querySelectorAll('.tab-btn').forEach(b => b.classList.remove('active'));
            document.getElementById(`tab-${tab}`).classList.add('active');
            renderOrders();
        }

        function renderOrders() {
            const container = document.getElementById('orders-container');
            const filtered = myOrders.filter(o => o.ongoing === (currentTab === 'ongoing'));

            if (!filtered.length) {
                container.innerHTML = `<div class="py-20 text-center"><p class="text-[10px] font-black text-gray-300 uppercase tracking-widest italic">No orders found</p></div>`;
                return;
            }

            container.innerHTML = filtered.map(o => `
                <div class="bg-white p-6 rounded-[32px] border border-gray-100 shadow-blueprint cursor-pointer active:scale-[0.98] transition-all" onclick="openDetails('${o.id}')">
                    <div class="flex justify-between items-start mb-6">
                        <div>
                            <p class="text-[9px] font-black text-gray-400 uppercase tracking-widest mb-1">${o.date}</p>
                            <h3 class="text-xl font-black text-gray-900 tracking-tighter">${o.id}</h3>
                        </div>
                        <span class="px-3 py-1.5 rounded-xl text-[8px] font-black uppercase tracking-widest ${o.status === 'DELIVERED' ? 'bg-emerald-50 text-emerald-600 border border-emerald-100' : 'bg-blue-50 text-blue-600 border border-blue-100'}">
                            ${o.status}
                        </span>
                    </div>

                    <div class="flex items-center justify-between">
                        <div class="flex items-center">
                            <div class="preview-stack flex mr-8">
                                ${o.items.slice(0, 3).map(i => `<img src="${i.img}">`).join('')}
                            </div>
                            <div>
                                <p class="text-sm font-black text-gray-900 italic uppercase tracking-tighter">${o.items[0].name}</p>
                                <p class="text-[9px] font-bold text-gray-400 uppercase tracking-widest mt-1">${o.items.length > 1 ? `+${o.items.length - 1} More Items` : 'Essential Gear'}</p>
                            </div>
                        </div>
                        <p class="text-xl font-black text-blue-600 tracking-tighter leading-none">$${o.total.toFixed(2)}</p>
                    </div>

                    <div class="mt-6 pt-5 border-t border-gray-50 flex items-center justify-between">
                        <div class="flex items-center text-[9px] font-black text-gray-400 uppercase tracking-widest">
                            <svg class="w-3.5 h-3.5 mr-2 text-blue-600" fill="none" stroke="currentColor" viewBox="0 0 24 24" stroke-width="2.5"><rect x="3" y="4" width="18" height="18" rx="2" ry="2"></rect><line x1="16" y1="2" x2="16" y2="6"></line><line x1="8" y1="2" x2="8" y2="6"></line><line x1="3" y1="10" x2="21" y2="10"></line></svg>
                            ${o.est}
                        </div>
                        <svg class="w-5 h-5 text-gray-200" fill="none" stroke="currentColor" viewBox="0 0 24 24" stroke-width="3"><polyline points="9 18 15 12 9 6"></polyline></svg>
                    </div>
                </div>
            `).join('');
        }

        function openDetails(id) {
            const o = myOrders.find(ord => ord.id === id);
            const content = document.getElementById('modal-content');
            
            content.innerHTML = `
                <div class="flex justify-between items-end">
                    <div>
                        <span class="px-3 py-1 bg-blue-50 text-blue-600 rounded-lg text-[9px] font-black uppercase tracking-widest border border-blue-100">${o.status}</span>
                        <h2 class="text-3xl font-black text-gray-900 tracking-tighter uppercase italic mt-3">${o.id}</h2>
                        <p class="text-[10px] font-bold text-gray-400 uppercase tracking-widest mt-1">Confirmed on ${o.date}</p>
                    </div>
                    <div class="text-right">
                        <p class="text-[9px] font-black text-gray-300 uppercase tracking-widest">Grand Total</p>
                        <p class="text-3xl font-black text-blue-600 tracking-tighter leading-none mt-1">$${o.total.toFixed(2)}</p>
                    </div>
                </div>

                <div class="space-y-4">
                    <h4 class="text-[10px] font-black text-gray-400 uppercase tracking-[0.2em] border-b border-gray-50 pb-2">Parcel Contents</h4>
                    <div class="space-y-2">
                        ${o.items.map(item => `
                            <div class="flex items-center justify-between p-4 bg-gray-50 rounded-2xl border border-gray-100 shadow-inner">
                                <div class="flex items-center space-x-4">
                                    <img src="${item.img}" class="w-12 h-12 rounded-xl object-cover border-2 border-white shadow-sm">
                                    <span class="text-sm font-black text-gray-800 uppercase italic tracking-tighter">${item.name}</span>
                                </div>
                                <span class="text-sm font-black text-gray-500 tracking-tighter">$${item.price.toFixed(2)}</span>
                            </div>
                        `).join('')}
                    </div>
                </div>

                <div class="pt-4 flex flex-col space-y-3">
                    <button class="w-full py-5 bg-blue-600 text-white rounded-[24px] font-black text-xs uppercase tracking-widest shadow-xl shadow-blue-100 active:scale-95 transition-all">
                        ${o.ongoing ? 'Track Shipment' : 'Buy Again'}
                    </button>
                    <button onclick="closeModal()" class="w-full py-2 text-[10px] font-black text-gray-400 uppercase tracking-widest">Back to List</button>
                </div>
            `;
            document.getElementById('modal-overlay').classList.remove('hidden');
        }

        function closeModal() { document.getElementById('modal-overlay').classList.add('hidden'); }
        window.onload = renderOrders;
    </script>
</body>
</html>