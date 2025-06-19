

window.ecotheque = window.ecotheque || {};

window.ecotheque.slider = {
    init: function () {
        'use strict';
        this.sliders = document.querySelectorAll('.splide');
        this.breakpoint = 768;

        if (window.innerWidth <= this.breakpoint || !this.sliders) {
            return;
        }
        this.listen();
    },
    listen: function () {
        'use strict';
        this.sliders.forEach(function (slider) {
            this.slides = slider.querySelectorAll('.splide__slide');

            this.updateFigcaptionSize();
            window.addEventListener('resize', this.updateFigcaptionSize.bind(this));
        }.bind(this));
    },
    updateFigcaptionSize: function () {
        'use strict';
        this.slides.forEach(function (slide) {
            this.figcaption = slide.querySelector('figcaption');
            if (this.figcaption) {
                this.image = slide.querySelector('picture');
                this.figcaption.style.maxWidth = this.image.offsetWidth + 'px';
            }
        }.bind(this));
    }
};

window.ecotheque.slider.init();
