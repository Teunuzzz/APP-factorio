import {cheatsFromData} from './engines.js';

export function viewImport(){
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
  return `<h1>Planner</h1>
  <p>(Hier kun je later je factory-planning uitwerken op basis van recipes.)</p>`;
}

export function viewDiff(){
  return `<h1>Diff</h1>
  <p>Selecteer een nieuwe <code>bundle.json</code> om te vergelijken met de huidige data.</p>
  <input type="file" id="diffFile" accept="application/json"/>
  <button id="runDiff">Bereken diff</button>
  <pre id="diffResult"></pre>`;
}
