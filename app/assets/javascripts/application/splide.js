/* global Splide */

var sliders = document.querySelectorAll('.splide'),
    i = 0;

if (sliders) {
    for (i = 0; i < sliders.length; i += 1) {
        new Splide(sliders[i], {
            pagination: false,
            autoWidth: true,
            breakpoints: {
                768: {
                    perPage: 1,
                    autoWidth: false,
                    padding: { right: '20%' }
                }
            }
        }).mount();
    }
}
