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
    safelist: [
        {
            pattern: /badge-(red|yellow|green|blue|indigo|purple|pink|gray)/
        },
        {
            pattern: /bg-(red|yellow|green|blue|indigo|purple|pink|gray)-100/
        }
    ],
    theme: {
        extend: {
            fontFamily: {
                sans: ['InterVariable', 'system-ui', 'sans-serif'],
                serif: ['Georgia', 'Cambria', 'Times New Roman', 'Times', 'serif'],
                mono: ['ui-monospace', 'FSMono-Regular', 'Menlo', 'Monaco', 'Consolas', 'Liberation Mono', 'Courier New', 'monospace']
            },
        },
    },
    plugins: [
        require('@tailwindcss/forms'),
        require('@tailwindcss/typography'),
        require('@tailwindcss/container-queries'),
    ]
}
