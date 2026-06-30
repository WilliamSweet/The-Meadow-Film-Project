if (typeof Formspree !== 'undefined') Formspree.init({ formId: 'mqeonzoz' });

// Nav: transparent + white text over hero, solid cream + dark text past hero
(function () {
  var nav = document.getElementById('nav');
  var hero = document.querySelector('.hero');
  if (!nav || !hero) return;
  new IntersectionObserver(
    function (entries) { nav.classList.toggle('nav--scrolled', !entries[0].isIntersecting); },
    { threshold: 0 }
  ).observe(hero);
})();

// Nav scroll-spy: highlight section link matching the section in view
(function () {
  if (window.matchMedia('(prefers-reduced-motion: reduce)').matches) return;
  var links = Array.from(document.querySelectorAll('[data-nav-link]'));
  if (!links.length) return;
  var ids = links.map(function (l) { return l.getAttribute('href').slice(1); });
  var visible = new Set();
  function setActive() {
    var activeId = null;
    for (var i = 0; i < ids.length; i++) {
      if (visible.has(ids[i])) { activeId = ids[i]; break; }
    }
    links.forEach(function (l) {
      l.classList.toggle('nav-link--active', l.getAttribute('href').slice(1) === activeId);
    });
  }
  var spy = new IntersectionObserver(function (entries) {
    entries.forEach(function (e) {
      if (e.isIntersecting) { visible.add(e.target.id); } else { visible.delete(e.target.id); }
    });
    setActive();
  }, { rootMargin: '-80px 0px -35% 0px', threshold: 0 });
  ids.forEach(function (id) {
    var el = document.getElementById(id);
    if (el) spy.observe(el);
  });
})();

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

  // Add data-reveal to main sections (skip first/hero, skip sections with scroll-card children)
  document.querySelectorAll('main section').forEach(function (el, i) {
    if (i === 0) return;
    if (el.querySelector('[data-scroll-card]')) return;
    if (el.hasAttribute('data-static')) return;
    el.setAttribute('data-reveal', '');
  });
  var footer = document.querySelector('footer');
  if (footer) footer.setAttribute('data-reveal', '');

  // Pull-quote gets its own bidirectional observer so the word-reveal replays every
  // time the section scrolls back into view. All other [data-reveal] sections are
  // one-directional (stay visible once shown).
  var pullQuote = document.querySelector('.pull-quote');
  if (pullQuote) {
    var pullObserver = new IntersectionObserver(
      function (entries) {
        entries.forEach(function (entry) {
          if (entry.isIntersecting) {
            entry.target.classList.add('is-visible');
            setTimeout(function () { startRevealedContent(entry.target); }, 650);
          } else {
            entry.target.classList.remove('is-visible');
            var text = entry.target.querySelector('.pull-quote-text');
            if (text) text.classList.remove('revealed');
          }
        });
      },
      { threshold: 0.15 }
    );
    pullObserver.observe(pullQuote);
  }

  // Observe ALL other [data-reveal] elements — one-directional: add is-visible, never remove.
  document.querySelectorAll('[data-reveal]:not(.pull-quote)').forEach(function (el) {
    var rect = el.getBoundingClientRect();
    if (rect.top < window.innerHeight && rect.bottom > 0) {
      el.classList.add('is-visible');
      setTimeout(function () { startRevealedContent(el); }, 650);
    } else {
      observer.observe(el);
    }
  });

  // Scroll-based fallback for one-directional sections
  var ticking = false;
  function revealInView() {
    document.querySelectorAll('[data-reveal]:not(.pull-quote):not(.is-visible)').forEach(function (el) {
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

// Story cards scrollytelling — bidirectional fade in/out as each card enters/leaves view
(function () {
  var cards = document.querySelectorAll('[data-scroll-card]');
  if (!cards.length) return;

  if (window.matchMedia('(prefers-reduced-motion: reduce)').matches) {
    cards.forEach(function (c) { c.classList.add('visible'); });
    return;
  }

  var cardObserver = new IntersectionObserver(
    function (entries) {
      entries.forEach(function (entry) {
        if (entry.isIntersecting) {
          entry.target.classList.add('visible');
          cardObserver.unobserve(entry.target);
        }
      });
    },
    { threshold: 0.15 }
  );

  cards.forEach(function (card) { cardObserver.observe(card); });

  // Scroll fallback — one-directional: add visible, never remove
  var cardTicking = false;
  function syncCardsInView() {
    cards.forEach(function (card) {
      if (card.classList.contains('visible')) return;
      var rect = card.getBoundingClientRect();
      if (rect.top < window.innerHeight * 0.88 && rect.bottom > 0) {
        card.classList.add('visible');
      }
    });
    cardTicking = false;
  }
  window.addEventListener('scroll', function () {
    if (!cardTicking) {
      requestAnimationFrame(syncCardsInView);
      cardTicking = true;
    }
  }, { passive: true });

  // Initial check on load
  syncCardsInView();
})();

// Smooth anchor scroll — eased, ~900ms, respects reduced-motion
(function () {
  if (window.matchMedia('(prefers-reduced-motion: reduce)').matches) return;

  function easeOutExpo(t) {
    return t === 1 ? 1 : 1 - Math.pow(2, -10 * t);
  }

  function smoothScrollTo(targetY, duration) {
    var startY = window.scrollY;
    var dist = targetY - startY;
    var startTime = null;

    function step(ts) {
      if (!startTime) startTime = ts;
      var elapsed = ts - startTime;
      var progress = Math.min(elapsed / duration, 1);
      window.scrollTo(0, startY + dist * easeOutExpo(progress));
      if (progress < 1) requestAnimationFrame(step);
    }
    requestAnimationFrame(step);
  }

  document.addEventListener('click', function (e) {
    var link = e.target.closest('a[href^="#"]');
    if (!link) return;
    var id = link.getAttribute('href').slice(1);
    if (!id) return;
    var target = document.getElementById(id);
    if (!target) return;
    e.preventDefault();
    var offset = 72; // nav height
    var targetY = target.getBoundingClientRect().top + window.scrollY - offset;
    smoothScrollTo(targetY, 900);
  });
})();
