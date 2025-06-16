window.ecotheque = window.ecotheque || {};

window.ecotheque.offcanvasSearch = {
    init: function () {
        'use strict';
        this.dom = document.querySelector('.directory');
        this.breakpoint = 768;

        if (!this.dom) {
            return;
        }
        // if(window.innerWidth <= this.breakpoint || !this.dom) {
        //     return;
        // }

        this.buttonsContainer = this.dom.querySelector('.js-offcanvas-cta-container');
        this.button = this.buttonsContainer.querySelector('.offcanvas-search-btn');
        this.offcanvas = this.dom.querySelector('.offcanvas-search');
        this.directoryContent = this.dom.querySelector('.directory-container');
        this.btnText = this.button.querySelector('span');
        this.orderByFacet = this.offcanvas.querySelector('.js-facet-order-by');
        this.filtersContainer = this.dom.querySelector('.directory-filters');
        this.btnOpenedText = 'Fermer les filtres';
        this.btnClosedText = 'Ouvrir les filtres';
        this.isOpened = true;

        this.hiddenTocClass = 'is-hidden';
        this.expandedContent = 'col-lg-12';
        this.reducedContent = 'col-lg-9';
        this.fullWidthFiltersToggleClass = 'is-full-width';

        this.button.addEventListener('click', this.listen.bind(this));
        this.cloneOrderByFacet();
    },
    listen: function () {
        'use strict';

        this.isOpened = !this.isOpened;

        this.toggleSearch();
        this.changeBtn(this.isOpened);

        // Déclenche un resize pour ajuster la carte
        window.dispatchEvent(new Event('resize'));
    },
    toggleSearch: function () {
        'use strict';
        this.offcanvas.classList.toggle(this.hiddenTocClass);
        this.directoryContent.classList.toggle(this.expandedContent);
        this.directoryContent.classList.toggle(this.reducedContent);
        this.filtersContainer.classList.toggle(this.fullWidthFiltersToggleClass);
    },
    changeBtn: function (status) {
        'use strict';
        this.btnText.innerHTML = status === true ? this.btnOpenedText : this.btnClosedText;
    },
    cloneOrderByFacet: function () {
        'use strict';
        var clonedOrderByFacet;
        if (!this.orderByFacet) {
            return;
        }
        clonedOrderByFacet = this.orderByFacet.cloneNode(true);
        this.buttonsContainer.appendChild(clonedOrderByFacet);
    }
};

window.ecotheque.offcanvasSearch.init();
