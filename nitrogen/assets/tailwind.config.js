module.exports = {
  purge: [
    '../lib/**/*.ex',
    '../lib/**/*.leex',
    '../lib/**/*.eex',
    '../lib/**/.sface',
    './js/**/*.js'
  ],
  darkMode: false, // or 'media' or 'class'
  theme: {
    extend: {
      colors: {
        'primary': 'var(--primary-color)',
        'primary-variant': 'var(--primary-variant-color)',
        'secondary': 'var(--secondary-color)',
        'surface': 'var(--surface-color)',
        'error': 'var(--error-color)',
      }
    },
  },
  variants: {
    extend: {},
  },
  plugins: [
    require('@tailwindcss/forms')
  ],
}
