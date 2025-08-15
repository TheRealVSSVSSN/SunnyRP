// src/services/features.service.js
import { env } from '../config/env.js';
import { getAllConfig } from '../repositories/config.repo.js';

let cache = { features: null, expires: 0 };

export async function getFeatures() {
    const now = Date.now();
    if (cache.features && cache.expires > now) {
        return cache.features;
    }
    const map = await getAllConfig();
    const features = (map && typeof map.features === 'object') ? map.features : {};
    cache = { features, expires: now + env.FEATURE_CACHE_TTL_SEC * 1000 };
    return features;
}

export async function getFeature(name, defaultOn = true) {
    const features = await getFeatures();
    if (Object.prototype.hasOwnProperty.call(features, name)) {
        return !!features[name];
    }
    return !!defaultOn;
}

export async function invalidateFeaturesCache() {
    cache = { features: null, expires: 0 };
}