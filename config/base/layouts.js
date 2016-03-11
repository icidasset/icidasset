export default function(files, deps, layouts) {
  return files.map((f) => {
    return {
      ...f,

      metadata: {
        ...f.metadata,
        layouts: layouts || ['src/layouts/application.mu'],
      },
    };
  });
}
