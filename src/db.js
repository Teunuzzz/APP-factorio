export async function saveBundle(file){
  const text = await file.text();
  const obj = JSON.parse(text);
  localStorage.setItem('companion_bundle', text);
  const items = Array.isArray(obj.items) ? obj.items.length : 0;
  const recipes = Array.isArray(obj.recipes) ? obj.recipes.length : 0;
  const techs = Array.isArray(obj.techs) ? obj.techs.length : 0;
  const planets = Array.isArray(obj.planets) ? obj.planets.length : 0;
  return {items,recipes,techs,planets};
}

export async function loadData(){
  const text = localStorage.getItem('companion_bundle');
  if(!text){
    return {items:[],recipes:[],techs:[],planets:[], plan:[]};
  }
  const obj = JSON.parse(text);
  return {
    items: obj.items || [],
    recipes: obj.recipes || [],
    techs: obj.techs || [],
    planets: obj.planets || [],
    plan: obj.plan || []        // ⬅️ hier komt het plan uit de dump
  };
}

