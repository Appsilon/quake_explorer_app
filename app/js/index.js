export function sentQuakeId(ns, elementId) {
  Shiny.setInputValue(ns.concat('-quake_id'), elementId);
}

export function headerExpand(ns, elementId) {
  document.getElementById(ns.concat('app_header'), elementId).classList
    .remove('mobile-collapsed');
  document.getElementById(ns.concat('app_header'), elementId).classList
    .add('mobile-expanded');
}

export function headerCollapse(ns, elementId) {
  document.getElementById(ns.concat('app_header'), elementId).classList
    .add('mobile-collapsed');
  document.getElementById(ns.concat('app_header'), elementId).classList
    .remove('mobile-expanded');
}
