module.exports = {
    future: {
        strictPostcssConfiguration: true,
    },
    content: [
        './public/*.html',
        './app/helpers/**/*.rb',
        './app/javascript/**/*.js',
        './app/views/**/*.{erb,haml,html,slim}'
    ],
    theme: {
        extend: {
            fontFamily: {
                sans: ['InterVariable', 'system-ui', 'sans-serif'],
                display: ['Georgia', 'Cambria', 'Times New Roman', 'Times', 'serif'],
            },
        },
    },
    plugins: [
        require('@tailwindcss/forms'),
    ]
}
