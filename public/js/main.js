if (typeof Formspree !== 'undefined') Formspree.init({ formId: 'mqeonzoz' });

// Strip hash from URL on load to prevent scroll-to-section on refresh
window.addEventListener('load', function () {
  if (window.location.hash) {
    window.scrollTo(0, 0);
    history.replaceState(null, '', window.location.pathname);
  }
  document.documentElement.style.scrollBehavior = 'smooth';
});

// Strip hash after anchor-link click once scroll settles
document.querySelectorAll('a[href^="#"]').forEach(function (link) {
  link.addEventListener('click', function () {
    setTimeout(function () {
      history.replaceState(null, '', window.location.pathname);
    }, 800);
  });
});

(function () {
  if (window.matchMedia('(prefers-reduced-motion: reduce)').matches) return;

  // Called after a section's reveal transition completes.
  // Starts count-up on [data-count] elements and triggers word-reveal on pull quotes.
  function startRevealedContent(container) {
    container.querySelectorAll('[data-count]:not(.counted)').forEach(function (el) {
      el.classList.add('counted');
      var target = parseFloat(el.dataset.count);
      if (isNaN(target)) return;
      var display = el.dataset.display || String(target);
      var suffix = el.dataset.suffix || '';
      var duration = 1800;
      var start = null;

      function formatCount(val) {
        if (target >= 1000000000) {
          var b = val / 1000000000;
          if (b >= 1) return Math.floor(b) + ' billion';
          return (b).toFixed(1).replace(/\.0$/, '') + ' billion';
        }
        if (target >= 1000000) {
          return Math.round(val / 1000000) + 'M';
        }
        return Math.round(val) + suffix;
      }

      function easeOut(t) { return 1 - Math.pow(1 - t, 3); }

      function step(timestamp) {
        if (!start) start = timestamp;
        var progress = Math.min((timestamp - start) / duration, 1);
        var current = easeOut(progress) * target;
        el.textContent = formatCount(current);
        if (progress < 1) {
          requestAnimationFrame(step);
        } else {
          el.textContent = display;
        }
      }

      requestAnimationFrame(step);
    });

    // Trigger staggered word reveal on pull quote
    var pullText = container.querySelector('.pull-quote-text');
    if (pullText) { pullText.classList.add('revealed'); }
  }

  var observer = new IntersectionObserver(
    function (entries) {
      entries.forEach(function (entry) {
        if (entry.isIntersecting) {
          entry.target.classList.add('is-visible');
          observer.unobserve(entry.target);
          setTimeout(function () { startRevealedContent(entry.target); }, 650);
        }
      });
    },
    { threshold: 0.08 }
  );

  // Add data-reveal to main sections (skip first/hero) and footer
  document.querySelectorAll('main section').forEach(function (el, i) {
    if (i === 0) return;
    el.setAttribute('data-reveal', '');
  });
  var footer = document.querySelector('footer');
  if (footer) footer.setAttribute('data-reveal', '');

  // Observe ALL [data-reveal] elements — catches template-set ones (TallammyPullQuote div)
  // and the programmatically-set ones above. Elements already in the viewport at script
  // run time (e.g. page loaded at a hash anchor) are shown immediately without waiting
  // for the observer's async callback.
  document.querySelectorAll('[data-reveal]').forEach(function (el) {
    var rect = el.getBoundingClientRect();
    if (rect.top < window.innerHeight && rect.bottom > 0) {
      el.classList.add('is-visible');
      setTimeout(function () { startRevealedContent(el); }, 650);
    } else {
      observer.observe(el);
    }
  });

  // Scroll-based fallback: IntersectionObserver handles most cases, but programmatic
  // and anchor-triggered scrolls can miss the callback. This scan runs on every scroll
  // (throttled to one per frame) and catches any element in the viewport that the
  // observer hasn't yet marked visible.
  var ticking = false;
  function revealInView() {
    document.querySelectorAll('[data-reveal]:not(.is-visible)').forEach(function (el) {
      var rect = el.getBoundingClientRect();
      if (rect.top < window.innerHeight && rect.bottom > 0) {
        el.classList.add('is-visible');
        observer.unobserve(el);
        setTimeout(function () { startRevealedContent(el); }, 650);
      }
    });
    ticking = false;
  }
  window.addEventListener('scroll', function () {
    if (!ticking) {
      requestAnimationFrame(revealInView);
      ticking = true;
    }
  }, { passive: true });
})();
