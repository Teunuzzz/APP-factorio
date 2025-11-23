import {viewImport,viewCheats,viewPlanner,viewDiff} from './ui.js';
import {saveBundle,loadData} from './db.js';
import {computeDiff, computeFactoryBalance, suggestBuildNext, MACHINE_LABELS} from './engines.js';

const app = document.getElementById('app');

let state = {
  data:{items:[],recipes:[],techs:[],planets:[]},
  plan:[]
};

async function init(){
  state.data = await loadData();
  render('import');
}

export function render(view){
  if(view==='import') app.innerHTML = viewImport(state);
  if(view==='cheats') app.innerHTML = viewCheats(state);
  if(view==='planner') app.innerHTML = viewPlanner(state);
  if(view==='diff') app.innerHTML = viewDiff(state);
  wire(view);
}

function wire(view){
  if(view==='import'){
    const btn = document.getElementById('doImport');
    if(btn){
      btn.onclick = async ()=>{
        const file = document.getElementById('bundle').files[0];
        if(!file){ alert('Kies eerst een bundle.json'); return; }
        const res = await saveBundle(file);
        state.data = await loadData();
        document.getElementById('importResult').textContent =
          `Geïmporteerd: items=${res.items}, recipes=${res.recipes}, techs=${res.techs}, planets=${res.planets}`;
      };
    }
  }

  if(view==='diff'){
    const btn = document.getElementById('runDiff');
    if(btn){
      btn.onclick = async ()=>{
        const file = document.getElementById('diffFile').files[0];
        if(!file){ alert('Kies eerst een bundle.json'); return; }
        const text = await file.text();
        const incoming = JSON.parse(text);
        const diff = computeDiff(state.data, incoming);
        document.getElementById('diffResult').textContent = JSON.stringify({
          items:{added:diff.items.added.length,removed:diff.items.removed.length,changed:diff.items.changed.length},
          recipes:{added:diff.recipes.added.length,removed:diff.recipes.removed.length,changed:diff.recipes.changed.length},
          techs:{added:diff.techs.added.length,removed:diff.techs.removed.length,changed:diff.techs.changed.length}
        }, null, 2);
      };
    }
  }

  if(view==='planner'){
    const body = document.getElementById('planBody');
    const recipes = state.data.recipes || [];

    function renderPlanRows(){
      body.innerHTML = '';
      state.plan.forEach((line, idx)=>{
        const tr = document.createElement('tr');
        tr.innerHTML = `
          <td>${idx+1}</td>
          <td>
            <select data-field="recipeId">
              <option value="">-- kies recipe --</option>
              ${recipes.map(r=>`<option value="${r.id}" ${r.id===line.recipeId?'selected':''}>${r.name||r.id}</option>`).join('')}
            </select>
          </td>
          <td><input type="number" min="0" step="0.1" data-field="machines" value="${line.machines||0}"/></td>
          <td>
            <select data-field="machineType">
              ${Object.entries(MACHINE_LABELS).map(([k,label])=>`<option value="${k}" ${k===line.machineType?'selected':''}>${label}</option>`).join('')}
            </select>
          </td>
          <td><input type="number" min="0" step="1" data-field="prodBonus" value="${line.prodBonus||0}"/></td>
          <td><button data-action="delete">Verwijder</button></td>
        `;
        body.appendChild(tr);
      });
    }

    function syncFromDOM(){
      const rows = Array.from(body.querySelectorAll('tr'));
      state.plan = rows.map(tr=>{
        const get = sel=>tr.querySelector(sel);
        return {
          recipeId: get('select[data-field="recipeId"]').value || '',
          machines: Number(get('input[data-field="machines"]').value||0),
          machineType: get('select[data-field="machineType"]').value || 'assem-1',
          prodBonus: Number(get('input[data-field="prodBonus"]').value||0)
        };
      });
    }

    function recalc(){
      syncFromDOM();
      const { balance } = computeFactoryBalance(state.plan, state.data);
      const balDiv = document.getElementById('balance');
      if(!balance.length){
        balDiv.textContent = 'Nog geen lijnen ingevoerd.';
      }else{
        const rows = balance.map(b=>`<tr>
          <td>${b.name}</td>
          <td>${b.produced.toFixed(2)}</td>
          <td>${b.consumed.toFixed(2)}</td>
          <td>${b.net.toFixed(2)}</td>
          <td>${b.status}</td>
        </tr>`).join('');
        balDiv.innerHTML = `<table border="1" cellspacing="0" cellpadding="4">
          <thead><tr><th>Item</th><th>Prod/min</th><th>Verbruik/min</th><th>Netto</th><th>Status</th></tr></thead>
          <tbody>${rows}</tbody>
        </table>`;
      }

      const suggDiv = document.getElementById('suggestions');
      const suggestions = suggestBuildNext(state.plan, state.data);
      if(!suggestions.length){
        suggDiv.textContent = 'Geen tekorten gevonden die op basis van recipes opgelost kunnen worden.';
      }else{
        const rows = suggestions.slice(0,20).map(s=>`<tr>
          <td>${s.item}</td>
          <td>${s.shortagePerMin.toFixed(2)}</td>
          <td>${s.recipeName}</td>
          <td>${s.machineType}</td>
          <td>${s.machinesExtra.toFixed(2)}</td>
        </tr>`).join('');
        suggDiv.innerHTML = `<table border="1" cellspacing="0" cellpadding="4">
          <thead><tr><th>Item</th><th>Tekort/min</th><th>Recipe</th><th>Machine type</th><th>Extra machines nodig</th></tr></thead>
          <tbody>${rows}</tbody>
        </table>`;
      }
    }

    document.getElementById('addLine').onclick = ()=>{
      state.plan.push({
        recipeId:'',
        machines:1,
        machineType:'assem-1',
        prodBonus:0
      });
      renderPlanRows();
    };

    body.addEventListener('click', e=>{
      const btn = e.target.closest('button[data-action="delete"]');
      if(!btn) return;
      const tr = btn.closest('tr');
      const index = Array.from(body.children).indexOf(tr);
      if(index>=0){
        state.plan.splice(index,1);
        renderPlanRows();
      }
    });

    document.getElementById('recalc').onclick = recalc;

    renderPlanRows();
    recalc();
  }
}

// nav buttons
document.querySelectorAll('[data-goto]').forEach(btn=>{
  btn.onclick = ()=>render(btn.dataset.goto);
});

init();
