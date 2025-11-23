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
