export function isEnv(env) {
  return process.env.ENV === env;
}


export function isDevelopmentEnv() {
  return isEnv('development');
}


export function isProductionEnv() {
  return isEnv('production');
}
