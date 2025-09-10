(() => {
    'use strict';

    /**
     * Type: Function
     * Name: createSvgElement
     * Use: Generates an SVG element with attributes
     * Created: 2023-10-06
     * By: VSSVSSN
     */
    const createSvgElement = (tag, attrs = {}) => {
        const el = document.createElementNS('http://www.w3.org/2000/svg', tag);
        Object.entries(attrs).forEach(([key, value]) => {
            el.setAttribute(key, value);
        });
        return el;
    };

    const filters = {};

    const svg = createSvgElement('svg', { style: 'display:block;width:0;height:0' });
    const defs = createSvgElement('defs');

    // Gaussian Blur Filter
    const blurFilter = createSvgElement('filter', { id: 'svgBlurFilter' });
    filters.blur = createSvgElement('feGaussianBlur', { stdDeviation: '0 0' });
    blurFilter.appendChild(filters.blur);
    defs.appendChild(blurFilter);

    // Drop Shadow Filter
    const dropShadowFilter = createSvgElement('filter', { id: 'svgDropShadowFilter' });
    filters.dropShadowBlur = createSvgElement('feGaussianBlur', { in: 'SourceAlpha', stdDeviation: '3' });
    dropShadowFilter.appendChild(filters.dropShadowBlur);

    filters.dropShadowOffset = createSvgElement('feOffset', { dx: '0', dy: '0', result: 'offsetblur' });
    dropShadowFilter.appendChild(filters.dropShadowOffset);

    filters.dropShadowFlood = createSvgElement('feFlood', { 'flood-color': 'rgba(0,0,0,1)' });
    dropShadowFilter.appendChild(filters.dropShadowFlood);

    dropShadowFilter.appendChild(createSvgElement('feComposite', { in2: 'offsetblur', operator: 'in' }));
    dropShadowFilter.appendChild(createSvgElement('feComposite', { in2: 'SourceAlpha', operator: 'out', result: 'outer' }));

    const dropShadowMerge = createSvgElement('feMerge');
    dropShadowMerge.appendChild(createSvgElement('feMergeNode'));
    filters.dropShadowMergeNode = createSvgElement('feMergeNode');
    dropShadowMerge.appendChild(filters.dropShadowMergeNode);
    dropShadowFilter.appendChild(dropShadowMerge);

    defs.appendChild(dropShadowFilter);
    svg.appendChild(defs);
    document.documentElement.appendChild(svg);

    /**
     * Type: Function
     * Name: updateDropShadow
     * Use: Recalculates drop shadow settings on resize
     * Created: 2023-10-06
     * By: VSSVSSN
     */
    const updateDropShadow = () => {
        const blurScale = 1;
        const scale = window.innerWidth / 1280;
        const offset = Math.cos(Math.PI / 4) * scale;

        filters.dropShadowBlur.setAttribute('stdDeviation', `${blurScale} ${blurScale}`);
        filters.dropShadowOffset.setAttribute('dx', offset.toString());
        filters.dropShadowOffset.setAttribute('dy', offset.toString());
        filters.dropShadowFlood.setAttribute('flood-color', 'rgba(0, 0, 0, 1)');
        filters.dropShadowMergeNode.setAttribute('in', 'SourceGraphic');
    };

    updateDropShadow();
    window.addEventListener('resize', updateDropShadow);
})();
