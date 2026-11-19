---
layout: almanac
title: μ Cassiopeiae
subtitle: the Queen's Jewel
description: The brightest & nearest metal-poor, Sun-like star with a fundamental mass and radius measurement.
group: research
order: 1
live: true
---

μ Cassiopeiae is a visible (~5th magnitude), nearby (~7.7 parsecs), metal-poor, G-type dwarf with a high proper motion. Its metallicity and high space motion indicate that it is 

## The Binary
μ Cas is an astrometric binary. The primary star that we can see with our naked eye is orbited by a low mass M-dwarf secondary that is ~6 magnitudes fainter than the primary. The faintness, combined with the small on-sky separation (< ~1.5") makes the secondary invisible to the naked eye and most telescopes, requiring advanced techniques like interferometry and adaptive optics to be seen from the ground. Though the secondary was not directly observed until the 1970's, its existence was known at least a decade earlier because its gravity still influences the visible primary, causing the primary's position to wobble with a period of about 21 years. 

Continuous monitoring over the past 20 years with the Hubble Space Telescope, which does not have to contend with the blurring from Earth's atmosphere, has been able to cleanly resolve the two components and thus measure their orbit. Bond et al. (2020) precisely measured the system's orbit to have a period $21.568 \pm 0.015$ yr, with a maximum on sky separation of 1.59".

## Significance as a Benchmark Star
Spectroscopy of μ Cas A reveals it to be metal-poor, with a metallicity [Fe/H]$ = -0.8$. This [Fe/H] measurement is on a logarithmic scale relative to the Sun, meaning that μ Cas A has $10^{-0.8} \approx 1/6$ as much iron and heavy element content as the Sun, making it the nearest and brightest Sun-like star that is at least this metal-poor. Metal-poor stars are rare in the Solar neighborhood, making them on average more distant and fainter. The proximity and brightness of μ Cas A therefore makes it a crucial low metallicity benchmark star with which we test our models of stellar atmospheres against.

The astrometric orbit of μ Cas, combined with radial velocity measurements, yields purely a dynamical measurement for the masses of both components. The primary star is bright and near enough that its angular size has also been resolved. The angular diameter is combined with the system's parallax to yield a purely geometric measurement of the star's linear radius, and so μ Cas A has both its mass and radius measured wholly independently of stellar evolutionary models, making it a prime benchmark for models of stellar interiors as well as atmospheres. 

## Using it to Improve our Standard Stellar Models
μ Cas A, with the model-independent, fundamental measurements of its stellar parameters, offers an exceptional test of our models of stars. In my own work I have used it to test whether the way we model convection in the outer layers of metal-poor, Sun-like stars is correct.

{% include figure.liquid loading="eager" path="assets/img/almanac/mu-cas-a-amlt-age-posterior.png" sizes="(min-width: 768px) 420px, 92vw" alt="Age-mixing length posterior for μ Cas A, showing that a sub-solar mixing length is preferred in order for models to reproduce the observed radius and temperature at physically realistic ages." class="img-fluid rounded" %}

The efficiency of convective in the envelopes of FGK-type stars is set by a free parameter, the mixing length parameter $\alpha_\mathrm{MLT}$. In standard stellar model and isochrone libraries $\alpha_\mathrm{MLT}$ is conventionally calibrated within the model for the Sun, and then that value is held fixed and applied to all other stars, regardless of differences in their surface temperature, evolutionary state, or metallicity. This universal $\alpha_\mathrm{MLT}$ assumption is overly optimistic, and if it is indeed wrong, it is causing systematic inaccuracies to the stellar ages we derive from isochrone fitting. 

Fitting μ Cas A's fundamental mass and radius to stellar models while letting $\alpha_\mathrm{MLT}$ to vary yields the posterior above (shown relative to the solar value $\alpha_{\mathrm{MLT},\odot}=2.03$; the shaded region marks models older than the Universe). The data clearly prefer a **sub-solar** mixing length, $\alpha_\mathrm{MLT}/\alpha_{\mathrm{MLT},\odot} \approx 0.8$. This is one example among many supporting that convection in metal-poor stars is *not* well described by the standard, Solar-calibrated mixing length, and that we must update our treatment of convection in stellar models in order for our inferred ages of metal-poor stars to be reliable and accurate.

*Entry in progress — details and references to be expanded.*
