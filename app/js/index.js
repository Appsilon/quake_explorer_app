export function sentQuakeId(ns, elementId) {
  Shiny.setInputValue(ns.concat('-quake_id'), elementId);
}
