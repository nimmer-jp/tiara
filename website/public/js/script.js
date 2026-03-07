document.addEventListener('DOMContentLoaded', () => {
    document.querySelectorAll('a[href^="#"]').forEach((anchor) => {
        anchor.addEventListener('click', function (e) {
            e.preventDefault();
            const target = document.querySelector(this.getAttribute('href'));
            if (target) {
                target.scrollIntoView({
                    behavior: 'smooth'
                });
            }
        });
    });

    const card = document.querySelector('.glass-card');
    if (card) {
        card.addEventListener('mousemove', (e) => {
            const rect = card.getBoundingClientRect();
            const x = e.clientX - rect.left;
            const y = e.clientY - rect.top;

            card.style.background = `rgba(17, 24, 39, 0.7) radial-gradient(circle at ${x}px ${y}px, rgba(255,255,255,0.05) 0%, transparent 50%)`;
        });

        card.addEventListener('mouseleave', () => {
            card.style.background = 'rgba(17, 24, 39, 0.7)';
        });
    }

    const docsSearchInput = document.querySelector('[data-doc-search-input]');
    const docItems = Array.from(document.querySelectorAll('[data-doc-item]'));
    const docCount = document.querySelector('[data-doc-count]');
    const emptyState = document.querySelector('[data-doc-empty]');

    if (docsSearchInput && docItems.length > 0) {
        const updateDocsSearch = () => {
            const query = docsSearchInput.value.trim().toLowerCase();
            let visibleCount = 0;

            docItems.forEach((item) => {
                const haystack = (item.dataset.docSearch || '').toLowerCase();
                const isVisible = query === '' || haystack.includes(query);
                item.hidden = !isVisible;

                if (isVisible) {
                    visibleCount += 1;
                }
            });

            if (docCount) {
                docCount.textContent = query === ''
                    ? `${visibleCount} sections`
                    : `${visibleCount} result${visibleCount === 1 ? '' : 's'}`;
            }

            if (emptyState) {
                emptyState.hidden = visibleCount !== 0;
            }
        };

        docsSearchInput.addEventListener('input', updateDocsSearch);
        updateDocsSearch();
    }
});
