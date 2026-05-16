/* Distortionz Coords — display-only HUD overlay */
const panel = document.getElementById('panel');
const elVer = document.getElementById('ver');
const elXyz = document.getElementById('xyz');
const elVec = document.getElementById('vec');
const elEnt = document.getElementById('ent');
const elHint = document.getElementById('hint');

const esc = s => String(s == null ? '' : s).replace(/[&<>"]/g, c =>
  ({ '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;' }[c]));

let flashTimer;

window.addEventListener('message', (e) => {
  const d = e.data || {};
  switch (d.action) {
    case 'show':
      elVer.textContent = 'v' + (d.version || '1.0.0');
      panel.classList.remove('hidden');
      break;

    case 'hide':
      panel.classList.add('hidden');
      break;

    case 'update':
      // Visibility is driven by the update stream so a missed 'show'
      // (CEF page not loaded yet when /coords fired) can't leave it stuck.
      panel.classList.remove('hidden');
      if (d.version && !elVer.textContent) elVer.textContent = 'v' + d.version;
      elXyz.innerHTML =
        `X ${d.x.toFixed(3)}&nbsp;&nbsp;Y ${d.y.toFixed(3)}&nbsp;&nbsp;Z ${d.z.toFixed(3)}`;
      elVec.textContent = d.vec4 || '';
      elEnt.textContent = d.entity ? d.entity : '(world surface)';
      elHint.innerHTML =
        `<b>[E]</b> copy ${esc(d.copyMode || 'vec4')} &nbsp;·&nbsp; /${esc(d.cmd || 'coords')} to close`;
      break;

    case 'flash':
      panel.classList.add('flash');
      clearTimeout(flashTimer);
      flashTimer = setTimeout(() => panel.classList.remove('flash'), 350);
      break;
  }
});
