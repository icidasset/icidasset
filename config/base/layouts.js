export default function(files, layouts) {
  return files.map(f => {
    return {
      ...f,

      layouts: layouts || ['src/layouts/application.mu'],
    };
  });
}
