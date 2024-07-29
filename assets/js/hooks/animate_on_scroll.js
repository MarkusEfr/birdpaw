AnimateOnScroll = {
    mounted() {
        let observer = new IntersectionObserver(
            (entries) => {
                entries.forEach((entry) => {
                    if (entry.isIntersecting) {
                        entry.target.classList.add("opacity-100");
                        entry.target.classList.remove("opacity-0");
                    }
                });
            },
            {
                threshold: 0.1
            }
        );

        observer.observe(this.el);
    }
};

export default AnimateOnScroll;