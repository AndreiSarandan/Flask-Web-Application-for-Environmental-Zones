const swiper = new Swiper('.swiper', {
    slidesPerView: 2,
    spaceBetween: 30,
    speed: 800,
    loop: true,
    pagination: {
        el: '.swiper-pagination',
    },
    navigation: {
        nextEl: '.swiper-button-next',
        prevEl: '.swiper-button-prev',

    },
    breakpoints: {
        // when window width is >= 320px
        320: {
            slidesPerView: 1,
            spaceBetween: 20
        },
        // when window width is >= 480px
        480: {
            slidesPerView: 2,
            spaceBetween: 30
        },
        // when window width is >= 640px
        1200: {
            slidesPerView: 4,
            spaceBetween: 40
        }
    }
});