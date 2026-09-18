<!DOCTYPE html>
<html lang="it">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no">
    <title>DM Dashboard - Scena e Combattimento</title>
    <style>
        :root {
            --bg-color: #121212;
            --surface-color: #1e1e1e;
            --primary-color: #bb86fc;
            --secondary-color: #03dac6;
            --danger-color: #cf6679;
            --text-color: #e0e0e0;
            --text-muted: #a0a0a0;
            --border-radius: 12px;
            --pc-color: #4a90e2;
            --npc-color: #e24a4a;
        }

        body {
            font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Helvetica, Arial, sans-serif;
            background-color: var(--bg-color);
            color: var(--text-color);
            margin: 0;
            padding: 0;
            padding-bottom: 90px;
        }

        header { background-color: var(--surface-color); padding: 15px; text-align: center; border-bottom: 1px solid #333; }
        header h1 { margin: 0; font-size: 20px; color: var(--primary-color); }

        .section { display: none; padding: 15px; animation: fadeIn 0.2s; }
        .section.active { display: block; }
        @keyframes fadeIn { from { opacity: 0; transform: translateY(10px); } to { opacity: 1; transform: translateY(0); } }

        .card { background-color: var(--surface-color); border-radius: var(--border-radius); padding: 15px; margin-bottom: 15px; box-shadow: 0 2px 4px rgba(0,0,0,0.2); }
        
        /* SCHERMO TIRI SCENA */
        .display-screen { text-align: center; padding: 15px; background: #000; border: 2px solid #333; border-radius: 8px; margin-bottom: 15px; }
        .display-screen span { display: block; font-size: 12px; color: var(--text-muted); }
        .display-screen h2 { margin: 5px 0 0 0; font-size: 38px; color: var(--text-color); }
        .display-screen .crit-text { font-size: 14px; color: #ffd700; display: block; margin-top: 5px; min-height: 20px; font-weight: bold; }

        /* INIZIATIVA & SCENA */
        .form-group { display: flex; gap: 10px; margin-bottom: 10px; }
        .form-group input, .form-group select { flex: 1; background: #2c2c2c; border: 1px solid #444; color: white; padding: 10px; border-radius: 6px; box-sizing: border-box; }
        .btn-full { width: 100%; background-color: var(--primary-color); color: #000; font-weight: bold; border: none; padding: 12px; border-radius: 6px; cursor: pointer; }
        
        .init-list { list-style: none; padding: 0; margin: 0; }
        .init-item { display: flex; justify-content: space-between; align-items: center; background: #2c2c2c; padding: 12px; margin-bottom: 8px; border-radius: 8px; border-left: 4px solid #444; }
        .init-item.pc { border-left-color: var(--pc-color); }
        .init-item.npc { border-left-color: var(--npc-color); }
        
        /* Stato "Morto / A Terra" */
        .init-item.dead { opacity: 0.4; filter: grayscale(100%); }
        .init-item.dead .init-score { color: #666; background: #111; }

        .init-score { font-size: 20px; font-weight: bold; color: var(--secondary-color); background: #1e1e1e; padding: 5px 10px; border-radius: 6px; }
        .btn-remove { background: none; border: none; color: var(--danger-color); font-size: 18px; cursor: pointer; padding: 0 10px; }

        .hp-btn-small { background: #444; color: white; border: none; border-radius: 4px; width: 28px; height: 28px; font-weight: bold; cursor: pointer; display: flex; align-items: center; justify-content: center; }
        .hp-btn-small.dmg { background: var(--danger-color); color: #000; }
        .hp-btn-small.heal { background: var(--secondary-color); color: #000; }

        /* PULSANTI ATTACCO MOSTRI */
        .atk-btn { background-color: #3a1c1c; border: 1px solid var(--danger-color); color: #e0e0e0; padding: 5px 8px; border-radius: 4px; font-size: 12px; cursor: pointer; font-weight: bold; display: flex; align-items: center; gap: 4px; transition: 0.1s; }
        .atk-btn:active { background-color: var(--danger-color); color: #000; transform: scale(0.95); }

        /* BESTIARIO */
        details { background-color: #2c2c2c; border-radius: 8px; margin-bottom: 10px; padding: 0; }
        summary { padding: 12px; font-weight: bold; cursor: pointer; display: flex; justify-content: space-between; align-items: center; }
        summary::-webkit-details-marker { display: none; }
        .monster-cr { font-size: 11px; color: var(--danger-color); background: #1e1e1e; padding: 2px 6px; border-radius: 4px; }
        .details-content { padding: 12px; border-top: 1px dashed #444; font-size: 13px; color: #ccc; }
        .monster-statblock strong { color: var(--text-color); }
        .monster-actions { margin-top: 8px; padding-top: 8px; border-top: 1px solid #333; }
        .monster-actions .atk { color: var(--danger-color); font-weight: bold; }

        /* DADI & NOTE */
        .dice-grid { display: grid; grid-template-columns: repeat(3, 1fr); gap: 10px; margin-bottom: 20px; }
        .dice-btn { background-color: #2c2c2c; color: var(--text-color); border: 2px solid #333; border-radius: 8px; padding: 15px 0; font-size: 18px; font-weight: bold; cursor: pointer; }
        .dice-btn:active { background-color: var(--primary-color); color: #fff; transform: scale(0.95); }
        #dice-log { list-style: none; padding: 0; margin: 0; font-size: 14px; color: var(--text-muted); }
        #dice-log li { padding: 8px 0; border-bottom: 1px dashed #333; }
        .reset-btn { background-color: transparent; border: 1px solid var(--danger-color); padding: 10px; border-radius: 8px; width: 100%; cursor: pointer; margin-top: 15px; font-weight: bold; color: var(--danger-color); }

        /* NAVIGAZIONE */
        nav { position: fixed; bottom: 0; width: 100%; background-color: var(--surface-color); display: flex; padding: 8px 0; border-top: 1px solid #333; z-index: 1000; }
        nav button { background: none; border: none; color: var(--text-muted); font-size: 10px; font-weight: 600; display: flex; flex-direction: column; align-items: center; padding: 5px 2px; cursor: pointer; flex: 1; }
        nav button.active { color: var(--primary-color); background-color: rgba(187, 134, 252, 0.1); border-radius: 8px; }
        nav button i { font-size: 20px; margin-bottom: 4px; font-style: normal; }
    </style>
</head>
<body>

    <header>
        <h1>DM Combat Dashboard</h1>
    </header>

    <!-- 1. SCENA & INIZIATIVA -->
    <div id="sec-iniziativa" class="section active">
        
        <div class="display-screen">
            <span id="scene-dice-label">Schermo Tiri Combattimento DM</span>
            <h2 id="scene-dice-result">--</h2>
            <div class="crit-text" id="scene-dice-crit"></div>
        </div>

        <div class="card">
            <h3 style="margin-top:0; color:var(--primary-color);">Aggiungi Manualmente</h3>
            <div class="form-group">
                <input type="text" id="add-name" placeholder="Nome (es. Eroe)">
                <input type="number" id="add-init" placeholder="Iniziativa" style="flex: 0.5;">
            </div>
            <div class="form-group">
                <input type="number" id="add-hp" placeholder="Max HP">
                <select id="add-type">
                    <option value="pc">Giocatore (PC)</option>
                    <option value="npc">Mostro Generico (NPC)</option>
                </select>
            </div>
            <div style="display: flex; gap: 10px;">
                <button class="btn-full" onclick="addCombatant()">➕ Aggiungi in Ordine</button>
            </div>
        </div>

        <!-- RIAGGIUNTA LA CARD PER LA SCENA -->
        <div class="card">
            <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 15px;">
                <h3 style="margin:0;">Scena Attuale</h3>
                <button onclick="clearCombat()" style="background:none; border:1px solid var(--danger-color); color:var(--danger-color); padding:5px 10px; border-radius:4px; cursor:pointer;">Svuota Scena</button>
            </div>
            
            <ul class="init-list" id="initiative-list">
                <!-- Generato da JS -->
            </ul>
        </div>
    </div>

    <!-- 2. BESTIARIO -->
    <div id="sec-bestiario" class="section">
        <div class="card">
            <h3 style="margin-top:0;">Mini Bestiario Rapido</h3>
            <p style="font-size:12px; color:var(--text-muted);">Aggiungendo i mostri da qui, il sistema calcola la loro Iniziativa in automatico e sblocca i pulsanti per i loro attacchi nella Scena.</p>
            
            <details>
                <summary>👺 Goblin <span class="monster-cr">CR 1/4</span></summary>
                <div class="details-content monster-statblock">
                    <strong>CA:</strong> 15 (Arm. Cuoio, Scudo) | <strong>HP:</strong> 7 (2d6) | <strong>Vel:</strong> 9m<br>
                    <strong>TS:</strong> For -1, Des +2, Cos +0, Int +0, Sag -1, Car -1<br>
                    <div class="monster-actions">
                        <span class="atk">Scimitarra:</span> +4 a colpire, 1d6+2 Tagliente<br>
                        <span class="atk">Arco Corto:</span> +4 a colpire, 1d6+2 Perforante (24/96m)<br><br>
                        <em>Fuga Agile:</em> Disimpegno o Nascondersi come Azione Bonus.
                    </div>
                    <button class="btn-full" style="margin-top:10px; padding:8px; font-size:14px;" onclick="addFromBestiary('goblin')">➕ Aggiungi alla Scena</button>
                </div>
            </details>

            <details>
                <summary>🐺 Lupo (Wolf) <span class="monster-cr">CR 1/4</span></summary>
                <div class="details-content monster-statblock">
                    <strong>CA:</strong> 13 (Naturale) | <strong>HP:</strong> 11 (2d8+2) | <strong>Vel:</strong> 12m<br>
                    <strong>Abilità:</strong> Percezione +3, Furtività +4<br>
                    <em>Pack Tactics:</em> Vantaggio al TxC se un alleato è entro 1.5m dal bersaglio.<br>
                    <div class="monster-actions">
                        <span class="atk">Morso:</span> +4 a colpire, 2d4+2 Perforante. TS Forza CD 11 o cade a terra prono.
                    </div>
                    <button class="btn-full" style="margin-top:10px; padding:8px; font-size:14px;" onclick="addFromBestiary('wolf')">➕ Aggiungi alla Scena</button>
                </div>
            </details>

            <details>
                <summary>🧟 Zombie <span class="monster-cr">CR 1/4</span></summary>
                <div class="details-content monster-statblock">
                    <strong>CA:</strong> 8 | <strong>HP:</strong> 22 (3d8+9) | <strong>Vel:</strong> 6m<br>
                    <strong>Immunità:</strong> Veleno, Condizione Avvelenato<br>
                    <em>Undead Fortitude:</em> Se scende a 0 HP, TS Cos (CD 5 + danno). Se successo, scende a 1 HP.<br>
                    <div class="monster-actions">
                        <span class="atk">Schianto:</span> +3 a colpire, 1d6+1 Contundente.
                    </div>
                    <button class="btn-full" style="margin-top:10px; padding:8px; font-size:14px;" onclick="addFromBestiary('zombie')">➕ Aggiungi alla Scena</button>
                </div>
            </details>

            <details>
                <summary>🗡️ Bandito <span class="monster-cr">CR 1/8</span></summary>
                <div class="details-content monster-statblock">
                    <strong>CA:</strong> 12 (Arm. Cuoio) | <strong>HP:</strong> 11 (2d8+2) | <strong>Vel:</strong> 9m<br>
                    <div class="monster-actions">
                        <span class="atk">Scimitarra:</span> +3 a colpire, 1d6+1 Tagliente<br>
                        <span class="atk">Balestra Leggera:</span> +3 a colpire, 1d8+1 Perforante (24/96m)
                    </div>
                    <button class="btn-full" style="margin-top:10px; padding:8px; font-size:14px;" onclick="addFromBestiary('bandit')">➕ Aggiungi alla Scena</button>
                </div>
            </details>
        </div>
    </div>

    <!-- 3. DADI LIBERI -->
    <div id="sec-dadi" class="section">
        <div class="card">
            <h3 style="margin-top: 0;">Lancio Libero</h3>
            <div class="dice-grid">
                <button class="dice-btn" onclick="rollSimpleDice(4)">d4</button>
                <button class="dice-btn" onclick="rollSimpleDice(6)">d6</button>
                <button class="dice-btn" onclick="rollSimpleDice(8)">d8</button>
                <button class="dice-btn" onclick="rollSimpleDice(10)">d10</button>
                <button class="dice-btn" onclick="rollSimpleDice(12)">d12</button>
                <button class="dice-btn" onclick="rollSimpleDice(20)">d20</button>
            </div>
        </div>
        <div class="card">
            <h3>Cronologia Dadi DM</h3>
            <ul id="dice-log"><li>Nessun lancio effettuato.</li></ul>
        </div>
    </div>

    <!-- 4. NOTE -->
    <div id="sec-note" class="section">
        <div class="card">
            <h3 style="margin-top: 0;">Appunti Campagna / Segreti</h3>
            <textarea id="session-notes" oninput="saveDMData()" style="width: 100%; height: 400px; background: #2c2c2c; color: white; border: 1px solid #444; padding: 12px; border-radius: 8px; box-sizing: border-box; font-family: inherit; font-size: 14px; resize: vertical;" placeholder="Scrivi qui i segreti, le trappole o i loot dell'incontro..."></textarea>
            
            <button class="reset-btn" onclick="resetDMData()">🗑️ Resetta Dati Salvati (Incontri e Note)</button>
        </div>
    </div>

    <!-- NAVIGAZIONE -->
    <nav>
        <button onclick="switchTab('sec-iniziativa')" id="btn-sec-iniziativa" class="active"><i>⚔️</i>Scena</button>
        <button onclick="switchTab('sec-bestiario')" id="btn-sec-bestiario"><i>👹</i>Bestiario</button>
        <button onclick="switchTab('sec-dadi')" id="btn-sec-dadi"><i>🎲</i>Dadi</button>
        <button onclick="switchTab('sec-note')" id="btn-sec-note"><i>📝</i>Note</button>
    </nav>

    <<script>
    // ==========================================
    // DATABASE MOSTRI (BESTIARIO)
    // ==========================================
    const bestiaryDB = {
        'goblin': { 
            name: 'Goblin', hp: 7, initMod: 2, type: 'npc', 
            attacks: [{name: 'Scimitarra', atk: 4, dmg: '1d6+2'}, {name: 'Arco Corto', atk: 4, dmg: '1d6+2'}] 
        },
        'wolf': { 
            name: 'Lupo', hp: 11, initMod: 2, type: 'npc', 
            attacks: [{name: 'Morso', atk: 4, dmg: '2d4+2'}] 
        },
        'zombie': { 
            name: 'Zombie', hp: 22, initMod: -1, type: 'npc', 
            attacks: [{name: 'Schianto', atk: 3, dmg: '1d6+1'}] 
        },
        'bandit': { 
            name: 'Bandito', hp: 11, initMod: 1, type: 'npc', 
            attacks: [{name: 'Scimitarra', atk: 3, dmg: '1d6+1'}, {name: 'Balestra', atk: 3, dmg: '1d8+1'}] 
        }
    };

    // ==========================================
    // DATABASE DM (LOCAL STORAGE)
    // ==========================================
    const dmStorageKey = 'dm_dashboard_save_v6';
    let dmData = {
        combatants: [],
        notes: ""
    };

    function loadDMData() {
        try {
            const saved = localStorage.getItem(dmStorageKey);
            if (saved) {
                const parsed = JSON.parse(saved);
                if (parsed.combatants) dmData.combatants = parsed.combatants;
                if (parsed.notes) {
                    dmData.notes = parsed.notes;
                    const notesArea = document.getElementById('session-notes');
                    if (notesArea) notesArea.value = dmData.notes;
                }
            }
        } catch (e) {
            console.warn("Lettura da LocalStorage bloccata:", e);
        }
    }

    function saveDMData() {
        const notesArea = document.getElementById('session-notes');
        if (notesArea) dmData.notes = notesArea.value;
        try {
            localStorage.setItem(dmStorageKey, JSON.stringify(dmData));
        } catch (e) {
            console.warn("Salvataggio in LocalStorage bloccato (tipico da file:///):", e);
        }
    }

    function resetDMData() {
        if (confirm("Vuoi davvero cancellare tutti i combattenti nella scena e le note?")) {
            try {
                localStorage.removeItem(dmStorageKey);
            } catch (e) {}
            location.reload();
        }
    }

    function switchTab(tabId) {
        document.querySelectorAll('.section').forEach(sec => sec.classList.remove('active'));
        document.querySelectorAll('nav button').forEach(btn => btn.classList.remove('active'));
        document.getElementById(tabId).classList.add('active');
        document.getElementById('btn-' + tabId).classList.add('active');
    }

    // ==========================================
    // LOGICA COMBATTIMENTO E SCENA
    // ==========================================
    function addCombatant() {
        const nameInput = document.getElementById('add-name');
        const initInput = document.getElementById('add-init');
        const hpInput = document.getElementById('add-hp');
        const typeInput = document.getElementById('add-type');

        const name = nameInput.value.trim();
        const initVal = initInput.value;
        const maxHp = parseInt(hpInput.value) || 0;
        const type = typeInput.value;

        if (!name) { 
            alert("Inserisci un nome!"); 
            return; 
        }

        const init = initVal === '' ? 0 : Number(initVal);
        const combatantId = Date.now() + Math.floor(Math.random() * 1000);

        const combatant = {
            id: combatantId,
            name: name,
            init: init,
            hp: maxHp,
            maxHp: maxHp,
            type: type,
            attacks: [] 
        };

        insertCombatantAndSort(combatant);
        
        nameInput.value = '';
        initInput.value = '';
        if (type === 'pc') {
            hpInput.value = '';
        }
    }

    function addFromBestiary(monsterKey) {
        const template = bestiaryDB[monsterKey];
        if (!template) return;
        
        const existingCount = dmData.combatants.filter(c => c.name.startsWith(template.name)).length;
        const finalName = existingCount > 0 ? `${template.name} ${existingCount + 1}` : template.name;
        
        const d20 = Math.floor(Math.random() * 20) + 1;
        const initScore = d20 + template.initMod;
        const combatantId = Date.now() + Math.floor(Math.random() * 1000);

        const combatant = {
            id: combatantId,
            name: finalName,
            init: initScore,
            hp: template.hp,
            maxHp: template.hp,
            type: template.type,
            attacks: template.attacks
        };
        
        insertCombatantAndSort(combatant);
        
        document.getElementById('scene-dice-label').innerText = `Aggiunto: ${finalName}`;
        document.getElementById('scene-dice-result').innerText = initScore;
        document.getElementById('scene-dice-crit').innerHTML = `Iniziativa rollata in automatico (+${template.initMod})`;
        document.getElementById('scene-dice-crit').style.color = "var(--text-muted)";
        
        switchTab('sec-iniziativa');
    }

    function insertCombatantAndSort(combatant) {
        dmData.combatants.push(combatant);
        dmData.combatants.sort((a, b) => b.init - a.init);
        saveDMData();
        renderCombat();
    }

    function removeCombatant(id) {
        dmData.combatants = dmData.combatants.filter(c => c.id !== id);
        saveDMData();
        renderCombat();
    }

    function clearCombat() {
        if (confirm("Rimuovere tutti i combattenti dalla scena?")) {
            dmData.combatants = [];
            saveDMData();
            renderCombat();
        }
    }

    function modifyHP(id, amount) {
        const c = dmData.combatants.find(x => x.id === id);
        if (c) {
            c.hp += amount;
            if (c.maxHp > 0 && c.hp > c.maxHp) c.hp = c.maxHp;
            if (c.hp < 0) c.hp = 0;
            saveDMData();
            renderCombat();
        }
    }

    function renderCombat() {
        const initList = document.getElementById('initiative-list');
        initList.innerHTML = '';

        if (dmData.combatants.length === 0) {
            initList.innerHTML = `<li style="text-align:center; color:var(--text-muted); font-size:14px; padding:10px;">La scena è vuota. Aggiungi giocatori o mostri.</li>`;
            return;
        }

        dmData.combatants.forEach((c) => {
            const typeClass = c.type === 'pc' ? 'pc' : 'npc';
            const isDead = (c.maxHp > 0 && c.hp <= 0) ? 'dead' : ''; 
            
            let attacksHtml = '';
            if (c.type === 'npc' && c.attacks && c.attacks.length > 0) {
                attacksHtml = `<div style="margin-top: 8px; display:flex; gap:6px; flex-wrap:wrap;">`;
                
                const safeName = c.name.replace(/'/g, "\\'"); // Protegge dai nomi con apostrofo
                
                c.attacks.forEach(atk => {
                    const safeAtkName = atk.name.replace(/'/g, "\\'");
                    attacksHtml += `<button class="atk-btn" onclick="rollMonsterAttack('${safeName}', '${safeAtkName}', ${atk.atk}, '${atk.dmg}')">🗡️ ${atk.name} (+${atk.atk})</button>`;
                });
                attacksHtml += `</div>`;
            }

            let hpSectionHtml = '';
            if (c.maxHp > 0 || c.type === 'npc') {
                hpSectionHtml = `
                    <button class="hp-btn-small dmg" onclick="modifyHP(${c.id}, -1)">-</button>
                    <span style="font-size:18px; font-weight:bold; min-width:25px; text-align:center;">${c.hp}</span>
                    <button class="hp-btn-small heal" onclick="modifyHP(${c.id}, 1)">+</button>
                    <span style="font-size:12px; color:var(--text-muted);">/ ${c.maxHp > 0 ? c.maxHp : '??'} HP</span>
                `;
            } else {
                hpSectionHtml = `<span style="font-size:12px; color:var(--text-muted); font-style:italic;">HP gestiti dal Giocatore</span>`;
            }

            const li = document.createElement('li');
            li.className = `init-item ${typeClass} ${isDead}`;
            li.innerHTML = `
                <div style="flex:1;">
                    <div style="font-weight:bold; font-size:16px; margin-bottom: 6px;">${c.name}</div>
                    <div style="display:flex; align-items:center; gap:8px;">
                        ${hpSectionHtml}
                    </div>
                    ${attacksHtml}
                </div>
                <div style="display:flex; flex-direction:column; align-items:flex-end; gap:10px;">
                    <span class="init-score">${c.init}</span>
                    <button class="btn-remove" onclick="removeCombatant(${c.id})">✖</button>
                </div>
            `;
            initList.appendChild(li);
        });
    }

    // ==========================================
    // LOGICA TIRI E DADI
    // ==========================================
    let rollHistory = [];

    function logDiceDM(title, total, subtext, color="var(--danger-color)") {
        const time = new Date().toLocaleTimeString('it-IT', { hour: '2-digit', minute: '2-digit' });
        let logMsg = `<strong style="color: ${color}">${title}</strong><br>Risultato: <b style="font-size:18px;">${total}</b> <span style="font-size:11px; color:#777;">(${subtext})</span><div style="color:#777; font-size:11px; margin-top:3px; text-align:right;">${time}</div>`;
        rollHistory.unshift(logMsg);
        if (rollHistory.length > 10) rollHistory.pop();
        document.getElementById('dice-log').innerHTML = rollHistory.map(log => `<li>${log}</li>`).join('');
    }

    function rollMonsterAttack(mName, aName, mod, dmg) {
        const d20 = Math.floor(Math.random() * 20) + 1;
        const total = d20 + mod;
        let critClass = "";
        let subtext = `d20: ${d20} + ${mod} | Danni Medi: ${dmg}`;
        
        if (d20 === 20) { critClass = "crit-text"; subtext = `CRITICO! (Danni raddoppiati!)`; document.getElementById('scene-dice-crit').style.color = "#ffd700"; }
        else if (d20 === 1) { critClass = "crit-text"; subtext = "FALLIMENTO CRITICO!"; document.getElementById('scene-dice-crit').style.color = "var(--danger-color)"; }
        else { document.getElementById('scene-dice-crit').style.color = "#ffd700"; }

        document.getElementById('scene-dice-label').innerText = `TxC: ${mName} usa ${aName}`;
        document.getElementById('scene-dice-result').innerText = total;
        document.getElementById('scene-dice-crit').innerHTML = critClass ? `<span class="${critClass}">${subtext}</span>` : subtext;
        
        logDiceDM(`🎯 ${mName} - ${aName}`, total, subtext);
    }

    function rollSimpleDice(sides) {
        const result = Math.floor(Math.random() * sides) + 1;
        
        document.getElementById('scene-dice-label').innerText = `Tiro Libero (d${sides})`;
        document.getElementById('scene-dice-result').innerText = result;
        document.getElementById('scene-dice-crit').innerText = '';
        
        logDiceDM(`🎲 d${sides}`, result, `Tiro base`, "var(--text-color)");
    }

    window.onload = () => {
        loadDMData();
        renderCombat();
    };
</script>
</body>
</html>
