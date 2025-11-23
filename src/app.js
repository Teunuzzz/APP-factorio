import {viewImport,viewCheats,viewPlanner,viewDiff} from './ui.js';
import {saveBundle,loadData} from './db.js';
import {computeDiff} from './engines.js';

const app = document.getElementById('app');
let state = { data:{items:[],recipes:[],techs:[],planets:[]} };

async function init(){
  state.data = await loadData();
  render('import');
}

export function render(view){
  if(view==='import') app.innerHTML = viewImport();
  if(view==='cheats') app.innerHTML = viewCheats(state);
  if(view==='planner') app.innerHTML = viewPlanner(state);
  if(view==='diff') app.innerHTML = viewDiff();
  wire(view);
}

function wire(view){
  if(view==='import'){
    const btn = document.getElementById('doImport');
    btn.onclick = async ()=>{
      const file = document.getElementById('bundle').files[0];
      if(!file){ alert('Kies eerst een bundle.json'); return; }
      const res = await saveBundle(file);
      state.data = await loadData();
      document.getElementById('importResult').textContent =
        `Geïmporteerd: items=${res.items}, recipes=${res.recipes}, techs=${res.techs}, planets=${res.planets}`;
    };
  }
  if(view==='diff'){
    const btn = document.getElementById('runDiff');
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

// nav
document.querySelectorAll('[data-goto]').forEach(btn=>{
  btn.onclick = ()=>render(btn.dataset.goto);
});

init();
