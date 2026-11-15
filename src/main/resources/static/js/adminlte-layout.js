/* AdminLTE owns sidebar toggling; do not register a competing click handler. */
(function ($) {
    'use strict';
    $(function () {
        var menu = document.getElementById('hrms-lte-menu');
        if (!menu) return;
        var context = menu.getAttribute('data-context-path') || '';
        var current = window.location.pathname;
        if (context && (current === context || current.indexOf(context + '/') === 0)) {
            current = current.substring(context.length);
        }
        current = current.replace(/\/+$/, '') || '/';
        var best = null;
        menu.querySelectorAll('[data-menu-path]').forEach(function (link) {
            var path = link.getAttribute('data-menu-path');
            link.classList.remove('active');
            link.removeAttribute('aria-current');
            if (path && (current === path || current.indexOf(path + '/') === 0 ||
                    (current === '/' && path === '/dashboard'))) {
                if (!best || path.length > best.getAttribute('data-menu-path').length) best = link;
            }
        });
        if (best) {
            best.classList.add('active');
            best.setAttribute('aria-current', 'page');
        }
        function updateExpanded() {
            var mobile = window.matchMedia('(max-width: 991.98px)').matches;
            var expanded = mobile ? document.body.classList.contains('sidebar-open') :
                !document.body.classList.contains('sidebar-collapse');
            $('[data-widget="pushmenu"]').attr('aria-expanded', String(expanded));
        }
        $(document).on('collapsed.lte.pushmenu shown.lte.pushmenu', updateExpanded);
        $(window).on('resize.hrmsAdminlte', updateExpanded);
        updateExpanded();
    });
}(jQuery));
