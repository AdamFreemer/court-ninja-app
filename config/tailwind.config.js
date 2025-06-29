const defaultTheme = require('tailwindcss/defaultTheme')

module.exports = {
  content: ["./app/**/*.{html,js,erb}"],
  theme: {
    fontSize: {
      xs: ["0.75rem", { lineHeight: "1rem" }],
      sm: ["0.875rem", { lineHeight: "1.25rem" }],
      md: ["0.938rem", { lineHeight: "1.5rem" }],
      base: ["1rem", { lineHeight: "1.75rem" }],
      lg: ["1.125rem", { lineHeight: "1.75rem" }],
      xl: ["1.25rem", { lineHeight: "1.75rem" }],
      "2xl": ["1.5rem", { lineHeight: "2rem" }],
      "3xl": ["1.875rem", { lineHeight: "2.25rem" }],
      "4xl": ["2.25rem", { lineHeight: "2.75rem" }],
      "5xl": ["3rem", { lineHeight: "1.125" }],
      "6xl": ["3.75rem", { lineHeight: "1.125" }],
      "7xl": ["4.5rem", { lineHeight: "1.125" }],
      "8xl": ["6rem", { lineHeight: "1.125" }],
      "9xl": ["8rem", { lineHeight: "1" }],
    },    
    extend: {
      backgroundImage: {
        "gradient-radial": "radial-gradient(var(--tw-gradient-stops))",
      },      
      fontFamily: {
        sans: ["Inter", "sans-serif"],
        display: ["Lexend", "sans-serif"],
        writing: ["Gochi Hand", "mono"],
        cursive: ["Mr Dafoe", "mono"],
      },
      animation: {
        'reverse-spin': 'reverse-spin 1s linear infinite',
        "spin-slow": "spin 12s linear infinite",
      },
      keyframes: {
        'reverse-spin': {
          from: {
            transform: 'rotate(360deg)'
          },
        }
      }
    },
  },
  plugins: [
    require('@tailwindcss/forms'),
    require("daisyui"),
    // require('@tailwindcss/aspect-ratio'),
    require("@tailwindcss/line-clamp"),
    require("@tailwindcss/typography"),
  ],
  daisyui: {
    styled: true,
    themes: true,
    base: true,
    utils: true,
    logs: true,
    rtl: false,
    prefix: "",
    darkTheme: "light",
  },
}

