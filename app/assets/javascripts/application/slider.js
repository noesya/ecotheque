

window.ecotheque = window.ecotheque || {};

window.ecotheque.slider = {
    init: function () {
        'use strict';
        this.sliders = document.querySelectorAll('.splide');
        this.breakpoint = 768;

        if(window.innerWidth <= this.breakpoint || !this.sliders) {
            return;
        }
        this.listen();
    },
    listen: function () {
        'use strict';
        this.sliders.forEach(slider => {
          this.slides = slider.querySelectorAll('.splide__slide');

          this.updateFigcaptionSize();
          window.addEventListener('resize', this.updateFigcaptionSize.bind(this));
        });
    },
    updateFigcaptionSize: function () {
        this.slides.forEach(slide => {
          var figcaption = slide.querySelector('figcaption');
          if (figcaption) {
              var image = slide.querySelector('picture');
              figcaption.style.maxWidth = `${image.offsetWidth}px`;
          }
        });
    }
};

window.ecotheque.slider.init();
