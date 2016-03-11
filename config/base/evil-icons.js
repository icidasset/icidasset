import evilIcons from 'evil-icons';


export default function(files, deps) {
  return files.map((f) => {
    return {
      ...f,

      metadata: {
        ...f.metadata,
        evilIcons: {
          sprite: evilIcons.sprite,
        },
      },
    };
  });
}
