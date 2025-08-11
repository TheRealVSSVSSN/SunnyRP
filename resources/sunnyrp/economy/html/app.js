window.addEventListener('message', (e) => {
    if (e.data?.type === 'atm:open') document.querySelector('.wrap').style.display = 'block';
});
document.getElementById('deposit').onclick = () => {
    const amount = Number(document.getElementById('amt').value || 0);
    fetch(`https://${GetParentResourceName()}/atm:deposit`, { method: 'POST', headers: { 'Content-Type': 'application/json' }, body: JSON.stringify({ amount }) });
};
document.getElementById('withdraw').onclick = () => {
    const amount = Number(document.getElementById('amt').value || 0);
    fetch(`https://${GetParentResourceName()}/atm:withdraw`, { method: 'POST', headers: { 'Content-Type': 'application/json' }, body: JSON.stringify({ amount }) });
};
document.getElementById('close').onclick = () => {
    document.querySelector('.wrap').style.display = 'none';
    fetch(`https://${GetParentResourceName()}/__close`, { method: 'POST' });
};