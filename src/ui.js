import {cheatsFromData, MACHINE_LABELS} from './engines.js';

export function viewImport(state){
  return `<h1>Import bundle.json</h1>
  <p>Kies <code>bundle.json</code> uit <kbd>script-output/FactorioCompanion/</kbd>.</p>
  <input type="file" id="bundle" accept="application/json"/>
  <button id="doImport">Importeer</button>
  <div id="importResult"></div>`;
}

export function viewCheats(state){
  const c = cheatsFromData(state.data);
  return `<h1>Cheats</h1>
  <p>Items: ${c.itemCount}</p>
  <p>Recipes: ${c.recipeCount}</p>
  <p>Techs: ${c.techCount}</p>`;
}

export function viewPlanner(state){
  return `<h1>Factory planner & analyzer</h1>
  <p>Voeg productielijnen toe (recipe + machines). De app berekent productie, verbruik, tekorten, overproductie en suggesties wat je moet bijbouwen.</p>
  <button id="addLine">+ Lijn toevoegen</button>
  <table id="planTable" border="1" cellspacing="0" cellpadding="4" style="margin-top:.5rem;border-collapse:collapse;">
    <thead>
      <tr>
        <th>#</th>
        <th>Recipe</th>
        <th>Machines</th>
        <th>Machine type</th>
        <th>Prod. bonus %</th>
        <th>Acties</th>
      </tr>
    </thead>
    <tbody id="planBody"></tbody>
  </table>
  <div style="margin-top:0.5rem;">
    <button id="recalc">Herbereken balans</button>
  </div>
  <h2 style="margin-top:1rem;">Balans per item</h2>
  <div id="balance"></div>
  <h2 style="margin-top:1rem;">What to build next</h2>
  <div id="suggestions"></div>`;
}

export function viewDiff(state){
  return `<h1>Diff</h1>
  <p>Selecteer een nieuwe <code>bundle.json</code> om te vergelijken met de huidige data.</p>
  <input type="file" id="diffFile" accept="application/json"/>
  <button id="runDiff">Bereken diff</button>
  <pre id="diffResult"></pre>`;
}
