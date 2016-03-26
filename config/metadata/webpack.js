/**
 * Adds:
 * { assets: { 'main.js': ... } }
 */
export default function(data) {
  const assets = {};

  data.assets.forEach((f) => {
    const assetname = f.basename.split('.')[0];
    assets[`${assetname}${f.extname}`] = f;
  });

  return { ...data, assets };
}
