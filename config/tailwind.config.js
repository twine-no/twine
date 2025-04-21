module.exports = {
    future: {
        strictPostcssConfiguration: true
    },
    content: ['./public/*.html', './app/helpers/**/*.rb', './app/javascript/**/*.js', './app/views/**/*.{erb,haml,html,slim}'],
    daisyui: {
        themes: ["cupcake --default", "cyberpunk --prefersdark"],
    },
    plugins: [
        require('daisyui'),
        require('@tailwindcss/forms'),
        require('@tailwindcss/typography'),
        require('@tailwindcss/container-queries')
    ],
};