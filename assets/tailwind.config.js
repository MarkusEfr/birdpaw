module.exports = {
  content: [
    "./js/**/*.js",
    "../lib/birdpaw_web.ex",
    "../lib/birdpaw_web/**/*.*ex"
  ],
  theme: {
    extend: {
      colors: {
        scrollbar: '#1a1a1a', // Dark background for the track
        'scrollbar-thumb': '#333333', // Lighter dark color for the thumb
        'scrollbar-thumb-hover': '#4d4d4d', // Hover color for the thumb
      },
      animation: {
        fadeInUp: 'fadeInUp 1s ease-out forwards',
      },
      keyframes: {
        fadeInUp: {
          '0%': { opacity: 0, transform: 'translateY(20px)' },
          '100%': { opacity: 1, transform: 'translateY(0)' },
        },
      },
    },
  },
  plugins: [
    require("@tailwindcss/forms"),
  ]
}
