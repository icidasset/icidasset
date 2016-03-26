import * as utils from '../utils';


/**
 * Adds:
 * { env: { development: true, production: false } }
 */
export default function(data) {
  return Promise.resolve({
    ...data,

    env: {
      development: utils.isDevelopmentEnv(),
      production: utils.isProductionEnv(),
    }
  });
}
