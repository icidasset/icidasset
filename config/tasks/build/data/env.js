import * as utils from '../../../utils';


export default function(data) {
  return Promise.resolve({
    ...data,

    env: {
      development: utils.isDevelopmentEnv(),
      production: utils.isProductionEnv(),
    }
  });
}
