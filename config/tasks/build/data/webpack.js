export default function(data) {
  const assets = {};

  data.assets.forEach((f) => {
    assets[`${f.basename}${f.extname}`] = f;
  });

  return { ...data, assets };
}
