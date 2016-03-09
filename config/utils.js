import ejs from 'ejs';


export function isEnv(env) {
  return process.env.ENV === env;
}


export function isDevelopmentEnv() {
  return isEnv('development');
}


export function isProductionEnv() {
  return isEnv('production');
}


export function render(template, data) {
  return Promise.resolve(
    ejs.render(template, data)
  );
}
