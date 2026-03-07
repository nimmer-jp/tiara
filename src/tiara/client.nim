const TiaraClientBundle* = """
(function () {
  if (window.__tiaraClientReady) return;
  window.__tiaraClientReady = true;

  function updateCarousel(carousel, nextIndex) {
    if (!carousel) return;
    var track = carousel.querySelector('[data-tiara-carousel-track]');
    if (!track) return;

    var size = parseInt(carousel.getAttribute('data-tiara-carousel-size') || '0', 10);
    if (!(size > 0)) return;

    var boundedIndex = ((nextIndex % size) + size) % size;
    carousel.setAttribute('data-tiara-carousel-index', String(boundedIndex));
    track.style.transform = 'translateX(' + String(-boundedIndex * 100) + '%)';

    var slides = carousel.querySelectorAll('[data-tiara-carousel-slide]');
    for (var i = 0; i < slides.length; i += 1) {
      slides[i].setAttribute('aria-hidden', i === boundedIndex ? 'false' : 'true');
    }

    var indicators = carousel.querySelectorAll('[data-tiara-carousel-indicator]');
    for (var j = 0; j < indicators.length; j += 1) {
      indicators[j].setAttribute('aria-current', j === boundedIndex ? 'true' : 'false');
      if (indicators[j].classList) {
        indicators[j].classList.toggle('is-active', j === boundedIndex);
      }
    }
  }

  function updateTabs(tabs, nextIndex) {
    if (!tabs) return;

    var triggers = tabs.querySelectorAll('[data-tiara-tabs-index]');
    var panels = tabs.querySelectorAll('[data-tiara-tabs-panel]');
    var size = Math.min(triggers.length, panels.length);
    if (!(size > 0)) return;

    var boundedIndex = ((nextIndex % size) + size) % size;
    tabs.setAttribute('data-tiara-tabs-index', String(boundedIndex));

    for (var i = 0; i < size; i += 1) {
      var isActive = i === boundedIndex;
      triggers[i].setAttribute('aria-selected', isActive ? 'true' : 'false');
      triggers[i].setAttribute('tabindex', isActive ? '0' : '-1');
      if (triggers[i].classList) {
        triggers[i].classList.toggle('is-active', isActive);
      }

      if (isActive) {
        panels[i].removeAttribute('hidden');
        panels[i].setAttribute('aria-hidden', 'false');
      } else {
        panels[i].setAttribute('hidden', '');
        panels[i].setAttribute('aria-hidden', 'true');
      }
      if (panels[i].classList) {
        panels[i].classList.toggle('is-active', isActive);
      }
    }
  }

  function getMotionMs(node, fallbackMs) {
    if (!node) return fallbackMs;
    var raw = parseInt(node.getAttribute('data-tiara-motion-ms') || '', 10);
    if (!(raw > 0)) return fallbackMs;
    return raw;
  }

  function openModal(dialog) {
    if (!dialog) return;
    var motionMs = getMotionMs(dialog, 220);
    dialog.style.setProperty('--tiara-motion-ms', String(motionMs) + 'ms');

    if (dialog._tiaraCloseTimer) {
      clearTimeout(dialog._tiaraCloseTimer);
      dialog._tiaraCloseTimer = null;
    }

    if (typeof dialog.showModal === 'function' && !dialog.open) {
      dialog.showModal();
    }
    if (dialog.classList) {
      dialog.classList.remove('is-closing');
      dialog.classList.remove('is-opening');
    }
    requestAnimationFrame(function () {
      if (dialog.classList) {
        dialog.classList.add('is-open');
      }
    });
  }

  function closeModal(dialog) {
    if (!dialog) return;
    var motionMs = getMotionMs(dialog, 220);
    dialog.style.setProperty('--tiara-motion-ms', String(motionMs) + 'ms');

    if (dialog._tiaraCloseTimer) {
      clearTimeout(dialog._tiaraCloseTimer);
      dialog._tiaraCloseTimer = null;
    }

    if (dialog.classList) {
      dialog.classList.remove('is-open');
      dialog.classList.add('is-closing');
    }

    dialog._tiaraCloseTimer = setTimeout(function () {
      dialog._tiaraCloseTimer = null;
      if (dialog.classList) {
        dialog.classList.remove('is-closing');
      }
      if (typeof dialog.close === 'function' && dialog.open) {
        dialog.close();
      }
    }, motionMs);
  }

  function setDropdownOpen(dropdown, isOpen) {
    if (!dropdown) return;

    var menu = dropdown.querySelector('[data-tiara-dropdown-menu]');
    var toggle = dropdown.querySelector('[data-tiara-dropdown-toggle]');
    var motionMs = getMotionMs(dropdown, 180);
    dropdown.style.setProperty('--tiara-motion-ms', String(motionMs) + 'ms');

    dropdown.setAttribute('data-tiara-dropdown-open', isOpen ? 'true' : 'false');

    if (toggle) {
      toggle.setAttribute('aria-expanded', isOpen ? 'true' : 'false');
    }

    if (!menu) return;
    if (menu._tiaraClosingTimer) {
      clearTimeout(menu._tiaraClosingTimer);
      menu._tiaraClosingTimer = null;
    }

    menu.style.setProperty('--tiara-motion-ms', String(motionMs) + 'ms');
    if (isOpen) {
      menu.removeAttribute('hidden');
      if (menu.classList) {
        menu.classList.remove('is-closing');
      }
      requestAnimationFrame(function () {
        if (menu.classList) {
          menu.classList.add('is-open');
        }
      });
    } else {
      if (menu.hasAttribute('hidden') && (!menu.classList || !menu.classList.contains('is-open'))) {
        if (menu.classList) {
          menu.classList.remove('is-closing');
        }
        return;
      }
      if (menu.classList) {
        menu.classList.remove('is-open');
        menu.classList.add('is-closing');
      }
      menu._tiaraClosingTimer = setTimeout(function () {
        if (menu.classList) {
          menu.classList.remove('is-closing');
        }
        menu.setAttribute('hidden', '');
      }, motionMs);
    }
  }

  function closeAllDropdowns(exceptDropdown) {
    var openDropdowns = document.querySelectorAll('[data-tiara="dropdown"][data-tiara-dropdown-open="true"]');
    for (var i = 0; i < openDropdowns.length; i += 1) {
      if (exceptDropdown && openDropdowns[i] === exceptDropdown) {
        continue;
      }
      setDropdownOpen(openDropdowns[i], false);
    }
  }

  function hideToast(toast) {
    if (!toast) return;
    toast.setAttribute('hidden', '');
  }

  document.addEventListener('click', function (event) {
    if (event.target && event.target.matches && event.target.matches('dialog[data-tiara=\"modal\"]')) {
      closeModal(event.target);
      return;
    }

    var opener = event.target.closest('[data-tiara-modal-open]');
    if (opener) {
      var dialogId = opener.getAttribute('data-tiara-modal-open');
      var dialog = document.getElementById(dialogId);
      if (dialog) {
        openModal(dialog);
      }
      return;
    }

    var closeButton = event.target.closest('[data-tiara-modal-close]');
    if (closeButton) {
      var hostDialog = closeButton.closest('dialog');
      if (hostDialog) {
        closeModal(hostDialog);
      }
      return;
    }

    var tabsTrigger = event.target.closest('[data-tiara-tabs-target]');
    if (tabsTrigger) {
      var tabsId = tabsTrigger.getAttribute('data-tiara-tabs-target');
      var tabs = tabsId ? document.getElementById(tabsId) : tabsTrigger.closest('[data-tiara="tabs"]');
      if (tabs) {
        var tabIndex = parseInt(tabsTrigger.getAttribute('data-tiara-tabs-index') || '0', 10);
        updateTabs(tabs, tabIndex);
      }
      return;
    }

    var dropdownToggle = event.target.closest('[data-tiara-dropdown-toggle]');
    if (dropdownToggle) {
      var dropdownId = dropdownToggle.getAttribute('data-tiara-dropdown-toggle');
      var dropdown = dropdownId ? document.getElementById(dropdownId) : dropdownToggle.closest('[data-tiara="dropdown"]');
      if (dropdown) {
        var opened = dropdown.getAttribute('data-tiara-dropdown-open') === 'true';
        closeAllDropdowns(dropdown);
        setDropdownOpen(dropdown, !opened);
      }
      return;
    }

    var dropdownItem = event.target.closest('[data-tiara-dropdown-item]');
    if (dropdownItem) {
      var itemDropdown = dropdownItem.closest('[data-tiara="dropdown"]');
      if (itemDropdown) {
        setDropdownOpen(itemDropdown, false);
      }
      return;
    }

    var toastClose = event.target.closest('[data-tiara-toast-close]');
    if (toastClose) {
      var toast = toastClose.closest('[data-tiara="toast"]');
      hideToast(toast);
      return;
    }

    var carouselControl = event.target.closest('[data-tiara-carousel-action]');
    if (carouselControl) {
      var targetId = carouselControl.getAttribute('data-tiara-carousel-target');
      var carousel = targetId ? document.getElementById(targetId) : null;
      if (carousel) {
        var action = carouselControl.getAttribute('data-tiara-carousel-action');
        var current = parseInt(carousel.getAttribute('data-tiara-carousel-index') || '0', 10);
        if (action === 'prev') {
          updateCarousel(carousel, current - 1);
        } else if (action === 'next') {
          updateCarousel(carousel, current + 1);
        } else if (action === 'go') {
          var goIndex = parseInt(carouselControl.getAttribute('data-tiara-carousel-go') || '0', 10);
          updateCarousel(carousel, goIndex);
        }
      }
      return;
    }

    closeAllDropdowns(null);
  });

  document.addEventListener('keydown', function (event) {
    if (event.key === 'Escape') {
      closeAllDropdowns(null);
    }
  });

  document.addEventListener('cancel', function (event) {
    if (!event.target || !event.target.matches || !event.target.matches('dialog[data-tiara=\"modal\"]')) {
      return;
    }
    event.preventDefault();
    closeModal(event.target);
  }, true);

  document.addEventListener('input', function (event) {
    var input = event.target;
    if (!input.matches || !input.matches("input[type='color'][data-tiara-color-input]")) return;

    var previewId = input.getAttribute('data-tiara-color-input');
    var swatch = document.querySelector("[data-tiara-color-preview='" + previewId + "']");
    if (swatch) {
      swatch.style.backgroundColor = input.value;
    }
  });

  var carousels = document.querySelectorAll('[data-tiara="carousel"]');
  for (var m = 0; m < carousels.length; m += 1) {
    var initialCarouselIndex = parseInt(carousels[m].getAttribute('data-tiara-carousel-index') || '0', 10);
    updateCarousel(carousels[m], initialCarouselIndex);
  }

  var tabsList = document.querySelectorAll('[data-tiara="tabs"]');
  for (var n = 0; n < tabsList.length; n += 1) {
    var initialTabIndex = parseInt(tabsList[n].getAttribute('data-tiara-tabs-index') || '0', 10);
    updateTabs(tabsList[n], initialTabIndex);
  }

  var dropdowns = document.querySelectorAll('[data-tiara="dropdown"]');
  for (var p = 0; p < dropdowns.length; p += 1) {
    setDropdownOpen(dropdowns[p], false);
  }

  var toasts = document.querySelectorAll('[data-tiara="toast"][data-tiara-toast-autohide]');
  for (var q = 0; q < toasts.length; q += 1) {
    (function (toastNode) {
      var hideAfter = parseInt(toastNode.getAttribute('data-tiara-toast-autohide') || '0', 10);
      if (hideAfter > 0) {
        setTimeout(function () {
          hideToast(toastNode);
        }, hideAfter);
      }
    })(toasts[q]);
  }
})();
"""

when defined(js):
  proc initTiaraClient*() =
    {.emit: TiaraClientBundle.}

  initTiaraClient()
else:
  proc initTiaraClient*() =
    discard
