document.addEventListener('DOMContentLoaded', () => {
    const loginForm = document.getElementById('loginForm');
    const roleSelect = document.getElementById('roleSelect');
    const dropdownTrigger = document.getElementById('dropdownTrigger');
    const dropdownMenuList = document.getElementById('dropdownMenuList');
    const triggerText = document.getElementById('triggerText');
    const chevronIcon = dropdownTrigger ? dropdownTrigger.querySelector('.bi-chevron-down') : null;

    if (!dropdownTrigger || !dropdownMenuList || !roleSelect) return;

    const menuOptions = dropdownMenuList.querySelectorAll('li');

    dropdownTrigger.addEventListener('click', (e) => {
        e.stopPropagation();
        const isHidden = window.getComputedStyle(dropdownMenuList).display === 'none';
        
        dropdownMenuList.style.display = isHidden ? 'block' : 'none';
        if (chevronIcon) chevronIcon.style.transform = isHidden ? 'rotate(180deg)' : 'rotate(0deg)';
    });

    menuOptions.forEach(option => {
        option.addEventListener('click', function(e) {
            e.stopPropagation();
            const chosenValue = this.getAttribute('data-value'); 
            
            roleSelect.value = chosenValue; 
            triggerText.textContent = chosenValue;

            menuOptions.forEach(opt => opt.classList.remove('selected-option'));
            this.classList.add('selected-option');

            dropdownMenuList.style.display = 'none';
            if (chevronIcon) chevronIcon.style.transform = 'rotate(0deg)';
        });
    });

    document.addEventListener('click', () => {
        dropdownMenuList.style.display = 'none';
        if (chevronIcon) chevronIcon.style.transform = 'rotate(0deg)';
    });

    if (loginForm) {
        loginForm.addEventListener('submit', (event) => {
            if (!roleSelect.value) {
                event.preventDefault(); 
                alert("Please click your staff position dropdown and select a role before logging in.");
                dropdownTrigger.style.borderColor = '#dc2626';
            }
        });
    }
});