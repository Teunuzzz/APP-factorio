// Diff + cheats

export function computeDiff(current, incoming){
  function byId(arr){return Object.fromEntries((arr||[]).map(x=>[x.id,x]));}
  const sections = ['items','recipes','techs'];
  const out = {};
  for(const s of sections){
    const A = byId(current[s]||[]);
    const B = byId(incoming[s]||[]);
    const added = [], removed = [], changed = [];
    for(const id in B){ if(!A[id]) added.push(B[id]); }
    for(const id in A){ if(!B[id]) removed.push(A[id]); }
    for(const id in B){ if(A[id] && JSON.stringify(A[id])!==JSON.stringify(B[id])) changed.push({id,from:A[id],to:B[id]}); }
    out[s] = {added,removed,changed};
  }
  return out;
}

export function cheatsFromData(data){
  return {
    itemCount: data.items.length,
    recipeCount: data.recipes.length,
    techCount: data.techs.length
  };
}

// Planner constants & helpers

export const MACHINE_SPEEDS = {
  'assem-1': 0.5,
  'assem-2': 0.75,
  'assem-3': 1.25,
  'chem-plant': 1.0,
  'furnace-1': 1.0,
  'furnace-2': 2.0,
  'furnace-3': 2.0,
  'miner-1': 0.5,
  'miner-2': 0.75,
  'miner-3': 1.0
};

export const MACHINE_LABELS = {
  'assem-1': 'Assembler 1',
  'assem-2': 'Assembler 2',
  'assem-3': 'Assembler 3',
  'chem-plant': 'Chemical plant',
  'furnace-1': 'Stone furnace',
  'furnace-2': 'Steel furnace',
  'furnace-3': 'Electric furnace',
  'miner-1': 'Burner miner',
  'miner-2': 'Electric miner 1',
  'miner-3': 'Electric miner 2'
};

export function buildRecipeIndex(data){
  const byId = {};
  const byOutput = {};
  for(const r of data.recipes||[]){
    byId[r.id] = r;
    for(const o of r.outputs||[]){
      if(!o || !o.name) continue;
      if(!byOutput[o.name]) byOutput[o.name] = [];
      byOutput[o.name].push(r);
    }
  }
  return { byId, byOutput };
}

export function computeLineIO(recipe, line){
  if(!recipe) return { outputs:{}, inputs:{} };
  const machines = Number(line.machines||0);
  if(!machines) return { outputs:{}, inputs:{} };

  const speed = MACHINE_SPEEDS[line.machineType] || 1;
  const time = recipe.time || recipe.energy || 1;
  const craftsPerMinPerMachine = 60 / time * speed;
  const prodBonus = (Number(line.prodBonus||0) / 100);
  const factor = machines * craftsPerMinPerMachine;

  const outputs = {};
  for(const o of recipe.outputs||[]){
    const base = (o.amount||0) * factor;
    outputs[o.name] = (outputs[o.name]||0) + base * (1+prodBonus);
  }

  const inputs = {};
  const ins = recipe.inputs || recipe.ingredients || [];
  for(const i of ins){
    const use = (i.amount||0) * factor;
    inputs[i.name] = (inputs[i.name]||0) + use;
  }

  return { outputs, inputs };
}

export function computeFactoryBalance(plan, data){
  const { byId } = buildRecipeIndex(data);
  const totals = {};
  const perLine = [];
  for(const line of plan){
    const recipe = byId[line.recipeId];
    const io = computeLineIO(recipe, line);
    perLine.push({line, recipe, io});
    for(const [name,qty] of Object.entries(io.outputs)){
      if(!totals[name]) totals[name] = {produced:0, consumed:0};
      totals[name].produced += qty;
    }
    for(const [name,qty] of Object.entries(io.inputs)){
      if(!totals[name]) totals[name] = {produced:0, consumed:0};
      totals[name].consumed += qty;
    }
  }
  const balance = [];
  for(const [name,t] of Object.entries(totals)){
    const net = t.produced - t.consumed;
    balance.push({
      name,
      produced: t.produced,
      consumed: t.consumed,
      net,
      status: net > 0.01 ? 'overproductie'
            : net < -0.01 ? 'tekort'
            : 'in balans'
    });
  }
  balance.sort((a,b)=>Math.abs(b.net)-Math.abs(a.net));
  return { balance, perLine };
}

export function suggestBuildNext(plan, data){
  const { byId, byOutput } = buildRecipeIndex(data);
  const { balance } = computeFactoryBalance(plan, data);
  const deficits = balance.filter(b=>b.net < -0.01);
  const suggestions = [];
  const machinesByRecipe = {};
  for(const l of plan){
    machinesByRecipe[l.recipeId] = (machinesByRecipe[l.recipeId]||0) + Number(l.machines||0);
  }

  for(const def of deficits){
    const makers = byOutput[def.name]||[];
    if(!makers.length) continue;
    const r = makers[0];
    const out1 = (r.outputs||[]).find(o=>o.name===def.name);
    if(!out1 || !out1.amount) continue;

    let machineType = 'assem-1';
    for(const l of plan){
      if(l.recipeId===r.id && l.machineType){
        machineType = l.machineType;
        break;
      }
    }
    const time = r.time || r.energy || 1;
    const speed = MACHINE_SPEEDS[machineType] || 1;
    const craftsPerMinPerMachine = 60 / time * speed;
    const prodPerMachine = craftsPerMinPerMachine * out1.amount;
    if(prodPerMachine <= 0) continue;

    const neededExtraPerMin = -def.net;
    const machinesNeeded = neededExtraPerMin / prodPerMachine;

    suggestions.push({
      item: def.name,
      shortagePerMin: neededExtraPerMin,
      recipeId: r.id,
      recipeName: r.name || r.id,
      machineType,
      machinesExtra: machinesNeeded
    });
  }
  suggestions.sort((a,b)=>b.shortagePerMin - a.shortagePerMin);
  return suggestions;
}
